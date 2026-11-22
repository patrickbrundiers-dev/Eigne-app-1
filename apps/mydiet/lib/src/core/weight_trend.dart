/// Weight analysis: smoothed trend, weekly rate, plateau detection, forecast.
///
/// Single weigh-ins fluctuate by 1-2 kg (water, salt, digestion). The app therefore
/// never reacts to one value: rate and plateau come from a least-squares line over
/// several weeks, and the "trend weight" is a 7-day average.
library;

class WeightPoint {
  const WeightPoint(this.date, this.kg);
  final DateTime date;
  final double kg;
}

class PeriodAverage {
  const PeriodAverage(this.start, this.averageKg, this.count);
  final DateTime start;
  final double averageKg;
  final int count;
}

class WeightAnalysis {
  const WeightAnalysis({
    required this.latest,
    required this.trendKg,
    required this.weeklyRateKg,
    required this.isPlateau,
    required this.forecastDate,
    required this.rateBasisDays,
  });

  final WeightPoint? latest;

  /// Average of the entries in the 7 days up to the latest entry.
  final double? trendKg;

  /// kg per week from linear regression over the last 28 days; null if too little data.
  final double? weeklyRateKg;
  final int rateBasisDays;

  /// True when the goal is weight loss/gain and the last >= 14 days show < 0.1 kg/week change.
  final bool isPlateau;
  final DateTime? forecastDate;
}

DateTime _d(DateTime x) => DateTime(x.year, x.month, x.day);

int _days(DateTime a, DateTime b) =>
    DateTime.utc(b.year, b.month, b.day).difference(DateTime.utc(a.year, a.month, a.day)).inDays;

/// Sorted ascending by date; one entry per day is assumed (the database enforces it).
List<WeightPoint> sortPoints(Iterable<WeightPoint> pts) => pts.toList()..sort((a, b) => a.date.compareTo(b.date));

double? trailingAverage(List<WeightPoint> sorted, DateTime upTo, {int days = 7}) {
  final end = _d(upTo);
  final start = DateTime(end.year, end.month, end.day - (days - 1));
  final window = sorted.where((p) => !_d(p.date).isBefore(start) && !_d(p.date).isAfter(end));
  if (window.isEmpty) return null;
  return window.map((p) => p.kg).reduce((a, b) => a + b) / window.length;
}

/// Slope in kg/day of a least-squares line, or null with fewer than [minPoints]
/// points or a time span shorter than [minSpanDays].
double? regressionSlopePerDay(List<WeightPoint> pts, {int minPoints = 4, int minSpanDays = 10}) {
  if (pts.length < minPoints) return null;
  final t0 = _d(pts.first.date);
  final xs = pts.map((p) => _days(t0, p.date).toDouble()).toList();
  if (xs.last - xs.first < minSpanDays) return null;
  final ys = pts.map((p) => p.kg).toList();
  final n = pts.length;
  final mx = xs.reduce((a, b) => a + b) / n;
  final my = ys.reduce((a, b) => a + b) / n;
  var num = 0.0, den = 0.0;
  for (var i = 0; i < n; i++) {
    num += (xs[i] - mx) * (ys[i] - my);
    den += (xs[i] - mx) * (xs[i] - mx);
  }
  if (den == 0) return null;
  return num / den;
}

WeightAnalysis analyzeWeight(Iterable<WeightPoint> points, {double? targetKg}) {
  final sorted = sortPoints(points);
  if (sorted.isEmpty) {
    return const WeightAnalysis(
      latest: null,
      trendKg: null,
      weeklyRateKg: null,
      isPlateau: false,
      forecastDate: null,
      rateBasisDays: 0,
    );
  }
  final latest = sorted.last;
  final end = _d(latest.date);
  final trend = trailingAverage(sorted, end);

  final last28 = sorted.where((p) => !_d(p.date).isBefore(DateTime(end.year, end.month, end.day - 27))).toList();
  final slope = regressionSlopePerDay(last28);
  final weekly = slope == null ? null : slope * 7;
  final basis = last28.isEmpty ? 0 : _days(last28.first.date, end);

  var plateau = false;
  if (targetKg != null && trend != null && (targetKg - trend).abs() > 1) {
    final last21 = sorted.where((p) => !_d(p.date).isBefore(DateTime(end.year, end.month, end.day - 20))).toList();
    final s21 = regressionSlopePerDay(last21, minPoints: 6, minSpanDays: 14);
    if (s21 != null && (s21 * 7).abs() < 0.1) plateau = true;
  }

  DateTime? forecast;
  if (targetKg != null && trend != null && slope != null && slope != 0) {
    final remaining = targetKg - trend;
    if (remaining.abs() < 0.1) {
      forecast = end;
    } else if ((remaining < 0) == (slope < 0)) {
      final days = (remaining / slope).ceil();
      if (days <= 3650) forecast = DateTime(end.year, end.month, end.day + days);
    }
  }

  return WeightAnalysis(
    latest: latest,
    trendKg: trend,
    weeklyRateKg: weekly,
    isPlateau: plateau,
    forecastDate: forecast,
    rateBasisDays: basis,
  );
}

/// Monday of the ISO week containing [d].
DateTime weekStart(DateTime d) => DateTime(d.year, d.month, d.day - (d.weekday - 1));

List<PeriodAverage> weeklyAverages(Iterable<WeightPoint> pts) => _group(pts, weekStart);

List<PeriodAverage> monthlyAverages(Iterable<WeightPoint> pts) => _group(pts, (d) => DateTime(d.year, d.month));

List<PeriodAverage> _group(Iterable<WeightPoint> pts, DateTime Function(DateTime) key) {
  final m = <DateTime, List<double>>{};
  for (final p in pts) {
    m.putIfAbsent(key(p.date), () => []).add(p.kg);
  }
  final keys = m.keys.toList()..sort((a, b) => b.compareTo(a));
  return [for (final k in keys) PeriodAverage(k, m[k]!.reduce((a, b) => a + b) / m[k]!.length, m[k]!.length)];
}

/// Goal progress 0..1 from start weight to target weight.
double goalProgress({required double startKg, required double currentKg, required double targetKg}) {
  final total = startKg - targetKg;
  if (total.abs() < 0.01) return 1;
  return ((startKg - currentKg) / total).clamp(0.0, 1.0);
}
