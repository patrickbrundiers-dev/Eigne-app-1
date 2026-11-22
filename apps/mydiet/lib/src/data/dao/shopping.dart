part of '../database.dart';

extension ShoppingDao on AppDatabase {
  // ---------------------------------------------------------------- shopping list

  Stream<List<ShoppingItem>> watchShopping() =>
      (select(shoppingItems)
            ..where((s) => s.deletedAt.isNull())
            ..orderBy([
              (s) => OrderingTerm.asc(s.checked),
              (s) => OrderingTerm.asc(s.category, nulls: NullsOrder.last),
              (s) => OrderingTerm.asc(s.label.collate(Collate.noCase)),
            ]))
          .watch();

  /// Adds a line or adds the amount to an open line with the same item and unit.
  Future<void> addShoppingItem({
    required String label,
    double? amount,
    String? unit,
    String? foodId,
    String? category,
    String? fromRecipe,
  }) async {
    final l = label.trim();
    if (l.isEmpty) throw ArgumentError('Bitte eine Bezeichnung eingeben.');
    if (amount != null && !(amount > 0 && amount <= 100000)) throw ArgumentError('Ungültige Menge.');
    final u = (unit?.trim().isEmpty ?? true) ? null : unit!.trim();
    final key = foodId ?? normalizeName(l);
    final now = DateTime.now();
    await transaction(() async {
      final open =
          await (select(shoppingItems)
                ..where(
                  (s) =>
                      s.itemKey.equals(key) &
                      s.checked.equals(false) &
                      s.deletedAt.isNull() &
                      (u == null ? s.unit.isNull() : s.unit.equals(u)),
                )
                ..limit(1))
              .getSingleOrNull();
      if (open == null) {
        await into(shoppingItems).insert(
          ShoppingItemsCompanion.insert(
            label: l,
            itemKey: key,
            amount: Value(amount),
            unit: Value(u),
            foodId: Value(foodId),
            category: Value(category),
            fromRecipes: Value(fromRecipe),
          ),
        );
        return;
      }
      final merged = mergeShopping([
        ShoppingLine(key: key, label: open.label, amount: open.amount, unit: u),
        ShoppingLine(key: key, label: l, amount: amount, unit: u),
      ]).single;
      final sources = {...?open.fromRecipes?.split(', '), ?fromRecipe};
      await (update(shoppingItems)..where((s) => s.id.equals(open.id))).write(
        ShoppingItemsCompanion(
          amount: Value(merged.amount),
          fromRecipes: Value(sources.isEmpty ? null : sources.join(', ')),
          updatedAt: Value(now),
        ),
      );
    });
  }

  /// Puts all ingredients of a recipe, scaled to [servings], on the shopping list.
  /// Returns the number of ingredients.
  Future<int> addRecipeToShopping(String recipeId, {double? servings}) async {
    final r = await getRecipe(recipeId);
    if (r == null) return 0;
    final items = await recipeItemsOf(recipeId);
    final foodIds = [for (final i in items) ?i.foodId];
    final cats = {for (final f in await (select(foods)..where((f) => f.id.isIn(foodIds))).get()) f.id: f.category};
    await transaction(() async {
      for (final i in items) {
        await addShoppingItem(
          label: i.brand == null ? i.foodName : '${i.foodName} (${i.brand})',
          amount: scaleAmount(i.amount, recipeServings: r.servings, wantedServings: servings ?? r.servings),
          unit: i.unit,
          foodId: i.foodId,
          category: cats[i.foodId],
          fromRecipe: r.name,
        );
      }
    });
    return items.length;
  }

  Future<void> setShoppingChecked(String id, bool checked) => (update(shoppingItems)..where((s) => s.id.equals(id)))
      .write(ShoppingItemsCompanion(checked: Value(checked), updatedAt: Value(DateTime.now())));

  Future<void> deleteShoppingItem(String id) => _tombstone(shoppingItems, id);
  Future<void> restoreShoppingItem(String id) => _restore(shoppingItems, id);

  /// Removes all checked lines. Returns how many were removed.
  Future<int> clearCheckedShopping() {
    final now = DateTime.now();
    return (update(shoppingItems)..where((s) => s.checked.equals(true) & s.deletedAt.isNull())).write(
      ShoppingItemsCompanion(deletedAt: Value(now), updatedAt: Value(now)),
    );
  }
}
