import '../api/api_client.dart';
import '../api/models.dart';
import '../import/document_picker.dart';
import 'local_store.dart';

/// A file that waits on this device until the server is reachable.
class PendingUpload {
  const PendingUpload({
    required this.id,
    required this.spaceId,
    required this.filename,
    required this.length,
    required this.queuedAt,
    this.error,
  });

  factory PendingUpload.fromJson(Map<String, dynamic> json) => PendingUpload(
        id: json['id'] as String,
        spaceId: json['space_id'] as String,
        filename: json['filename'] as String,
        length: json['length'] as int,
        queuedAt: DateTime.parse(json['queued_at'] as String),
        error: json['error'] as String?,
      );

  final String id;
  final String spaceId;
  final String filename;
  final int length;
  final DateTime queuedAt;

  /// Set when the server refused the file; it then waits for the user to discard it.
  final String? error;

  PendingUpload failed(String message) => PendingUpload(
      id: id,
      spaceId: spaceId,
      filename: filename,
      length: length,
      queuedAt: queuedAt,
      error: message);

  Map<String, dynamic> toJson() => {
        'id': id,
        'space_id': spaceId,
        'filename': filename,
        'length': length,
        'queued_at': queuedAt.toUtc().toIso8601String(),
        if (error != null) 'error': error,
      };
}

/// Offline cache of the document list plus the upload queue.
///
/// The server's change feed (`/api/v1/sync`) is the source of truth: every device pulls
/// the same changes, so phone and PC converge on the same state. Changes from a sync are
/// applied only after all pages arrived, so an interrupted sync leaves the cache unchanged.
class SyncEngine {
  SyncEngine(this.store, {DateTime Function()? clock})
      : _clock = clock ?? DateTime.now;

  static const _cacheRecord = 'cache';
  static const _queueRecord = 'queue';
  static const _formatVersion = 1;

  final LocalStore store;
  final DateTime Function() _clock;

  String? server;
  UserInfo? user;
  String? cursor;
  DateTime? lastSyncedAt;
  List<SpaceInfo> spaces = const [];
  final Map<String, DocumentInfo> _docs = {};
  List<PendingUpload> queue = [];
  int _counter = 0;

  bool get hasCache => user != null;

  List<DocumentInfo> documentsIn(String spaceId) =>
      _docs.values.where((d) => d.spaceId == spaceId).toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

  int get documentCount => _docs.length;

  List<PendingUpload> pendingIn(String spaceId) => [
        for (final p in queue)
          if (p.spaceId == spaceId) p
      ];

  /// Loads the cache if it belongs to [forServer]; a cache of another server or user is
  /// dropped so data never leaks between accounts.
  Future<void> load(String forServer) async {
    final data = await store.readRecord(_cacheRecord);
    final q = await store.readRecord(_queueRecord);
    queue = [
      for (final p in (q?['items'] as List?) ?? const [])
        PendingUpload.fromJson(p as Map<String, dynamic>)
    ];
    if (data == null ||
        data['v'] != _formatVersion ||
        data['server'] != forServer) {
      _reset(forServer);
      return;
    }
    server = forServer;
    user = UserInfo.fromJson(data['user'] as Map<String, dynamic>);
    cursor = data['cursor'] as String?;
    final synced = data['last_synced_at'] as String?;
    lastSyncedAt = synced == null ? null : DateTime.parse(synced);
    spaces = [
      for (final s in data['spaces'] as List)
        SpaceInfo.fromJson(s as Map<String, dynamic>)
    ];
    _docs
      ..clear()
      ..addEntries([
        for (final d in data['documents'] as List)
          () {
            final doc = DocumentInfo.fromJson(d as Map<String, dynamic>);
            return MapEntry(doc.id, doc);
          }()
      ]);
  }

  void _reset(String? forServer) {
    server = forServer;
    user = null;
    cursor = null;
    lastSyncedAt = null;
    spaces = const [];
    _docs.clear();
  }

  /// Called after sign-in: a different account starts with an empty cache.
  void adopt(String forServer, UserInfo signedIn) {
    if (server != forServer || user?.id != signedIn.id) _reset(forServer);
    user = signedIn;
  }

  Future<void> _save() async {
    if (user == null) return;
    await store.writeRecord(_cacheRecord, {
      'v': _formatVersion,
      'server': server,
      'user': user!.toJson(),
      'cursor': cursor,
      'last_synced_at': lastSyncedAt?.toUtc().toIso8601String(),
      'spaces': [for (final s in spaces) s.toJson()],
      'documents': [for (final d in _docs.values) d.toJson()],
    });
  }

  Future<void> _saveQueue() => store.writeRecord(_queueRecord, {
        'items': [for (final p in queue) p.toJson()]
      });

  /// Keeps a copy of [picked] on the device until it can be uploaded.
  Future<PendingUpload> enqueue(PickedDocument picked, String spaceId) async {
    final now = _clock();
    final id = 'up-${now.microsecondsSinceEpoch}-${_counter++}';
    final length = await store.putBlob(id, picked.open());
    final item = PendingUpload(
      id: id,
      spaceId: spaceId,
      filename: picked.name,
      length: length,
      queuedAt: now,
    );
    queue = [...queue, item];
    await _saveQueue();
    return item;
  }

  Future<void> discard(String uploadId) async {
    queue = [
      for (final p in queue)
        if (p.id != uploadId) p
    ];
    await store.deleteBlob(uploadId);
    await _saveQueue();
  }

  /// Uploads waiting files, then pulls all changes.
  ///
  /// Throws [ConnectionFailed] when the server is unreachable and [ApiException] for
  /// errors of the feed itself (e.g. 401). The cache stays as it was in that case.
  Future<void> sync(ApiClient client) async {
    await _flushQueue(client);

    final hadCursor = cursor != null;
    final known = {for (final s in spaces) s.id};
    final changes = <DocumentInfo>[];
    var next = cursor;
    SyncPage page;
    do {
      page = await client.sync(cursor: next);
      changes.addAll(page.documents);
      next = page.cursor;
    } while (page.hasMore);

    // spaces the account newly sees: their older documents are not in the feed window
    final added = <DocumentInfo>[];
    if (hadCursor) {
      for (final s in page.spaces) {
        if (!known.contains(s.id)) added.addAll(await client.documents(s.id));
      }
    }

    for (final d in [...added, ...changes]) {
      final existing = _docs[d.id];
      if (existing != null && existing.revision > d.revision) continue;
      if (d.deleted) {
        _docs.remove(d.id);
      } else {
        _docs[d.id] = d;
      }
    }
    final readable = {for (final s in page.spaces) s.id};
    _docs.removeWhere((_, d) => !readable.contains(d.spaceId));
    spaces = page.spaces;
    cursor = next;
    lastSyncedAt = _clock();
    await _save();
  }

  Future<void> _flushQueue(ApiClient client) async {
    if (queue.isEmpty) return;
    for (final item in List.of(queue)) {
      if (item.error != null) continue;
      try {
        final doc = await client.upload(
          spaceId: item.spaceId,
          filename: item.filename,
          length: item.length,
          content: store.openBlob(item.id),
        );
        _docs[doc.id] = doc;
        await discard(item.id);
      } on ApiException catch (e) {
        if (e.isUnauthorized) rethrow;
        if (e.code == 'duplicate') {
          await discard(
              item.id); // already on the server, e.g. a retried upload
        } else {
          queue = [
            for (final p in queue) p.id == item.id ? p.failed(e.userMessage) : p
          ];
          await _saveQueue();
        }
      }
    }
  }

  /// Wipes cache and queue (sign-out).
  Future<void> clear() async {
    _reset(null);
    queue = [];
    await store.clear();
  }
}
