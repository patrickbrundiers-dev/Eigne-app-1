part of '../database.dart';

extension MicrosDao on AppDatabase {
  // ---------------------------------------------------------------- micronutrients (W5)

  /// Adds the shipped vitamin and mineral values to base foods that have none yet.
  Future<void> seedReferenceMicros() async {
    final current = int.tryParse(await getSetting('microSeedVersion') ?? '') ?? 0;
    if (current >= AppDatabase.microSeedVersion) return;
    await transaction(() async {
      final base = await (select(foods)..where((f) => f.source.equals('base') & f.deletedAt.isNull())).get();
      final withData =
          (await (selectOnly(foodMicronutrients, distinct: true)
                    ..addColumns([foodMicronutrients.foodId])
                    ..where(foodMicronutrients.deletedAt.isNull()))
                  .map((r) => r.read(foodMicronutrients.foodId)!)
                  .get())
              .toSet();
      await batch((b) {
        for (final f in base) {
          if (withData.contains(f.id)) continue;
          final m = baseMicros(f.name);
          if (m == null) continue;
          for (final e in m.entries) {
            b.insert(
              foodMicronutrients,
              FoodMicronutrientsCompanion.insert(foodId: f.id, nutrientId: e.key, amount: e.value),
            );
          }
        }
      });
      await setSetting('microSeedVersion', '${AppDatabase.microSeedVersion}');
    });
  }

  Future<void> _writeMicros(String foodId, Map<String, double> micros) async {
    for (final e in micros.entries) {
      if (nutrientById(e.key) == null) throw ArgumentError('Unbekannter Nährstoff ${e.key}.');
      if (!(e.value >= 0 && e.value < 1e6)) throw ArgumentError('Ungültiger Wert für ${nutrientById(e.key)!.name}.');
    }
    final now = DateTime.now();
    await (update(foodMicronutrients)..where((m) => m.foodId.equals(foodId) & m.deletedAt.isNull())).write(
      FoodMicronutrientsCompanion(deletedAt: Value(now), updatedAt: Value(now)),
    );
    for (final e in micros.entries) {
      await into(foodMicronutrients)
          .insert(FoodMicronutrientsCompanion.insert(foodId: foodId, nutrientId: e.key, amount: e.value));
    }
  }

  /// Vitamins and minerals per 100 of the given foods (foods without data are missing).
  Future<Map<String, Map<String, double>>> microsOf(Iterable<String> foodIds) async {
    final ids = foodIds.toSet();
    if (ids.isEmpty) return {};
    final rows = await (select(foodMicronutrients)..where((m) => m.foodId.isIn(ids) & m.deletedAt.isNull())).get();
    final out = <String, Map<String, double>>{};
    for (final r in rows) {
      (out[r.foodId] ??= {})[r.nutrientId] = r.amount;
    }
    return out;
  }

  /// Per 100 g of a recipe, from its ingredients that have data.
  Future<Map<String, double>> recipeMicrosPer100(Recipe r) async {
    final items = await recipeItemsOf(r.id);
    final n = await recipeNutritionOf(r);
    if (!(n.finalWeight > 0)) return {};
    final micros = await microsOf([for (final i in items) ?i.foodId]);
    final out = <String, double>{};
    for (final i in items) {
      final m = micros[i.foodId];
      if (m == null) continue;
      m.forEach((id, v) => out[id] = (out[id] ?? 0) + v * i.amount / 100);
    }
    return {for (final e in out.entries) e.key: e.value / n.finalWeight * 100};
  }

  /// Vitamins and minerals of one day: diary (current values of the foods) plus the
  /// supplement intakes that were ticked off.
  Stream<MicroDay> watchMicroDay(String day) async* {
    yield await microDay(day);
    await for (final _ in tableUpdates(
      TableUpdateQuery.onAllTables([
        diaryEntries,
        supplementIntakes,
        supplements,
        supplementIngredients,
        profiles,
        foodMicronutrients,
        recipes,
        recipeItems,
      ]),
    )) {
      yield await microDay(day);
    }
  }

  Future<MicroDay> microDay(String day) async => _microDay(
    await watchDiary(day).first,
    await watchIntakes(day).first,
    await watchSupplements().first,
    await watchProfile().first,
  );

  Future<MicroDay> _microDay(
    List<DiaryEntry> diary,
    List<SupplementIntake> intakes,
    List<SupplementWithDoses> sups,
    Profile? profile,
  ) async {
    final foodMicros = await microsOf([for (final e in diary) ?e.foodId]);
    final recipeCache = <String, Map<String, double>>{};
    final portions = <MicroPortion>[];
    for (final e in diary) {
      var per100 = e.foodId == null ? const <String, double>{} : (foodMicros[e.foodId] ?? const {});
      if (e.recipeId != null) {
        if (!recipeCache.containsKey(e.recipeId)) {
          final r = await (select(recipes)..where((x) => x.id.equals(e.recipeId!))).getSingleOrNull();
          recipeCache[e.recipeId!] = r == null ? const {} : await recipeMicrosPer100(r);
        }
        per100 = recipeCache[e.recipeId]!;
      }
      portions.add(MicroPortion(amount: e.amount, per100: per100));
    }
    final byId = {for (final s in sups) s.supplement.id: s};
    final uses = <SupplementUse>[];
    for (final i in intakes) {
      final s = byId[i.supplementId];
      if (s == null) continue;
      uses.add(SupplementUse(product: s.label, servings: i.servings, doses: s.doses));
    }
    final age = profile == null ? 30 : ageOn(profile.birthDate, DateTime.now());
    return sumMicros(portions: portions, supplements: uses, female: profile?.sex == 'female', age: age);
  }
}
