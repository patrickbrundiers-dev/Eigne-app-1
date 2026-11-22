part of '../database.dart';

extension BodyDao on AppDatabase {
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

  /// Creates or updates an imported activity (Health Connect, later Garmin) by its external id.
  /// An entry the user deleted stays deleted; importing again does not bring it back.
  Future<void> upsertExternalActivity({
    required String externalId,
    required String day,
    required String label,
    required int minutes,
    required double kcal,
    int? steps,
    required String source,
  }) async {
    if (minutes < 0 || minutes > 1440 || kcal < 0 || kcal > 10000 || (steps != null && steps < 0)) {
      throw ArgumentError('Ungültige Aktivitätswerte.');
    }
    await transaction(() async {
      final existing = await (select(activityEntries)..where((a) => a.externalId.equals(externalId))).getSingleOrNull();
      if (existing == null) {
        await into(activityEntries).insert(
          ActivityEntriesCompanion.insert(
            dayKey: day,
            label: label,
            minutes: Value(minutes),
            kcal: Value(kcal),
            steps: Value(steps),
            source: Value(source),
            externalId: Value(externalId),
          ),
        );
        return;
      }
      if (existing.deletedAt != null) return;
      if (existing.dayKey == day &&
          existing.label == label &&
          existing.minutes == minutes &&
          existing.kcal == kcal &&
          existing.steps == steps) {
        return;
      }
      await (update(activityEntries)..where((a) => a.id.equals(existing.id))).write(
        ActivityEntriesCompanion(
          dayKey: Value(day),
          label: Value(label),
          minutes: Value(minutes),
          kcal: Value(kcal),
          steps: Value(steps),
          updatedAt: Value(DateTime.now()),
        ),
      );
    });
  }
}
