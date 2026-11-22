import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import '../core/dates.dart';
import '../core/nutrition.dart';
import '../core/recipes.dart';
import 'seed_foods.dart';
import 'tables.dart';

export 'tables.dart' show newId;

part 'database.g.dart';

class DuplicateFoodException implements Exception {
  DuplicateFoodException(this.message, this.existing);
  final String message;
  final Food existing;
  @override
  String toString() => message;
}

class DuplicateRecipeException implements Exception {
  DuplicateRecipeException(this.existing);
  final Recipe existing;
  @override
  String toString() => 'Ein Rezept „${existing.name}“ gibt es schon.';
}

/// An ingredient as entered in the recipe form: a copy of the food's values plus amount.
class IngredientInput {
  const IngredientInput({
    this.foodId,
    required this.name,
    this.brand,
    required this.unit,
    required this.per100,
    required this.amount,
    this.category,
  });

  factory IngredientInput.fromFood(Food f, double amount) => IngredientInput(
    foodId: f.id,
    name: f.name,
    brand: f.brand,
    unit: f.unit,
    per100: f.per100,
    amount: amount,
    category: f.category,
  );

  factory IngredientInput.fromItem(RecipeItem i) => IngredientInput(
    foodId: i.foodId,
    name: i.foodName,
    brand: i.brand,
    unit: i.unit,
    per100: i.per100,
    amount: i.amount,
  );

  final String? foodId;
  final String name;
  final String? brand;
  final String unit;
  final Nutrients per100;
  final double amount;
  final String? category;

  IngredientInput withAmount(double a) => IngredientInput(
    foodId: foodId,
    name: name,
    brand: brand,
    unit: unit,
    per100: per100,
    amount: a,
    category: category,
  );

  Ingredient get ingredient => Ingredient(per100: per100, amount: amount, unit: unit);
}

class InvalidFoodException implements Exception {
  InvalidFoodException(this.errors);
  final List<String> errors;
  @override
  String toString() => errors.join(' ');
}

const _defaultSlots = [
  ('Frühstück', 7 * 60 + 30),
  ('Mittagessen', 12 * 60 + 30),
  ('Abendessen', 18 * 60 + 30),
  ('Snacks', null),
];

/// Increase when the shipped reference foods change; [seedReferenceFoods] then
/// adds new ones without touching the user's foods.
const int seedVersion = 1;

@DriftDatabase(
  tables: [
    Profiles,
    MealSlots,
    Foods,
    DiaryEntries,
    WeightEntries,
    WaterEntries,
    ActivityEntries,
    Settings,
    Recipes,
    RecipeItems,
    ShoppingItems,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _open());

  static QueryExecutor _open() => driftDatabase(
    name: 'mydiet',
    web: DriftWebOptions(sqlite3Wasm: Uri.parse('sqlite3.wasm'), driftWorker: Uri.parse('drift_worker.js')),
  );

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
    },
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        // Phase 2: recipes and shopping list.
        await m.addColumn(diaryEntries, diaryEntries.recipeId);
        await m.createTable(recipes);
        await m.createTable(recipeItems);
        await m.createTable(shoppingItems);
        await m.createIndex(recipesKey);
        await m.createIndex(recipeItemsRecipe);
      }
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
      if (details.wasCreated) {
        await batch((b) {
          for (var i = 0; i < _defaultSlots.length; i++) {
            b.insert(
              mealSlots,
              MealSlotsCompanion.insert(
                name: _defaultSlots[i].$1,
                minuteOfDay: Value(_defaultSlots[i].$2),
                sortOrder: i,
              ),
            );
          }
        });
      }
      await seedReferenceFoods();
    },
  );

  // ---------------------------------------------------------------- settings

  Future<String?> getSetting(String key) async =>
      (await (select(settings)..where((s) => s.key.equals(key))).getSingleOrNull())?.value;

  Stream<String?> watchSetting(String key) =>
      (select(settings)..where((s) => s.key.equals(key))).watchSingleOrNull().map((r) => r?.value);

  Future<void> setSetting(String key, String value) =>
      into(settings).insertOnConflictUpdate(SettingsCompanion.insert(key: key, value: value));

  // ---------------------------------------------------------------- seed

  Future<void> seedReferenceFoods() async {
    final current = int.tryParse(await getSetting('seedVersion') ?? '') ?? 0;
    if (current >= seedVersion) return;
    await transaction(() async {
      final existing = (await select(foods).get()).map((f) => f.foodKey).toSet();
      await batch((b) {
        for (final f in referenceFoods) {
          final key = foodKey(f.name, null);
          if (existing.contains(key)) continue;
          existing.add(key);
          b.insert(
            foods,
            FoodsCompanion.insert(
              name: f.name,
              foodKey: key,
              category: Value(f.category),
              unit: Value(f.unit),
              kcal: f.kcal,
              protein: f.protein,
              carbs: f.carbs,
              sugar: Value(f.sugar),
              fat: f.fat,
              saturatedFat: Value(f.satFat),
              fiber: Value(f.fiber),
              salt: Value(f.salt),
              servingAmount: Value(f.serving),
              servingLabel: Value(f.servingLabel),
              source: const Value('base'),
            ),
          );
        }
      });
      await setSetting('seedVersion', '$seedVersion');
    });
  }

  // ---------------------------------------------------------------- profile

  Stream<Profile?> watchProfile() => (select(profiles)..where((p) => p.id.equals('me'))).watchSingleOrNull();

  Future<Profile?> getProfile() => (select(profiles)..where((p) => p.id.equals('me'))).getSingleOrNull();

  Future<void> saveProfile(ProfilesCompanion data) async {
    await into(profiles).insertOnConflictUpdate(data.copyWith(id: const Value('me'), updatedAt: Value(DateTime.now())));
  }

  // ---------------------------------------------------------------- meal slots

  Stream<List<MealSlot>> watchMealSlots() =>
      (select(mealSlots)
            ..where((s) => s.deletedAt.isNull())
            ..orderBy([(s) => OrderingTerm.asc(s.sortOrder)]))
          .watch();

  /// Saves the full list of slots in order. Removed slots are tombstoned; their
  /// diary entries stay and are shown under "Weitere Einträge".
  Future<void> saveMealSlots(List<({String? id, String name, int? minuteOfDay})> slots) async {
    if (slots.isEmpty || slots.length > 6) {
      throw ArgumentError('Es sind 1 bis 6 Mahlzeiten möglich.');
    }
    await transaction(() async {
      final now = DateTime.now();
      final keep = <String>{};
      for (var i = 0; i < slots.length; i++) {
        final s = slots[i];
        final id = s.id ?? newId();
        keep.add(id);
        await into(mealSlots).insertOnConflictUpdate(
          MealSlotsCompanion(
            id: Value(id),
            name: Value(s.name.trim()),
            minuteOfDay: Value(s.minuteOfDay),
            sortOrder: Value(i),
            updatedAt: Value(now),
            deletedAt: const Value(null),
          ),
        );
      }
      await (update(mealSlots)..where((m) => m.id.isNotIn(keep) & m.deletedAt.isNull())).write(
        MealSlotsCompanion(deletedAt: Value(now), updatedAt: Value(now)),
      );
    });
  }

  // ---------------------------------------------------------------- foods

  Stream<List<Food>> watchFoods({String query = '', bool onlyUser = false, bool onlyFavorites = false}) {
    final q = select(foods)..where((f) => f.deletedAt.isNull());
    final norm = normalizeName(query);
    if (norm.isNotEmpty) {
      for (final word in norm.split(' ')) {
        q.where((f) => f.foodKey.like('%$word%'));
      }
    }
    if (onlyUser) q.where((f) => f.source.equals('user'));
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
  }) async {
    final trimmedName = name.trim();
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
        updatedAt: Value(now),
      );
      if (id == null) {
        final newFoodId = newId();
        await into(foods)
            .insert(companion.copyWith(id: Value(newFoodId), source: const Value('user'), createdAt: Value(now)));
        return newFoodId;
      }
      await (update(foods)..where((f) => f.id.equals(id))).write(companion);
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

  // ---------------------------------------------------------------- diary

  Stream<List<DiaryEntry>> watchDiary(String day) =>
      (select(diaryEntries)
            ..where((e) => e.dayKey.equals(day) & e.deletedAt.isNull())
            ..orderBy([(e) => OrderingTerm.asc(e.createdAt)]))
          .watch();

  Future<List<DiaryEntry>> diaryForDay(String day) =>
      (select(diaryEntries)
            ..where((e) => e.dayKey.equals(day) & e.deletedAt.isNull())
            ..orderBy([(e) => OrderingTerm.asc(e.createdAt)]))
          .get();

  Future<String> logFood({
    required String day,
    required String mealSlotId,
    required Food food,
    required double amount,
  }) async {
    if (!(amount > 0) || amount > 5000) {
      throw ArgumentError('Die Menge muss zwischen 0 und 5000 ${food.unit} liegen.');
    }
    final id = newId();
    await into(diaryEntries).insert(
      DiaryEntriesCompanion.insert(
        id: Value(id),
        dayKey: day,
        mealSlotId: mealSlotId,
        foodId: Value(food.id),
        foodName: food.name,
        brand: Value(food.brand),
        unit: food.unit,
        amount: amount,
        kcal100: food.kcal,
        protein100: food.protein,
        carbs100: food.carbs,
        sugar100: food.sugar,
        fat100: food.fat,
        saturatedFat100: food.saturatedFat,
        fiber100: food.fiber,
        salt100: food.salt,
      ),
    );
    return id;
  }

  Future<void> updateDiaryEntry(String id, {double? amount, String? mealSlotId}) async {
    if (amount != null && (!(amount > 0) || amount > 5000)) {
      throw ArgumentError('Die Menge muss zwischen 0 und 5000 liegen.');
    }
    await (update(diaryEntries)..where((e) => e.id.equals(id))).write(
      DiaryEntriesCompanion(
        amount: amount == null ? const Value.absent() : Value(amount),
        mealSlotId: mealSlotId == null ? const Value.absent() : Value(mealSlotId),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> deleteDiaryEntry(String id) => _tombstone(diaryEntries, id);
  Future<void> restoreDiaryEntry(String id) => _restore(diaryEntries, id);

  /// Copies the entries of one meal (or a whole day if [fromSlotId] is null) to
  /// another day. Returns the number of copied entries.
  Future<int> copyMeal({required String fromDay, String? fromSlotId, required String toDay, String? toSlotId}) async {
    return transaction(() async {
      final q = select(diaryEntries)..where((e) => e.dayKey.equals(fromDay) & e.deletedAt.isNull());
      if (fromSlotId != null) q.where((e) => e.mealSlotId.equals(fromSlotId));
      final src = await q.get();
      final now = DateTime.now();
      var i = 0;
      for (final e in src) {
        await into(diaryEntries).insert(
          e.copyWith(
            id: newId(),
            dayKey: toDay,
            mealSlotId: toSlotId ?? e.mealSlotId,
            // keep the original order within the copied meal
            createdAt: now.add(Duration(milliseconds: i++)),
            updatedAt: now,
          ),
        );
      }
      return src.length;
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

  // ---------------------------------------------------------------- weight

  Stream<List<WeightEntry>> watchWeights() =>
      (select(weightEntries)
            ..where((w) => w.deletedAt.isNull())
            ..orderBy([(w) => OrderingTerm.asc(w.dayKey)]))
          .watch();

  Future<List<WeightEntry>> allWeights() =>
      (select(weightEntries)
            ..where((w) => w.deletedAt.isNull())
            ..orderBy([(w) => OrderingTerm.asc(w.dayKey)]))
          .get();

  /// Saves the weight for a day; an existing entry for that day is replaced.
  Future<void> saveWeight({
    required String day,
    required double weightKg,
    double? bodyFatPercent,
    double? waistCm,
    String? note,
  }) async {
    if (!(weightKg >= 25 && weightKg <= 400)) {
      throw ArgumentError('Bitte ein Gewicht zwischen 25 und 400 kg eingeben.');
    }
    if (bodyFatPercent != null && !(bodyFatPercent > 2 && bodyFatPercent < 75)) {
      throw ArgumentError('Körperfett muss zwischen 2 und 75 % liegen.');
    }
    if (waistCm != null && !(waistCm >= 30 && waistCm <= 250)) {
      throw ArgumentError('Bauchumfang muss zwischen 30 und 250 cm liegen.');
    }
    final now = DateTime.now();
    await transaction(() async {
      final existing = await (select(weightEntries)..where((w) => w.dayKey.equals(day))).getSingleOrNull();
      final data = WeightEntriesCompanion(
        dayKey: Value(day),
        weightKg: Value(weightKg),
        bodyFatPercent: Value(bodyFatPercent),
        waistCm: Value(waistCm),
        note: Value(note?.trim().isEmpty ?? true ? null : note!.trim()),
        updatedAt: Value(now),
        deletedAt: const Value(null),
      );
      if (existing == null) {
        await into(weightEntries).insert(data.copyWith(id: Value(newId()), createdAt: Value(now)));
      } else {
        await (update(weightEntries)..where((w) => w.id.equals(existing.id))).write(data);
      }
    });
  }

  Future<void> deleteWeight(String id) => _tombstone(weightEntries, id);

  // ---------------------------------------------------------------- water

  Stream<int> watchWaterMl(String day) {
    final sum = waterEntries.ml.sum();
    return (selectOnly(waterEntries)
          ..addColumns([sum])
          ..where(waterEntries.dayKey.equals(day) & waterEntries.deletedAt.isNull()))
        .map((r) => r.read(sum) ?? 0)
        .watchSingle();
  }

  Future<void> addWater(String day, int ml) async {
    if (ml == 0 || ml.abs() > 3000) throw ArgumentError('Ungültige Wassermenge.');
    await into(waterEntries).insert(WaterEntriesCompanion.insert(dayKey: day, ml: ml));
  }

  /// Removes the most recent water entry of the day.
  Future<bool> undoLastWater(String day) async {
    final last =
        await (select(waterEntries)
              ..where((w) => w.dayKey.equals(day) & w.deletedAt.isNull())
              ..orderBy([(w) => OrderingTerm.desc(w.createdAt), (w) => OrderingTerm.desc(w.rowId)])
              ..limit(1))
            .getSingleOrNull();
    if (last == null) return false;
    await _tombstone(waterEntries, last.id);
    return true;
  }

  // ---------------------------------------------------------------- activity

  Stream<List<ActivityEntry>> watchActivities(String day) =>
      (select(activityEntries)
            ..where((a) => a.dayKey.equals(day) & a.deletedAt.isNull())
            ..orderBy([(a) => OrderingTerm.asc(a.createdAt)]))
          .watch();

  Future<void> addActivity({
    required String day,
    required String label,
    int minutes = 0,
    double kcal = 0,
    int? steps,
  }) async {
    if (label.trim().isEmpty) throw ArgumentError('Bitte eine Bezeichnung eingeben.');
    if (minutes < 0 || minutes > 1440 || kcal < 0 || kcal > 10000 || (steps != null && steps < 0)) {
      throw ArgumentError('Ungültige Aktivitätswerte.');
    }
    await into(activityEntries).insert(
      ActivityEntriesCompanion.insert(
        dayKey: day,
        label: label.trim(),
        minutes: Value(minutes),
        kcal: Value(kcal),
        steps: Value(steps),
      ),
    );
  }

  Future<void> deleteActivity(String id) => _tombstone(activityEntries, id);

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

  // ---------------------------------------------------------------- helpers

  Future<void> _tombstone(TableInfo table, String id) async {
    final now = DateTime.now();
    await customUpdate(
      'UPDATE ${table.actualTableName} SET deleted_at = ?, updated_at = ? WHERE id = ?',
      variables: [Variable(now), Variable(now), Variable(id)],
      updates: {table},
    );
  }

  Future<void> _restore(TableInfo table, String id) async {
    await customUpdate(
      'UPDATE ${table.actualTableName} SET deleted_at = NULL, updated_at = ? WHERE id = ?',
      variables: [Variable(DateTime.now()), Variable(id)],
      updates: {table},
    );
  }

  // ---------------------------------------------------------------- export / import

  static const exportFormat = 'mydiet-export';
  static const exportVersion = 1;

  List<TableInfo> get _exportTables => [
    profiles,
    mealSlots,
    foods,
    diaryEntries,
    weightEntries,
    waterEntries,
    activityEntries,
    settings,
    recipes,
    recipeItems,
    shoppingItems,
  ];

  /// All data, including tombstones, as JSON.
  Future<String> exportJson() async {
    final data = <String, dynamic>{
      'format': exportFormat,
      'version': exportVersion,
      'schema': schemaVersion,
      'exportedAt': DateTime.now().toUtc().toIso8601String(),
    };
    for (final t in _exportTables) {
      final rows = await customSelect('SELECT * FROM ${t.actualTableName}', readsFrom: {t}).get();
      data[t.actualTableName] = [for (final r in rows) r.data];
    }
    return const JsonEncoder.withIndent(' ').convert(data);
  }

  /// Replaces all data with an export. Runs in one transaction: on any error
  /// nothing changes.
  Future<Map<String, int>> importJson(String json) async {
    final decoded = jsonDecode(json);
    if (decoded is! Map<String, dynamic> || decoded['format'] != exportFormat) {
      throw const FormatException('Das ist keine MyDiet-Exportdatei.');
    }
    if ((decoded['version'] as int? ?? 0) > exportVersion) {
      throw const FormatException('Die Datei stammt aus einer neueren App-Version.');
    }
    final counts = <String, int>{};
    await transaction(() async {
      for (final t in _exportTables.reversed) {
        await customStatement('DELETE FROM ${t.actualTableName}');
      }
      for (final t in _exportTables) {
        final rows = (decoded[t.actualTableName] as List?) ?? const [];
        final cols = t.$columns.map((c) => c.name).toSet();
        for (final raw in rows) {
          final row = Map<String, dynamic>.from(raw as Map)..removeWhere((k, _) => !cols.contains(k));
          if (row.isEmpty) continue;
          final keys = row.keys.toList();
          await customInsert(
            'INSERT INTO ${t.actualTableName} (${keys.join(', ')}) '
            'VALUES (${List.filled(keys.length, '?').join(', ')})',
            variables: [for (final k in keys) Variable(row[k])],
            updates: {t},
          );
        }
        counts[t.actualTableName] = rows.length;
      }
    });
    return counts;
  }
}

extension DiaryEntryNutrients on DiaryEntry {
  Nutrients get per100 => Nutrients(
    kcal: kcal100,
    protein: protein100,
    carbs: carbs100,
    sugar: sugar100,
    fat: fat100,
    saturatedFat: saturatedFat100,
    fiber: fiber100,
    salt: salt100,
  );
  Nutrients get nutrients => per100.forAmount(amount);
}

extension RecipeItemNutrients on RecipeItem {
  Nutrients get per100 => Nutrients(
    kcal: kcal100,
    protein: protein100,
    carbs: carbs100,
    sugar: sugar100,
    fat: fat100,
    saturatedFat: saturatedFat100,
    fiber: fiber100,
    salt: salt100,
  );
  Nutrients get nutrients => per100.forAmount(amount);
}

extension RecipeTags on Recipe {
  List<String> get tags => _list(tagsJson);
}

extension FoodNutrients on Food {
  Nutrients get per100 => Nutrients(
    kcal: kcal,
    protein: protein,
    carbs: carbs,
    sugar: sugar,
    fat: fat,
    saturatedFat: saturatedFat,
    fiber: fiber,
    salt: salt,
  );
  bool get isUserFood => source == 'user';
}

extension ProfileLists on Profile {
  List<String> get allergies => _list(allergiesJson);
  List<String> get preferredFoods => _list(preferredFoodsJson);
  List<String> get dislikedFoods => _list(dislikedFoodsJson);
}

List<String> _list(String json) {
  try {
    return (jsonDecode(json) as List).map((e) => e.toString()).toList();
  } catch (_) {
    return [];
  }
}

String encodeList(List<String> items) =>
    jsonEncode(items.map((e) => e.trim()).where((e) => e.isNotEmpty).toSet().toList());

/// Convenience used by the dashboard and diary.
String todayKey() => dayKey(DateTime.now());
