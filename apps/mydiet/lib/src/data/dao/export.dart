part of '../database.dart';

extension ExportDao on AppDatabase {
  // ---------------------------------------------------------------- export / import

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
    foodMicronutrients,
  ];

  /// All data, including tombstones, as JSON.
  Future<String> exportJson() async {
    final data = <String, dynamic>{
      'format': AppDatabase.exportFormat,
      'version': AppDatabase.exportVersion,
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
    if (decoded is! Map<String, dynamic> || decoded['format'] != AppDatabase.exportFormat) {
      throw const FormatException('Das ist keine MyDiet-Exportdatei.');
    }
    if ((decoded['version'] as int? ?? 0) > AppDatabase.exportVersion) {
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

  Future<void> _insertDefaultSlots() => batch((b) {
    for (var i = 0; i < _defaultSlots.length; i++) {
      b.insert(
        mealSlots,
        MealSlotsCompanion.insert(name: _defaultSlots[i].$1, minuteOfDay: Value(_defaultSlots[i].$2), sortOrder: i),
      );
    }
  });

  /// Erases every row of every table for good (no tombstones, right to erasure) and
  /// returns the database to the state of a fresh install: default meals and the
  /// shipped reference foods. One transaction: on an error nothing is deleted.
  /// Returns the number of deleted rows per table.
  Future<Map<String, int>> deleteAllData() async {
    final counts = <String, int>{};
    await transaction(() async {
      for (final t in allTables.toList().reversed) {
        counts[t.actualTableName] = await customUpdate(
          'DELETE FROM ${t.actualTableName}',
          updates: {t},
          updateKind: UpdateKind.delete,
        );
      }
      await _insertDefaultSlots();
      await seedReferenceFoods();
      await seedReferenceMicros();
    });
    return counts;
  }
}
