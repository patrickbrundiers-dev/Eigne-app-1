/// Weight progress dashboard: start / current / goal, 7-day average, 30-day trend,
/// goal forecast, calorie balance and protein adherence of the last days.
///
/// Principles (see docs/BERECHNUNGEN.md, "Gewichts-Dashboard"):
/// - "Current weight" is always the 7-day average, never a single weigh-in.
/// - Trends come from a least-squares line, so one salty dinner does not move them.
/// - Every figure says how reliable it is ([Reliability]); with too little data the
///   app shows "–" instead of guessing.
/// - Today is never part of the nutrition figures, because it is usually not finished.
library;

import 'dart:math' as math;

import 'energy.dart' show kcalPerKg;
import 'weight_trend.dart';

/// Logged nutrition of one day (only energy and protein are needed here).
class DayLog {
  const DayLog(this.date, {required this.kcal, required this.protein});
  final DateTime date;
  final double kcal;
  final double protein;
}

/// How much a trend figure can be trusted, from the amount and span of data.
enum Reliability {
  /// Not enough data, the figure is not shown.
  none,

  /// Shown, but may still change noticeably.
  low,
  medium,
  high,
}

class WeightTrendWindow {
  const WeightTrendWindow({
    required this.days,
    required this.count,
    required this.spanDays,
    required this.weeklyRateKg,
    required this.changeKg,
    required this.fluctuationKg,
    required this.reliability,
  });

  /// Window length in days, ending at the latest weigh-in.
  final int days;

  /// Weigh-ins inside the window.
  final int count;

  /// Days between the first and the last weigh-in in the window.
  final int spanDays;

  /// Slope of the least-squares line in kg/week; null with too little data.
  final double? weeklyRateKg;

  /// Change along the line over the covered span (not last minus first value).
  final double? changeKg;

  /// Typical deviation of single weigh-ins from the line (standard deviation, kg).
  /// Shows how much a single day may differ without meaning anything.
  final double? fluctuationKg;
  final Reliability reliability;
}

class NutritionWindow {
  const NutritionWindow({
    required this.days,
    required this.loggedDays,
    required this.averageKcal,
    required this.averageProteinG,
    required this.targetKcal,
    required this.proteinTargetG,
    required this.proteinHitDays,
    required this.balanceVsTargetKcal,
    required this.balanceVsTdeeKcal,
    required this.expectedWeeklyChangeKg,
  });

  /// Calendar days looked at (ending yesterday).
  final int days;

  /// Days with at least [minLoggedDayKcal]; only those enter the averages.
  final int loggedDays;
  final double? averageKcal;
  final double? averageProteinG;
  final int targetKcal;
  final double proteinTargetG;

  /// Logged days with protein ≥ [proteinHitShare] of the target.
  final int proteinHitDays;

  /// Average intake minus target (negative = below target).
  final double? balanceVsTargetKcal;

  /// Average intake minus estimated expenditure (negative = deficit).
  final double? balanceVsTdeeKcal;

  /// Weight change per week that this balance would explain (balance × 7 / 7700).
  final double? expectedWeeklyChangeKg;

  double get proteinHitShare => loggedDays == 0 ? 0 : proteinHitDays / loggedDays;
}

class WeightProgress {
  const WeightProgress({
    required this.startKg,
    required this.startDate,
    required this.targetKg,
    required this.currentKg,
    required this.latest,
    required this.average7Kg,
    required this.previousAverage7Kg,
    required this.trend30,
    required this.forecastDate,
    required this.forecastReliability,
    required this.nutrition,
  });

  final double startKg;

  /// Date of the first weigh-in, or null without any.
  final DateTime? startDate;
  final double targetKg;

  /// 7-day average, else latest weigh-in, else start weight.
  final double currentKg;
  final WeightPoint? latest;
  final double? average7Kg;

  /// 7-day average of the week before (days 8–14 before the latest weigh-in).
  final double? previousAverage7Kg;
  final WeightTrendWindow trend30;
  final DateTime? forecastDate;
  final Reliability forecastReliability;
  final NutritionWindow? nutrition;

  /// Positive when moving towards the goal direction from the start: for weight loss
  /// this is the lost weight, for weight gain the gained weight.
  double get changeSinceStartKg => currentKg - startKg;

  /// Absolute distance to the goal (0 when reached or passed).
  double get remainingKg {
    final losing = targetKg < startKg;
    final r = losing ? currentKg - targetKg : targetKg - currentKg;
    return r < 0 ? 0 : r;
  }

  bool get goalIsLoss => targetKg < startKg;
  bool get goalReached => (targetKg - startKg).abs() >= 0.1 && remainingKg < 0.05;

  /// 0..1 progress from start to goal.
  double get progress => goalProgress(startKg: startKg, currentKg: currentKg, targetKg: targetKg);

  /// Change of the 7-day average against the week before.
  double? get weekOverWeekKg =>
      average7Kg == null || previousAverage7Kg == null ? null : average7Kg! - previousAverage7Kg!;
}

/// A day counts as logged from this energy on (a single snack is not a day).
const double minLoggedDayKcal = 800;

/// Protein target counts as reached from this share on (rounding, scale tolerance).
const double proteinHitShare = 0.9;

DateTime _d(DateTime x) => DateTime(x.year, x.month, x.day);

int _days(DateTime a, DateTime b) =>
    DateTime.utc(b.year, b.month, b.day).difference(DateTime.utc(a.year, a.month, a.day)).inDays;

Reliability reliabilityFor({required int count, required int spanDays}) {
  if (count < 4 || spanDays < 10) return Reliability.none;
  if (count < 8 || spanDays < 14) return Reliability.low;
  if (count < 14 || spanDays < 21) return Reliability.medium;
  return Reliability.high;
}

/// Trend over the last [days] days up to the latest weigh-in.
WeightTrendWindow trendWindow(List<WeightPoint> sorted, {int days = 30}) {
  if (sorted.isEmpty) {
    return WeightTrendWindow(
      days: days,
      count: 0,
      spanDays: 0,
      weeklyRateKg: null,
      changeKg: null,
      fluctuationKg: null,
      reliability: Reliability.none,
    );
  }
  final end = _d(sorted.last.date);
  final start = DateTime(end.year, end.month, end.day - (days - 1));
  final w = sorted.where((p) => !_d(p.date).isBefore(start)).toList();
  final span = _days(w.first.date, end);
  final slope = regressionSlopePerDay(w);
  double? fluct;
  if (slope != null) {
    // Residuals around the regression line through the means.
    final t0 = _d(w.first.date);
    final xs = [for (final p in w) _days(t0, p.date).toDouble()];
    final mx = xs.reduce((a, b) => a + b) / w.length;
    final my = w.map((p) => p.kg).reduce((a, b) => a + b) / w.length;
    var ss = 0.0;
    for (var i = 0; i < w.length; i++) {
      final r = w[i].kg - (my + slope * (xs[i] - mx));
      ss += r * r;
    }
    fluct = math.sqrt(ss / math.max(1, w.length - 2));
  }
  return WeightTrendWindow(
    days: days,
    count: w.length,
    spanDays: span,
    weeklyRateKg: slope == null ? null : slope * 7,
    changeKg: slope == null ? null : slope * span,
    fluctuationKg: fluct,
    reliability: slope == null ? Reliability.none : reliabilityFor(count: w.length, spanDays: span),
  );
}

/// Nutrition of the [days] days before [today] (today excluded).
NutritionWindow? nutritionWindow({
  required DateTime today,
  required List<DayLog> logs,
  required int targetKcal,
  required double proteinTargetG,
  required double tdeeKcal,
  int days = 7,
}) {
  final t = _d(today);
  final from = DateTime(t.year, t.month, t.day - days);
  final inWindow = logs.where((l) {
    final d = _d(l.date);
    return !d.isBefore(from) && d.isBefore(t) && l.kcal >= minLoggedDayKcal;
  }).toList();
  final n = inWindow.length;
  final avgKcal = n == 0 ? null : inWindow.map((l) => l.kcal).reduce((a, b) => a + b) / n;
  final avgProt = n == 0 ? null : inWindow.map((l) => l.protein).reduce((a, b) => a + b) / n;
  final hits = proteinTargetG <= 0 ? 0 : inWindow.where((l) => l.protein >= proteinTargetG * proteinHitShare).length;
  final vsTdee = avgKcal == null ? null : avgKcal - tdeeKcal;
  return NutritionWindow(
    days: days,
    loggedDays: n,
    averageKcal: avgKcal,
    averageProteinG: avgProt,
    targetKcal: targetKcal,
    proteinTargetG: proteinTargetG,
    proteinHitDays: hits,
    balanceVsTargetKcal: avgKcal == null ? null : avgKcal - targetKcal,
    balanceVsTdeeKcal: vsTdee,
    expectedWeeklyChangeKg: vsTdee == null ? null : vsTdee * 7 / kcalPerKg,
  );
}

WeightProgress computeWeightProgress({
  required Iterable<WeightPoint> points,
  required double startKg,
  required double targetKg,
  DateTime? today,
  List<DayLog> logs = const [],
  int? targetKcal,
  double? proteinTargetG,
  double? tdeeKcal,
}) {
  final sorted = sortPoints(points);
  final a = analyzeWeight(sorted, targetKg: targetKg);
  final now = _d(today ?? DateTime.now());
  double? prev;
  if (sorted.isNotEmpty) {
    final end = _d(sorted.last.date);
    prev = trailingAverage(sorted, DateTime(end.year, end.month, end.day - 7));
  }
  final t30 = trendWindow(sorted);
  // The forecast in analyzeWeight uses the 28-day line; its reliability follows the
  // same data, and it is withheld entirely when the data are too thin.
  final t28 = trendWindow(sorted, days: 28);
  final forecastRel = a.forecastDate == null ? Reliability.none : t28.reliability;
  return WeightProgress(
    startKg: startKg,
    startDate: sorted.isEmpty ? null : sorted.first.date,
    targetKg: targetKg,
    currentKg: a.trendKg ?? a.latest?.kg ?? startKg,
    latest: a.latest,
    average7Kg: a.trendKg,
    previousAverage7Kg: prev,
    trend30: t30,
    forecastDate: forecastRel == Reliability.none ? null : a.forecastDate,
    forecastReliability: forecastRel,
    nutrition: targetKcal == null || proteinTargetG == null || tdeeKcal == null
        ? null
        : nutritionWindow(
            today: now,
            logs: logs,
            targetKcal: targetKcal,
            proteinTargetG: proteinTargetG,
            tdeeKcal: tdeeKcal,
          ),
  );
}

/// Short explanation of what a trend's reliability means for the user.
String reliabilityText(Reliability r) => switch (r) {
  Reliability.none => 'zu wenige Messungen',
  Reliability.low => 'Aussagekraft gering',
  Reliability.medium => 'Aussagekraft mittel',
  Reliability.high => 'Aussagekraft gut',
};

/// How the measured weight trend relates to what the logged balance would explain.
enum BalanceCheck {
  /// Within ±[balanceTolerancePerWeekKg]: logging and expenditure estimate look consistent.
  matches,

  /// The scale trend is higher than expected: intake missing from the diary, estimated
  /// portions, water, or a lower expenditure than the formula assumes.
  scaleHigher,

  /// The scale trend is lower than expected: expenditure probably higher than estimated.
  scaleLower,
}

const double balanceTolerancePerWeekKg = 0.3;

BalanceCheck checkBalance({required double expectedWeeklyKg, required double measuredWeeklyKg}) {
  final diff = measuredWeeklyKg - expectedWeeklyKg;
  if (diff.abs() < balanceTolerancePerWeekKg) return BalanceCheck.matches;
  return diff > 0 ? BalanceCheck.scaleHigher : BalanceCheck.scaleLower;
}
