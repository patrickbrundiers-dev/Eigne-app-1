/// Weekly calorie budget.
///
/// Instead of a fixed target every day, the week (Monday to Sunday) has
/// 7 × daily target. What was eaten more or less on earlier days is spread over the
/// remaining days of the week, so a dinner with friends does not "ruin" the day.
///
/// Guards:
/// - a past day without any entry counts as exactly on target (not as 0 kcal),
///   otherwise forgetting to log would create a huge budget,
/// - today's target never drops below the minimum (1500/1200 kcal) and never rises
///   more than [maxRaisePercent] above the normal daily target.
library;

import 'dart:math' as math;

import 'energy.dart' show CalcStep;

const int maxRaisePercent = 20;

class WeekBudget {
  const WeekBudget({
    required this.weekStart,
    required this.weekKcal,
    required this.consumedBeforeToday,
    required this.daysLeft,
    required this.todayTargetKcal,
    required this.dailyTargetKcal,
    required this.isClamped,
    required this.steps,
  });

  final DateTime weekStart;
  final int weekKcal;

  /// Sum of the days before today (unlogged days counted as on target).
  final double consumedBeforeToday;

  /// Days left including today (1 on Sunday, 7 on Monday).
  final int daysLeft;
  final int todayTargetKcal;
  final int dailyTargetKcal;

  /// True when the minimum or the upper limit applied.
  final bool isClamped;
  final List<CalcStep> steps;

  /// Positive: earlier days were below target, so today has more.
  int get shiftKcal => todayTargetKcal - dailyTargetKcal;
}

DateTime mondayOf(DateTime d) => DateTime(d.year, d.month, d.day - (d.weekday - 1));

String _k(num v) => '${v.round()} kcal';

/// [consumedByDay] holds the logged kcal per day; days without entries are absent.
WeekBudget weekBudget({
  required DateTime today,
  required int dailyTargetKcal,
  required Map<DateTime, double> consumedByDay,
  required double floorKcal,
}) {
  final day = DateTime(today.year, today.month, today.day);
  final start = mondayOf(day);
  final weekKcal = dailyTargetKcal * 7;
  final pastDays = day.weekday - 1;
  var past = 0.0;
  var unlogged = 0;
  for (var i = 0; i < pastDays; i++) {
    final d = DateTime(start.year, start.month, start.day + i);
    final v = consumedByDay[d];
    if (v == null || v <= 0) {
      past += dailyTargetKcal;
      unlogged++;
    } else {
      past += v;
    }
  }
  final daysLeft = 7 - pastDays;
  final raw = (weekKcal - past) / daysLeft;
  final upper = dailyTargetKcal * (100 + maxRaisePercent) / 100;
  final lower = math.min(floorKcal, dailyTargetKcal.toDouble());
  final clamped = raw.clamp(lower, upper).toDouble();
  final steps = <CalcStep>[
    CalcStep('Wochenbudget', '7 × ${_k(dailyTargetKcal)}', _k(weekKcal)),
    CalcStep(
      'Bisher diese Woche',
      '$pastDays Tag(e)${unlogged > 0 ? ', davon $unlogged ohne Einträge als Tagesziel gezählt' : ''}',
      _k(past),
    ),
    CalcStep('Heute', '(${_k(weekKcal)} − ${_k(past)}) ÷ $daysLeft Tag(e)', _k(raw)),
  ];
  if (clamped != raw) {
    steps.add(
      CalcStep(
        'Begrenzung',
        raw > upper ? 'höchstens $maxRaisePercent % über dem Tagesziel' : 'nie unter ${_k(lower)}',
        _k(clamped),
      ),
    );
  }
  return WeekBudget(
    weekStart: start,
    weekKcal: weekKcal,
    consumedBeforeToday: past,
    daysLeft: daysLeft,
    todayTargetKcal: clamped.round(),
    dailyTargetKcal: dailyTargetKcal,
    isClamped: clamped != raw,
    steps: steps,
  );
}
