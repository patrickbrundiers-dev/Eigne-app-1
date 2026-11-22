import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mydiet_ai/src/core/portion_memory.dart';
import 'package:mydiet_ai/src/data/database.dart';
import 'package:mydiet_ai/src/data/meal_text_match.dart';

void main() {
  group('Übliche Menge', () {
    test('Ohne Einträge keine Annahme', () => expect(usualAmount(const []), isNull));
    test('Ein Eintrag reicht', () => expect(usualAmount(const [180]), 180));
    test('Häufigste Menge gewinnt', () => expect(usualAmount(const [250, 150, 150, 200, 150]), 150));
    test('Gleichstand: die neuere', () => expect(usualAmount(const [200, 150, 150, 200]), 200));
    test('Gerundet auf ganze Gramm', () => expect(usualAmount(const [149.6, 150.2]), 150));
    test('Nur die letzten zehn zählen', () {
      final old = List<double>.filled(20, 100);
      expect(usualAmount([...List<double>.filled(4, 60), ...old]), 100);
      expect(usualAmount([60, 60, 60, ...List<double>.filled(7, 30), ...old]), 30);
    });
  });

  test('Aus dem Tagebuch gelernt', () async {
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    await db.getProfile();
    final slot = (await db.watchMealSlots().first).first;
    final oats = (await db.searchFoods('haferflocken')).first;
    expect(await usualLoggedAmount(db, oats.id), isNull);
    for (final a in [60.0, 40.0, 60.0]) {
      await db.logFood(day: '2026-11-20', mealSlotId: slot.id, food: oats, amount: a);
    }
    expect(await usualLoggedAmount(db, oats.id), 60);
  });
}
