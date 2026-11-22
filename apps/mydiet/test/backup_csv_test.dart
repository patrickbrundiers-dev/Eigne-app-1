import 'dart:io';

import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mydiet_ai/src/data/backup.dart';
import 'package:mydiet_ai/src/data/csv_export.dart';
import 'package:mydiet_ai/src/data/database.dart';

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
