import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mydiet_ai/src/core/food_quality.dart';
import 'package:mydiet_ai/src/core/micronutrients.dart';
import 'package:mydiet_ai/src/core/nutrition.dart';
import 'package:mydiet_ai/src/core/supplements.dart';
import 'package:mydiet_ai/src/data/database.dart';
import 'package:mydiet_ai/src/data/seed_foods.dart';
import 'package:mydiet_ai/src/data/seed_micros.dart';

const _d3 = SupplementDose(nutrientId: 'vit_d', amount: 20, unit: 'µg');
const _mg = SupplementDose(nutrientId: 'magnesium', amount: 300, unit: 'mg');

void main() {
  group('targets', () {
    test('by sex and age', () {
      expect(dachTargets['iron']!.forPerson(female: true, age: 30), 16);
      expect(dachTargets['iron']!.forPerson(female: true, age: 55), 14);
      expect(dachTargets['iron']!.forPerson(female: false, age: 55), 11);
      expect(dachTargets['magnesium']!.forPerson(female: true, age: 30), 300);
    });
  });

  group('sumMicros', () {
    test('food plus supplements, target percent and status', () {
      final d = sumMicros(
        portions: const [
          MicroPortion(amount: 150, per100: {'vit_d': 8, 'calcium': 10}), // salmon
          MicroPortion(amount: 200, per100: {}), // no data
        ],
        supplements: const [
          SupplementUse(product: 'D3', servings: 1, doses: [_d3]),
        ],
        female: false,
        age: 40,
      );
      final vd = d.row('vit_d')!;
      expect(vd.food, 12);
      expect(vd.supplements, 20);
      expect(vd.total, 32);
      expect(vd.targetPercent, closeTo(160, 1e-9));
      expect(vd.status, MicroStatus.ok);
      expect(vd.supplementSources, {'D3': 20});
      expect(d.row('calcium')!.status, MicroStatus.below);
      expect(d.entries, 2);
      expect(d.entriesWithData, 1);
    });

    test('upper level counts only supplements where EFSA says so (magnesium)', () {
      final d = sumMicros(
        portions: const [
          MicroPortion(amount: 100, per100: {'magnesium': 400}),
        ],
        supplements: const [
          SupplementUse(product: 'Mg', servings: 1, doses: [_mg]),
        ],
        female: false,
        age: 40,
      );
      final m = d.row('magnesium')!;
      expect(m.total, 700);
      expect(m.limitBasis, 300);
      expect(m.status, MicroStatus.overLimit); // 300 > 250 from supplements alone
      final onlyFood = sumMicros(
        portions: const [
          MicroPortion(amount: 200, per100: {'magnesium': 400}),
        ],
        supplements: const [],
        female: false,
        age: 40,
      ).row('magnesium')!;
      expect(onlyFood.status, MicroStatus.ok);
    });

    test('total upper level (vitamin D) with food and IU conversion', () {
      final d = sumMicros(
        portions: const [
          MicroPortion(amount: 100, per100: {'vit_d': 10}),
        ],
        supplements: [
          SupplementUse(
            product: 'D3 4000 IE',
            servings: 2,
            doses: [SupplementDose(nutrientId: 'vit_d', amount: vitaminDIuToUg(1600), unit: 'µg')],
          ),
        ],
        female: true,
        age: 30,
      );
      expect(d.row('vit_d')!.total, 90);
      expect(d.row('vit_d')!.status, MicroStatus.nearLimit);
    });
  });

  test('supplementOverlaps finds the same nutrient in other products', () {
    final o = supplementOverlaps(
      newDoses: const [
        SupplementDose(nutrientId: 'zinc', amount: 25, unit: 'mg'),
        _d3,
      ],
      newServingsPerDay: 1,
      others: const [
        SupplementUse(
          product: 'Multi A',
          servings: 1,
          doses: [SupplementDose(nutrientId: 'zinc', amount: 13, unit: 'mg')],
        ),
      ],
    );
    expect(o, hasLength(1));
    expect(o.single.info.id, 'zinc');
    expect(o.single.combined, 38);
    expect(o.single.others, ['Multi A']);
    expect(o.single.overLimit, isTrue);
  });

  test('seed micros: every key is a reference food, values plausible', () {
    final names = {for (final f in referenceFoods) f.name};
    for (final e in referenceMicros.entries) {
      expect(names, contains(e.key));
      for (final v in e.value.entries) {
        expect(nutrientById(v.key), isNotNull, reason: v.key);
        expect(v.value, greaterThanOrEqualTo(0));
      }
      // Per 100 g no food has more than 2 g potassium or 1.5 g calcium.
      expect(e.value['potassium'] ?? 0, lessThan(2000), reason: e.key);
      expect(e.value['calcium'] ?? 0, lessThan(1500), reason: e.key);
    }
    expect(referenceMicros.length, greaterThan(90));
  });

  test('Open Food Facts micronutrients are converted from g', () {
    final p = parseOffProduct({
      'status': 1,
      'product': {
        'product_name': 'Milch',
        'nutriments': {
          'energy-kcal_100g': 64,
          'proteins_100g': 3.3,
          'carbohydrates_100g': 4.8,
          'fat_100g': 3.5,
          'calcium_100g': 0.12,
          'vitamin-d_100g': 0.000001,
          'iron_100g': 'kaputt',
        },
      },
    }, '1')!;
    expect(p.micros['calcium'], closeTo(120, 1e-9));
    expect(p.micros['vit_d'], closeTo(1, 1e-9));
    expect(p.micros.containsKey('iron'), isFalse);
  });

  group('database', () {
    late AppDatabase db;
    setUp(() => db = AppDatabase(NativeDatabase.memory()));
    tearDown(() => db.close());

    Future<void> profile(String sex) => db.saveProfile(
      ProfilesCompanion.insert(
        sex: sex,
        birthDate: DateTime(1990, 1, 1),
        heightCm: 170,
        startWeightKg: 70,
        targetWeightKg: 65,
        jobActivity: 'sitting',
      ),
    );

    test('base foods get reference micros once', () async {
      final salmon = (await db.searchFoods('Lachs, roh')).first;
      final m = await db.microsOf([salmon.id]);
      expect(m[salmon.id]!['vit_d'], 8);
      await db.seedReferenceMicros(); // no duplicates
      final rows = await (db.select(db.foodMicronutrients)..where((r) => r.foodId.equals(salmon.id))).get();
      expect(rows.where((r) => r.nutrientId == 'vit_d'), hasLength(1));
    });

    test('saveFood stores, keeps and clears micros', () async {
      final id = await db.saveFood(
        name: 'Testmilch',
        per100: const Nutrients(kcal: 64, protein: 3.3, carbs: 4.8, fat: 3.5),
        micros: {'calcium': 120},
      );
      expect((await db.microsOf([id]))[id], {'calcium': 120});
      await db.saveFood(
        id: id,
        name: 'Testmilch',
        per100: const Nutrients(kcal: 64, protein: 3.3, carbs: 4.8, fat: 3.5),
      );
      expect((await db.microsOf([id]))[id], {'calcium': 120});
      await db.saveFood(
        id: id,
        name: 'Testmilch',
        per100: const Nutrients(kcal: 64, protein: 3.3, carbs: 4.8, fat: 3.5),
        micros: {},
      );
      expect((await db.microsOf([id]))[id], isNull);
      expect(
        () => db.saveFood(name: 'X', per100: const Nutrients(kcal: 1), micros: {'unbekannt': 1}),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('day: foods, recipe and ticked supplements', () async {
      await profile('female');
      final slot = (await db.watchMealSlots().first).first;
      final salmon = (await db.searchFoods('Lachs, roh')).first;
      final oats = (await db.searchFoods('Haferflocken')).first;
      const day = '2026-11-22';
      await db.logFood(day: day, mealSlotId: slot.id, food: salmon, amount: 100);
      final rid = await db.saveRecipe(name: 'Porridge', servings: 1, items: [IngredientInput.fromFood(oats, 100)]);
      final recipe = (await (db.select(db.recipes)..where((r) => r.id.equals(rid))).getSingle());
      await db.logRecipe(day: day, mealSlotId: slot.id, recipe: recipe, grams: 50);
      final sid = await db.saveSupplement(name: 'D3', doses: const [_d3], times: const [480]);
      await db.setIntake(supplementId: sid, day: day, plannedMinute: 480, servings: 1, taken: true);

      final d = await db.microDay(day);
      expect(d.entries, 2);
      expect(d.entriesWithData, 2);
      expect(d.row('vit_d')!.food, 8);
      expect(d.row('vit_d')!.supplements, 20);
      expect(d.row('magnesium')!.food, closeTo(29 + 130 * 0.5, 1e-9)); // salmon + half the porridge
      expect(d.row('iron')!.target, 16);

      final stream = db.watchMicroDay(day);
      final first = await stream.first;
      expect(first.row('vit_d')!.total, 28);
    });
  });
}
