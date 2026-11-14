import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/widgets.dart';

import 'api/api_client.dart';
import 'api/models.dart';
import 'api/server_url.dart';
import 'auth/token_store.dart';
import 'import/document_picker.dart';
import 'sync/local_store.dart';
import 'sync/sync_engine.dart';

typedef ApiClientFactory = ApiClient Function(Uri baseUrl, String? token);

/// App-wide state: server connection, signed-in user, visible spaces and the synced
/// document list (works offline from the on-device cache).
class AppState extends ChangeNotifier {
  AppState({
    required this.tokenStore,
    ApiClientFactory? clientFactory,
    this.picker = const NativeDocumentPicker(),
    LocalStore? localStore,
    this.autoSyncEvery = const Duration(minutes: 5),
  })  : _factory = clientFactory ??
            ((base, token) => ApiClient(baseUrl: base, token: token)),
        sync = SyncEngine(localStore ?? FileLocalStore());

  final TokenStore tokenStore;
  final DocumentPicker picker;
  final ApiClientFactory _factory;
  final SyncEngine sync;

  /// Background sync interval while signed in; null disables it (tests).
  final Duration? autoSyncEvery;

  ApiClient? _client;
  UserInfo? user;
  List<SpaceInfo> spaces = const [];
  String? lastServer;

  /// True while the server is unreachable; lists then come from the cache.
  bool offline = false;
  bool syncing = false;
  String? syncError;
  Timer? _timer;
  Future<void>? _running;

  /// Bumped after each import or sync so document lists rebuild.
  int documentsVersion = 0;

  bool get isSignedIn => _client?.token != null && user != null;
  ApiClient? get client => isSignedIn ? _client : null;
  List<SpaceInfo> get writableSpaces => [
        for (final s in spaces)
          if (s.canWrite) s
      ];

  static String defaultDeviceName() {
    try {
      return 'Paperless AI (${Platform.operatingSystem})';
    } catch (_) {
      return 'Paperless AI';
    }
  }

  /// Restore a saved session on app start. Silent on failure.
  Future<void> restore() async {
    final saved = await tokenStore.load();
    lastServer = saved.server;
    if (saved.server == null || saved.token == null) {
      notifyListeners();
      return;
    }
    await sync.load(saved.server!);
    final client = _factory(Uri.parse(saved.server!), saved.token);
    try {
      user = await client.me();
      _client = client;
      sync.adopt(saved.server!, user!);
      spaces = await client.spaces();
    } on ApiException catch (e) {
      if (e.isUnauthorized) {
        await tokenStore.clear();
        await sync.clear();
      }
      _client = null;
      user = null;
    } on ConnectionFailed {
      if (sync.hasCache) {
        // Offline: show the cached state, keep the token and retry in the background.
        _client = client;
        user = sync.user;
        spaces = sync.spaces;
        offline = true;
      } else {
        _client = null;
        user = null;
      }
    }
    notifyListeners();
    if (isSignedIn) {
      _startTimer();
      if (!offline) unawaited(syncNow());
    }
  }

  /// Throws [InvalidServerUrl], [ApiException] or [ConnectionFailed].
  Future<void> signIn({
    required String server,
    required String email,
    required String password,
    String? deviceName,
  }) async {
    final base = normalizeServerUrl(server);
    final anonymous = _factory(base, null);
    final token = await anonymous.login(
        email.trim(), password, deviceName ?? defaultDeviceName());
    final client = _factory(base, token);
    user = await client.me();
    spaces = await client.spaces();
    _client = client;
    lastServer = base.toString();
    offline = false;
    await tokenStore.save(server: base.toString(), token: token);
    await sync.load(base.toString());
    sync.adopt(base.toString(), user!);
    notifyListeners();
    _startTimer();
    unawaited(syncNow());
  }

  Future<void> signOut() async {
    final client = _client;
    _timer?.cancel();
    _client = null;
    user = null;
    spaces = const [];
    offline = false;
    syncError = null;
    await tokenStore.clear();
    await sync.clear();
    notifyListeners();
    try {
      await client?.logout();
    } catch (_) {
      // The local token is gone either way; the server session expires on its own.
    }
  }

  Future<void> refreshSpaces() async {
    final c = client;
    if (c == null) return;
    spaces = await c.spaces();
    notifyListeners();
  }

  void documentsChanged() {
    documentsVersion++;
    notifyListeners();
    unawaited(syncNow());
  }

  /// Keeps a picked file on the device and uploads it with the next successful sync.
  Future<PendingUpload> queueUpload(
      PickedDocument picked, SpaceInfo space) async {
    final item = await sync.enqueue(picked, space.id);
    documentsVersion++;
    notifyListeners();
    return item;
  }

  Future<void> discardUpload(String id) async {
    await sync.discard(id);
    documentsVersion++;
    notifyListeners();
  }

  void _startTimer() {
    _timer?.cancel();
    final every = autoSyncEvery;
    if (every != null) {
      _timer = Timer.periodic(every, (_) => unawaited(syncNow()));
    }
  }

  /// Uploads waiting files and pulls changes. Never throws; sets [offline]/[syncError].
  Future<void> syncNow() =>
      _running ??= _syncOnce().whenComplete(() => _running = null);

  Future<void> _syncOnce() async {
    final c = _client;
    if (c == null || user == null) return;
    syncing = true;
    notifyListeners();
    try {
      if (offline) {
        user = await c.me(); // reconnect check, also catches a revoked device
        sync.adopt(lastServer ?? sync.server ?? '', user!);
      }
      await sync.sync(c);
      spaces = sync.spaces;
      offline = false;
      syncError = null;
    } on ConnectionFailed {
      offline = true;
    } on ApiException catch (e) {
      if (e.isUnauthorized) {
        syncing = false;
        await signOut();
        return;
      }
      syncError = e.userMessage;
    } finally {
      syncing = false;
    }
    documentsVersion++;
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

/// Makes [AppState] available to the widget tree.
class AppScope extends InheritedNotifier<AppState> {
  const AppScope({super.key, required AppState state, required super.child})
      : super(notifier: state);

  static AppState of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AppScope>()!.notifier!;
}
