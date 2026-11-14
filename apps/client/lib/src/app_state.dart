import 'dart:io' show Platform;

import 'package:flutter/widgets.dart';

import 'api/api_client.dart';
import 'api/models.dart';
import 'api/server_url.dart';
import 'auth/token_store.dart';
import 'import/document_picker.dart';

typedef ApiClientFactory = ApiClient Function(Uri baseUrl, String? token);

/// App-wide state: server connection, signed-in user and visible spaces.
class AppState extends ChangeNotifier {
  AppState({
    required this.tokenStore,
    ApiClientFactory? clientFactory,
    this.picker = const NativeDocumentPicker(),
  }) : _factory = clientFactory ??
            ((base, token) => ApiClient(baseUrl: base, token: token));

  final TokenStore tokenStore;
  final DocumentPicker picker;
  final ApiClientFactory _factory;

  ApiClient? _client;
  UserInfo? user;
  List<SpaceInfo> spaces = const [];
  String? lastServer;

  /// Bumped after each import so document lists reload.
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
    try {
      final client = _factory(Uri.parse(saved.server!), saved.token);
      user = await client.me();
      _client = client;
      spaces = await client.spaces();
    } on ApiException catch (e) {
      if (e.isUnauthorized) await tokenStore.clear();
      _client = null;
      user = null;
    } on ConnectionFailed {
      // Offline: keep the token, try again next start.
      _client = null;
      user = null;
    }
    notifyListeners();
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
    await tokenStore.save(server: base.toString(), token: token);
    notifyListeners();
  }

  Future<void> signOut() async {
    final client = _client;
    _client = null;
    user = null;
    spaces = const [];
    await tokenStore.clear();
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
  }
}

/// Makes [AppState] available to the widget tree.
class AppScope extends InheritedNotifier<AppState> {
  const AppScope({super.key, required AppState state, required super.child})
      : super(notifier: state);

  static AppState of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AppScope>()!.notifier!;
}
