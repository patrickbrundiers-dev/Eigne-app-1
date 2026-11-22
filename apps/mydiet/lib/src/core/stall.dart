/// Stall analysis ("Warum geht es nicht weiter?"): when the weight stops moving towards
/// the goal, list the likely reasons that the user's own data support, each with its numbers.
/// Pure Dart. No diagnosis and no lower calorie target: the adaptive weekly check
/// stays the only place where the target changes (after confirmation).
library;

import 'energy.dart' show kcalPerKg;
import 'weight_progress.dart';
import 'weight_trend.dart';

enum StallCauseKind {
  /// Too few complete diary days: the intake is not really known.
  gaps,

  /// Logged intake above the calorie target.
  aboveTarget,

  /// Weekends clearly higher than weekdays.
  weekend,

  /// Logged deficit should show on the scale but does not: probably unlogged calories
  /// or a lower expenditure than the formula assumes.
  balanceMismatch,

  /// Too few weigh-ins for a reliable trend.
  fewWeighIns,
}

class StallCause {
  const StallCause(this.kind, this.title, this.detail);
  final StallCauseKind kind;
  final String title;
  final String detail;
}

class StallAnalysis {
  const StallAnalysis({required this.weeklyRateKg, required this.days, required this.causes});

  /// Trend in kg/week over [days] days (0 when flat).
  final double weeklyRateKg;
  final int days;

  /// Most important first; may be empty (then only the general note applies).
  final List<StallCause> causes;

  /// Always shown: short-term water changes can hide fat loss for 1–2 weeks.
  static const waterNote =
      'Wasser (Salz, Kohlenhydrate, Training, Zyklus) kann einen Fettverlust ein bis zwei Wochen lang überdecken.';
}

/// Below this weekly change towards the goal the weight counts as standing still.
const double stallRateKgPerWeek = 0.1;

/// Share of complete days below which the diary is too patchy to judge the intake.
const double minLoggedShare = 0.7;

/// Weekend minus weekday average (kcal) worth a remark.
const double weekendGapKcal = 300;

/// Logged deficit (kcal/day vs. expenditure) that should be visible on the scale within 3 weeks.
const double visibleDeficitKcal = 250;

String _n0(num v) => v.round().toString();
String _n1(num v) => v.toStringAsFixed(1).replaceAll('.', ',');

/// Returns null when the weight is moving towards the goal, the goal is to keep the weight,
/// or the trend over [days] days is not reliable enough to speak of a stall.
StallAnalysis? analyzeStall({
  required List<WeightPoint> points,
  required List<DayLog> logs,
  required DateTime today,
  required double startKg,
  required double targetKg,
  required int targetKcal,
  required double tdeeKcal,
  int days = 21,
}) {
  final losing = targetKg < startKg;
  if ((targetKg - startKg).abs() < 0.5) return null;
  final sorted = sortPoints(points);
  final tr = trendWindow(sorted, days: days);
  final rate = tr.weeklyRateKg;
  if (rate == null || tr.reliability == Reliability.none) return null;
  final towardsGoal = losing ? -rate : rate;
  if (towardsGoal >= stallRateKgPerWeek) return null;

  final t = DateTime(today.year, today.month, today.day);
  final from = t.subtract(Duration(days: days));
  final window = [
    for (final l in logs)
      if (!l.date.isBefore(from) && l.date.isBefore(t)) l,
  ];
  final complete = [
    for (final l in window)
      if (l.kcal >= minLoggedDayKcal) l,
  ];
  final causes = <StallCause>[];

  final share = complete.length / days;
  if (share < minLoggedShare) {
    causes.add(
      StallCause(
        StallCauseKind.gaps,
        'Lücken im Tagebuch',
        'Nur an ${complete.length} von $days Tagen vollständig eingetragen (ab ${_n0(minLoggedDayKcal)} kcal). '
            'Ohne die übrigen Tage lässt sich die Aufnahme nicht sicher beurteilen.',
      ),
    );
  }

  double avg(Iterable<DayLog> xs) => xs.map((l) => l.kcal).reduce((a, b) => a + b) / xs.length;
  if (complete.isNotEmpty) {
    final mean = avg(complete);
    final over = losing ? mean - targetKcal : targetKcal - mean;
    if (over > targetKcal * 0.05) {
      causes.add(
        StallCause(
          StallCauseKind.aboveTarget,
          losing ? 'Über dem Kalorienziel' : 'Unter dem Kalorienziel',
          'Im Schnitt ${_n0(mean)} kcal an eingetragenen Tagen, Ziel ${_n0(targetKcal)} kcal '
          '(${losing ? '+' : '−'}${_n0(over)} kcal pro Tag).',
        ),
      );
    }
    final weekend = complete.where((l) => l.date.weekday >= DateTime.saturday);
    final weekday = complete.where((l) => l.date.weekday < DateTime.saturday);
    if (weekend.isNotEmpty && weekday.isNotEmpty) {
      final gap = avg(weekend) - avg(weekday);
      if (losing && gap >= weekendGapKcal) {
        causes.add(
          StallCause(
            StallCauseKind.weekend,
            'Wochenende deutlich höher',
            'Samstag/Sonntag im Schnitt ${_n0(gap)} kcal mehr als unter der Woche. '
                'Zwei solche Tage können einen großen Teil des Wochendefizits ausgleichen.',
          ),
        );
      }
    }
    final balance = mean - tdeeKcal;
    final enoughData = share >= minLoggedShare;
    if (enoughData && (losing ? balance <= -visibleDeficitKcal : balance >= visibleDeficitKcal)) {
      final expected = balance * 7 / kcalPerKg;
      causes.add(
        StallCause(
          StallCauseKind.balanceMismatch,
          'Bilanz passt nicht zur Waage',
          'Laut Tagebuch ${_n0(balance.abs())} kcal pro Tag ${losing ? 'unter' : 'über'} dem geschätzten Verbrauch, '
              'das wären etwa ${_n1(expected.abs())} kg pro Woche. Die Waage zeigt ${rate <= 0 ? '−' : '+'}${_n1(rate.abs())} kg pro Woche. '
              'Häufige Gründe: nicht eingetragene Kleinigkeiten (Öl, Getränke, Soßen), geschätzte Portionen, '
              'oder der tatsächliche Verbrauch ist niedriger als die Formel annimmt. '
              'Der Wochen-Check kann das Ziel aus deinen Daten anpassen.',
        ),
      );
    }
  }

  if (tr.reliability == Reliability.low) {
    causes.add(
      StallCause(
        StallCauseKind.fewWeighIns,
        'Wenige Messungen',
        '${tr.count} Messungen in $days Tagen. Mit 3–4 Messungen pro Woche, morgens nüchtern, wird der Trend verlässlicher.',
      ),
    );
  }

  return StallAnalysis(weeklyRateKg: rate, days: days, causes: causes);
}
