import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mydiet_ai/src/core/energy.dart';
import 'package:mydiet_ai/src/core/fasting.dart';
import 'package:mydiet_ai/src/core/meal_plan.dart';
import 'package:mydiet_ai/src/data/database.dart';

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  group('Makro-Aufteilung', () {
    EnergyResult calc({double? cap, double fat = 30, double ppk = 1.8}) => calculateEnergy(
      EnergyInput(
        sex: Sex.male,
        ageYears: 40,
        heightCm: 182,
        weightKg: 100,
        targetWeightKg: 100,
        jobActivity: JobActivity.sitting,
        calorieOverride: 2400,
        proteinPerKg: ppk,
        fatPercent: fat,
        carbCapG: cap,
      ),
    );

    test('Ohne Grenze: Kohlenhydrate sind der Rest', () {
      final r = calc();
      expect(r.proteinG, 180);
      expect(r.fatG, 80);
      expect(r.carbsG, ((2400 - 720 - 720) / 4).round());
    });

    test('Low Carb: Kohlenhydrate begrenzt, Rest als Fett, Energie bleibt gleich', () {
      final r = calc(cap: 100, fat: 40);
      expect(r.carbsG, 100);
      expect(r.fatG, ((2400 - 180 * 4 - 100 * 4) / 9).round());
      final kcal = r.proteinG * 4 + r.carbsG * 4 + r.fatG * 9;
      expect((kcal - 2400).abs(), lessThan(9));
      expect(r.steps.any((s) => s.label == 'Kohlenhydrat-Grenze'), isTrue);
    });

    test('Grenze über dem Rest ändert nichts', () {
      expect(calc(cap: 500).carbsG, calc().carbsG);
    });

    test('Vorlagen passen zur Ernährungsweise', () {
      expect(presetForDietStyle('low_carb').carbCapG, 100);
      expect(presetForDietStyle('keto').carbCapG, 30);
      expect(presetForDietStyle(null).id, 'balanced');
      expect(macroPresets.map((p) => p.id).toSet().length, macroPresets.length);
    });
  });

  group('Wochenplan-Rechnung', () {
    test('Anteile: Snacks 10 %, Rest gleich, Summe 100 %', () {
      final s = slotShares(const [
        (id: 'f', name: 'Frühstück'),
        (id: 'm', name: 'Mittagessen'),
        (id: 'a', name: 'Abendessen'),
        (id: 's', name: 'Snacks'),
      ]);
      expect(s['s'], closeTo(0.1, 1e-9));
      expect(s['f'], closeTo(0.3, 1e-9));
      expect(s.values.reduce((a, b) => a + b), closeTo(1, 1e-9));
      expect(slotShares(const [(id: 'x', name: 'Mahlzeit')]), {'x': 1.0});
    });

    test('Generator: Kalorien je Mahlzeit, keine Wiederholung am selben Tag, Rotation', () {
      const pool = [
        PlanRecipe(id: 'a', kcalPer100: 150, servingWeight: 400),
        PlanRecipe(id: 'b', kcalPer100: 200, servingWeight: 300),
        PlanRecipe(id: 'c', kcalPer100: 120, servingWeight: 500),
      ];
      final plan = generatePlan(
        pool: pool,
        shares: const {'f': 0.3, 'm': 0.3, 'a': 0.3, 's': 0.1},
        days: 7,
        targetKcal: 2000,
        skipSlots: const {'s'},
      );
      expect(plan.length, 21);
      for (var d = 0; d < 7; d++) {
        final ids = plan.where((m) => m.dayIndex == d).map((m) => m.recipeId).toList();
        expect(ids.toSet().length, 3);
      }
      final first = plan.first; // a: 600 kcal / 150 per 100 g = 400 g
      expect(first.recipeId, 'a');
      expect(first.grams, 400);
      for (final m in plan) {
        expect(m.grams % 10, 0);
      }
    });

    test('Portionen werden begrenzt (0,5–2,5) und leere Pools liefern nichts', () {
      final plan = generatePlan(
        pool: const [PlanRecipe(id: 'x', kcalPer100: 50, servingWeight: 200)],
        shares: const {'m': 1},
        days: 1,
        targetKcal: 3000,
      );
      expect(plan.single.grams, 500); // 2,5 × 200 g
      expect(generatePlan(pool: const [], shares: const {'m': 1}, days: 3, targetKcal: 2000), isEmpty);
      expect(
        filterByTags(
          const [
            PlanRecipe(id: 'x', kcalPer100: 1, servingWeight: 1, tags: ['Schnell', 'vegan']),
            PlanRecipe(id: 'y', kcalPer100: 1, servingWeight: 1, tags: ['schnell']),
          ],
          {'schnell', 'Vegan'},
        ).single.id,
        'x',
      );
    });
  });

  group('Fasten', () {
    test('Zustand und Formatierung', () {
      final s = FastingState(start: DateTime(2026, 11, 21, 20), now: DateTime(2026, 11, 22, 8, 30), targetHours: 16);
      expect(s.elapsed, const Duration(hours: 12, minutes: 30));
      expect(s.remaining, const Duration(hours: 3, minutes: 30));
      expect(s.progress, closeTo(12.5 / 16, 1e-9));
      expect(s.reached, isFalse);
      expect(s.endsAt, DateTime(2026, 11, 22, 12));
      expect(formatHm(s.elapsed), '12:30 h');
      expect(protocolById('18_6').fastHours, 18);
      expect(protocolById('unbekannt').id, '16_8');
      expect(
        averageFastHours([
          (start: DateTime(2026, 1, 1, 20), end: DateTime(2026, 1, 2, 12)),
          (start: DateTime(2026, 1, 2, 20), end: DateTime(2026, 1, 3, 14)),
          (start: DateTime(2026, 1, 3, 20), end: null),
        ]),
        17,
      );
    });
  });

  group('Datenbank', () {
    late AppDatabase db;
    setUp(() => db = AppDatabase(NativeDatabase.memory()));
    tearDown(() => db.close());

    Future<String> recipe(String name, {List<String> tags = const []}) async {
      final oats = (await db.searchFoods('Haferflocken')).first;
      return db.saveRecipe(name: name, servings: 2, tags: tags, items: [IngredientInput.fromFood(oats, 200)]);
    }

    test('Plan ins Tagebuch übernehmen zählt nie doppelt', () async {
      final slot = (await db.watchMealSlots().first).first;
      final skyr = (await db.searchFoods('Skyr')).first;
      final id = await db.planFood(day: '2026-11-23', mealSlotId: slot.id, food: skyr, amount: 250);
      expect(await db.planToDiary([id]), 1);
      expect(await db.planToDiary([id]), 0);
      final d = (await db.diaryForDay('2026-11-23')).single;
      expect(d.nutrients.kcal, closeTo(skyr.kcal * 2.5, 1e-9));
      // Im Tagebuch gelöscht → darf erneut übernommen werden
      await db.deleteDiaryEntry(d.id);
      expect(await db.planToDiary([id]), 1);
    });

    test('Generator füllt nur leere Mahlzeiten, Tags filtern', () async {
      await recipe('Porridge', tags: ['schnell']);
      await recipe('Linseneintopf', tags: ['Meal Prep']);
      final slots = await db.watchMealSlots().first;
      final skyr = (await db.searchFoods('Skyr')).first;
      await db.planFood(day: '2026-11-23', mealSlotId: slots.first.id, food: skyr, amount: 150);
      final days = ['2026-11-23', '2026-11-24'];
      final n = (await db.generatePlanFor(days: days, targetKcal: 2000)).planned;
      expect(n, 5); // 2 Tage × 3 Hauptmahlzeiten − 1 belegt
      final plan = await db.planEntries('2026-11-23', '2026-11-24');
      expect(plan.where((e) => e.dayKey == '2026-11-23' && e.mealSlotId == slots.first.id).length, 1);
      await db.clearPlanDays('2026-11-23', '2026-11-24');
      expect((await db.generatePlanFor(days: days, targetKcal: 2000, tags: {'meal prep'})).planned, 6);
      final names = (await db.planEntries('2026-11-23', '2026-11-24')).map((e) => e.name).toSet();
      expect(names, {'Linseneintopf'});
    });

    test('Generator beachtet Unverträglichkeiten, Abneigungen und Vorlieben aus dem Profil', () async {
      Future<void> withItems(String name, List<String> foods) async {
        final items = <IngredientInput>[];
        for (final f in foods) {
          items.add(IngredientInput.fromFood((await db.searchFoods(f)).first, 150));
        }
        await db.saveRecipe(name: name, servings: 2, items: items);
      }

      await withItems('Porridge', ['Haferflocken', 'Milch 3,5']);
      await withItems('Lachs mit Reis', ['Lachs', 'Reis']);
      await withItems('Linsensuppe', ['Linsen']);
      await withItems('Hähnchenpfanne', ['Hähnchenbrust', 'Reis']);
      await db.saveProfile(
        ProfilesCompanion.insert(
          sex: 'female',
          birthDate: DateTime(1990, 1, 1),
          heightCm: 168,
          startWeightKg: 70,
          targetWeightKg: 64,
          jobActivity: 'sitting',
          allergiesJson: const Value('["Laktose"]'),
          dislikedFoodsJson: const Value('["Fisch"]'),
          preferredFoodsJson: const Value('["Hähnchen"]'),
        ),
      );
      final days = ['2026-11-23'];
      final fill = await db.generatePlanFor(days: days, targetKcal: 2000);
      expect(fill.planned, 3);
      expect(fill.skipped.keys, unorderedEquals(['Porridge', 'Lachs mit Reis']));
      expect(fill.skipped['Porridge'], startsWith('Laktose'));
      expect(fill.skipped['Lachs mit Reis'], startsWith('Fisch'));
      expect(fill.skippedText(), contains('Porridge'));
      final plan = await db.planEntries('2026-11-23', '2026-11-23');
      final names = plan.map((e) => e.name).toList();
      expect(names.toSet(), {'Linsensuppe', 'Hähnchenpfanne'});
      // Preferred first: the first meal of the day gets the chicken dish.
      final slots = await db.watchMealSlots().first;
      expect(plan.firstWhere((e) => e.mealSlotId == slots.first.id).name, 'Hähnchenpfanne');

      // Without profile filters everything is used.
      await db.clearPlanDays('2026-11-23', '2026-11-23');
      final all = await db.generatePlanFor(days: days, targetKcal: 2000, useProfile: false);
      expect(all.skipped, isEmpty);
    });

    test('Woche kopieren und Einkaufsliste aus dem Plan', () async {
      final r = await recipe('Porridge');
      final slot = (await db.watchMealSlots().first).first;
      final rec = (await db.getRecipe(r))!;
      final n = await db.recipeNutritionOf(rec); // 1 Portion = 100 g Haferflocken
      await db.planRecipe(day: '2026-11-23', mealSlotId: slot.id, recipe: rec, grams: n.servingWeight * 2);
      expect(await db.copyPlanDays(['2026-11-23'], ['2026-11-30']), 1);
      expect((await db.planEntries('2026-11-30', '2026-11-30')).single.diaryEntryId, isNull);
      await db.planToShopping('2026-11-23', '2026-11-30');
      final list = await db.watchShopping().first;
      expect(list.single.amount, closeTo(400, 1e-6)); // 2 × 2 Portionen × 100 g
    });

    test('Fasten: nie zwei gleichzeitig, Ende nicht vor Beginn', () async {
      final start = DateTime.now().subtract(const Duration(hours: 10));
      final a = await db.startFast(targetHours: 16, at: start);
      final b = await db.startFast(targetHours: 18);
      expect(b, a);
      expect(() => db.endFast(at: start.subtract(const Duration(hours: 1))), throwsArgumentError);
      await db.endFast();
      expect(await db.activeFast(), isNull);
      final all = await db.watchFasting().first;
      expect(all.single.endAt, isNotNull);
      expect(
        () => db.startFast(targetHours: 16, at: DateTime.now().add(const Duration(hours: 2))),
        throwsArgumentError,
      );
    });
  });
}
