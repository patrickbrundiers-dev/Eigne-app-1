import 'dart:io';

import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mydiet_ai/src/data/database.dart';
import 'package:mydiet_ai/src/data/db_encryption.dart';
import 'package:sqlite3/sqlite3.dart';

class _FailingStore implements DbKeyStore {
  _FailingStore({this.failRead = false});
  final bool failRead;
  @override
  Future<String?> read() async => failRead ? throw StateError('Keystore gesperrt') : null;
  @override
  Future<void> write(String key) async => throw StateError('Keystore voll');
}

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  late Directory dir;
  late File file;

  setUp(() {
    dir = Directory.systemTemp.createTempSync('sattly_enc_');
    file = File('${dir.path}/mydiet.sqlite');
  });
  tearDown(() => dir.deleteSync(recursive: true));

  AppDatabase openWith(String key) => AppDatabase(NativeDatabase(file, setup: (db) => db.execute(keyPragma(key))));

  /// An unencrypted database as older app versions left it, with some own data.
  Future<void> createPlainDb() async {
    final db = AppDatabase(NativeDatabase(file));
    await db.setSetting('test', 'Klartext-Wert');
    await db.setSetting('zweiter', '2');
    await db.close();
  }

  test('Schlüssel: 32 Zufallsbytes, nur sichere Zeichen; andere Schlüssel werden abgelehnt', () {
    final k = newDbKey();
    expect(k.length, 43);
    expect(RegExp(r'^[A-Za-z0-9_-]+$').hasMatch(k), isTrue);
    expect(newDbKey(), isNot(k));
    expect(() => keyPragma("abc'; DROP TABLE foods; --"), throwsArgumentError);
    expect(() => keyPragma('kurz'), throwsArgumentError);
  });

  test('Neuinstallation: Schlüssel wird angelegt, Datenbank entsteht verschlüsselt', () async {
    final keys = MemoryDbKeyStore();
    final p = await prepareEncryptedDatabase(file, keys);
    expect(p.result, DbPrepareResult.created);
    expect(keys.key, p.key);

    final db = openWith(p.key);
    await db.setSetting('a', 'b');
    await db.close();
    expect(await isPlainSqlite(file), isFalse);
    expect(String.fromCharCodes(file.readAsBytesSync()).contains('Klartext'), isFalse);
  });

  test('Bestehende unverschlüsselte Daten werden ohne Verlust umgestellt', () async {
    await createPlainDb();
    final before = file.readAsBytesSync();
    expect(await isPlainSqlite(file), isTrue);
    expect(String.fromCharCodes(before).contains('Klartext-Wert'), isTrue);

    final keys = MemoryDbKeyStore();
    final p = await prepareEncryptedDatabase(file, keys);
    expect(p.result, DbPrepareResult.migrated);
    expect(await isPlainSqlite(file), isFalse);
    expect(String.fromCharCodes(file.readAsBytesSync()).contains('Klartext-Wert'), isFalse);
    expect(File('${file.path}.verschluesselung.tmp').existsSync(), isFalse);

    // Same data and schema version, no migration runs again.
    final db = openWith(p.key);
    expect(await db.getSetting('test'), 'Klartext-Wert');
    expect(await db.getSetting('zweiter'), '2');
    final raw = sqlite3.open(file.path)..execute(keyPragma(p.key));
    expect(raw.userVersion, db.schemaVersion);
    raw.close();
    await db.close();

    // Without the key the file is unreadable.
    final noKey = sqlite3.open(file.path);
    expect(() => noKey.select('SELECT count(*) FROM sqlite_master'), throwsA(isA<SqliteException>()));
    noKey.close();
  });

  test('Zweiter Start: vorhandener Schlüssel wird genutzt, kein neuer angelegt', () async {
    final keys = MemoryDbKeyStore();
    final first = await prepareEncryptedDatabase(file, keys);
    final db = openWith(first.key);
    await db.setSetting('x', 'y');
    await db.close();

    final second = await prepareEncryptedDatabase(file, keys);
    expect(second.result, DbPrepareResult.opened);
    expect(second.key, first.key);
    expect(keys.writes, 1);
    final again = openWith(second.key);
    expect(await again.getSetting('x'), 'y');
    await again.close();
  });

  test('Daten aus dem WAL-Journal gehen bei der Umstellung nicht verloren', () async {
    // Simulates a crash: the rows are only in the -wal file, not yet in the main file.
    final work = '${dir.path}/arbeit.sqlite';
    final raw = sqlite3.open(work)
      ..execute('PRAGMA journal_mode = WAL;')
      ..execute('PRAGMA wal_autocheckpoint = 0;')
      ..execute('CREATE TABLE notiz (t TEXT)');
    for (var i = 0; i < 50; i++) {
      raw.execute('INSERT INTO notiz VALUES (?)', ['Eintrag $i']);
    }
    File(work).copySync(file.path);
    File('$work-wal').copySync('${file.path}-wal');
    raw.close();
    expect(File('${file.path}-wal').lengthSync(), greaterThan(0));

    final p = await prepareEncryptedDatabase(file, MemoryDbKeyStore());
    expect(p.result, DbPrepareResult.migrated);
    final enc = sqlite3.open(file.path)..execute(keyPragma(p.key));
    expect(enc.select('SELECT count(*) AS c FROM notiz').first['c'], 50);
    enc.close();
    expect(File('${file.path}-wal').existsSync(), isFalse);
  });

  test('Schlüssel verloren: Datei wird beiseitegelegt, nicht gelöscht', () async {
    final keys = MemoryDbKeyStore();
    final p = await prepareEncryptedDatabase(file, keys);
    final db = openWith(p.key);
    await db.setSetting('wichtig', 'ja');
    await db.close();
    final bytes = file.readAsBytesSync();

    keys.key = null; // e.g. restored on another phone without the Keystore entry
    final lost = await prepareEncryptedDatabase(file, keys, now: DateTime(2026, 11, 22, 19, 30));
    expect(lost.result, DbPrepareResult.keyLost);
    expect(lost.setAside, '${file.path}.unlesbar-20261122-193000');
    expect(File(lost.setAside!).readAsBytesSync(), bytes);
    expect(file.existsSync(), isFalse);
    expect(lost.key, isNot(p.key));

    // With the old key the set-aside file is still complete.
    final old = sqlite3.open(lost.setAside!)..execute(keyPragma(p.key));
    expect(old.select("SELECT value FROM settings WHERE key = 'wichtig'").first['value'], 'ja');
    old.close();
  });

  test('Falscher Schlüssel wird wie ein verlorener behandelt', () async {
    final p = await prepareEncryptedDatabase(file, MemoryDbKeyStore());
    final db = openWith(p.key);
    await db.setSetting('a', 'b');
    await db.close();

    final other = MemoryDbKeyStore(newDbKey());
    final r = await prepareEncryptedDatabase(file, other);
    expect(r.result, DbPrepareResult.keyLost);
    expect(r.key, other.key);
    expect(File(r.setAside!).existsSync(), isTrue);
  });

  test('Sicherer Speicher nicht lesbar: nichts wird verändert', () async {
    await createPlainDb();
    final before = file.readAsBytesSync();
    await expectLater(prepareEncryptedDatabase(file, _FailingStore(failRead: true)), throwsA(isA<DbKeyUnavailable>()));
    expect(file.readAsBytesSync(), before);
  });

  test('Schlüssel lässt sich nicht speichern: Klartext-Datei bleibt unverändert', () async {
    await createPlainDb();
    final before = file.readAsBytesSync();
    await expectLater(prepareEncryptedDatabase(file, _FailingStore()), throwsA(isA<DbKeyUnavailable>()));
    expect(file.readAsBytesSync(), before);
    final db = AppDatabase(NativeDatabase(file));
    expect(await db.getSetting('test'), 'Klartext-Wert');
    await db.close();
  });

  test('Reste einer abgebrochenen Umstellung werden aufgeräumt, das Original bleibt maßgeblich', () async {
    await createPlainDb();
    File('${file.path}.verschluesselung.tmp').writeAsStringSync('halb geschrieben');
    final p = await prepareEncryptedDatabase(file, MemoryDbKeyStore());
    expect(p.result, DbPrepareResult.migrated);
    expect(File('${file.path}.verschluesselung.tmp').existsSync(), isFalse);
    final db = openWith(p.key);
    expect(await db.getSetting('test'), 'Klartext-Wert');
    await db.close();
  });
}
