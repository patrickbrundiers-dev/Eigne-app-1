import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:sqlite3/sqlite3.dart';

/// Database encryption at rest (7.2, D-22).
///
/// The database file is encrypted with SQLite3 Multiple Ciphers (selected in pubspec.yaml under
/// `hooks`). The key is a random 256-bit value that never leaves the device: it lives in the
/// platform's secure storage (Android Keystore, Windows Credential Manager), never in the
/// database, an export, a backup or a log.
///
/// [prepareEncryptedDatabase] runs before the app opens the database and handles every state:
/// a new install, an existing plaintext database from an older version (converted once, the
/// original stays untouched until the encrypted copy is verified), an already encrypted
/// database, and a database whose key is gone (set aside, never deleted).

/// Where the key lives. Replaceable in tests.
abstract class DbKeyStore {
  Future<String?> read();
  Future<void> write(String key);
}

class MemoryDbKeyStore implements DbKeyStore {
  MemoryDbKeyStore([this.key]);
  String? key;
  int writes = 0;
  @override
  Future<String?> read() async => key;
  @override
  Future<void> write(String key) async {
    writes++;
    this.key = key;
  }
}

enum DbPrepareResult {
  /// No database yet: a new key was created, the database will be created encrypted.
  created,

  /// The database was already encrypted and the key fits.
  opened,

  /// An unencrypted database from an older version was converted.
  migrated,

  /// The database could not be opened with the stored key (or no key exists any more, e.g.
  /// after restoring an Android backup on another phone). It was renamed to [PreparedDb.setAside]
  /// and the app starts with an empty database.
  keyLost,
}

class PreparedDb {
  const PreparedDb(this.path, this.key, this.result, {this.setAside});
  final String path;
  final String key;
  final DbPrepareResult result;
  final String? setAside;
}

/// Thrown when the key store itself fails. The database is left exactly as it was.
class DbKeyUnavailable implements Exception {
  DbKeyUnavailable(this.cause);
  final Object cause;
  @override
  String toString() => 'Der Schlüssel der Datenbank ist nicht lesbar: $cause';
}

/// The 16-byte header of every unencrypted SQLite file.
const _plainHeader = 'SQLite format 3\u0000';

/// A fresh random key: 32 bytes from a secure random source, base64url without padding
/// (only `A-Z a-z 0-9 - _`, so it can be used in a PRAGMA without escaping).
String newDbKey([Random? random]) {
  final r = random ?? Random.secure();
  final bytes = List<int>.generate(32, (_) => r.nextInt(256));
  return base64Url.encode(bytes).replaceAll('=', '');
}

final _keyPattern = RegExp(r'^[A-Za-z0-9_-]{32,}$');

/// The statement that unlocks the database; must be the first statement on a connection.
String keyPragma(String key) {
  if (!_keyPattern.hasMatch(key)) throw ArgumentError('Ungültiger Datenbankschlüssel');
  return "PRAGMA key = '$key';";
}

/// Whether [file] is an unencrypted SQLite database. An empty file counts as unencrypted.
Future<bool> isPlainSqlite(File file) async {
  final raf = await file.open();
  try {
    final head = await raf.read(16);
    if (head.isEmpty) return true;
    return head.length == 16 && String.fromCharCodes(head) == _plainHeader;
  } finally {
    await raf.close();
  }
}

String _stamp(DateTime t) {
  String two(int v) => v.toString().padLeft(2, '0');
  return '${t.year}${two(t.month)}${two(t.day)}-${two(t.hour)}${two(t.minute)}${two(t.second)}';
}

Future<void> _deleteIfExists(String path) async {
  final f = File(path);
  if (await f.exists()) await f.delete();
}

/// Makes sure [file] is encrypted and returns the key to open it with.
Future<PreparedDb> prepareEncryptedDatabase(
  File file,
  DbKeyStore keys, {
  DateTime? now,
  String Function()? makeKey,
}) async {
  final path = file.path;
  final tmpPath = '$path.verschluesselung.tmp';
  // A leftover from a conversion that was interrupted before the swap. The original is intact.
  await _deleteIfExists(tmpPath);

  String? key;
  try {
    key = await keys.read();
  } catch (e) {
    throw DbKeyUnavailable(e);
  }

  Future<String> createKey() async {
    final k = (makeKey ?? newDbKey)();
    try {
      await keys.write(k);
      // Only use a key that can be read back; otherwise the data would be locked away.
      if (await keys.read() != k) throw StateError('Schlüssel nach dem Speichern nicht lesbar');
    } catch (e) {
      throw DbKeyUnavailable(e);
    }
    return k;
  }

  if (!await file.exists()) {
    return PreparedDb(path, key ?? await createKey(), DbPrepareResult.created);
  }

  if (await isPlainSqlite(file)) {
    final k = key ?? await createKey();
    await _encryptPlainFile(path, tmpPath, k);
    return PreparedDb(path, k, DbPrepareResult.migrated);
  }

  if (key != null && _opens(path, key)) {
    return PreparedDb(path, key, DbPrepareResult.opened);
  }

  // Encrypted, but the key is missing or wrong: keep the file, start fresh.
  final aside = '$path.unlesbar-${_stamp(now ?? DateTime.now())}';
  await file.rename(aside);
  for (final suffix in ['-wal', '-shm', '-journal']) {
    final f = File('$path$suffix');
    if (await f.exists()) await f.rename('$aside$suffix');
  }
  final k = key ?? await createKey();
  return PreparedDb(path, k, DbPrepareResult.keyLost, setAside: aside);
}

bool _opens(String path, String key) {
  Database? db;
  try {
    db = sqlite3.open(path, mode: OpenMode.readOnly);
    db.execute(keyPragma(key));
    db.select('SELECT count(*) FROM sqlite_master');
    return true;
  } on SqliteException {
    return false;
  } finally {
    db?.close();
  }
}

/// Copies the plaintext database into an encrypted file, verifies it and only then replaces
/// the original. If anything fails, the original stays as it was and the error is rethrown.
Future<void> _encryptPlainFile(String path, String tmpPath, String key) async {
  final plain = sqlite3.open(path);
  final Map<String, int> counts;
  final int userVersion;
  try {
    // Fold a WAL file into the main file, so the copy below is complete.
    plain.execute('PRAGMA wal_checkpoint(TRUNCATE);');
    userVersion = plain.userVersion;
    counts = _rowCounts(plain);
    plain.execute('VACUUM INTO ?;', [tmpPath]);
  } finally {
    plain.close();
  }

  try {
    final enc = sqlite3.open(tmpPath);
    try {
      enc.execute('PRAGMA journal_mode = DELETE;');
      enc.execute("PRAGMA rekey = '${_checked(key)}';");
      enc.userVersion = userVersion;
    } finally {
      enc.close();
    }

    final check = sqlite3.open(tmpPath);
    try {
      check.execute(keyPragma(key));
      final integrity = check.select('PRAGMA integrity_check;').first.values.first;
      if (integrity != 'ok') throw StateError('Prüfung der verschlüsselten Kopie fehlgeschlagen: $integrity');
      if (check.userVersion != userVersion) throw StateError('Schemaversion der Kopie stimmt nicht');
      final copied = _rowCounts(check);
      if (copied.length != counts.length || counts.entries.any((e) => copied[e.key] != e.value)) {
        throw StateError('Die verschlüsselte Kopie enthält nicht alle Einträge');
      }
    } finally {
      check.close();
    }
    if (await isPlainSqlite(File(tmpPath))) throw StateError('Die Kopie ist nicht verschlüsselt');

    // Remnants of the plaintext connection must not be applied to the new file.
    await _deleteIfExists('$path-wal');
    await _deleteIfExists('$path-shm');
    await _deleteIfExists('$path-journal');
    // Atomic on Android and Windows: the original is replaced in one step.
    await File(tmpPath).rename(path);
  } catch (_) {
    await _deleteIfExists(tmpPath);
    rethrow;
  }
}

String _checked(String key) {
  keyPragma(key); // throws on anything but the safe alphabet
  return key;
}

Map<String, int> _rowCounts(Database db) {
  final tables = db
      .select("SELECT name FROM sqlite_master WHERE type = 'table' AND name NOT LIKE 'sqlite_%' ORDER BY name")
      .map((r) => r['name'] as String);
  return {
    for (final t in tables) t: db.select('SELECT count(*) AS c FROM "${t.replaceAll('"', '""')}"').first['c'] as int,
  };
}
