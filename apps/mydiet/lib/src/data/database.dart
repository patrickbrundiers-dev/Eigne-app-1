import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import '../core/dashboard_layout.dart';
import '../core/dates.dart';
import '../core/nutrition.dart';
import '../core/meal_plan.dart';
import '../core/recipes.dart';
import '../core/supplements.dart';
import 'database.steps.dart';
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
    Supplements,
    SupplementIngredients,
    SupplementIntakes,
    MealPlanEntries,
    FastingSessions,
    MealTemplates,
    MealTemplateItems,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _open());

  static QueryExecutor _open() => driftDatabase(
    name: 'mydiet',
    web: DriftWebOptions(sqlite3Wasm: Uri.parse('sqlite3.wasm'), driftWorker: Uri.parse('drift_worker.js')),
  );

  @override
  int get schemaVersion => 5;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
    },
    // Each step uses the schema of its target version (database.steps.dart, generated
    // by `dart run drift_dev make-migrations`), so old databases upgrade one version at a time.
    onUpgrade: stepByStep(
      from1To2: (m, schema) async {
        // Phase 2: recipes and shopping list.
        await m.addColumn(schema.diaryEntries, schema.diaryEntries.recipeId);
        await m.createTable(schema.recipes);
        await m.createTable(schema.recipeItems);
        await m.createTable(schema.shoppingItems);
        await m.createIndex(schema.recipesKey);
        await m.createIndex(schema.recipeItemsRecipe);
      },
      from2To3: (m, schema) async {
        // Phase 2: supplements.
        await m.createTable(schema.supplements);
        await m.createTable(schema.supplementIngredients);
        await m.createTable(schema.supplementIntakes);
        await m.createIndex(schema.supplementsKey);
        await m.createIndex(schema.supplementIngredientsSup);
        await m.createIndex(schema.supplementIntakeSlot);
        await m.createIndex(schema.supplementIntakeDay);
      },
      from3To4: (m, schema) async {
        // Phase 2: meal plan, fasting, carb limit.
        await m.addColumn(schema.profiles, schema.profiles.carbCapG);
        await m.createTable(schema.mealPlanEntries);
        await m.createTable(schema.fastingSessions);
        await m.createIndex(schema.mealPlanDay);
      },
      from4To5: (m, schema) async {
        // Meal templates (quick logging).
        await m.createTable(schema.mealTemplates);
        await m.createTable(schema.mealTemplateItems);
        await m.createIndex(schema.mealTemplatesKey);
        await m.createIndex(schema.mealTemplateItemsTpl);
      },
    ),
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

  Future<void> setDashTileVisible(String id, bool visible) async =>
      setSetting('dashboardLayout', setTileVisible(await getSetting('dashboardLayout'), id, visible));

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

  /// All live diary entries, oldest first (for the CSV export).
  Future<List<DiaryEntry>> allDiary() =>
      (select(diaryEntries)
            ..where((e) => e.deletedAt.isNull())
            ..orderBy([(e) => OrderingTerm.asc(e.dayKey), (e) => OrderingTerm.asc(e.createdAt)]))
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

  /// Brand shown on quick entries; marks the values as an estimate.
  static const quickEntryBrand = 'Schnelleintrag (Schätzung)';

  /// Logs calories (and optionally macros) without a food, e.g. for a restaurant meal.
  /// Stored as one portion whose values are kept "per 100" × 100, so the diary math
  /// stays the same for every entry.
  Future<String> logQuickEntry({
    required String day,
    required String mealSlotId,
    required String label,
    required double kcal,
    double protein = 0,
    double carbs = 0,
    double fat = 0,
  }) async {
    if (!(kcal > 0) || kcal > 10000) throw ArgumentError('Die Kalorien müssen zwischen 1 und 10000 liegen.');
    if (protein < 0 || carbs < 0 || fat < 0) throw ArgumentError('Nährwerte dürfen nicht negativ sein.');
    final id = newId();
    final name = label.trim().isEmpty ? 'Schnelleintrag' : label.trim();
    await into(diaryEntries).insert(
      DiaryEntriesCompanion.insert(
        id: Value(id),
        dayKey: day,
        mealSlotId: mealSlotId,
        foodName: name.length > 120 ? name.substring(0, 120) : name,
        brand: const Value(quickEntryBrand),
        unit: 'Portion',
        amount: 1,
        kcal100: kcal * 100,
        protein100: protein * 100,
        carbs100: carbs * 100,
        sugar100: 0,
        fat100: fat * 100,
        saturatedFat100: 0,
        fiber100: 0,
        salt100: 0,
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

  /// Like [dailyTotals], as a stream that updates when diary entries change.
  Stream<Map<String, Nutrients>> watchDailyTotals(String fromDay, String toDay) =>
      (select(diaryEntries)..where((e) => e.dayKey.isBetweenValues(fromDay, toDay) & e.deletedAt.isNull())).watch().map(
        (rows) {
          final out = <String, Nutrients>{};
          for (final e in rows) {
            out[e.dayKey] = (out[e.dayKey] ?? Nutrients.zero) + e.nutrients;
          }
          return out;
        },
      );

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

  // ---------------------------------------------------------------- supplements

  /// Products with their ingredients, ordered by name.
  Stream<List<SupplementWithDoses>> watchSupplements({bool activeOnly = false}) {
    final q = select(supplements)..where((s) => s.deletedAt.isNull());
    if (activeOnly) q.where((s) => s.active.equals(true));
    q.orderBy([(s) => OrderingTerm.asc(s.name.collate(Collate.noCase))]);
    return q.watch().asyncMap((rows) async {
      if (rows.isEmpty) return const <SupplementWithDoses>[];
      final ings =
          await (select(supplementIngredients)
                ..where((i) => i.supplementId.isIn(rows.map((r) => r.id)) & i.deletedAt.isNull())
                ..orderBy([(i) => OrderingTerm.asc(i.sortOrder)]))
              .get();
      return [
        for (final r in rows) SupplementWithDoses(r, [for (final i in ings.where((i) => i.supplementId == r.id)) i]),
      ];
    });
  }

  Future<Supplement?> getSupplement(String id) =>
      (select(supplements)..where((s) => s.id.equals(id))).getSingleOrNull();

  /// Creates or updates a product with all ingredients. Returns the id.
  Future<String> saveSupplement({
    String? id,
    required String name,
    String? brand,
    String? form,
    String servingLabel = 'Portion',
    String? manufacturerDose,
    double servingsPerDay = 1,
    List<int> times = const [],
    bool active = true,
    double? stockServings,
    String? note,
    required List<SupplementDose> doses,
  }) async {
    final n = name.trim();
    final b = (brand?.trim().isEmpty ?? true) ? null : brand!.trim();
    final errors = <String>[
      if (n.isEmpty) 'Bitte einen Namen eingeben.',
      if (!(servingsPerDay >= 0 && servingsPerDay <= 50)) 'Portionen pro Tag: 0 bis 50.',
      if (doses.any((d) => !(d.amount > 0 && d.amount < 1e7))) 'Jeder Inhaltsstoff braucht eine Menge größer 0.',
      if (times.any((t) => t < 0 || t >= 24 * 60)) 'Ungültige Uhrzeit.',
      if (stockServings != null && stockServings < 0) 'Der Vorrat kann nicht negativ sein.',
    ];
    final ids = [
      for (final d in doses) nutrientById(d.nutrientId)?.id ?? 'custom:${d.displayName.trim().toLowerCase()}',
    ];
    if (ids.toSet().length != ids.length) errors.add('Jeder Inhaltsstoff darf nur einmal vorkommen.');
    if (errors.isNotEmpty) throw InvalidFoodException(errors);
    final key = foodKey(n, b);
    return transaction(() async {
      final dup = await (select(
        supplements,
      )..where((s) => s.nameKey.equals(key) & s.deletedAt.isNull())).getSingleOrNull();
      if (dup != null && dup.id != id) {
        throw ArgumentError('„${dup.name}“${dup.brand != null ? ' (${dup.brand})' : ''} gibt es schon.');
      }
      final now = DateTime.now();
      final supId = id ?? newId();
      final sortedTimes = times.toSet().toList()..sort();
      final data = SupplementsCompanion(
        name: Value(n),
        brand: Value(b),
        nameKey: Value(key),
        form: Value(form?.trim().isEmpty ?? true ? null : form!.trim()),
        servingLabel: Value(servingLabel.trim().isEmpty ? 'Portion' : servingLabel.trim()),
        manufacturerDose: Value(manufacturerDose?.trim().isEmpty ?? true ? null : manufacturerDose!.trim()),
        servingsPerDay: Value(servingsPerDay),
        timesJson: Value(jsonEncode(sortedTimes)),
        active: Value(active),
        stockServings: Value(stockServings),
        note: Value(note?.trim().isEmpty ?? true ? null : note!.trim()),
        updatedAt: Value(now),
      );
      if (id == null) {
        await into(supplements).insert(data.copyWith(id: Value(supId), createdAt: Value(now)));
      } else {
        await (update(supplements)..where((s) => s.id.equals(id))).write(data);
        await (update(supplementIngredients)..where((i) => i.supplementId.equals(id) & i.deletedAt.isNull())).write(
          SupplementIngredientsCompanion(deletedAt: Value(now), updatedAt: Value(now)),
        );
      }
      for (var i = 0; i < doses.length; i++) {
        final d = doses[i];
        final custom = nutrientById(d.nutrientId) == null;
        await into(supplementIngredients).insert(
          SupplementIngredientsCompanion.insert(
            supplementId: supId,
            nutrientId: custom ? 'custom:${d.displayName.trim()}' : d.nutrientId,
            name: Value(custom ? d.displayName.trim() : null),
            amount: d.amount,
            unit: d.unit,
            sortOrder: i,
          ),
        );
      }
      return supId;
    });
  }

  Future<void> deleteSupplement(String id) async {
    final now = DateTime.now();
    await transaction(() async {
      await customUpdate(
        "UPDATE supplements SET deleted_at = ?, updated_at = ?, name_key = name_key || '#deleted:' || id "
        'WHERE id = ? AND deleted_at IS NULL',
        variables: [Variable(now), Variable(now), Variable(id)],
        updates: {supplements},
      );
      await (update(supplementIngredients)..where((i) => i.supplementId.equals(id) & i.deletedAt.isNull())).write(
        SupplementIngredientsCompanion(deletedAt: Value(now), updatedAt: Value(now)),
      );
    });
  }

  Stream<List<SupplementIntake>> watchIntakes(String day) =>
      (select(supplementIntakes)..where((i) => i.dayKey.equals(day) & i.deletedAt.isNull())).watch();

  /// Marks a planned intake as taken or not taken. The stock (if tracked) goes
  /// down or back up by the servings. Toggling twice never counts twice.
  Future<void> setIntake({
    required String supplementId,
    required String day,
    required int plannedMinute,
    required double servings,
    required bool taken,
  }) async {
    if (!(servings > 0 && servings <= 50)) throw ArgumentError('Ungültige Menge.');
    await transaction(() async {
      final now = DateTime.now();
      final existing =
          await (select(supplementIntakes)..where(
                (i) =>
                    i.supplementId.equals(supplementId) & i.dayKey.equals(day) & i.plannedMinute.equals(plannedMinute),
              ))
              .getSingleOrNull();
      final wasTaken = existing != null && existing.deletedAt == null;
      if (wasTaken == taken) return;
      double delta;
      if (taken) {
        if (existing == null) {
          await into(supplementIntakes).insert(
            SupplementIntakesCompanion.insert(
              supplementId: supplementId,
              dayKey: day,
              plannedMinute: plannedMinute,
              servings: servings,
            ),
          );
        } else {
          await (update(supplementIntakes)..where((i) => i.id.equals(existing.id))).write(
            SupplementIntakesCompanion(servings: Value(servings), deletedAt: const Value(null), updatedAt: Value(now)),
          );
        }
        delta = -servings;
      } else {
        await (update(supplementIntakes)..where((i) => i.id.equals(existing!.id))).write(
          SupplementIntakesCompanion(deletedAt: Value(now), updatedAt: Value(now)),
        );
        delta = existing!.servings;
      }
      await customUpdate(
        'UPDATE supplements SET stock_servings = MAX(0, stock_servings + ?), updated_at = ? '
        'WHERE id = ? AND stock_servings IS NOT NULL',
        variables: [Variable(delta), Variable(now), Variable(supplementId)],
        updates: {supplements},
      );
    });
  }

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
  Future<int> generatePlanFor({
    required List<String> days,
    required double targetKcal,
    Set<String> tags = const {},
    bool includeSnacks = false,
  }) async {
    final slots = await watchMealSlots().first;
    final recipesList = await watchRecipes().first;
    final pool = <PlanRecipe>[];
    final byId = <String, Recipe>{};
    for (final r in recipesList) {
      final n = await recipeNutritionOf(r);
      if (!(n.finalWeight > 0)) continue;
      byId[r.id] = r;
      pool.add(PlanRecipe(id: r.id, kcalPer100: n.per100.kcal, servingWeight: n.servingWeight, tags: r.tags));
    }
    final filtered = filterByTags(pool, tags);
    if (filtered.isEmpty) return 0;
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
      return n;
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

  // ---------------------------------------------------------------- fasting

  Stream<List<FastingSession>> watchFasting({int limit = 30}) =>
      (select(fastingSessions)
            ..where((f) => f.deletedAt.isNull())
            ..orderBy([(f) => OrderingTerm.desc(f.startAt)])
            ..limit(limit))
          .watch();

  Future<FastingSession?> activeFast() =>
      (select(fastingSessions)
            ..where((f) => f.deletedAt.isNull() & f.endAt.isNull())
            ..orderBy([(f) => OrderingTerm.desc(f.startAt)])
            ..limit(1))
          .getSingleOrNull();

  /// Starts a fast. An already running fast is returned unchanged (never two at once).
  Future<String> startFast({required double targetHours, DateTime? at}) async {
    if (!(targetHours > 0 && targetHours <= 168)) throw ArgumentError('Fastendauer 1 bis 168 Stunden.');
    final start = at ?? DateTime.now();
    if (start.isAfter(DateTime.now().add(const Duration(minutes: 1)))) {
      throw ArgumentError('Der Beginn liegt in der Zukunft.');
    }
    return transaction(() async {
      final open = await activeFast();
      if (open != null) return open.id;
      final id = newId();
      await into(fastingSessions)
          .insert(FastingSessionsCompanion.insert(id: Value(id), startAt: start, targetHours: targetHours));
      return id;
    });
  }

  Future<void> endFast({DateTime? at}) async {
    final open = await activeFast();
    if (open == null) return;
    final end = at ?? DateTime.now();
    if (end.isBefore(open.startAt)) throw ArgumentError('Das Ende liegt vor dem Beginn.');
    await (update(fastingSessions)..where((f) => f.id.equals(open.id))).write(
      FastingSessionsCompanion(endAt: Value(end), updatedAt: Value(DateTime.now())),
    );
  }

  Future<void> deleteFast(String id) => _tombstone(fastingSessions, id);

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
    supplements,
    supplementIngredients,
    supplementIntakes,
    mealPlanEntries,
    fastingSessions,
    mealTemplates,
    mealTemplateItems,
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

/// A product with its ingredients per serving.
class SupplementWithDoses {
  const SupplementWithDoses(this.supplement, this.ingredients);
  final Supplement supplement;
  final List<SupplementIngredient> ingredients;

  List<SupplementDose> get doses => [
    for (final i in ingredients) SupplementDose(nutrientId: i.nutrientId, amount: i.amount, unit: i.unit, name: i.name),
  ];

  String get label => supplement.brand == null ? supplement.name : '${supplement.name} (${supplement.brand})';

  /// Planned intake slots today: one per time, or one without time (-1).
  List<({int minute, double servings})> get slots {
    final times = supplement.times;
    final per = supplement.servingsPerDay;
    if (!(per > 0)) return const [];
    if (times.isEmpty) return [(minute: -1, servings: per)];
    return [for (final t in times) (minute: t, servings: per / times.length)];
  }
}

extension SupplementTimes on Supplement {
  List<int> get times {
    try {
      return (jsonDecode(timesJson) as List).map((e) => (e as num).toInt()).toList();
    } catch (_) {
      return [];
    }
  }
}

extension MealPlanNutrients on MealPlanEntry {
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
