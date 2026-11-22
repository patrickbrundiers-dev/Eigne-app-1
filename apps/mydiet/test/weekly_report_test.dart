import 'package:flutter_test/flutter_test.dart';
import 'package:mydiet_ai/src/core/weekly_report.dart';
import 'package:mydiet_ai/src/core/weight_trend.dart';

void main() {
  final mon = DateTime(2026, 11, 16); // Montag
  DateTime day(int i) => DateTime(mon.year, mon.month, mon.day + i);
  List<ReportDay> week(List<double> kcal, {double protein = 150, double fiber = 30, int offset = 0}) => [
    for (var i = 0; i < kcal.length; i++) ReportDay(day(i + offset), kcal: kcal[i], protein: protein, fiber: fiber),
  ];

  test('Leere Woche: freundlicher Hinweis, ein Vorschlag', () {
    final r = buildWeeklyReport(monday: mon, days: const [], targetKcal: 2000, proteinTargetG: 150);
    expect(r.loggedDays, 0);
    expect(r.findings.single.kind, FindingKind.info);
    expect(r.suggestions, hasLength(1));
  });

  test('Woche im Ziel: nur positive Befunde', () {
    final r = buildWeeklyReport(
      monday: mon,
      days: week([2000, 1950, 2050, 2000, 1980, 2100, 2000]),
      targetKcal: 2000,
      proteinTargetG: 150,
    );
    expect(r.loggedDays, 7);
    expect(r.daysNearTarget, 7);
    expect(r.proteinHitDays, 7);
    expect(r.findings.map((f) => f.kind), everyElement(FindingKind.good));
    expect(r.suggestions.single, startsWith('So weitermachen'));
  });

  test('Wochenende, Protein, Ballaststoffe, Tage unter 800 kcal zählen nicht', () {
    final days = [
      ...week([1800, 1800, 1800, 1800, 1800, 2600, 2700], protein: 90, fiber: 12),
      ReportDay(day(2).add(const Duration(hours: 1)), kcal: 0, protein: 0), // doppelter Tag ohne Einträge
    ];
    final r = buildWeeklyReport(
      monday: mon,
      days: days,
      targetKcal: 2000,
      proteinTargetG: 150,
      proteinIdeas: const ['Skyr', 'Linsen', 'Eier', 'Tofu'],
    );
    expect(r.loggedDays, 7);
    expect(r.weekendExtraKcal, closeTo(850, 0.01));
    expect(r.findings.map((f) => f.title), contains('Am Wochenende mehr gegessen'));
    expect(r.findings.map((f) => f.title), contains('Protein oft unter dem Ziel'));
    expect(r.findings.map((f) => f.title), contains('Wenig Ballaststoffe'));
    expect(r.suggestions, hasLength(3));
    expect(r.suggestions.join(), contains('Skyr, Linsen, Eier'));
    expect(r.suggestions.join(), isNot(contains('Tofu')));
  });

  test('Wenige Tage werden als unsicher benannt, Vorwoche verglichen', () {
    final r = buildWeeklyReport(
      monday: mon,
      days: [
        ...week([2300, 2400]),
        ...week([2000, 2000, 2000], offset: -7),
      ],
      targetKcal: 2000,
      proteinTargetG: 150,
    );
    expect(r.loggedDays, 2);
    expect(r.findings.first.title, '2 von 7 Tagen vollständig eingetragen');
    expect(r.previousAverageKcal, 2000);
    expect(r.findings.map((f) => f.title), contains('Über dem Kalorienziel'));
    expect(r.findings.firstWhere((f) => f.title == 'Über dem Kalorienziel').detail, contains('Vorwoche: Ø 2000 kcal'));
  });

  test('Sehr wenig gegessen: Hinweis ohne Schuld, Vorschlag nicht zu knapp', () {
    final r = buildWeeklyReport(
      monday: mon,
      days: week([1200, 1200, 1200, 1200]),
      targetKcal: 2000,
      proteinTargetG: 150,
    );
    expect(r.findings.map((f) => f.title), contains('Unter dem Kalorienziel'));
    expect(r.suggestions.first, contains('nicht zu knapp'));
  });

  test('Gewicht: 7-Tage-Mittel gegen Vorwoche, Mikros unter 70 %', () {
    final weights = [for (var i = -7; i < 7; i++) WeightPoint(day(i), 90 - (i + 7) * 0.1)];
    final r = buildWeeklyReport(
      monday: mon,
      days: week([2000, 2000, 2000, 2000]),
      targetKcal: 2000,
      proteinTargetG: 150,
      weights: weights,
      micros: const [
        ReportMicro(name: 'Vitamin D', targetPercent: 20),
        ReportMicro(name: 'Jod', targetPercent: 55),
        ReportMicro(name: 'Calcium', targetPercent: 95),
      ],
    );
    expect(r.weightChangeKg, closeTo(-0.7, 0.001));
    final w = r.findings.firstWhere((f) => f.title.startsWith('Gewicht'));
    expect(w.kind, FindingKind.good);
    expect(w.title, contains('−0,7 kg'));
    final m = r.findings.firstWhere((f) => f.title.startsWith('Vitamine'));
    expect(m.title, contains('Vitamin D, Jod'));
    expect(m.title, isNot(contains('Calcium')));
  });

  test('Zielrichtung aus dem Profil', () {
    expect(goalFrom(currentKg: 90, targetKg: 80), GoalLoseOrGain.lose);
    expect(goalFrom(currentKg: 60, targetKg: 65), GoalLoseOrGain.gain);
    expect(goalFrom(currentKg: 70, targetKg: 70.3), GoalLoseOrGain.keep);
  });
}
