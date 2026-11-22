part of '../database.dart';

extension RecipesDao on AppDatabase {
  // ---------------------------------------------------------------- recipes

  Stream<List<Recipe>> watchRecipes({String query = '', bool onlyFavorites = false}) {
    final q = select(recipes)..where((r) => r.deletedAt.isNull());
    for (final word in normalizeName(query).split(' ').where((w) => w.isNotEmpty)) {
      q.where((r) => r.nameKey.like('%$word%'));
    }
    if (onlyFavorites) q.where((r) => r.isFavorite.equals(true));
    q.orderBy([(r) => OrderingTerm.desc(r.isFavorite), (r) => OrderingTerm.asc(r.name.collate(Collate.noCase))]);
    return q.watch();
  }

  Future<List<Recipe>> searchRecipes(String query, {int limit = 20}) async {
    final norm = normalizeName(query);
    if (norm.isEmpty) return [];
    final rows = await watchRecipes(query: query).first;
    rows.sort((a, b) {
      int rank(Recipe r) => r.nameKey == norm ? 0 : (r.nameKey.startsWith(norm) ? 1 : 2);
      final c = rank(a).compareTo(rank(b));
      return c != 0 ? c : a.name.length.compareTo(b.name.length);
    });
    return rows.take(limit).toList();
  }

  Future<Recipe?> getRecipe(String id) => (select(recipes)..where((r) => r.id.equals(id))).getSingleOrNull();

  Stream<Recipe?> watchRecipe(String id) => (select(recipes)..where((r) => r.id.equals(id))).watchSingleOrNull();

  Future<List<RecipeItem>> recipeItemsOf(String recipeId) => _recipeItemsQuery(recipeId).get();

  Stream<List<RecipeItem>> watchRecipeItems(String recipeId) => _recipeItemsQuery(recipeId).watch();

  SimpleSelectStatement<$RecipeItemsTable, RecipeItem> _recipeItemsQuery(String recipeId) => select(recipeItems)
    ..where((i) => i.recipeId.equals(recipeId) & i.deletedAt.isNull())
    ..orderBy([(i) => OrderingTerm.asc(i.sortOrder)]);

  Future<RecipeNutrition> recipeNutritionOf(Recipe r) async => recipeNutrition(
    [for (final i in await recipeItemsOf(r.id)) Ingredient(per100: i.per100, amount: i.amount, unit: i.unit)],
    servings: r.servings,
    cookedWeight: r.cookedWeightG,
  );

  /// Creates or updates a recipe with all ingredients. Returns the id.
  Future<String> saveRecipe({
    String? id,
    required String name,
    required double servings,
    double? cookedWeightG,
    int? prepMinutes,
    String? instructions,
    List<String> tags = const [],
    required List<IngredientInput> items,
  }) async {
    final trimmed = name.trim();
    final errors = <String>[
      if (trimmed.isEmpty) 'Bitte einen Namen eingeben.',
      if (!(servings > 0 && servings <= 100)) 'Portionen müssen zwischen 0 und 100 liegen.',
      if (items.isEmpty) 'Bitte mindestens eine Zutat hinzufügen.',
      if (items.any((i) => !(i.amount > 0 && i.amount <= 10000))) 'Jede Zutat braucht eine Menge bis 10.000 g/ml.',
      if (cookedWeightG != null && !(cookedWeightG > 0 && cookedWeightG <= 50000))
        'Das Gewicht nach dem Kochen muss zwischen 0 und 50.000 g liegen.',
      if (prepMinutes != null && (prepMinutes < 0 || prepMinutes > 24 * 60)) 'Ungültige Zubereitungszeit.',
    ];
    if (errors.isNotEmpty) throw InvalidFoodException(errors);
    final key = normalizeName(trimmed);
    return transaction(() async {
      final dup = await (select(recipes)..where((r) => r.nameKey.equals(key) & r.deletedAt.isNull())).getSingleOrNull();
      if (dup != null && dup.id != id) throw DuplicateRecipeException(dup);
      final now = DateTime.now();
      final recipeId = id ?? newId();
      final data = RecipesCompanion(
        name: Value(trimmed),
        nameKey: Value(key),
        servings: Value(servings),
        cookedWeightG: Value(cookedWeightG),
        prepMinutes: Value(prepMinutes),
        instructions: Value(instructions?.trim().isEmpty ?? true ? null : instructions!.trim()),
        tagsJson: Value(encodeList(tags)),
        updatedAt: Value(now),
      );
      if (id == null) {
        await into(recipes).insert(data.copyWith(id: Value(recipeId), createdAt: Value(now)));
      } else {
        await (update(recipes)..where((r) => r.id.equals(id))).write(data);
        await (update(recipeItems)..where((i) => i.recipeId.equals(id) & i.deletedAt.isNull())).write(
          RecipeItemsCompanion(deletedAt: Value(now), updatedAt: Value(now)),
        );
      }
      for (var n = 0; n < items.length; n++) {
        final i = items[n];
        await into(recipeItems).insert(
          RecipeItemsCompanion.insert(
            recipeId: recipeId,
            foodId: Value(i.foodId),
            foodName: i.name,
            brand: Value(i.brand),
            unit: i.unit,
            amount: i.amount,
            sortOrder: n,
            kcal100: i.per100.kcal,
            protein100: i.per100.protein,
            carbs100: i.per100.carbs,
            sugar100: i.per100.sugar,
            fat100: i.per100.fat,
            saturatedFat100: i.per100.saturatedFat,
            fiber100: i.per100.fiber,
            salt100: i.per100.salt,
          ),
        );
      }
      return recipeId;
    });
  }

  Future<void> setRecipeFavorite(String id, bool fav) => (update(
    recipes,
  )..where((r) => r.id.equals(id))).write(RecipesCompanion(isFavorite: Value(fav), updatedAt: Value(DateTime.now())));

  /// Tombstones a recipe and its ingredients; the name becomes free again.
  /// Diary entries logged from it keep their copied values.
  Future<void> deleteRecipe(String id) async {
    final now = DateTime.now();
    await transaction(() async {
      await customUpdate(
        "UPDATE recipes SET deleted_at = ?, updated_at = ?, name_key = name_key || '#deleted:' || id "
        'WHERE id = ? AND deleted_at IS NULL',
        variables: [Variable(now), Variable(now), Variable(id)],
        updates: {recipes},
      );
      await (update(recipeItems)..where((i) => i.recipeId.equals(id) & i.deletedAt.isNull())).write(
        RecipeItemsCompanion(deletedAt: Value(now), updatedAt: Value(now)),
      );
    });
  }

  /// Logs [grams] of the finished dish. The values per 100 g are copied, so a later
  /// change to the recipe does not change past days.
  Future<String> logRecipe({
    required String day,
    required String mealSlotId,
    required Recipe recipe,
    required double grams,
  }) async {
    if (!(grams > 0) || grams > 5000) throw ArgumentError('Die Menge muss zwischen 0 und 5000 g liegen.');
    final n = await recipeNutritionOf(recipe);
    if (!(n.finalWeight > 0)) throw ArgumentError('Das Rezept hat keine Zutaten.');
    final p = n.per100;
    final id = newId();
    await into(diaryEntries).insert(
      DiaryEntriesCompanion.insert(
        id: Value(id),
        dayKey: day,
        mealSlotId: mealSlotId,
        recipeId: Value(recipe.id),
        foodName: recipe.name,
        unit: 'g',
        amount: grams,
        kcal100: p.kcal,
        protein100: p.protein,
        carbs100: p.carbs,
        sugar100: p.sugar,
        fat100: p.fat,
        saturatedFat100: p.saturatedFat,
        fiber100: p.fiber,
        salt100: p.salt,
      ),
    );
    return id;
  }
}
