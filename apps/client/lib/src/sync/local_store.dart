import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

/// Small on-device storage for the offline cache and the upload queue.
///
/// Records are JSON objects, blobs are files that wait for upload. Everything lives in the
/// app's private support directory and is wiped on sign-out.
abstract class LocalStore {
  Future<Map<String, dynamic>?> readRecord(String name);
  Future<void> writeRecord(String name, Map<String, dynamic> data);

  /// Copies [content] into the store; returns its size in bytes.
  Future<int> putBlob(String name, Stream<List<int>> content);
  Stream<List<int>> openBlob(String name);
  Future<void> deleteBlob(String name);

  /// Removes every record and blob.
  Future<void> clear();
}

class FileLocalStore implements LocalStore {
  FileLocalStore([Directory? root]) : _root = root;

  Directory? _root;

  Future<Directory> _dir() async {
    final root = _root ??= Directory(
        '${(await getApplicationSupportDirectory()).path}${Platform.pathSeparator}sync');
    await root.create(recursive: true);
    return root;
  }

  static final _safe = RegExp(r'^[A-Za-z0-9_.-]{1,100}$');

  Future<File> _file(String name, String ext) async {
    if (!_safe.hasMatch(name)) throw ArgumentError.value(name, 'name');
    final dir = await _dir();
    return File('${dir.path}${Platform.pathSeparator}$name.$ext');
  }

  @override
  Future<Map<String, dynamic>?> readRecord(String name) async {
    final f = await _file(name, 'json');
    if (!await f.exists()) return null;
    try {
      return jsonDecode(await f.readAsString()) as Map<String, dynamic>;
    } on FormatException {
      return null; // a damaged cache is rebuilt by the next full sync
    }
  }

  @override
  Future<void> writeRecord(String name, Map<String, dynamic> data) async {
    final f = await _file(name, 'json');
    final tmp = File('${f.path}.tmp');
    await tmp.writeAsString(jsonEncode(data), flush: true);
    await tmp
        .rename(f.path); // atomic replace, no half-written cache after a crash
  }

  @override
  Future<int> putBlob(String name, Stream<List<int>> content) async {
    final f = await _file(name, 'blob');
    final sink = f.openWrite();
    var size = 0;
    try {
      await for (final chunk in content) {
        size += chunk.length;
        sink.add(chunk);
      }
      await sink.flush();
    } finally {
      await sink.close();
    }
    return size;
  }

  @override
  Stream<List<int>> openBlob(String name) async* {
    yield* (await _file(name, 'blob')).openRead();
  }

  @override
  Future<void> deleteBlob(String name) async {
    final f = await _file(name, 'blob');
    if (await f.exists()) await f.delete();
  }

  @override
  Future<void> clear() async {
    final dir = await _dir();
    if (await dir.exists()) await dir.delete(recursive: true);
  }
}

/// For tests.
class MemoryLocalStore implements LocalStore {
  final records = <String, String>{};
  final blobs = <String, List<int>>{};

  @override
  Future<Map<String, dynamic>?> readRecord(String name) async {
    final raw = records[name];
    return raw == null ? null : jsonDecode(raw) as Map<String, dynamic>;
  }

  @override
  Future<void> writeRecord(String name, Map<String, dynamic> data) async {
    records[name] = jsonEncode(data);
  }

  @override
  Future<int> putBlob(String name, Stream<List<int>> content) async {
    final bytes = <int>[];
    await for (final chunk in content) {
      bytes.addAll(chunk);
    }
    blobs[name] = bytes;
    return bytes.length;
  }

  @override
  Stream<List<int>> openBlob(String name) => Stream.value(blobs[name]!);

  @override
  Future<void> deleteBlob(String name) async => blobs.remove(name);

  @override
  Future<void> clear() async {
    records.clear();
    blobs.clear();
  }
}
