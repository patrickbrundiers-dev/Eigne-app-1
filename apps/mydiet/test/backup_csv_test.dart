import 'dart:io';

import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mydiet_ai/src/data/backup.dart';
import 'package:mydiet_ai/src/data/csv_export.dart';
import 'package:mydiet_ai/src/data/database.dart';
import 'package:mydiet_ai/src/data/db_encryption.dart' show newDbKey;

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  late AppDatabase db;
  late Directory tmp;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    tmp = await Directory.systemTemp.createTemp('mydiet-backup-test');
  });
  tearDown(() async {
    await db.close();
    await tmp.delete(recursive: true);
  });

  test('Tägliche Sicherung: einmal pro Tag, die neuesten bleiben', () async {
    final s = BackupService(db, tmp, keep: 3);
    for (var d = 1; d <= 5; d++) {
      expect(await s.runIfDue(now: DateTime(2026, 3, d)), isNotNull);
      expect(await s.runIfDue(now: DateTime(2026, 3, d, 18)), isNull);
    }
    final files = await s.list();
    expect(files.map(BackupService.dayOf), ['2026-03-05', '2026-03-04', '2026-03-03']);
    expect(tmp.listSync().where((e) => e.path.endsWith('.tmp')), isEmpty);
  });

  test('Wiederherstellen bringt alten Stand zurück und sichert vorher', () async {
    final s = BackupService(db, tmp);
    await db.saveWeight(day: '2026-03-01', weightKg: 98.4);
    final backup = (await s.runIfDue(now: DateTime(2026, 3, 1)))!;
    await db.saveWeight(day: '2026-03-02', weightKg: 97.9);
    expect((await db.allWeights()).length, 2);

    await s.restore(backup);
    expect((await db.allWeights()).single.weightKg, 98.4);
    final names = (await s.list()).map((f) => f.uri.pathSegments.last);
    expect(names.any((n) => n.contains('vor-wiederherstellung')), isTrue);
  });

  test('Verschlüsselte Sicherung (7.2b): kein Klartext in der Datei, Wiederherstellen klappt', () async {
    final key = newDbKey();
    final s = BackupService(db, tmp, key: key);
    await db.saveWeight(day: '2026-03-01', weightKg: 98.4);
    await db.setSetting('notiz', 'Geheimer Klartext');
    final backup = (await s.runIfDue(now: DateTime(2026, 3, 1)))!;
    expect(backup.path, endsWith('.sbak'));
    expect(BackupService.isEncrypted(backup), isTrue);
    expect(String.fromCharCodes(backup.readAsBytesSync()).contains('Geheimer Klartext'), isFalse);
    expect(await s.runIfDue(now: DateTime(2026, 3, 1, 20)), isNull);

    await db.saveWeight(day: '2026-03-02', weightKg: 97.9);
    await s.restore(backup);
    expect((await db.allWeights()).single.weightKg, 98.4);
    expect(await db.getSetting('notiz'), 'Geheimer Klartext');

    // Another key (e.g. after the key was lost) cannot read it, and says so.
    final other = BackupService(db, tmp, key: newDbKey());
    await expectLater(other.read(backup), throwsA(isA<StateError>()));
    await expectLater(BackupService(db, tmp).read(backup), throwsA(isA<StateError>()));
  });

  test('Alte Klartext-Sicherungen werden verschlüsselt, Inhalt bleibt gleich (7.2b)', () async {
    await db.saveWeight(day: '2026-03-01', weightKg: 98.4);
    final plain = BackupService(db, tmp, keep: 5);
    await plain.runIfDue(now: DateTime(2026, 3, 1));
    await plain.runIfDue(now: DateTime(2026, 3, 2));
    final before = {for (final f in await plain.list()) BackupService.dayOf(f): await f.readAsString()};

    final enc = BackupService(db, tmp, keep: 5, key: newDbKey());
    expect(await enc.encryptLegacy(), 2);
    final after = await enc.list();
    expect(after.map(BackupService.dayOf), ['2026-03-02', '2026-03-01']);
    expect(after.every(BackupService.isEncrypted), isTrue);
    for (final f in after) {
      expect(await enc.read(f), before[BackupService.dayOf(f)]);
    }
    expect(tmp.listSync().where((e) => e.path.endsWith('.json') || e.path.endsWith('.tmp')), isEmpty);
    expect(await enc.encryptLegacy(), 0);
    // A plain backup for a day that already has one is not written again.
    expect(await enc.runIfDue(now: DateTime(2026, 3, 2, 12)), isNull);
  });

  test('Ohne Schlüssel bleibt alles wie bisher (Klartext-JSON)', () async {
    final s = BackupService(db, tmp);
    final f = (await s.runIfDue(now: DateTime(2026, 3, 1)))!;
    expect(f.path, endsWith('.json'));
    expect(await s.encryptLegacy(), 0);
    expect(f.existsSync(), isTrue);
  });

  test('CSV: Semikolon, Dezimalkomma, Anführungszeichen, BOM', () async {
    final slot = (await db.watchMealSlots().first).first;
    final oats = (await db.searchFoods('Haferflocken')).first;
    await db.logFood(day: '2026-03-01', mealSlotId: slot.id, food: oats, amount: 55);
    await db.logQuickEntry(day: '2026-03-01', mealSlotId: slot.id, label: 'Brötchen; mit "Ei"', kcal: 320.5);
    final csv = diaryCsv(await db.allDiary(), {slot.id: slot.name});
    expect(csv, startsWith('${csvBom}Datum;Mahlzeit;Lebensmittel'));
    final lines = csv.trimRight().split('\n');
    expect(lines.length, 3);
    expect(lines[1], startsWith('2026-03-01;Frühstück;Haferflocken'));
    expect(lines[1], contains(';55;g;'));
    expect(lines[2], contains('"Brötchen; mit ""Ei"""'));
    expect(lines[2], contains(';320,5;'));

    await db.saveWeight(day: '2026-03-01', weightKg: 98.45);
    final w = weightCsv(await db.allWeights()).trimRight().split('\n');
    expect(w[1], '2026-03-01;98,5;;;');
  });
}
