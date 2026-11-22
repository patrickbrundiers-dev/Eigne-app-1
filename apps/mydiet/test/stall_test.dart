import 'package:flutter_test/flutter_test.dart';
import 'package:mydiet_ai/src/core/stall.dart';
import 'package:mydiet_ai/src/core/weight_progress.dart';
import 'package:mydiet_ai/src/core/weight_trend.dart';

void main() {
  final today = DateTime(2026, 11, 23); // Montag

  /// Weigh-ins every day for the last 21 days with [perDay] change.
  List<WeightPoint> weights({double perDay = 0, int every = 1}) => [
    for (var i = 21; i >= 1; i -= every) WeightPoint(today.subtract(Duration(days: i)), 95 + perDay * (21 - i)),
  ];

  List<DayLog> logs(double Function(DateTime d) kcal, {int days = 21}) => [
    for (var i = 1; i <= days; i++)
      DayLog(
        today.subtract(Duration(days: i)),
        kcal: kcal(today.subtract(Duration(days: i))),
        protein: 120,
      ),
  ];

  StallAnalysis? run(List<WeightPoint> w, List<DayLog> l, {double target = 85}) =>
      analyzeStall(points: w, logs: l, today: today, startKg: 100, targetKg: target, targetKcal: 2000, tdeeKcal: 2600);

  test('Kein Stillstand, wenn es vorangeht', () {
    expect(run(weights(perDay: -0.07), logs((_) => 2000)), isNull); // ≈ −0,5 kg/Woche
  });

  test('Gewicht halten ist kein Stillstand', () {
    expect(run(weights(), logs((_) => 2000), target: 100), isNull);
  });

  test('Ohne Messungen keine Aussage', () {
    expect(run(const [], logs((_) => 2000)), isNull);
  });

  test('Bilanz passt nicht: Defizit laut Tagebuch, Waage bleibt stehen', () {
    final s = run(weights(), logs((_) => 2000))!;
    expect(s.weeklyRateKg.abs(), lessThan(0.01));
    final kinds = s.causes.map((c) => c.kind);
    expect(kinds, contains(StallCauseKind.balanceMismatch));
    expect(kinds, isNot(contains(StallCauseKind.gaps)));
    expect(kinds, isNot(contains(StallCauseKind.aboveTarget)));
    final c = s.causes.firstWhere((c) => c.kind == StallCauseKind.balanceMismatch);
    expect(c.detail, contains('600 kcal pro Tag unter'));
    expect(c.detail, contains('0,5 kg pro Woche'));
  });

  test('Lücken: Bilanz wird dann nicht beurteilt', () {
    final l = [
      for (final x in logs((_) => 2000))
        if (x.date.day % 2 == 0) x,
    ];
    final s = run(weights(), l)!;
    final kinds = s.causes.map((c) => c.kind);
    expect(kinds, contains(StallCauseKind.gaps));
    expect(kinds, isNot(contains(StallCauseKind.balanceMismatch)));
  });

  test('Über dem Ziel und Wochenende', () {
    final s = run(weights(), logs((d) => d.weekday >= DateTime.saturday ? 3000 : 2100))!;
    final kinds = s.causes.map((c) => c.kind).toList();
    expect(kinds, contains(StallCauseKind.aboveTarget));
    expect(kinds, contains(StallCauseKind.weekend));
    expect(s.causes.firstWhere((c) => c.kind == StallCauseKind.weekend).detail, contains('900 kcal mehr'));
  });

  test('Wenige Messungen werden genannt', () {
    final s = run(weights(every: 4), logs((_) => 2500))!;
    expect(s.causes.map((c) => c.kind), contains(StallCauseKind.fewWeighIns));
  });
}
