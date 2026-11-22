import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart';

import '../core/dates.dart';
import 'database.dart';
import 'db_encryption.dart' show keyPragma;

/// Key for encrypted backups, set by `openAppDatabase` when the database itself is encrypted
/// (same key, 7.2b). Null means plain JSON backups as before.
String? backupKey;

/// Automatic local backups: one JSON export per day in the app's private storage,
/// the newest [keep] are kept. A restore first saves the current state, so a
/// restore can itself be undone.
///
/// With a [key] (7.2b) each backup is a small SQLite file encrypted like the database (`.sbak`,
/// one row with the JSON export). Older plain `.json` backups stay readable and are converted by
/// [encryptLegacy].
class BackupService {
  BackupService(this.db, this.dir, {this.keep = 14, this.key});

  final AppDatabase db;
  final Directory dir;
  final int keep;
  final String? key;

  static const _prefix = 'mydiet-backup-';
  static const _plainExt = '.json';
  static const _encExt = '.sbak';

  static Future<BackupService> forApp(AppDatabase db) async {
    final base = await getApplicationSupportDirectory();
    return BackupService(db, Directory('${base.path}${Platform.pathSeparator}backups'), key: backupKey);
  }

  String get _ext => key == null ? _plainExt : _encExt;

  static String _name(File f) => f.uri.pathSegments.last;

  /// Whether [f] is an encrypted backup.
  static bool isEncrypted(File f) => _name(f).endsWith(_encExt);

  File _file(String name) => File('${dir.path}${Platform.pathSeparator}$name');

  /// Backups, newest first.
  Future<List<File>> list() async {
    if (!await dir.exists()) return [];
    final files = await dir
        .list()
        .where(
          (e) =>
              e is File &&
              e.uri.pathSegments.last.startsWith(_prefix) &&
              (e.path.endsWith(_plainExt) || e.path.endsWith(_encExt)),
        )
        .cast<File>()
        .toList();
    files.sort((a, b) => b.uri.pathSegments.last.compareTo(a.uri.pathSegments.last));
    return files;
  }

  /// Writes today's backup if it does not exist yet. Returns the new file or null.
  Future<File?> runIfDue({DateTime? now}) async {
    final day = dayKey(now ?? DateTime.now());
    if (await _file('$_prefix$day$_plainExt').exists() || await _file('$_prefix$day$_encExt').exists()) return null;
    final f = _file('$_prefix$day$_ext');
    final written = await _write(f);
    await _prune();
    return written;
  }

  /// Saves the current state (also when a backup of today exists).
  Future<File> backupNow({String suffix = 'manuell', DateTime? now}) async {
    final t = now ?? DateTime.now();
    final stamp =
        '${dayKey(t)}-${t.hour.toString().padLeft(2, '0')}${t.minute.toString().padLeft(2, '0')}'
        '${t.second.toString().padLeft(2, '0')}';
    final f = await _write(_file('$_prefix$stamp-$suffix$_ext'));
    await _prune();
    return f;
  }

  /// Replaces all data with [backup]; the current state is saved first.
  Future<void> restore(File backup) async {
    final json = await read(backup);
    await backupNow(suffix: 'vor-wiederherstellung');
    await db.importJson(json);
  }

  /// The JSON export stored in [backup], plain or encrypted.
  Future<String> read(File backup) async {
    if (!isEncrypted(backup)) return backup.readAsString();
    final k = key;
    if (k == null) throw StateError('Diese Sicherung ist verschlüsselt und auf diesem Gerät nicht lesbar.');
    final sdb = sqlite3.open(backup.path, mode: OpenMode.readOnly);
    try {
      sdb.execute(keyPragma(k));
      return sdb.select('SELECT json FROM backup').single['json'] as String;
    } on SqliteException {
      throw StateError('Diese Sicherung lässt sich mit dem Schlüssel dieses Geräts nicht öffnen.');
    } finally {
      sdb.close();
    }
  }

  Future<File> _write(File f) async {
    await dir.create(recursive: true);
    return _writeJson(f, await db.exportJson());
  }

  // Write to a temp file first, so a crash never leaves a half-written backup.
  Future<File> _writeJson(File f, String json) async {
    final tmp = File('${f.path}.tmp');
    if (await tmp.exists()) await tmp.delete();
    final k = key;
    if (k == null || !isEncrypted(f)) {
      await tmp.writeAsString(json, flush: true);
    } else {
      final sdb = sqlite3.open(tmp.path);
      try {
        sdb.execute(keyPragma(k));
        sdb.execute('PRAGMA journal_mode = DELETE;');
        sdb.execute('CREATE TABLE backup (json TEXT NOT NULL)');
        sdb.execute('INSERT INTO backup (json) VALUES (?)', [json]);
      } finally {
        sdb.close();
      }
    }
    return tmp.rename(f.path);
  }

  /// Converts plain `.json` backups into encrypted ones (7.2b). Each plain file is deleted only
  /// after its encrypted copy was read back unchanged. Returns how many were converted.
  Future<int> encryptLegacy() async {
    if (key == null) return 0;
    var n = 0;
    for (final f in await list()) {
      if (isEncrypted(f)) continue;
      final name = _name(f);
      final target = _file('${name.substring(0, name.length - _plainExt.length)}$_encExt');
      final json = await f.readAsString();
      if (!await target.exists()) await _writeJson(target, json);
      if (await read(target) != json) {
        throw StateError('Verschlüsselte Sicherung weicht ab: $name');
      }
      await f.delete();
      n++;
    }
    return n;
  }

  Future<void> _prune() async {
    final all = await list();
    for (final f in all.skip(keep)) {
      try {
        await f.delete();
      } on FileSystemException {
        // ignore: a locked file stays until the next run
      }
    }
  }

  /// Deletes all backups (used by "Alle Daten löschen"). Returns how many were removed.
  Future<int> deleteAll() async {
    var n = 0;
    for (final f in await list()) {
      await f.delete();
      n++;
    }
    return n;
  }

  /// Date part of a backup file name, e.g. "2026-03-01".
  static String dayOf(File f) => f.uri.pathSegments.last.substring(_prefix.length, _prefix.length + 10);
}
