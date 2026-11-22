import 'package:flutter_test/flutter_test.dart';
import 'package:mydiet_ai/src/core/weight_progress.dart';
import 'package:mydiet_ai/src/core/weight_trend.dart';

void main() {
  final d0 = DateTime(2026, 3, 2);
  List<WeightPoint> line(int days, double start, double perDay, {int every = 1, double Function(int i)? noise}) => [
    for (var i = 0; i < days; i += every)
      WeightPoint(d0.add(Duration(days: i)), start + perDay * i + (noise?.call(i) ?? 0)),
  ];

  group('Gewichts-Fortschritt', () {
    test('Ohne Messungen: Startgewicht, keine Trends, keine Prognose', () {
      final p = computeWeightProgress(points: const [], startKg: 90, targetKg: 80);
      expect(p.currentKg, 90);
      expect(p.startDate, isNull);
      expect(p.changeSinceStartKg, 0);
      expect(p.remainingKg, 10);
      expect(p.progress, 0);
      expect(p.trend30.reliability, Reliability.none);
      expect(p.trend30.weeklyRateKg, isNull);
      expect(p.forecastDate, isNull);
      expect(p.nutrition, isNull);
    });

    test('Abnahme: bisher, verbleibend, Fortschritt aus dem 7-Tage-Schnitt', () {
      // 30 Tage, -0,1 kg/Tag ab 90 kg -> Tage 23..29: 87,7..87,1 -> Ø 87,4
      final p = computeWeightProgress(points: line(30, 90, -0.1), startKg: 90, targetKg: 80);
      expect(p.average7Kg, closeTo(87.4, 1e-9));
      expect(p.currentKg, closeTo(87.4, 1e-9));
      expect(p.changeSinceStartKg, closeTo(-2.6, 1e-9));
      expect(p.remainingKg, closeTo(7.4, 1e-9));
      expect(p.progress, closeTo(0.26, 1e-9));
      expect(p.goalIsLoss, isTrue);
      expect(p.goalReached, isFalse);
    });

    test('Wochenvergleich: 7-Tage-Schnitt gegen die Woche davor', () {
      final p = computeWeightProgress(points: line(30, 90, -0.1), startKg: 90, targetKg: 80);
      // Vorwoche: Tage 16..22 -> Ø 88,1 ; Differenz -0,7
      expect(p.previousAverage7Kg, closeTo(88.1, 1e-9));
      expect(p.weekOverWeekKg, closeTo(-0.7, 1e-9));
    });

    test('30-Tage-Trend: Tempo, Veränderung entlang der Geraden, Aussagekraft gut', () {
      final p = computeWeightProgress(points: line(30, 90, -0.1), startKg: 90, targetKg: 80);
      expect(p.trend30.count, 30);
      expect(p.trend30.spanDays, 29);
      expect(p.trend30.weeklyRateKg, closeTo(-0.7, 1e-9));
      expect(p.trend30.changeKg, closeTo(-2.9, 1e-9));
      expect(p.trend30.fluctuationKg, closeTo(0, 1e-9));
      expect(p.trend30.reliability, Reliability.high);
    });

    test('Ältere Messungen außerhalb von 30 Tagen zählen nicht zum 30-Tage-Trend', () {
      final old = [WeightPoint(d0.subtract(const Duration(days: 60)), 120)];
      final p = computeWeightProgress(points: [...old, ...line(30, 90, -0.1)], startKg: 95, targetKg: 80);
      expect(p.trend30.count, 30);
      expect(p.trend30.weeklyRateKg, closeTo(-0.7, 1e-9));
      expect(p.startDate, old.first.date);
    });

    test('Schwankung: Wasser-Ausschläge erhöhen die Streuung, nicht das Tempo', () {
      // abwechselnd +0,5 / -0,5 kg um eine flache Linie
      final p = computeWeightProgress(
        points: line(28, 85, 0, noise: (i) => i.isEven ? 0.5 : -0.5),
        startKg: 85,
        targetKg: 80,
      );
      expect(p.trend30.weeklyRateKg!.abs(), lessThan(0.05));
      expect(p.trend30.fluctuationKg, closeTo(0.5, 0.05));
    });

    test('Aussagekraft wächst mit Anzahl und Zeitraum der Messungen', () {
      expect(reliabilityFor(count: 3, spanDays: 30), Reliability.none);
      expect(reliabilityFor(count: 10, spanDays: 7), Reliability.none);
      expect(reliabilityFor(count: 5, spanDays: 12), Reliability.low);
      expect(reliabilityFor(count: 10, spanDays: 16), Reliability.medium);
      expect(reliabilityFor(count: 14, spanDays: 21), Reliability.high);
    });

    test('Wenige Messungen: kein Trend, keine Prognose statt geratener Werte', () {
      final p = computeWeightProgress(points: line(6, 90, -0.2, every: 2), startKg: 90, targetKg: 80);
      expect(p.trend30.reliability, Reliability.none);
      expect(p.trend30.weeklyRateKg, isNull);
      expect(p.forecastDate, isNull);
      expect(p.forecastReliability, Reliability.none);
    });

    test('Prognose mit Aussagekraft aus denselben 28 Tagen', () {
      final p = computeWeightProgress(points: line(28, 90, -0.1), startKg: 90, targetKg: 80);
      expect(p.forecastDate, isNotNull);
      expect(p.forecastReliability, Reliability.high);
    });

    test('Zunahme-Ziel: Richtung wird umgekehrt', () {
      final p = computeWeightProgress(points: line(14, 60, 0.05), startKg: 60, targetKg: 65);
      expect(p.goalIsLoss, isFalse);
      expect(p.changeSinceStartKg, greaterThan(0));
      expect(p.remainingKg, closeTo(65 - p.currentKg, 1e-9));
    });

    test('Ziel erreicht oder unterschritten: verbleibend 0, Fortschritt 100 %', () {
      final p = computeWeightProgress(points: line(10, 79.5, 0), startKg: 90, targetKg: 80);
      expect(p.remainingKg, 0);
      expect(p.goalReached, isTrue);
      expect(p.progress, 1);
    });
  });

  group('Ernährung der letzten 7 Tage', () {
    final today = DateTime(2026, 3, 20);
    DayLog log(int daysAgo, double kcal, double protein) => DayLog(
      today.subtract(Duration(days: daysAgo)),
      kcal: kcal,
      protein: protein,
    );

    test('Heute zählt nicht, unvollständige Tage und ältere Tage auch nicht', () {
      final n = nutritionWindow(
        today: today,
        logs: [
          log(0, 2500, 200), // heute
          log(1, 2000, 150),
          log(2, 1800, 100),
          log(3, 400, 30), // unvollständig
          log(8, 3000, 200), // außerhalb
        ],
        targetKcal: 2000,
        proteinTargetG: 140,
        tdeeKcal: 2500,
      )!;
      expect(n.loggedDays, 2);
      expect(n.averageKcal, closeTo(1900, 1e-9));
      expect(n.averageProteinG, closeTo(125, 1e-9));
      expect(n.balanceVsTargetKcal, closeTo(-100, 1e-9));
      expect(n.balanceVsTdeeKcal, closeTo(-600, 1e-9));
      // -600 kcal/Tag * 7 / 7700 = -0,545 kg/Woche
      expect(n.expectedWeeklyChangeKg, closeTo(-600 * 7 / 7700, 1e-9));
    });

    test('Proteinziel gilt ab 90 % als erreicht', () {
      final n = nutritionWindow(
        today: today,
        logs: [log(1, 2000, 126), log(2, 2000, 125.9), log(3, 2000, 200)],
        targetKcal: 2000,
        proteinTargetG: 140,
        tdeeKcal: 2300,
      )!;
      expect(n.proteinHitDays, 2);
      expect(n.proteinHitShare, closeTo(2 / 3, 1e-9));
    });

    test('Ohne Einträge: keine Mittelwerte', () {
      final n = nutritionWindow(today: today, logs: const [], targetKcal: 2000, proteinTargetG: 140, tdeeKcal: 2300)!;
      expect(n.loggedDays, 0);
      expect(n.averageKcal, isNull);
      expect(n.balanceVsTdeeKcal, isNull);
      expect(n.expectedWeeklyChangeKg, isNull);
      expect(n.proteinHitShare, 0);
    });

    test('computeWeightProgress reicht die Ernährung durch', () {
      final p = computeWeightProgress(
        points: line(30, 90, -0.1),
        startKg: 90,
        targetKg: 80,
        today: today,
        logs: [log(1, 1900, 150)],
        targetKcal: 2000,
        proteinTargetG: 140,
        tdeeKcal: 2500,
      );
      expect(p.nutrition!.loggedDays, 1);
      expect(p.nutrition!.proteinHitDays, 1);
    });
  });

  test('Bilanz gegen Waage: Toleranz 0,3 kg/Woche, Richtung der Abweichung', () {
    expect(checkBalance(expectedWeeklyKg: -0.5, measuredWeeklyKg: -0.3), BalanceCheck.matches);
    // erwartet -0,5, Waage -0,1: weniger Abnahme als erwartet
    expect(checkBalance(expectedWeeklyKg: -0.5, measuredWeeklyKg: -0.1), BalanceCheck.scaleHigher);
    expect(checkBalance(expectedWeeklyKg: -0.2, measuredWeeklyKg: -0.8), BalanceCheck.scaleLower);
    // Zunahme-Ziel: erwartet +0,3, Waage +0,8
    expect(checkBalance(expectedWeeklyKg: 0.3, measuredWeeklyKg: 0.8), BalanceCheck.scaleHigher);
  });
}
