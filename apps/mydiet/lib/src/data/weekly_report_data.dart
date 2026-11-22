import '../core/dates.dart';
import '../core/daily_hints.dart' show proteinIdeas;
import '../core/weekly_report.dart';
import '../core/weight_progress.dart' show minLoggedDayKcal;
import 'database.dart';
import 'targets.dart';

/// Collects everything the weekly report needs for the week starting on [monday]
/// (the week before is read for the comparison). Returns null without a profile.
Future<WeeklyReport?> loadWeeklyReport(AppDatabase db, DateTime monday) async {
  final p = await db.getProfile();
  if (p == null) return null;
  final mon = DateTime(monday.year, monday.month, monday.day);
  final sun = DateTime(mon.year, mon.month, mon.day + 6);
  final weights = await db.watchWeights().first;
  final targets = targetsFor(p, weights, today: sun);
  final totals = await db.dailyTotals(dayKey(DateTime(mon.year, mon.month, mon.day - 7)), dayKey(sun));
  final days = [
    for (final e in totals.entries)
      ReportDay(parseDayKey(e.key), kcal: e.value.kcal, protein: e.value.protein, fiber: e.value.fiber),
  ];

  // Average share of the target per nutrient over the logged days of the week.
  final sums = <String, ({String name, double sum, int n})>{};
  for (final d in days) {
    if (d.date.isBefore(mon) || d.date.isAfter(sun) || d.kcal < minLoggedDayKcal) continue;
    final m = await db.microDay(dayKey(d.date));
    if (m.entriesWithData == 0) continue;
    for (final r in m.rows) {
      final pct = r.targetPercent;
      if (pct == null) continue;
      final s = sums[r.info.id];
      sums[r.info.id] = (name: r.info.name, sum: (s?.sum ?? 0) + pct, n: (s?.n ?? 0) + 1);
    }
  }
  final micros = [
    for (final s in sums.values)
      if (s.n >= 2) ReportMicro(name: s.name, targetPercent: s.sum / s.n),
  ];

  final points = weightPoints(weights);
  final current = points.isEmpty ? p.startWeightKg : points.last.kg;
  return buildWeeklyReport(
    monday: mon,
    days: days,
    targetKcal: targets.targetKcal,
    proteinTargetG: targets.proteinG.toDouble(),
    fiberTargetG: targets.fiberG.toDouble(),
    weights: points,
    micros: micros,
    goal: goalFrom(currentKg: current, targetKg: p.targetWeightKg),
    proteinIdeas: proteinIdeas(dietStyle: p.dietStyle, avoid: [...p.allergies, ...p.dislikedFoods]),
  );
}

/// The week to show by default: the last finished week (Monday to Sunday), or the current
/// one from Sunday on.
DateTime defaultReportMonday(DateTime now) {
  final d = DateTime(now.year, now.month, now.day);
  final thisMonday = DateTime(d.year, d.month, d.day - (d.weekday - 1));
  return d.weekday == DateTime.sunday ? thisMonday : DateTime(thisMonday.year, thisMonday.month, thisMonday.day - 7);
}
