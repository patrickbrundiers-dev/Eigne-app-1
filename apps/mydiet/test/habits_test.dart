import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mydiet_ai/src/core/dates.dart';
import 'package:mydiet_ai/src/core/habits.dart';
import 'package:mydiet_ai/src/data/database.dart';
import 'package:mydiet_ai/src/data/habits_data.dart';

LoggedMeal meal(int day, String slot, List<String> foods) =>
    LoggedMeal(day: DateTime(2026, 11, day), slotId: slot, foods: foods.toSet());

void main() {
  final today = DateTime(2026, 11, 22);

  group('Gewohnheiten erkennen', () {
    test('Drei gleiche Frühstücke werden vorgeschlagen', () {
      final r = findHabits(
        today: today,
        meals: [
          meal(18, 'f', ['hafer', 'banane', 'milch']),
          meal(19, 'f', ['hafer', 'banane', 'milch']),
          meal(21, 'f', ['hafer', 'banane', 'milch']),
          meal(20, 'f', ['brot', 'kaese']),
        ],
      );
      expect(r, hasLength(1));
      expect(r.single.foods, ['banane', 'hafer', 'milch']);
      expect(r.single.count, 3);
      expect(r.single.lastDay, DateTime(2026, 11, 21));
      expect(r.single.reason, '3× in den letzten 4 Wochen');
    });

    test('Zweimal reicht nicht, ein einzelnes Lebensmittel auch nicht', () {
      final r = findHabits(
        today: today,
        meals: [
          meal(18, 'f', ['hafer', 'banane']),
          meal(19, 'f', ['hafer', 'banane']),
          meal(20, 'f', ['apfel']),
          meal(21, 'f', ['apfel']),
          meal(22, 'f', ['apfel']),
        ],
      );
      expect(r, isEmpty);
    });

    test('Andere Mahlzeit zählt nicht mit', () {
      final r = findHabits(
        today: today,
        meals: [
          meal(18, 'f', ['a', 'b']),
          meal(19, 'm', ['a', 'b']),
          meal(20, 'a', ['a', 'b']),
        ],
      );
      expect(r, isEmpty);
    });

    test('Mit Extras zählt die Kernmahlzeit; die größere gewinnt nur bei gleicher Häufigkeit', () {
      final r = findHabits(
        today: today,
        meals: [
          meal(18, 'f', ['a', 'b']),
          meal(19, 'f', ['a', 'b', 'c']),
          meal(20, 'f', ['a', 'b']),
        ],
      );
      expect(r.single.foods, ['a', 'b']);
      expect(r.single.count, 3);
    });

    test('Älter als vier Wochen, schon Vorlage oder abgelehnt: kein Vorschlag', () {
      final meals = [
        meal(1, 'f', ['a', 'b']),
        meal(2, 'f', ['a', 'b']),
        meal(3, 'f', ['a', 'b']),
      ];
      expect(findHabits(today: DateTime(2026, 12, 31), meals: meals), isEmpty);
      expect(
        findHabits(
          today: DateTime(2026, 11, 5),
          meals: meals,
          templates: {
            'f': [
              {'a', 'b'},
            ],
          },
        ),
        isEmpty,
      );
      expect(findHabits(today: DateTime(2026, 11, 5), meals: meals, dismissed: {'f:a+b'}), isEmpty);
      expect(findHabits(today: DateTime(2026, 11, 5), meals: meals), hasLength(1));
    });
  });

  test('Aus dem Tagebuch: vorschlagen, als Vorlage speichern, danach nicht mehr', () async {
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    await db.getProfile();
    final slot = (await db.watchMealSlots().first).first;
    final oats = (await db.searchFoods('haferflocken')).first;
    final banana = (await db.searchFoods('banane')).first;
    final now = DateTime.now();
    for (var i = 1; i <= 3; i++) {
      final d = dayKey(now.subtract(Duration(days: i)));
      await db.logFood(day: d, mealSlotId: slot.id, food: oats, amount: 60);
      await db.logFood(day: d, mealSlotId: slot.id, food: banana, amount: 120);
    }
    final s = await habitSuggestions(db, slotId: slot.id);
    expect(s, hasLength(1));
    expect(s.single.names.toSet(), {oats.name, banana.name});
    await saveHabitAsTemplate(db, s.single, name: 'Mein Frühstück');
    final tpl = (await db.watchTemplates().first).single;
    expect((await db.templateItemsOf(tpl.id)).map((i) => i.amount), [60, 120]);
    expect(await habitSuggestions(db, slotId: slot.id), isEmpty);

    // Abgelehnte Vorschläge bleiben weg.
    await db.deleteTemplate(tpl.id);
    final again = await habitSuggestions(db, slotId: slot.id);
    expect(again, hasLength(1));
    await dismissHabit(db, again.single);
    expect(await habitSuggestions(db, slotId: slot.id), isEmpty);
  });
}
