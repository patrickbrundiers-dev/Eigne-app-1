import 'dart:convert';

import '../core/health_import.dart';
import 'database.dart';
import 'health_source.dart';

const healthSettingsKey = 'healthConnect';

class HealthSettings {
  const HealthSettings({this.enabled = false, this.lastImport});
  final bool enabled;
  final DateTime? lastImport;

  static HealthSettings parse(String? json) {
    if (json == null || json.isEmpty) return const HealthSettings();
    try {
      final m = jsonDecode(json) as Map<String, dynamic>;
      return HealthSettings(
        enabled: m['enabled'] == true,
        lastImport: DateTime.tryParse(m['lastImport'] as String? ?? ''),
      );
    } catch (_) {
      return const HealthSettings();
    }
  }

  String toJson() => jsonEncode({'enabled': enabled, 'lastImport': ?lastImport?.toIso8601String()});
}

class HealthImportResult {
  const HealthImportResult({required this.activities, required this.weights});
  final int activities;
  final int weights;
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
  await db.setSetting(healthSettingsKey, HealthSettings(enabled: settings.enabled, lastImport: t).toJson());
  return HealthImportResult(activities: plan.activities.length, weights: plan.weights.length);
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
