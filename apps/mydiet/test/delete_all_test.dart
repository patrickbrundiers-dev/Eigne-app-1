import 'dart:io';

import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mydiet_ai/src/data/backup.dart';
import 'package:mydiet_ai/src/data/database.dart';

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  late AppDatabase db;
  late Directory tmp;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    tmp = await Directory.systemTemp.createTemp('sattly-delete-test');
  });
  tearDown(() async {
    await db.close();
    await tmp.delete(recursive: true);
  });

  Future<int> count(TableInfo t) async =>
      (await db.customSelect('SELECT COUNT(*) AS c FROM ${t.actualTableName}').getSingle()).read<int>('c');

  Future<void> fill() async {
    await db.saveProfile(
      ProfilesCompanion.insert(
        sex: 'male',
        birthDate: DateTime(1986, 4, 1),
        heightCm: 182,
        startWeightKg: 104,
        targetWeightKg: 88,
        jobActivity: 'sitting',
      ),
    );
    await db.saveWeight(day: '2026-03-01', weightKg: 98.4);
    final slot = (await db.watchMealSlots().first).first;
    final skyr = (await db.searchFoods('Skyr')).first;
    await db.logFood(day: '2026-03-01', mealSlotId: slot.id, food: skyr, amount: 300);
    await db.deleteDiaryEntry((await db.diaryForDay('2026-03-01')).first.id); // Tombstone
    await db.addWater('2026-03-01', 500);
    await db.setSetting('hideNumbers', 'true');
    await db.saveMealSlots([(id: null, name: 'Mitternachtssnack', minuteOfDay: 0)]);
  }

  test('Alles weg, auch Tombstones; danach Zustand wie neu installiert', () async {
    await fill();
    final baseFoods = await count(db.foods);
    final micros = await count(db.foodMicronutrients);
    expect(micros, greaterThan(0));

    final deleted = await db.deleteAllData();
    expect(deleted['diary_entries'], 1);
    expect(deleted['profiles'], 1);

    expect(await db.getProfile(), isNull);
    expect(await count(db.diaryEntries), 0);
    expect(await count(db.weightEntries), 0);
    expect(await count(db.waterEntries), 0);
    expect(await db.getSetting('hideNumbers'), isNull);
    // Standard-Mahlzeiten statt der eigenen, Basis-Lebensmittel und Mikronährstoffe wieder da.
    final slots = await db.watchMealSlots().first;
    expect(slots.map((s) => s.name), isNot(contains('Mitternachtssnack')));
    expect(slots.length, greaterThanOrEqualTo(3));
    expect(await count(db.foods), baseFoods);
    expect(await count(db.foodMicronutrients), micros);
  });

  test('Eigene Lebensmittel werden mitgelöscht', () async {
    final before = await count(db.foods);
    await db.customStatement(
      "INSERT INTO foods (id, name, food_key, kcal, protein, carbs, fat, source, created_at, updated_at) "
      "VALUES ('x1', 'Omas Kuchen', 'omas kuchen', 400, 5, 50, 20, 'user', 0, 0)",
    );
    expect(await count(db.foods), before + 1);
    await db.deleteAllData();
    expect(await count(db.foods), before);
    expect(await db.getFood('x1'), isNull);
  });

  test('Sicherungen löschen', () async {
    final s = BackupService(db, tmp);
    await s.runIfDue(now: DateTime(2026, 3, 1));
    await s.backupNow(now: DateTime(2026, 3, 2));
    expect((await s.list()).length, 2);
    expect(await s.deleteAll(), 2);
    expect(await s.list(), isEmpty);
    expect(await BackupService(db, Directory('${tmp.path}/fehlt')).deleteAll(), 0);
  });
}
