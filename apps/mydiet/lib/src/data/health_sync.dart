import 'dart:convert';

import '../core/health_export.dart';
import '../core/health_import.dart';
import '../core/nutrition.dart';
import 'database.dart';
import 'health_source.dart';

const healthSettingsKey = 'healthConnect';

class HealthSettings {
  const HealthSettings({this.enabled = false, this.lastImport, this.writeNutrition = false});
  final bool enabled;
  final DateTime? lastImport;

  /// Also write the diary's meals to Health Connect.
  final bool writeNutrition;

  HealthSettings copyWith({bool? enabled, DateTime? lastImport, bool? writeNutrition}) => HealthSettings(
    enabled: enabled ?? this.enabled,
    lastImport: lastImport ?? this.lastImport,
    writeNutrition: writeNutrition ?? this.writeNutrition,
  );

  static HealthSettings parse(String? json) {
    if (json == null || json.isEmpty) return const HealthSettings();
    try {
      final m = jsonDecode(json) as Map<String, dynamic>;
      return HealthSettings(
        enabled: m['enabled'] == true,
        lastImport: DateTime.tryParse(m['lastImport'] as String? ?? ''),
        writeNutrition: m['writeNutrition'] == true,
      );
    } catch (_) {
      return const HealthSettings();
    }
  }

  String toJson() => jsonEncode({
    'enabled': enabled,
    'lastImport': ?lastImport?.toIso8601String(),
    if (writeNutrition) 'writeNutrition': true,
  });
}

class HealthImportResult {
  const HealthImportResult({required this.activities, required this.weights, this.mealsWritten});
  final int activities;
  final int weights;

  /// Meals written to Health Connect, null when writing is off or not permitted.
  final int? mealsWritten;
}

/// Reads the last [days] days (today included) and stores them. Safe to run repeatedly.
Future<HealthImportResult> importHealth(AppDatabase db, HealthSource source, {int days = 7, DateTime? now}) async {
  final t = now ?? DateTime.now();
  final from = DateTime(t.year, t.month, t.day - (days - 1));
  final read = await source.read(from, t);
  final range = lastDays(t, days);
  final own = {
    for (final w in await db.watchWeights().first)
      if (range.contains(w.dayKey)) w.dayKey,
  };
  final plan = planHealthImport(read, days: range, ownWeightDays: own);
  for (final a in plan.activities) {
    await db.upsertExternalActivity(
      externalId: a.externalId,
      day: a.day,
      label: a.label,
      minutes: a.minutes,
      kcal: a.kcal,
      steps: a.steps,
      source: healthSourceTag,
    );
  }
  for (final e in plan.weights.entries) {
    await db.saveWeight(day: e.key, weightKg: e.value, note: 'aus Health Connect');
  }
  final settings = HealthSettings.parse(await db.getSetting(healthSettingsKey));
  int? written;
  if (settings.writeNutrition && await source.hasWritePermission()) {
    written = await exportNutrition(db, source, days: days.clamp(1, 7), now: t);
  }
  await db.setSetting(healthSettingsKey, settings.copyWith(lastImport: t).toJson());
  return HealthImportResult(activities: plan.activities.length, weights: plan.weights.length, mealsWritten: written);
}

/// Writes the meals of the last [days] days (today included) to Health Connect, replacing what
/// was written before. Returns the number of meals written.
Future<int> exportNutrition(AppDatabase db, HealthSource source, {int days = 7, DateTime? now}) async {
  final t = now ?? DateTime.now();
  final slots = [for (final s in await db.watchMealSlots().first) (id: s.id, name: s.name, minuteOfDay: s.minuteOfDay)];
  var count = 0;
  for (final day in lastDays(t, days).toList()..sort()) {
    final totals = <String, Nutrients>{};
    for (final e in await db.diaryForDay(day)) {
      totals[e.mealSlotId] = (totals[e.mealSlotId] ?? Nutrients.zero) + e.nutrients;
    }
    final meals = planNutritionExport(day: day, slots: slots, totalsBySlot: totals);
    await source.writeDay(day, meals);
    count += meals.length;
  }
  return count;
}

/// At app start: import once every few hours when switched on. Errors are swallowed (logged
/// without health data), the app works without it.
Future<void> autoImportHealth(AppDatabase db, {DateTime? now}) async {
  final s = HealthSettings.parse(await db.getSetting(healthSettingsKey));
  final t = now ?? DateTime.now();
  if (!s.enabled) return;
  if (s.lastImport != null && t.difference(s.lastImport!) < const Duration(hours: 3)) return;
  try {
    final src = healthSourceFactory();
    if (await src.availability() != HealthAvailability.available || !await src.hasPermissions()) return;
    await importHealth(db, src, now: t, days: s.lastImport == null ? 30 : 7);
  } catch (_) {
    // Health Connect not reachable: try again next start.
  }
}
