/// Adaptive calorie target ("Wochen-Check").
///
/// Formulas for the basal metabolic rate and the activity factor are estimates and
/// can be off by several hundred kcal per person. Once enough real data exists, the
/// actual expenditure follows from energy balance:
///
///   expenditure ≈ average intake − (weight change per day × 7700 kcal/kg)
///
/// The weight change comes from a least-squares line over the window (not from two
/// single weigh-ins), and days that were obviously not logged completely are left
/// out so they cannot make the expenditure look lower than it is.
///
/// The result is only a suggestion. It is applied after the user confirms it.
library;

import 'dart:math' as math;

import 'energy.dart' show CalcStep, kcalPerKg;
import 'weight_trend.dart';

/// Logged energy of one day.
class DayIntake {
  const DayIntake(this.date, this.kcal);
  final DateTime date;
  final double kcal;
}

class AdaptiveInput {
  const AdaptiveInput({
    required this.today,
    required this.intakes,
    required this.weights,
    required this.formulaTdee,
    required this.desiredDailyDeltaKcal,
    required this.currentTargetKcal,
    required this.floorKcal,
    this.windowDays = 28,
  });

  /// Today is never counted, because it is usually not finished yet.
  final DateTime today;
  final List<DayIntake> intakes;
  final List<WeightPoint> weights;

  /// Expenditure estimated by the formula (BMR × PAL), used for comparison.
  final double formulaTdee;

  /// Planned daily balance from the goal (negative = deficit), as in the energy calculation.
  final double desiredDailyDeltaKcal;
  final int currentTargetKcal;

  /// Lowest target the app ever suggests (1500 men / 1200 women).
  final double floorKcal;
  final int windowDays;
}

enum AdaptiveStatus {
  /// Enough data, a suggestion was computed.
  ready,

  /// Too few completely logged days.
  notEnoughIntake,

  /// Too few weigh-ins or too short a time span.
  notEnoughWeights,
}

class AdaptiveResult {
  const AdaptiveResult({
    required this.status,
    required this.windowStart,
    required this.windowEnd,
    required this.countedDays,
    required this.excludedDays,
    required this.weightCount,
    this.averageIntakeKcal,
    this.weeklyWeightChangeKg,
    this.observedTdee,
    this.suggestedTargetKcal,
    this.steps = const [],
    this.notes = const [],
  });

  final AdaptiveStatus status;
  final DateTime windowStart;
  final DateTime windowEnd;

  /// Days that entered the average.
  final int countedDays;

  /// Days with entries that were left out as incomplete.
  final int excludedDays;
  final int weightCount;
  final double? averageIntakeKcal;
  final double? weeklyWeightChangeKg;
  final double? observedTdee;
  final int? suggestedTargetKcal;
  final List<CalcStep> steps;
  final List<String> notes;

  bool get isReady => status == AdaptiveStatus.ready;

  /// Difference between suggestion and the target in use.
  int changeFrom(int currentTarget) => (suggestedTargetKcal ?? currentTarget) - currentTarget;
}

/// Minimum number of completely logged days in the window.
const int minCountedDays = 14;

/// Minimum number of weigh-ins and their time span in the window.
const int minWeightCount = 6;
const int minWeightSpanDays = 14;

/// A day counts as incomplete below this share of the median logged day.
const double incompleteShare = 0.6;

/// Absolute lower bound for a day to count (a single snack is not a day).
const double minDayKcal = 800;

/// The suggestion moves the target by at most this much at once, so one unusual
/// period cannot cause a jump. Repeated checks converge to the real value.
const int maxStepKcal = 300;

DateTime _d(DateTime x) => DateTime(x.year, x.month, x.day);

String _kcal(num v) => '${v.round()} kcal';
String _f2(num v) => v.toStringAsFixed(2).replaceAll('.', ',');

double _median(List<double> xs) {
  final s = [...xs]..sort();
  final n = s.length;
  return n.isOdd ? s[n ~/ 2] : (s[n ~/ 2 - 1] + s[n ~/ 2]) / 2;
}

AdaptiveResult calculateAdaptiveTarget(AdaptiveInput i) {
  final end = DateTime(i.today.year, i.today.month, i.today.day - 1);
  final start = DateTime(end.year, end.month, end.day - (i.windowDays - 1));
  bool inWindow(DateTime x) => !_d(x).isBefore(start) && !_d(x).isAfter(end);

  // Intake: one value per day, empty days do not exist in the list.
  final byDay = <DateTime, double>{};
  for (final d in i.intakes) {
    if (!inWindow(d.date)) continue;
    byDay[_d(d.date)] = (byDay[_d(d.date)] ?? 0) + d.kcal;
  }
  final logged = byDay.values.where((k) => k > 0).toList();
  final threshold = logged.isEmpty ? minDayKcal : math.max(minDayKcal, _median(logged) * incompleteShare);
  final counted = logged.where((k) => k >= threshold).toList();
  final excluded = logged.length - counted.length;

  final weights = sortPoints(i.weights.where((p) => inWindow(p.date)));

  AdaptiveResult partial(AdaptiveStatus s, List<String> notes) => AdaptiveResult(
    status: s,
    windowStart: start,
    windowEnd: end,
    countedDays: counted.length,
    excludedDays: excluded,
    weightCount: weights.length,
    notes: notes,
  );

  if (counted.length < minCountedDays) {
    return partial(AdaptiveStatus.notEnoughIntake, [
      'Für den Wochen-Check braucht die App mindestens $minCountedDays vollständig erfasste Tage in den '
          'letzten ${i.windowDays} Tagen; bisher sind es ${counted.length}.',
    ]);
  }
  final slope = regressionSlopePerDay(weights, minPoints: minWeightCount, minSpanDays: minWeightSpanDays);
  if (slope == null) {
    return partial(AdaptiveStatus.notEnoughWeights, [
      'Für den Wochen-Check braucht die App mindestens $minWeightCount Wiegungen über mindestens '
          '$minWeightSpanDays Tage; bisher sind es ${weights.length}.',
    ]);
  }

  final avgIntake = counted.reduce((a, b) => a + b) / counted.length;
  final balance = slope * kcalPerKg;
  final observed = avgIntake - balance;
  final steps = <CalcStep>[
    CalcStep(
      'Durchschnittliche Aufnahme',
      '${counted.length} vollständig erfasste Tage${excluded > 0 ? ' ($excluded unvollständige ausgelassen)' : ''}',
      _kcal(avgIntake),
    ),
    CalcStep(
      'Gewichtsveränderung',
      'Ausgleichsgerade über ${weights.length} Wiegungen',
      '${slope >= 0 ? '+' : '−'}${_f2((slope * 7).abs())} kg/Woche',
    ),
    CalcStep(
      'Energiebilanz pro Tag',
      '${_f2(slope.abs())} kg × 7700 kcal${slope < 0 ? ' (Defizit)' : ' (Überschuss)'}',
      '${balance >= 0 ? '+' : '−'}${_kcal(balance.abs())}',
    ),
    CalcStep(
      'Tatsächlicher Verbrauch',
      '${_kcal(avgIntake)} ${balance >= 0 ? '−' : '+'} ${_kcal(balance.abs())}',
      _kcal(observed),
    ),
  ];
  final notes = <String>[];

  final diffToFormula = observed - i.formulaTdee;
  notes.add(
    'Die Formel schätzt deinen Verbrauch auf ${_kcal(i.formulaTdee)}; dein echter Verlauf ergibt '
    '${_kcal(observed)} (${diffToFormula >= 0 ? '+' : '−'}${_kcal(diffToFormula.abs())}).',
  );

  var raw = observed + i.desiredDailyDeltaKcal;
  steps.add(
    CalcStep(
      'Ziel mit geplanter Bilanz',
      '${_kcal(observed)} ${i.desiredDailyDeltaKcal < 0 ? '−' : '+'} ${_kcal(i.desiredDailyDeltaKcal.abs())}',
      _kcal(raw),
    ),
  );

  final change = raw - i.currentTargetKcal;
  if (change.abs() > maxStepKcal) {
    raw = i.currentTargetKcal + maxStepKcal * change.sign;
    steps.add(CalcStep('Begrenzung', 'höchstens $maxStepKcal kcal Änderung auf einmal', _kcal(raw)));
    notes.add(
      'Die Änderung wurde auf $maxStepKcal kcal begrenzt. Der nächste Wochen-Check passt weiter an, '
      'falls der Verlauf es bestätigt.',
    );
  }
  if (raw < i.floorKcal) {
    raw = i.floorKcal;
    steps.add(CalcStep('Mindestwert', 'nie unter ${_kcal(i.floorKcal)}', _kcal(raw)));
    notes.add('Der Vorschlag wurde auf den Mindestwert von ${_kcal(i.floorKcal)} angehoben.');
  }
  if (excluded > 0) {
    notes.add(
      '$excluded Tag(e) mit deutlich weniger Einträgen als üblich wurden nicht mitgezählt, '
      'weil dort vermutlich nicht alles eingetragen wurde.',
    );
  }

  return AdaptiveResult(
    status: AdaptiveStatus.ready,
    windowStart: start,
    windowEnd: end,
    countedDays: counted.length,
    excludedDays: excluded,
    weightCount: weights.length,
    averageIntakeKcal: avgIntake,
    weeklyWeightChangeKg: slope * 7,
    observedTdee: observed,
    suggestedTargetKcal: raw.round(),
    steps: steps,
    notes: notes,
  );
}
