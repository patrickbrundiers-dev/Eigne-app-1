part of '../database.dart';

extension FoodsDao on AppDatabase {
  // ---------------------------------------------------------------- foods

  Stream<List<Food>> watchFoods({String query = '', bool onlyUser = false, bool onlyFavorites = false}) {
    final q = select(foods)..where((f) => f.deletedAt.isNull());
    final norm = normalizeName(query);
    if (norm.isNotEmpty) {
      for (final word in norm.split(' ')) {
        q.where((f) => f.foodKey.like('%$word%'));
      }
    }
    if (onlyUser) q.where((f) => f.source.equals('base').not());
    if (onlyFavorites) q.where((f) => f.isFavorite.equals(true));
    q.orderBy([(f) => OrderingTerm.desc(f.isFavorite), (f) => OrderingTerm.asc(f.name.collate(Collate.noCase))]);
    return q.watch();
  }

  Future<List<Food>> searchFoods(String query, {int limit = 50}) async {
    final norm = normalizeName(query);
    final q = select(foods)..where((f) => f.deletedAt.isNull());
    for (final word in norm.split(' ').where((w) => w.isNotEmpty)) {
      q.where((f) => f.foodKey.like('%$word%'));
    }
    q.limit(300);
    final rows = await q.get();
    int rank(Food f) {
      final k = f.foodKey;
      if (k == norm) return 0;
      if (k.startsWith(norm)) return 1;
      if (k.split(' ').any((w) => w.startsWith(norm))) return 2;
      return 3;
    }

    rows.sort((a, b) {
      final r = rank(a).compareTo(rank(b));
      if (r != 0) return r;
      if (a.isFavorite != b.isFavorite) return a.isFavorite ? -1 : 1;
      return a.name.length.compareTo(b.name.length);
    });
    return rows.take(limit).toList();
  }

  Future<Food?> getFood(String id) => (select(foods)..where((f) => f.id.equals(id))).getSingleOrNull();

  Future<Food?> findLiveFoodByKey(String key) =>
      (select(foods)..where((f) => f.foodKey.equals(key) & f.deletedAt.isNull())).getSingleOrNull();

  Future<Food?> findFoodByBarcode(String code) =>
      (select(foods)..where((f) => f.barcode.equals(code) & f.deletedAt.isNull())).getSingleOrNull();

  /// Creates or updates a food after validation and duplicate checks.
  /// Returns the id.
  Future<String> saveFood({
    String? id,
    required String name,
    String? brand,
    String? barcode,
    String? category,
    String unit = 'g',
    required Nutrients per100,
    double? servingAmount,
    String? servingLabel,
    String source = 'user',

    /// Vitamins and minerals per 100 (catalogue id → amount in catalogue unit). Null keeps
    /// the stored values, an empty map removes them.
    Map<String, double>? micros,
  }) async {
    final trimmedName = name.trim();
    if (!const {'user', 'off', 'ai'}.contains(source)) throw ArgumentError('Unbekannte Quelle $source.');
    if (trimmedName.isEmpty) throw InvalidFoodException(['Bitte einen Namen eingeben.']);
    if (unit != 'g' && unit != 'ml') throw InvalidFoodException(['Einheit muss g oder ml sein.']);
    final check = checkPer100(per100);
    if (!check.ok) throw InvalidFoodException(check.errors);
    if (servingAmount != null && servingAmount <= 0) {
      throw InvalidFoodException(['Die Portionsgröße muss größer als 0 sein.']);
    }
    final b = (brand?.trim().isEmpty ?? true) ? null : brand!.trim();
    final code = (barcode?.trim().isEmpty ?? true) ? null : barcode!.replaceAll(RegExp(r'\s'), '');
    final key = foodKey(trimmedName, b);

    return transaction(() async {
      final dup = await findLiveFoodByKey(key);
      if (dup != null && dup.id != id) {
        throw DuplicateFoodException(
          '„${dup.name}“${dup.brand != null ? ' (${dup.brand})' : ''} '
          'gibt es schon.',
          dup,
        );
      }
      if (code != null) {
        final byCode = await findFoodByBarcode(code);
        if (byCode != null && byCode.id != id) {
          throw DuplicateFoodException('Der Barcode $code gehört schon zu „${byCode.name}“.', byCode);
        }
      }
      final now = DateTime.now();
      final companion = FoodsCompanion(
        name: Value(trimmedName),
        brand: Value(b),
        foodKey: Value(key),
        barcode: Value(code),
        category: Value(category),
        unit: Value(unit),
        kcal: Value(per100.kcal),
        protein: Value(per100.protein),
        carbs: Value(per100.carbs),
        sugar: Value(per100.sugar),
        fat: Value(per100.fat),
        saturatedFat: Value(per100.saturatedFat),
        fiber: Value(per100.fiber),
        salt: Value(per100.salt),
        servingAmount: Value(servingAmount),
        servingLabel: Value(servingLabel?.trim().isEmpty ?? true ? null : servingLabel!.trim()),
        source: Value(source),
        updatedAt: Value(now),
      );
      if (id == null) {
        final newFoodId = newId();
        await into(foods).insert(companion.copyWith(id: Value(newFoodId), createdAt: Value(now)));
        if (micros != null) await _writeMicros(newFoodId, micros);
        return newFoodId;
      }
      await (update(foods)..where((f) => f.id.equals(id))).write(companion);
      if (micros != null) await _writeMicros(id, micros);
      return id;
    });
  }

  Future<void> setFavorite(String id, bool fav) => (update(
    foods,
  )..where((f) => f.id.equals(id))).write(FoodsCompanion(isFavorite: Value(fav), updatedAt: Value(DateTime.now())));

  /// Tombstones a food. Its key and barcode get freed so a new food may reuse them;
  /// past diary entries keep their copied values.
  Future<void> deleteFood(String id) async {
    final now = DateTime.now();
    await customUpdate(
      "UPDATE foods SET deleted_at = ?, updated_at = ?, barcode = NULL, "
      "food_key = food_key || '#deleted:' || id WHERE id = ? AND deleted_at IS NULL",
      variables: [Variable(now), Variable(now), Variable(id)],
      updates: {foods},
    );
  }

  /// Foods logged most recently (distinct), for quick re-use.
  Future<List<Food>> recentFoods({int limit = 15}) async {
    final rows = await customSelect(
      'SELECT food_id, MAX(created_at) AS last FROM diary_entries '
      'WHERE deleted_at IS NULL AND food_id IS NOT NULL GROUP BY food_id ORDER BY last DESC LIMIT ?',
      variables: [Variable(limit)],
      readsFrom: {diaryEntries},
    ).get();
    final ids = rows.map((r) => r.read<String>('food_id')).toList();
    if (ids.isEmpty) return [];
    final found = await (select(foods)..where((f) => f.id.isIn(ids) & f.deletedAt.isNull())).get();
    final byId = {for (final f in found) f.id: f};
    return [for (final i in ids) ?byId[i]];
  }

  /// Foods most often logged in [mealSlotId] during the last [days] days, most
  /// frequent first (ties: most recent first). Breakfast suggests other foods than dinner.
  Future<List<Food>> suggestedFoods({required String mealSlotId, int limit = 8, int days = 60, DateTime? now}) async {
    final today = now ?? DateTime.now();
    final from = dayKey(DateTime(today.year, today.month, today.day - days));
    final rows = await customSelect(
      'SELECT food_id, COUNT(*) AS n, MAX(created_at) AS last FROM diary_entries '
      'WHERE deleted_at IS NULL AND food_id IS NOT NULL AND meal_slot_id = ? AND day_key >= ? '
      'GROUP BY food_id HAVING n >= 2 ORDER BY n DESC, last DESC LIMIT ?',
      variables: [Variable(mealSlotId), Variable(from), Variable(limit)],
      readsFrom: {diaryEntries},
    ).get();
    final ids = rows.map((r) => r.read<String>('food_id')).toList();
    if (ids.isEmpty) return [];
    final found = await (select(foods)..where((f) => f.id.isIn(ids) & f.deletedAt.isNull())).get();
    final byId = {for (final f in found) f.id: f};
    return [for (final i in ids) ?byId[i]];
  }
}
