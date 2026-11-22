import 'package:flutter_test/flutter_test.dart';
import 'package:mydiet_ai/src/core/weight_trend.dart';

void main() {
  final d0 = DateTime(2026, 3, 2); // Monday
  List<WeightPoint> line(int days, double start, double perDay, {int every = 1}) => [
    for (var i = 0; i < days; i += every) WeightPoint(d0.add(Duration(days: i)), start + perDay * i),
  ];

  test('Keine Daten', () {
    final a = analyzeWeight([], targetKg: 80);
    expect(a.latest, isNull);
    expect(a.trendKg, isNull);
    expect(a.weeklyRateKg, isNull);
    expect(a.isPlateau, isFalse);
  });

  test('Trend ist der 7-Tage-Durchschnitt', () {
    final pts = line(10, 100, -0.1);
    final a = analyzeWeight(pts);
    // Tage 3..9: 99.7 .. 99.1 -> Mittel 99.4
    expect(a.trendKg, closeTo(99.4, 1e-9));
    expect(a.latest!.kg, closeTo(99.1, 1e-9));
  });

  test('Tempo aus Regression: -0,1 kg/Tag = -0,7 kg/Woche', () {
    final a = analyzeWeight(line(28, 100, -0.1));
    expect(a.weeklyRateKg, closeTo(-0.7, 1e-9));
  });

  test('Einzelne Ausreißer verfälschen das Tempo kaum', () {
    final pts = line(28, 100, -0.1);
    pts[20] = WeightPoint(pts[20].date, pts[20].kg + 2); // +2 kg nach Pizza-Abend
    final a = analyzeWeight(pts);
    expect(a.weeklyRateKg, closeTo(-0.7, 0.15));
  });

  test('Zu wenig Daten: kein Tempo', () {
    expect(analyzeWeight(line(3, 100, -0.1)).weeklyRateKg, isNull); // < 4 Punkte
    expect(analyzeWeight(line(8, 100, -0.1)).weeklyRateKg, isNull); // < 10 Tage
  });

  test('Prognose zum Zielgewicht', () {
    final a = analyzeWeight(line(28, 100, -0.1), targetKg: 90);
    // Trend am Tag 27: Mittel der Tage 21..27 = 97.6; 7.6 kg / 0.1 kg pro Tag = 76 Tage
    expect(a.trendKg, closeTo(97.6, 1e-9));
    expect(a.forecastDate, d0.add(const Duration(days: 27 + 76)));
  });

  test('Keine Prognose, wenn der Trend vom Ziel weg zeigt', () {
    final a = analyzeWeight(line(28, 100, 0.05), targetKg: 90);
    expect(a.forecastDate, isNull);
  });

  test('Plateau: 3 Wochen praktisch kein Verlust', () {
    final pts = [
      ...line(14, 100, -0.1),
      for (var i = 14; i < 35; i++) WeightPoint(d0.add(Duration(days: i)), 98.6 + (i.isEven ? 0.3 : -0.3)),
    ];
    final a = analyzeWeight(pts, targetKg: 90);
    expect(a.isPlateau, isTrue);
  });

  test('Kein Plateau bei stetigem Verlust oder ohne Ziel', () {
    expect(analyzeWeight(line(35, 100, -0.1), targetKg: 90).isPlateau, isFalse);
    expect(analyzeWeight(line(35, 100, 0)).isPlateau, isFalse);
    // Ziel erreicht -> Halten ist kein Plateau
    expect(analyzeWeight(line(35, 90, 0), targetKg: 90).isPlateau, isFalse);
  });

  test('Wochen- und Monatsdurchschnitte', () {
    final pts = line(14, 100, -0.1);
    final w = weeklyAverages(pts);
    expect(w.length, 2);
    expect(w.first.start, DateTime(2026, 3, 9));
    expect(w.first.count, 7);
    expect(w.first.averageKg, closeTo(99.0, 1e-9)); // Tage 7..13: 99.3..98.7
    expect(w.last.averageKg, closeTo(99.7, 1e-9));
    final m = monthlyAverages(pts);
    expect(m.single.start, DateTime(2026, 3));
    expect(m.single.count, 14);
  });

  test('Zielfortschritt', () {
    expect(goalProgress(startKg: 100, currentKg: 95, targetKg: 90), 0.5);
    expect(goalProgress(startKg: 100, currentKg: 101, targetKg: 90), 0);
    expect(goalProgress(startKg: 100, currentKg: 88, targetKg: 90), 1);
    expect(goalProgress(startKg: 60, currentKg: 65, targetKg: 70), 0.5);
  });
}
