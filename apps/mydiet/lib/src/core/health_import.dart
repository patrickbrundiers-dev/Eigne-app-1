/// Turning Health Connect records into diary activity and weight (ROADMAP Phase 4, queue 6.1).
/// Pure Dart, unit tested; the platform access is in `data/health_source.dart`.
///
/// Rules (see docs/BERECHNUNGEN.md, "Health Connect"):
/// - Each workout becomes one activity entry (label, minutes, calories).
/// - Per day there is one entry "Alltag" with the steps and the active calories that are not
///   already part of a workout, so nothing is counted twice.
/// - Entries carry an external id; importing again updates them instead of adding new ones.
/// - A weight from Health Connect is only taken for days without an own weight entry.
library;

import 'dates.dart';

/// One workout as read from Health Connect.
class HealthWorkout {
  const HealthWorkout({
    required this.id,
    required this.type,
    required this.start,
    required this.end,
    this.kcal,
    this.sourceName,
  });

  /// Health Connect record id.
  final String id;

  /// Activity type name as used by Health Connect / the health plugin ("RUNNING", "BIKING" …).
  final String type;
  final DateTime start;
  final DateTime end;
  final double? kcal;
  final String? sourceName;
}

/// A value with a time range (active calories) or a point in time (weight).
class HealthValueSample {
  const HealthValueSample(this.start, this.end, this.value);
  final DateTime start;
  final DateTime end;
  final double value;
}

/// What was read for a range of days.
class HealthRead {
  const HealthRead({
    this.stepsByDay = const {},
    this.activeKcal = const [],
    this.workouts = const [],
    this.weights = const [],
  });

  /// dayKey → steps of that day (Health Connect aggregates across sources without duplicates).
  final Map<String, int> stepsByDay;
  final List<HealthValueSample> activeKcal;
  final List<HealthWorkout> workouts;
  final List<HealthValueSample> weights;
}

/// An activity entry to create or update.
class ImportedActivity {
  const ImportedActivity({
    required this.externalId,
    required this.day,
    required this.label,
    required this.minutes,
    required this.kcal,
    this.steps,
  });
  final String externalId;
  final String day;
  final String label;
  final int minutes;
  final double kcal;
  final int? steps;

  @override
  String toString() => 'ImportedActivity($externalId, $day, $label, $minutes min, $kcal kcal, $steps steps)';
}

class HealthImportPlan {
  const HealthImportPlan({required this.activities, required this.weights});
  final List<ImportedActivity> activities;

  /// dayKey → kg, only days without an own entry.
  final Map<String, double> weights;
}

const healthSourceTag = 'health_connect';
const dailyActivityLabel = 'Alltag (Health Connect)';

/// German names for common workout types; others are shown as "Training".
const workoutLabels = <String, String>{
  'RUNNING': 'Laufen',
  'RUNNING_TREADMILL': 'Laufband',
  'WALKING': 'Gehen',
  'HIKING': 'Wandern',
  'BIKING': 'Radfahren',
  'BIKING_STATIONARY': 'Ergometer',
  'SWIMMING_POOL': 'Schwimmen',
  'SWIMMING_OPEN_WATER': 'Freiwasserschwimmen',
  'STRENGTH_TRAINING': 'Krafttraining',
  'WEIGHTLIFTING': 'Gewichtheben',
  'YOGA': 'Yoga',
  'PILATES': 'Pilates',
  'HIGH_INTENSITY_INTERVAL_TRAINING': 'HIIT',
  'ELLIPTICAL': 'Crosstrainer',
  'ROWING_MACHINE': 'Rudergerät',
  'ROWING': 'Rudern',
  'DANCING': 'Tanzen',
  'SOCCER': 'Fußball',
  'TENNIS': 'Tennis',
  'BADMINTON': 'Badminton',
  'BASKETBALL': 'Basketball',
  'VOLLEYBALL': 'Volleyball',
  'SKIING': 'Skifahren',
  'SNOWBOARDING': 'Snowboarden',
  'STAIR_CLIMBING': 'Treppensteigen',
  'MARTIAL_ARTS': 'Kampfsport',
  'GOLF': 'Golf',
  'CALISTHENICS': 'Eigengewichtstraining',
};

String workoutLabel(String type) => workoutLabels[type.toUpperCase()] ?? 'Training';

/// Builds the entries for the days in [days] (dayKeys). [ownWeightDays] are days that already
/// have a weight the user entered; those are never overwritten.
HealthImportPlan planHealthImport(HealthRead read, {required Set<String> days, Set<String> ownWeightDays = const {}}) {
  final activities = <ImportedActivity>[];
  final workoutKcal = <String, double>{};
  for (final w in read.workouts) {
    final day = dayKey(w.start);
    if (!days.contains(day)) continue;
    final minutes = w.end.difference(w.start).inMinutes.clamp(0, 1440);
    final kcal = (w.kcal ?? 0).clamp(0, 10000).toDouble();
    workoutKcal[day] = (workoutKcal[day] ?? 0) + kcal;
    activities.add(
      ImportedActivity(
        externalId: 'hc:${w.id}',
        day: day,
        label: '${workoutLabel(w.type)} (Health Connect)',
        minutes: minutes,
        kcal: kcal.roundToDouble(),
      ),
    );
  }

  // Active calories per day; a sample that spans midnight counts for the day it starts.
  final active = <String, double>{};
  for (final s in read.activeKcal) {
    final day = dayKey(s.start);
    if (!days.contains(day) || !(s.value > 0) || !s.value.isFinite) continue;
    active[day] = (active[day] ?? 0) + s.value;
  }

  for (final day in days.toList()..sort()) {
    final steps = read.stepsByDay[day];
    final rest = ((active[day] ?? 0) - (workoutKcal[day] ?? 0)).clamp(0, 10000).toDouble();
    if ((steps == null || steps <= 0) && rest < 1) continue;
    activities.add(
      ImportedActivity(
        externalId: 'hc-day:$day',
        day: day,
        label: dailyActivityLabel,
        minutes: 0,
        kcal: rest.roundToDouble(),
        steps: steps != null && steps > 0 ? steps : null,
      ),
    );
  }

  // Weight: the latest reading of each day, plausible values only.
  final latest = <String, HealthValueSample>{};
  for (final w in read.weights) {
    final day = dayKey(w.start);
    if (!days.contains(day) || ownWeightDays.contains(day)) continue;
    if (!(w.value >= 25 && w.value <= 400)) continue;
    final prev = latest[day];
    if (prev == null || w.start.isAfter(prev.start)) latest[day] = w;
  }
  return HealthImportPlan(
    activities: activities,
    weights: {for (final e in latest.entries) e.key: (e.value.value * 10).round() / 10},
  );
}

/// The days to read: the last [count] days up to and including [today].
Set<String> lastDays(DateTime today, int count) => {
  for (var i = 0; i < count; i++) dayKey(DateTime(today.year, today.month, today.day - i)),
};
