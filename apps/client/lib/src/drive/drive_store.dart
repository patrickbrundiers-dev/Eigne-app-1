import 'dart:typed_data';

import '../api/models.dart';

/// A file or folder in Google Drive.
class DriveFile {
  const DriveFile(
      {required this.id, required this.name, required this.parentId});
  final String id;
  final String name;
  final String parentId;
}

/// The few Drive operations the app needs. Everything stored through it is already
/// encrypted; implementations only move bytes.
///
/// Files are never overwritten: new state is written as new files, so two devices can
/// never clobber each other. Network errors surface as [ConnectionFailed].
abstract class DriveStore {
  /// Parent id of the shared family area (`root` of the owner's Drive).
  static const root = 'root';

  /// Parent id of the person's private app-data folder (vault lives there).
  static const appData = 'appDataFolder';

  Future<DriveFile?> find(String parentId, String name);
  Future<List<DriveFile>> list(String parentId);
  Future<DriveFile> createFolder(String parentId, String name);
  Future<DriveFile> createFile(String parentId, String name, List<int> bytes);
  Future<Uint8List> read(String fileId);

  /// Returns the folder, creating it if needed.
  Future<DriveFile> folder(String parentId, String name) async =>
      await find(parentId, name) ?? await createFolder(parentId, name);
}

/// In-memory Drive for tests and offline development.
class FakeDrive extends DriveStore {
  final _files = <String, DriveFile>{};
  final _content = <String, Uint8List>{};
  int _next = 0;

  /// While true every call fails like a lost connection.
  bool offline = false;
  int reads = 0;

  void _check() {
    if (offline) throw const ConnectionFailed();
  }

  /// All stored bytes, to check that nothing readable reaches Drive.
  Iterable<Uint8List> get allContent => _content.values;
  Iterable<DriveFile> get allFiles => _files.values;

  @override
  Future<DriveFile?> find(String parentId, String name) async {
    _check();
    for (final f in _files.values) {
      if (f.parentId == parentId && f.name == name) return f;
    }
    return null;
  }

  @override
  Future<List<DriveFile>> list(String parentId) async {
    _check();
    return [
      for (final f in _files.values)
        if (f.parentId == parentId) f
    ];
  }

  @override
  Future<DriveFile> createFolder(String parentId, String name) async {
    _check();
    final f = DriveFile(id: 'f${_next++}', name: name, parentId: parentId);
    _files[f.id] = f;
    return f;
  }

  @override
  Future<DriveFile> createFile(
      String parentId, String name, List<int> bytes) async {
    _check();
    final f = await createFolder(parentId, name);
    _content[f.id] = Uint8List.fromList(bytes);
    return f;
  }

  @override
  Future<Uint8List> read(String fileId) async {
    _check();
    reads++;
    return _content[fileId] ?? (throw StateError('no such file $fileId'));
  }
}
