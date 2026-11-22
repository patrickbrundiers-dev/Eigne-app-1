import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import '../core/dashboard_layout.dart';
import '../core/dates.dart';
import '../core/energy.dart' show ageOn;
import '../core/nutrition.dart';
import '../core/food_quality.dart';
import '../core/meal_plan.dart';
import '../core/micronutrients.dart';
import '../core/recipes.dart';
import '../core/supplements.dart';
import 'database.steps.dart';
import 'seed_foods.dart';
import 'seed_micros.dart';
import 'seed_usda.dart';
import 'tables.dart';

export '../core/food_quality.dart' show FoodSource, FoodQuality;
export 'tables.dart' show newId;

part 'database.g.dart';
part 'dao/foods.dart';
part 'dao/diary.dart';
part 'dao/templates.dart';
part 'dao/body.dart';
part 'dao/recipes.dart';
part 'dao/shopping.dart';
part 'dao/supplements.dart';
part 'dao/meal_plan.dart';
part 'dao/fasting.dart';
part 'dao/micros.dart';
part 'dao/export.dart';

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
/// adds new ones without touching the user's foods. 2 = USDA-Lebensmittel (Aufgabe 3.6).
const int seedVersion = 2;

/// All shipped base foods: hand-curated reference values plus USDA FoodData Central.
const baseFoods = [...referenceFoods, ...usdaFoods];

/// Shipped vitamins and minerals per base food name.
Map<String, double>? baseMicros(String name) => referenceMicros[name] ?? usdaMicros[name];

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
    FoodMicronutrients,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _open());

  static QueryExecutor _open() => driftDatabase(
    name: 'mydiet',
    web: DriftWebOptions(sqlite3Wasm: Uri.parse('sqlite3.wasm'), driftWorker: Uri.parse('drift_worker.js')),
  );

  @override
  int get schemaVersion => 6;

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
      from5To6: (m, schema) async {
        // W5: vitamins and minerals per food.
        await m.createTable(schema.foodMicronutrients);
        await m.createIndex(schema.foodMicronutrientsFood);
      },
    ),
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
      if (details.wasCreated) await _insertDefaultSlots();
      await seedReferenceFoods();
      // Migration tests open the database at older versions, which lack the table.
      if (details.versionNow >= 6) await seedReferenceMicros();
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
      // Also the names of deleted foods, so a base food the user deleted does not come back.
      final existing = {
        for (final f in await select(foods).get()) ...[f.foodKey, foodKey(f.name, f.brand)],
      };
      await batch((b) {
        for (final f in baseFoods) {
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

  // ---------------------------------------------------------------- constants used by the part files

  static const quickEntryBrand = 'Schnelleintrag (Schätzung)';
  static const microSeedVersion = 2;
  static const exportFormat = 'mydiet-export';
  static const exportVersion = 1;
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

  /// Foods the user may edit or delete (everything except the shipped base foods).
  bool get isUserFood => source != 'base';
  FoodSource get sourceKind => FoodSource.parse(source);
  FoodQuality get quality => assessQuality(sourceKind, per100);
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
