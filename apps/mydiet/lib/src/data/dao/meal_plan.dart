part of '../database.dart';

extension MealPlanDao on AppDatabase {
  // ---------------------------------------------------------------- meal plan

  Stream<List<MealPlanEntry>> watchPlan(String fromDay, String toDay) =>
      (select(mealPlanEntries)
            ..where((e) => e.dayKey.isBetweenValues(fromDay, toDay) & e.deletedAt.isNull())
            ..orderBy([(e) => OrderingTerm.asc(e.dayKey), (e) => OrderingTerm.asc(e.createdAt)]))
          .watch();

  Future<List<MealPlanEntry>> planEntries(String fromDay, String toDay) => watchPlan(fromDay, toDay).first;

  Future<String> _insertPlan({
    required String day,
    required String mealSlotId,
    String? foodId,
    String? recipeId,
    required String name,
    required String unit,
    required double amount,
    required Nutrients per100,
    DateTime? createdAt,
  }) async {
    if (!(amount > 0) || amount > 5000) throw ArgumentError('Die Menge muss zwischen 0 und 5000 liegen.');
    final id = newId();
    await into(mealPlanEntries).insert(
      MealPlanEntriesCompanion.insert(
        id: Value(id),
        dayKey: day,
        mealSlotId: mealSlotId,
        foodId: Value(foodId),
        recipeId: Value(recipeId),
        name: name,
        unit: unit,
        amount: amount,
        kcal100: per100.kcal,
        protein100: per100.protein,
        carbs100: per100.carbs,
        sugar100: per100.sugar,
        fat100: per100.fat,
        saturatedFat100: per100.saturatedFat,
        fiber100: per100.fiber,
        salt100: per100.salt,
        createdAt: createdAt == null ? const Value.absent() : Value(createdAt),
      ),
    );
    return id;
  }

  Future<String> planFood({
    required String day,
    required String mealSlotId,
    required Food food,
    required double amount,
  }) => _insertPlan(
    day: day,
    mealSlotId: mealSlotId,
    foodId: food.id,
    name: food.brand == null ? food.name : '${food.name} (${food.brand})',
    unit: food.unit,
    amount: amount,
    per100: food.per100,
  );

  Future<String> planRecipe({
    required String day,
    required String mealSlotId,
    required Recipe recipe,
    required double grams,
  }) async {
    final n = await recipeNutritionOf(recipe);
    if (!(n.finalWeight > 0)) throw ArgumentError('Das Rezept hat keine Zutaten.');
    return _insertPlan(
      day: day,
      mealSlotId: mealSlotId,
      recipeId: recipe.id,
      name: recipe.name,
      unit: 'g',
      amount: grams,
      per100: n.per100,
    );
  }

  Future<void> updatePlanEntry(String id, {double? amount, String? mealSlotId, String? day}) async {
    if (amount != null && (!(amount > 0) || amount > 5000)) {
      throw ArgumentError('Die Menge muss zwischen 0 und 5000 liegen.');
    }
    await (update(mealPlanEntries)..where((e) => e.id.equals(id))).write(
      MealPlanEntriesCompanion(
        amount: amount == null ? const Value.absent() : Value(amount),
        mealSlotId: mealSlotId == null ? const Value.absent() : Value(mealSlotId),
        dayKey: day == null ? const Value.absent() : Value(day),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> deletePlanEntry(String id) => _tombstone(mealPlanEntries, id);
  Future<void> restorePlanEntry(String id) => _restore(mealPlanEntries, id);

  /// Copies one planned entry to [day] (same meal, not yet in the diary). Returns the new id.
  Future<String> copyPlanEntry(String id, {required String day, String? mealSlotId}) async {
    final e = await (select(mealPlanEntries)..where((x) => x.id.equals(id) & x.deletedAt.isNull())).getSingleOrNull();
    if (e == null) throw StateError('Eintrag nicht gefunden.');
    final now = DateTime.now();
    final copy = e.copyWith(
      id: newId(),
      dayKey: day,
      mealSlotId: mealSlotId ?? e.mealSlotId,
      diaryEntryId: const Value(null),
      createdAt: now,
      updatedAt: now,
    );
    await into(mealPlanEntries).insert(copy);
    return copy.id;
  }

  /// Copies planned entries from [fromDays] to [toDays] (same length, day by day).
  /// Returns the number of copied entries.
  Future<int> copyPlanDays(List<String> fromDays, List<String> toDays) async {
    if (fromDays.length != toDays.length) throw ArgumentError('Ungleiche Anzahl Tage.');
    return transaction(() async {
      var n = 0;
      final now = DateTime.now();
      for (var i = 0; i < fromDays.length; i++) {
        final src = await planEntries(fromDays[i], fromDays[i]);
        for (final e in src) {
          await into(mealPlanEntries).insert(
            e.copyWith(
              id: newId(),
              dayKey: toDays[i],
              diaryEntryId: const Value(null),
              createdAt: now.add(Duration(milliseconds: n)),
              updatedAt: now,
            ),
          );
          n++;
        }
      }
      return n;
    });
  }

  /// Removes all planned entries of the given days.
  Future<int> clearPlanDays(String fromDay, String toDay) {
    final now = DateTime.now();
    return (update(mealPlanEntries)..where((e) => e.dayKey.isBetweenValues(fromDay, toDay) & e.deletedAt.isNull()))
        .write(MealPlanEntriesCompanion(deletedAt: Value(now), updatedAt: Value(now)));
  }

  /// Puts planned entries into the diary of their day. Entries already in the diary
  /// (and not deleted there) are skipped, so nothing is counted twice.
  /// Returns the number of new diary entries.
  Future<int> planToDiary(List<String> planIds) async {
    return transaction(() async {
      var n = 0;
      final rows = await (select(mealPlanEntries)..where((e) => e.id.isIn(planIds) & e.deletedAt.isNull())).get();
      for (final e in rows) {
        if (e.diaryEntryId != null) {
          final live = await (select(
            diaryEntries,
          )..where((d) => d.id.equals(e.diaryEntryId!) & d.deletedAt.isNull())).getSingleOrNull();
          if (live != null) continue;
        }
        final id = newId();
        await into(diaryEntries).insert(
          DiaryEntriesCompanion.insert(
            id: Value(id),
            dayKey: e.dayKey,
            mealSlotId: e.mealSlotId,
            foodId: Value(e.foodId),
            recipeId: Value(e.recipeId),
            foodName: e.name,
            unit: e.unit,
            amount: e.amount,
            kcal100: e.kcal100,
            protein100: e.protein100,
            carbs100: e.carbs100,
            sugar100: e.sugar100,
            fat100: e.fat100,
            saturatedFat100: e.saturatedFat100,
            fiber100: e.fiber100,
            salt100: e.salt100,
            createdAt: Value(DateTime.now().add(Duration(milliseconds: n))),
          ),
        );
        await (update(mealPlanEntries)..where((p) => p.id.equals(e.id))).write(
          MealPlanEntriesCompanion(diaryEntryId: Value(id), updatedAt: Value(DateTime.now())),
        );
        n++;
      }
      return n;
    });
  }

  /// Fills [days] with recipes (see [generatePlan]). Existing entries stay; slots that
  /// already have something planned are skipped. Returns the number of new entries.
  /// Recipes that contain something from the profile's intolerances or dislikes are left out
  /// ([PlanFill.skipped] says why); recipes with preferred foods come first.
  Future<PlanFill> generatePlanFor({
    required List<String> days,
    required double targetKcal,
    Set<String> tags = const {},
    bool includeSnacks = false,
    bool useProfile = true,
  }) async {
    final slots = await watchMealSlots().first;
    final recipesList = await watchRecipes().first;
    final profile = useProfile ? await watchProfile().first : null;
    final avoid = [...?profile?.allergies, ...?profile?.dislikedFoods];
    final preferred = profile?.preferredFoods ?? const <String>[];
    final pool = <PlanRecipe>[];
    final byId = <String, Recipe>{};
    final skipped = <String, String>{};
    final scores = <String, int>{};
    for (final r in recipesList) {
      final n = await recipeNutritionOf(r);
      if (!(n.finalWeight > 0)) continue;
      final names = [r.name, for (final i in await recipeItemsOf(r.id)) i.foodName];
      final why = excludedBy(names, avoid: avoid);
      if (why != null) {
        skipped[r.name] = why.found == r.name ? why.entry : '${why.entry} (${why.found})';
        continue;
      }
      scores[r.id] = preferenceScore(names, preferred);
      byId[r.id] = r;
      pool.add(PlanRecipe(id: r.id, kcalPer100: n.per100.kcal, servingWeight: n.servingWeight, tags: r.tags));
    }
    final filtered = preferFirst(filterByTags(pool, tags), scores);
    if (filtered.isEmpty) return PlanFill(planned: 0, skipped: skipped);
    final shares = slotShares([for (final s in slots) (id: s.id, name: s.name)]);
    final snackIds = {
      for (final s in slots)
        if (!includeSnacks && RegExp(r'snack|zwischen', caseSensitive: false).hasMatch(s.name)) s.id,
    };
    final plan = generatePlan(
      pool: filtered,
      shares: shares,
      days: days.length,
      targetKcal: targetKcal,
      skipSlots: snackIds,
    );
    return transaction(() async {
      final existing = await planEntries(days.first, days.last);
      final taken = {for (final e in existing) '${e.dayKey}|${e.mealSlotId}'};
      var n = 0;
      for (final m in plan) {
        final day = days[m.dayIndex];
        if (taken.contains('$day|${m.slotId}')) continue;
        await planRecipe(day: day, mealSlotId: m.slotId, recipe: byId[m.recipeId]!, grams: m.grams);
        n++;
      }
      return PlanFill(planned: n, skipped: skipped);
    });
  }

  /// Puts everything planned between the two days on the shopping list. Recipes are
  /// scaled to the planned grams. Returns the number of planned entries used.
  Future<int> planToShopping(String fromDay, String toDay) async {
    final entries = await planEntries(fromDay, toDay);
    return transaction(() async {
      for (final e in entries) {
        if (e.recipeId != null) {
          final r = await getRecipe(e.recipeId!);
          if (r == null) continue;
          final n = await recipeNutritionOf(r);
          if (!(n.servingWeight > 0)) continue;
          await addRecipeToShopping(r.id, servings: e.amount / n.servingWeight);
        } else {
          final f = e.foodId == null ? null : await getFood(e.foodId!);
          await addShoppingItem(
            label: e.name,
            amount: e.amount,
            unit: e.unit,
            foodId: e.foodId,
            category: f?.category,
            fromRecipe: 'Wochenplan',
          );
        }
      }
      return entries.length;
    });
  }
}
