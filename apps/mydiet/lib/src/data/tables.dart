import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

const _uuid = Uuid();
String newId() => _uuid.v4();

/// Every synced table has a UUID primary key, timestamps and a tombstone column, so
/// Phase 4 can sync rows by id + updatedAt without changing the schema.
mixin SyncColumns on Table {
  TextColumn get id => text().clientDefault(newId)();
  DateTimeColumn get createdAt => dateTime().clientDefault(DateTime.now)();
  DateTimeColumn get updatedAt => dateTime().clientDefault(DateTime.now)();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// The personal profile. One row (id = "me") per installation in Phase 1.
class Profiles extends Table with SyncColumns {
  TextColumn get displayName => text().nullable()();
  TextColumn get sex => text()(); // male | female
  DateTimeColumn get birthDate => dateTime()();
  RealColumn get heightCm => real()();
  RealColumn get startWeightKg => real()();
  RealColumn get targetWeightKg => real()();
  DateTimeColumn get targetDate => dateTime().nullable()();
  RealColumn get bodyFatPercent => real().nullable()();
  TextColumn get occupation => text().nullable()();
  TextColumn get jobActivity => text()(); // JobActivity.name
  IntColumn get sportMinutesPerWeek => integer().withDefault(const Constant(0))();
  TextColumn get sportNote => text().nullable()();
  RealColumn get sleepHours => real().nullable()();
  TextColumn get dietStyle => text().nullable()();
  TextColumn get eatingHabits => text().nullable()();
  TextColumn get allergiesJson => text().withDefault(const Constant('[]'))();
  TextColumn get preferredFoodsJson => text().withDefault(const Constant('[]'))();
  TextColumn get dislikedFoodsJson => text().withDefault(const Constant('[]'))();
  IntColumn get calorieOverride => integer().nullable()();
  IntColumn get proteinOverrideG => integer().nullable()();
  RealColumn get proteinPerKg => real().withDefault(const Constant(1.8))();
  RealColumn get fatPercent => real().withDefault(const Constant(30))();

  /// Upper limit for carbohydrates in g (schema 4), e.g. low carb.
  RealColumn get carbCapG => real().nullable()();
  RealColumn get fiberTargetG => real().withDefault(const Constant(30))();
  IntColumn get waterOverrideMl => integer().nullable()();

  /// Share (0-100 %) of logged activity calories added to the day's budget.
  IntColumn get activityCreditPercent => integer().withDefault(const Constant(0))();
}

/// Meals of the day (1-6), with name and planned time.
class MealSlots extends Table with SyncColumns {
  TextColumn get name => text().withLength(min: 1, max: 40)();
  IntColumn get minuteOfDay => integer().nullable()();
  IntColumn get sortOrder => integer()();
}

/// Foods. Nutrients are per 100 g (unit "g") or per 100 ml (unit "ml").
@TableIndex(name: 'foods_key', columns: {#foodKey}, unique: true)
@TableIndex(name: 'foods_barcode', columns: {#barcode}, unique: true)
class Foods extends Table with SyncColumns {
  TextColumn get name => text().withLength(min: 1, max: 120)();
  TextColumn get brand => text().nullable()();

  /// Normalised name|brand. Unique among live rows (deleted rows get a suffix).
  TextColumn get foodKey => text()();
  TextColumn get barcode => text().nullable()();
  TextColumn get category => text().nullable()();
  TextColumn get unit => text().withDefault(const Constant('g'))();
  RealColumn get kcal => real()();
  RealColumn get protein => real()();
  RealColumn get carbs => real()();
  RealColumn get sugar => real().withDefault(const Constant(0))();
  RealColumn get fat => real()();
  RealColumn get saturatedFat => real().withDefault(const Constant(0))();
  RealColumn get fiber => real().withDefault(const Constant(0))();
  RealColumn get salt => real().withDefault(const Constant(0))();
  RealColumn get servingAmount => real().nullable()();
  TextColumn get servingLabel => text().nullable()();

  /// "base" = shipped reference values, "user" = created by the user.
  TextColumn get source => text().withDefault(const Constant('user'))();
  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();
}

/// A logged food. Name and nutrients are copied from the food at logging time, so
/// editing a food later never changes past days.
@TableIndex(name: 'diary_day', columns: {#dayKey})
class DiaryEntries extends Table with SyncColumns {
  TextColumn get dayKey => text()(); // yyyy-MM-dd, local date
  TextColumn get mealSlotId => text()();
  TextColumn get foodId => text().nullable()();
  TextColumn get foodName => text()();
  TextColumn get brand => text().nullable()();
  TextColumn get unit => text()();
  RealColumn get amount => real()();
  RealColumn get kcal100 => real()();
  RealColumn get protein100 => real()();
  RealColumn get carbs100 => real()();
  RealColumn get sugar100 => real()();
  RealColumn get fat100 => real()();
  RealColumn get saturatedFat100 => real()();
  RealColumn get fiber100 => real()();
  RealColumn get salt100 => real()();

  /// Set when the entry was logged from a recipe (schema 2). Values are still a copy.
  TextColumn get recipeId => text().nullable()();
}

/// One weight entry per day (unique), optional body fat and waist.
@TableIndex(name: 'weight_day', columns: {#dayKey}, unique: true)
class WeightEntries extends Table with SyncColumns {
  TextColumn get dayKey => text()();
  RealColumn get weightKg => real()();
  RealColumn get bodyFatPercent => real().nullable()();
  RealColumn get waistCm => real().nullable()();
  TextColumn get note => text().nullable()();
}

@TableIndex(name: 'water_day', columns: {#dayKey})
class WaterEntries extends Table with SyncColumns {
  TextColumn get dayKey => text()();
  IntColumn get ml => integer()();
}

/// Activities. Imported rows (later: Health Connect, Garmin) are unique per
/// source + externalId, so a re-import never counts an activity twice.
@TableIndex(name: 'activity_day', columns: {#dayKey})
@TableIndex(name: 'activity_ext', columns: {#source, #externalId}, unique: true)
class ActivityEntries extends Table with SyncColumns {
  TextColumn get dayKey => text()();
  TextColumn get label => text()();
  IntColumn get minutes => integer().withDefault(const Constant(0))();
  RealColumn get kcal => real().withDefault(const Constant(0))();
  IntColumn get steps => integer().nullable()();
  TextColumn get source => text().withDefault(const Constant('manual'))();
  TextColumn get externalId => text().nullable()();
}

/// Recipes (schema 2). Nutrients are computed from [RecipeItems].
@TableIndex(name: 'recipes_key', columns: {#nameKey}, unique: true)
class Recipes extends Table with SyncColumns {
  TextColumn get name => text().withLength(min: 1, max: 120)();

  /// Normalised name. Unique among live rows (deleted rows get a suffix).
  TextColumn get nameKey => text()();
  RealColumn get servings => real()();

  /// Weight of the finished dish in g, if weighed. Changes the values per 100 g.
  RealColumn get cookedWeightG => real().nullable()();
  IntColumn get prepMinutes => integer().nullable()();
  TextColumn get instructions => text().nullable()();
  TextColumn get tagsJson => text().withDefault(const Constant('[]'))();
  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();
}

/// Ingredients of a recipe with a copy of the food's values per 100, so a recipe
/// stays correct when a food is changed or deleted later.
@TableIndex(name: 'recipe_items_recipe', columns: {#recipeId})
class RecipeItems extends Table with SyncColumns {
  TextColumn get recipeId => text()();
  TextColumn get foodId => text().nullable()();
  TextColumn get foodName => text()();
  TextColumn get brand => text().nullable()();
  TextColumn get unit => text()();
  RealColumn get amount => real()();
  IntColumn get sortOrder => integer()();
  RealColumn get kcal100 => real()();
  RealColumn get protein100 => real()();
  RealColumn get carbs100 => real()();
  RealColumn get sugar100 => real()();
  RealColumn get fat100 => real()();
  RealColumn get saturatedFat100 => real()();
  RealColumn get fiber100 => real()();
  RealColumn get salt100 => real()();
}

/// Shopping list (schema 2). Lines with the same item key and unit are merged.
class ShoppingItems extends Table with SyncColumns {
  TextColumn get label => text().withLength(min: 1, max: 120)();

  /// foodId if known, else the normalised label. Used to merge lines.
  TextColumn get itemKey => text()();
  RealColumn get amount => real().nullable()();
  TextColumn get unit => text().nullable()();
  TextColumn get foodId => text().nullable()();
  TextColumn get category => text().nullable()();

  /// Names of the recipes this line came from, for display.
  TextColumn get fromRecipes => text().nullable()();
  BoolColumn get checked => boolean().withDefault(const Constant(false))();
}

/// Supplements (schema 3). One row per product; ingredients per serving in
/// [SupplementIngredients].
@TableIndex(name: 'supplements_key', columns: {#nameKey}, unique: true)
class Supplements extends Table with SyncColumns {
  TextColumn get name => text().withLength(min: 1, max: 120)();
  TextColumn get brand => text().nullable()();

  /// Normalised name|brand. Unique among live rows (deleted rows get a suffix).
  TextColumn get nameKey => text()();
  TextColumn get form => text().nullable()(); // Kapsel, Tablette, Pulver, Tropfen ...
  TextColumn get servingLabel => text().withDefault(const Constant('Portion'))();

  /// Manufacturer's recommendation as printed on the pack (free text, not a recommendation of the app).
  TextColumn get manufacturerDose => text().nullable()();
  RealColumn get servingsPerDay => real().withDefault(const Constant(1))();

  /// Planned intake times as JSON list of minutes after midnight.
  TextColumn get timesJson => text().withDefault(const Constant('[]'))();
  BoolColumn get active => boolean().withDefault(const Constant(true))();
  RealColumn get stockServings => real().nullable()();
  TextColumn get note => text().nullable()();
}

@TableIndex(name: 'supplement_ingredients_sup', columns: {#supplementId})
class SupplementIngredients extends Table with SyncColumns {
  TextColumn get supplementId => text()();

  /// Catalogue id (core/supplements.dart) or `custom:NAME`.
  TextColumn get nutrientId => text()();
  TextColumn get name => text().nullable()();
  RealColumn get amount => real()();
  TextColumn get unit => text()();
  IntColumn get sortOrder => integer()();
}

/// Taken supplements. One row per product, day and planned time (-1 = no fixed time).
@TableIndex(name: 'supplement_intake_slot', columns: {#supplementId, #dayKey, #plannedMinute}, unique: true)
@TableIndex(name: 'supplement_intake_day', columns: {#dayKey})
class SupplementIntakes extends Table with SyncColumns {
  TextColumn get supplementId => text()();
  TextColumn get dayKey => text()();
  IntColumn get plannedMinute => integer()();
  RealColumn get servings => real()();
}

/// Planned meals (schema 4). Values per 100 g/ml are copied like in the diary, so the
/// plan stays as planned when a food or recipe changes.
@TableIndex(name: 'meal_plan_day', columns: {#dayKey})
class MealPlanEntries extends Table with SyncColumns {
  TextColumn get dayKey => text()();
  TextColumn get mealSlotId => text()();
  TextColumn get foodId => text().nullable()();
  TextColumn get recipeId => text().nullable()();
  TextColumn get name => text()();
  TextColumn get unit => text()();
  RealColumn get amount => real()();
  RealColumn get kcal100 => real()();
  RealColumn get protein100 => real()();
  RealColumn get carbs100 => real()();
  RealColumn get sugar100 => real()();
  RealColumn get fat100 => real()();
  RealColumn get saturatedFat100 => real()();
  RealColumn get fiber100 => real()();
  RealColumn get salt100 => real()();

  /// Set when the planned entry was put into the diary.
  TextColumn get diaryEntryId => text().nullable()();
}

/// Fasting periods (schema 4). An open fast has no end.
class FastingSessions extends Table with SyncColumns {
  DateTimeColumn get startAt => dateTime()();
  DateTimeColumn get endAt => dateTime().nullable()();
  RealColumn get targetHours => real()();
}

/// App settings (theme, colours, dashboard layout, ...).
class Settings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}
