part of '../database.dart';

extension DiaryDao on AppDatabase {
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
        brand: const Value(AppDatabase.quickEntryBrand),
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
}
