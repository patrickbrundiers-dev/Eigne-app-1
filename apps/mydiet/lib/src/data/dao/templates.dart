part of '../database.dart';

extension TemplatesDao on AppDatabase {
  // ---------------------------------------------------------------- meal templates

  Stream<List<MealTemplate>> watchTemplates() =>
      (select(mealTemplates)
            ..where((t) => t.deletedAt.isNull())
            ..orderBy([(t) => OrderingTerm.desc(t.useCount), (t) => OrderingTerm.asc(t.nameKey)]))
          .watch();

  Future<List<MealTemplateItem>> templateItemsOf(String templateId) =>
      (select(mealTemplateItems)
            ..where((i) => i.templateId.equals(templateId) & i.deletedAt.isNull())
            ..orderBy([(i) => OrderingTerm.asc(i.sortOrder)]))
          .get();

  /// Saves the entries of one meal of [day] as a template. A template with the same
  /// name is replaced, so "Mein Frühstück" can be updated by saving again.
  Future<String> saveTemplateFromMeal({required String name, required String day, required String mealSlotId}) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) throw ArgumentError('Bitte einen Namen eingeben.');
    final key = normalizeName(trimmed);
    return transaction(() async {
      final src =
          await (select(diaryEntries)
                ..where((e) => e.dayKey.equals(day) & e.mealSlotId.equals(mealSlotId) & e.deletedAt.isNull())
                ..orderBy([(e) => OrderingTerm.asc(e.createdAt)]))
              .get();
      if (src.isEmpty) throw ArgumentError('Die Mahlzeit ist leer.');
      final now = DateTime.now();
      final existing = await (select(
        mealTemplates,
      )..where((t) => t.nameKey.equals(key) & t.deletedAt.isNull())).getSingleOrNull();
      final id = existing?.id ?? newId();
      if (existing == null) {
        await into(mealTemplates).insert(
          MealTemplatesCompanion.insert(id: Value(id), name: trimmed, nameKey: key, mealSlotId: Value(mealSlotId)),
        );
      } else {
        await (update(mealTemplates)..where((t) => t.id.equals(id))).write(
          MealTemplatesCompanion(name: Value(trimmed), mealSlotId: Value(mealSlotId), updatedAt: Value(now)),
        );
        await (update(mealTemplateItems)..where((i) => i.templateId.equals(id) & i.deletedAt.isNull())).write(
          MealTemplateItemsCompanion(deletedAt: Value(now), updatedAt: Value(now)),
        );
      }
      for (final (n, e) in src.indexed) {
        await into(mealTemplateItems).insert(
          MealTemplateItemsCompanion.insert(
            templateId: id,
            sortOrder: Value(n),
            foodId: Value(e.foodId),
            foodName: e.foodName,
            brand: Value(e.brand),
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
            recipeId: Value(e.recipeId),
          ),
        );
      }
      return id;
    });
  }

  /// Logs all items of a template into [mealSlotId] of [day]. Returns the number of entries.
  Future<int> logTemplate({required String templateId, required String day, required String mealSlotId}) {
    return transaction(() async {
      final items = await templateItemsOf(templateId);
      final now = DateTime.now();
      for (final (n, i) in items.indexed) {
        await into(diaryEntries).insert(
          DiaryEntriesCompanion.insert(
            dayKey: day,
            mealSlotId: mealSlotId,
            foodId: Value(i.foodId),
            foodName: i.foodName,
            brand: Value(i.brand),
            unit: i.unit,
            amount: i.amount,
            kcal100: i.kcal100,
            protein100: i.protein100,
            carbs100: i.carbs100,
            sugar100: i.sugar100,
            fat100: i.fat100,
            saturatedFat100: i.saturatedFat100,
            fiber100: i.fiber100,
            salt100: i.salt100,
            recipeId: Value(i.recipeId),
            createdAt: Value(now.add(Duration(milliseconds: n))),
            updatedAt: Value(now),
          ),
        );
      }
      await customUpdate(
        'UPDATE meal_templates SET use_count = use_count + 1, updated_at = ? WHERE id = ?',
        variables: [Variable(now), Variable(templateId)],
        updates: {mealTemplates},
      );
      return items.length;
    });
  }

  Future<void> deleteTemplate(String id) async {
    final now = DateTime.now();
    await transaction(() async {
      await customUpdate(
        "UPDATE meal_templates SET deleted_at = ?, updated_at = ?, name_key = name_key || '#deleted:' || id "
        'WHERE id = ? AND deleted_at IS NULL',
        variables: [Variable(now), Variable(now), Variable(id)],
        updates: {mealTemplates},
      );
      await (update(mealTemplateItems)..where((i) => i.templateId.equals(id) & i.deletedAt.isNull())).write(
        MealTemplateItemsCompanion(deletedAt: Value(now), updatedAt: Value(now)),
      );
    });
  }

  /// Daily totals for a range of days (inclusive), keyed by day.
  Future<Map<String, Nutrients>> dailyTotals(String fromDay, String toDay) async {
    final rows = await (select(
      diaryEntries,
    )..where((e) => e.dayKey.isBetweenValues(fromDay, toDay) & e.deletedAt.isNull())).get();
    final out = <String, Nutrients>{};
    for (final e in rows) {
      out[e.dayKey] = (out[e.dayKey] ?? Nutrients.zero) + e.nutrients;
    }
    return out;
  }
}
