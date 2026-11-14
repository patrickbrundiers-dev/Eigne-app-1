/// Serverless document library on Google Drive (milestone D2).
///
/// Layout below the shared family folder (`Paperless AI`):
///
/// ```
/// manifest/<n>.json              signed family manifest, highest valid n wins
/// spaces/<space>/files/<doc>-v1  encrypted document
/// spaces/<space>/log/<device>-<seq>  encrypted change entries, one file each
/// ```
///
/// Every device only ever creates new files, so devices never overwrite each other. A
/// space's documents are the result of replaying all its log entries in order.
library;

import 'dart:convert';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';

import '../api/models.dart';
import '../sync/local_store.dart';
import '../sync/sync_engine.dart';
import '../vault/vault.dart';
import 'drive_store.dart';

const familyFolderName = 'Paperless AI';
const _manifestVersion = 1;

String _b64(List<int> b) => base64Url.encode(b).replaceAll('=', '');
Uint8List _unb64(String s) =>
    Uint8List.fromList(base64Url.decode(s + '=' * ((4 - s.length % 4) % 4)));

String newId() => _b64(randomBytes(12));

/// Canonical JSON (sorted keys) so signatures do not depend on key order.
String canonicalJson(Object? value) {
  if (value is Map) {
    final keys = value.keys.map((k) => k as String).toList()..sort();
    return '{${keys.map((k) => '${jsonEncode(k)}:${canonicalJson(value[k])}').join(',')}}';
  }
  if (value is List) return '[${value.map(canonicalJson).join(',')}]';
  return jsonEncode(value);
}

/// Detects the file type from its first bytes; null means unsupported.
String? sniffMimeType(List<int> head) {
  bool starts(List<int> sig) =>
      head.length >= sig.length &&
      List.generate(sig.length, (i) => head[i] == sig[i]).every((x) => x);
  if (starts([0x25, 0x50, 0x44, 0x46, 0x2d])) return 'application/pdf';
  if (starts([0x89, 0x50, 0x4e, 0x47])) return 'image/png';
  if (starts([0xff, 0xd8, 0xff])) return 'image/jpeg';
  if (starts([0x49, 0x49, 0x2a, 0x00]) || starts([0x4d, 0x4d, 0x00, 0x2a])) {
    return 'image/tiff';
  }
  if (starts([0x52, 0x49, 0x46, 0x46]) &&
      head.length >= 12 &&
      String.fromCharCodes(head.sublist(8, 12)) == 'WEBP') {
    return 'image/webp';
  }
  return null;
}

class DriveLibrary implements RemoteLibrary {
  DriveLibrary._({
    required this.drive,
    required this.me,
    required this.memberId,
    required this.deviceId,
    required this.local,
    required String rootId,
    DateTime Function()? clock,
  })  : _rootId = rootId,
        _clock = clock ?? DateTime.now;

  final DriveStore drive;
  final PersonalKeys me;
  final String memberId;
  final String deviceId;
  final LocalStore local;
  final String _rootId;
  final DateTime Function() _clock;

  Map<String, dynamic> _manifest = const {};
  int _manifestNo = 0;
  final _spaceKeys = <String, SpaceKey>{};
  final _spaceNames = <String, String>{};
  final _folders = <String, String>{};

  // decrypted log entries per space (persisted in [local], so only new ones are
  // downloaded) and the document state derived from them by an ordered replay
  final _entries = <String, Map<String, Map<String, dynamic>>>{};
  final _skipped = <String>{};
  final _docs = <String, Map<String, dynamic>>{};
  int _seq = 0;

  static const _stateRecord = 'drive_state';
  static const maxFileBytes = 100 * 1024 * 1024;

  /// Creates the family folder with its first manifest; the caller becomes admin.
  static Future<DriveLibrary> createFamily({
    required DriveStore drive,
    required PersonalKeys me,
    required String displayName,
    required String deviceId,
    required LocalStore local,
    List<(String, String)> spaces = const [
      ('Haushalt', 'shared'),
      ('Privat', 'private')
    ],
    DateTime Function()? clock,
  }) async {
    if (await drive.find(DriveStore.root, familyFolderName) != null) {
      throw StateError('family folder already exists');
    }
    final root = await drive.createFolder(DriveStore.root, familyFolderName);
    final memberId = newId();
    final lib = DriveLibrary._(
        drive: drive,
        me: me,
        memberId: memberId,
        deviceId: deviceId,
        local: local,
        rootId: root.id,
        clock: clock);
    lib._manifest = {
      'v': _manifestVersion,
      'family_id': newId(),
      'admin': memberId,
      'admin_sign_pub': _b64(me.signPublic),
      'members': {
        memberId: {
          'name': displayName,
          'role': 'admin',
          'box_pub': _b64(me.boxPublic),
          'sign_pub': _b64(me.signPublic),
        }
      },
      'spaces': <String, dynamic>{},
    };
    for (final (name, type) in spaces) {
      await lib._addSpace(name, type);
    }
    await lib._publishManifest();
    await lib._loadState();
    return lib;
  }

  /// Opens an existing family folder. [trustedAdminSignPub] pins the admin key the
  /// device saw first, so a forged manifest by another folder writer is rejected.
  static Future<DriveLibrary> open({
    required DriveStore drive,
    required PersonalKeys me,
    required String memberId,
    required String deviceId,
    required LocalStore local,
    required List<int> trustedAdminSignPub,
    DateTime Function()? clock,
  }) async {
    final root = await drive.find(DriveStore.root, familyFolderName) ??
        (throw StateError('no family folder'));
    final lib = DriveLibrary._(
        drive: drive,
        me: me,
        memberId: memberId,
        deviceId: deviceId,
        local: local,
        rootId: root.id,
        clock: clock);
    await lib._loadState();
    await lib._readManifest(trustedAdminSignPub);
    return lib;
  }

  String get adminSignPublic => _manifest['admin_sign_pub'] as String;

  // --- manifest -----------------------------------------------------------------------

  Future<void> _addSpace(String name, String type) async {
    final id = newId();
    final key = SpaceKey.generate();
    _spaceKeys[id] = key;
    _spaceNames[id] = name;
    (_manifest['spaces'] as Map<String, dynamic>)[id] = {
      'type': type,
      'name':
          _b64(await encryptForSpace(key, utf8.encode(name), 'space/$id/name')),
      'write': [memberId],
      'keys': {
        memberId: await wrapSpaceKey(key, me.boxPublic,
            spaceId: id, memberId: memberId),
      },
    };
  }

  /// Admin only: adds a space and publishes a new manifest.
  Future<SpaceInfo> createSpace(String name, {String type = 'shared'}) async {
    _requireAdmin();
    await _addSpace(name, type);
    await _publishManifest();
    final id = _spaceNames.entries.last.key;
    return _spaceInfo(id);
  }

  void _requireAdmin() {
    if (_manifest['admin'] != memberId) {
      throw const ApiException(403);
    }
  }

  Future<void> _publishManifest() async {
    final body = Map<String, dynamic>.of(_manifest)..remove('sig');
    _manifestNo++;
    body['n'] = _manifestNo;
    body['signed_at'] = _clock().toUtc().toIso8601String();
    final sig = await me.sign(utf8.encode(canonicalJson(body)));
    _manifest = {...body, 'sig': _b64(sig)};
    final folder = await _folder('manifest', _rootId);
    await drive.createFile(
        folder,
        '${_manifestNo.toString().padLeft(8, '0')}.json',
        utf8.encode(jsonEncode(_manifest)));
  }

  Future<void> _readManifest(List<int> trustedAdminSignPub) async {
    final folder = await _folder('manifest', _rootId);
    final files = await drive.list(folder)
      ..sort((a, b) => b.name.compareTo(a.name)); // newest first
    for (final f in files) {
      final Map<String, dynamic> m;
      try {
        m = jsonDecode(utf8.decode(await drive.read(f.id)))
            as Map<String, dynamic>;
      } on FormatException {
        continue;
      }
      final body = Map<String, dynamic>.of(m)..remove('sig');
      final sig = m['sig'];
      if (sig is! String ||
          m['admin_sign_pub'] != _b64(trustedAdminSignPub) ||
          !await verifySignature(utf8.encode(canonicalJson(body)), _unb64(sig),
              trustedAdminSignPub)) {
        continue; // forged or damaged: ignore, fall back to an older valid one
      }
      _manifest = m;
      _manifestNo = m['n'] as int;
      break;
    }
    if (_manifest.isEmpty) throw const CryptoFailure('manifest');
    _spaceKeys.clear();
    _spaceNames.clear();
    final spaces = _manifest['spaces'] as Map<String, dynamic>;
    for (final e in spaces.entries) {
      final wrapped = (e.value['keys'] as Map<String, dynamic>)[memberId];
      if (wrapped == null) continue; // not a member of this space
      final key = await unwrapSpaceKey(wrapped as Map<String, dynamic>, me,
          spaceId: e.key, memberId: memberId);
      _spaceKeys[e.key] = key;
      _spaceNames[e.key] = utf8.decode(await decryptForSpace(
          key, _unb64(e.value['name'] as String), 'space/${e.key}/name'));
    }
  }

  SpaceInfo _spaceInfo(String id) {
    final s = (_manifest['spaces'] as Map<String, dynamic>)[id]
        as Map<String, dynamic>;
    final canWrite = (s['write'] as List).contains(memberId);
    return SpaceInfo(
      id: id,
      name: _spaceNames[id]!,
      type: s['type'] as String,
      permissions: {'read', if (canWrite) 'write'},
    );
  }

  List<SpaceInfo> get spaces => [
        for (final id in _spaceKeys.keys) _spaceInfo(id)
      ]..sort((a, b) => a.name.compareTo(b.name));

  // --- folders and state --------------------------------------------------------------

  Future<String> _folder(String name, String parentId) async {
    final cacheKey = '$parentId/$name';
    return _folders[cacheKey] ??= (await drive.folder(parentId, name)).id;
  }

  Future<String> _spaceFolder(String spaceId, String sub) async {
    final spacesId = await _folder('spaces', _rootId);
    final space = await _folder(spaceId, spacesId);
    return _folder(sub, space);
  }

  Future<void> _loadState() async {
    final s = await local.readRecord(_stateRecord);
    if (s == null || s['root'] != _rootId || s['member'] != memberId) return;
    _seq = s['seq'] as int;
    for (final e in (s['entries'] as Map<String, dynamic>).entries) {
      _entries[e.key] = {
        for (final x in (e.value as Map<String, dynamic>).entries)
          x.key: Map<String, dynamic>.from(x.value as Map)
      };
    }
    _skipped.addAll(List<String>.from(s['skipped'] as List));
    _replay();
  }

  Future<void> _saveState() => local.writeRecord(_stateRecord, {
        'root': _rootId,
        'member': memberId,
        'seq': _seq,
        'entries': _entries,
        'skipped': _skipped.toList(),
      });

  // --- log ----------------------------------------------------------------------------

  Future<void> _appendLog(String spaceId, Map<String, dynamic> entry) async {
    final key = _spaceKeys[spaceId]!;
    _seq++;
    // the random suffix keeps names unique even if this device lost its local state
    final name =
        '$deviceId-${_seq.toString().padLeft(10, '0')}-${newId().substring(0, 6)}';
    final full = {
      ...entry,
      'at': _clock().toUtc().toIso8601String(),
      'by': memberId,
      'device': deviceId,
    };
    final enc = await encryptForSpace(
        key, utf8.encode(jsonEncode(full)), 'log/$spaceId/$name');
    await drive.createFile(await _spaceFolder(spaceId, 'log'), name, enc);
    (_entries[spaceId] ??= {})[name] = full;
    _replay();
    await _saveState();
  }

  /// Rebuilds the documents from all entries in one global order (time, then file
  /// name), so every device ends with exactly the same state.
  void _replay() {
    _docs.clear();
    final all = [
      for (final space in _entries.entries)
        for (final e in space.value.entries) (space.key, e.key, e.value)
    ]..sort((a, b) {
        final t = (a.$3['at'] as String).compareTo(b.$3['at'] as String);
        return t != 0 ? t : a.$2.compareTo(b.$2);
      });
    for (final (space, _, entry) in all) {
      _apply(space, entry);
    }
  }

  void _apply(String spaceId, Map<String, dynamic> e) {
    final docId = e['doc'] as String;
    final doc = _docs[docId];
    switch (e['op']) {
      case 'add':
        _docs[docId] = {
          'space': spaceId,
          'title': e['title'],
          'created_at': e['at'],
          'mime': e['mime'],
          'size': e['size'],
          'sha256': e['sha256'],
          'file': e['file'],
          'rev': (doc?['rev'] as int? ?? 0) + 1,
          'deleted': doc?['deleted'] ?? false,
        };
      case 'rename':
        if (doc != null) {
          doc['title'] = e['title'];
          doc['rev'] = (doc['rev'] as int) + 1;
        }
      case 'delete':
        if (doc != null) {
          doc['deleted'] = true;
          doc['rev'] = (doc['rev'] as int) + 1;
        }
    }
  }

  /// Downloads log entries this device has not seen yet and replays.
  Future<void> _pull() async {
    var changed = false;
    for (final spaceId in _spaceKeys.keys) {
      final key = _spaceKeys[spaceId]!;
      final known = _entries[spaceId] ??= {};
      for (final f in await drive.list(await _spaceFolder(spaceId, 'log'))) {
        final id = '$spaceId/${f.name}';
        if (known.containsKey(f.name) || _skipped.contains(id)) continue;
        try {
          final clear = await decryptForSpace(
              key, await drive.read(f.id), 'log/$spaceId/${f.name}');
          known[f.name] =
              jsonDecode(utf8.decode(clear)) as Map<String, dynamic>;
        } on CryptoFailure {
          _skipped
              .add(id); // not written with this space key or tampered: ignore
        }
        changed = true;
      }
    }
    if (changed) {
      _replay();
      await _saveState();
    }
  }

  DocumentInfo _info(String id, Map<String, dynamic> d) => DocumentInfo(
        id: id,
        spaceId: d['space'] as String,
        title: d['title'] as String,
        createdAt: DateTime.parse(d['created_at'] as String),
        revision: d['rev'] as int,
        deleted: d['deleted'] as bool,
        mimeType: d['mime'] as String?,
        sizeBytes: d['size'] as int?,
      );

  // --- RemoteLibrary ------------------------------------------------------------------

  @override
  Future<SyncPage> sync({String? cursor, int limit = 200}) async {
    final trusted = _unb64(adminSignPublic);
    await _readManifest(trusted);
    await _pull();
    final readable = _spaceKeys.keys.toSet();
    return SyncPage(
      cursor: 'drive-$_manifestNo',
      hasMore: false,
      spaces: spaces,
      documents: [
        for (final e in _docs.entries)
          if (readable.contains(e.value['space'])) _info(e.key, e.value)
      ],
    );
  }

  @override
  Future<List<DocumentInfo>> documents(String spaceId) async {
    await _pull();
    return [
      for (final e in _docs.entries)
        if (e.value['space'] == spaceId && e.value['deleted'] != true)
          _info(e.key, e.value)
    ];
  }

  @override
  Future<DocumentInfo> upload({
    required String spaceId,
    required String filename,
    required int length,
    required Stream<List<int>> content,
    String? title,
  }) async {
    final key = _spaceKeys[spaceId];
    if (key == null) throw const ApiException(404);
    if (!_spaceInfo(spaceId).canWrite) throw const ApiException(403);

    final bytes = BytesBuilder(copy: false);
    await for (final chunk in content) {
      bytes.add(chunk);
      if (bytes.length > maxFileBytes) {
        throw const ApiException(413, code: 'too_large');
      }
    }
    final data = bytes.takeBytes();
    if (data.isEmpty) throw const ApiException(422, code: 'empty_file');
    final mime = sniffMimeType(data.length > 16 ? data.sublist(0, 16) : data);
    if (mime == null) throw const ApiException(422, code: 'unsupported_type');

    final sha = _b64((await Sha256().hash(data)).bytes);
    for (final d in _docs.values) {
      if (d['space'] == spaceId && d['sha256'] == sha && d['deleted'] != true) {
        throw const ApiException(409, code: 'duplicate');
      }
    }

    final docId = newId();
    final fileName = '$docId-v1';
    final enc = await encryptForSpace(key, data, 'doc/$docId/v1');
    await drive.createFile(await _spaceFolder(spaceId, 'files'), fileName, enc);

    final cleanTitle = (title?.trim().isNotEmpty ?? false)
        ? title!.trim()
        : filename.replaceAll(RegExp(r'\.[A-Za-z0-9]{1,5}$'), '');
    await _appendLog(spaceId, {
      'op': 'add',
      'doc': docId,
      'title': cleanTitle,
      'mime': mime,
      'size': data.length,
      'sha256': sha,
      'file': fileName,
    });
    return _info(docId, _docs[docId]!);
  }

  Future<void> rename(String docId, String title) async {
    final d = _docs[docId] ?? (throw const ApiException(404));
    final space = d['space'] as String;
    if (!_spaceInfo(space).canWrite) throw const ApiException(403);
    await _appendLog(
        space, {'op': 'rename', 'doc': docId, 'title': title.trim()});
  }

  Future<void> delete(String docId) async {
    final d = _docs[docId] ?? (throw const ApiException(404));
    final space = d['space'] as String;
    if (!_spaceInfo(space).canWrite) throw const ApiException(403);
    await _appendLog(space, {'op': 'delete', 'doc': docId});
  }

  /// Decrypted file content of a document.
  Future<Uint8List> download(String docId) async {
    final d = _docs[docId] ?? (throw const ApiException(404));
    final space = d['space'] as String;
    final key = _spaceKeys[space] ?? (throw const ApiException(404));
    final folder = await _spaceFolder(space, 'files');
    final f = await drive.find(folder, d['file'] as String) ??
        (throw const ApiException(404));
    return decryptForSpace(key, await drive.read(f.id), 'doc/$docId/v1');
  }
}
