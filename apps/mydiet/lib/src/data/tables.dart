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

/// App settings (theme, colours, dashboard layout, ...).
class Settings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}
