import 'package:flutter_test/flutter_test.dart';
import 'package:mydiet_ai/src/core/adaptive_target.dart';
import 'package:mydiet_ai/src/core/weight_trend.dart';

void main() {
  final today = DateTime(2026, 4, 1);
  DateTime day(int back) => DateTime(today.year, today.month, today.day - back);

  /// [days] logged days ending yesterday, constant intake.
  List<DayIntake> intake(int days, double kcal) => [for (var b = 1; b <= days; b++) DayIntake(day(b), kcal)];

  /// Weigh-in every [every] days over the window, changing by [perWeek] kg.
  List<WeightPoint> weights(double startKg, double perWeek, {int days = 28, int every = 2}) => [
    for (var b = days; b >= 1; b -= every) WeightPoint(day(b), startKg + perWeek / 7 * (days - b)),
  ];

  AdaptiveResult run({
    required List<DayIntake> intakes,
    required List<WeightPoint> w,
    double formula = 2500,
    double delta = -500,
    int current = 2000,
    double floor = 1500,
  }) => calculateAdaptiveTarget(
    AdaptiveInput(
      today: today,
      intakes: intakes,
      weights: w,
      formulaTdee: formula,
      desiredDailyDeltaKcal: delta,
      currentTargetKcal: current,
      floorKcal: floor,
    ),
  );

  test('Verbrauch aus Bilanz: 2000 kcal und -0,5 kg/Woche = 2550 kcal', () {
    final r = run(intakes: intake(28, 2000), w: weights(90, -0.5));
    expect(r.isReady, isTrue);
    expect(r.countedDays, 28);
    expect(r.weeklyWeightChangeKg, closeTo(-0.5, 1e-9));
    // 0,5 kg / 7 Tage × 7700 = 550 kcal Defizit pro Tag.
    expect(r.observedTdee, closeTo(2550, 1e-6));
    expect(r.suggestedTargetKcal, 2050);
    expect(r.steps, isNotEmpty);
  });

  test('Plateau: Formel überschätzt, Ziel sinkt', () {
    final r = run(intakes: intake(28, 2000), w: weights(90, 0), formula: 2500, current: 2000);
    expect(r.observedTdee, closeTo(2000, 1e-6));
    // 2000 - 500 = 1500; Änderung -500 ist größer als 300 -> begrenzt auf 1700.
    expect(r.suggestedTargetKcal, 1700);
    expect(r.steps.any((s) => s.label == 'Begrenzung'), isTrue);
  });

  test('Unvollständige Tage werden ausgelassen', () {
    final intakes = [...intake(20, 2000), for (var b = 21; b <= 26; b++) DayIntake(day(b), 400)];
    final r = run(intakes: intakes, w: weights(90, -0.5));
    expect(r.countedDays, 20);
    expect(r.excludedDays, 6);
    expect(r.averageIntakeKcal, closeTo(2000, 1e-9));
  });

  test('Heute zählt nicht mit', () {
    final r = run(intakes: [...intake(28, 2000), DayIntake(today, 300)], w: weights(90, -0.5));
    expect(r.countedDays, 28);
    expect(r.averageIntakeKcal, closeTo(2000, 1e-9));
  });

  test('Zu wenige erfasste Tage', () {
    final r = run(intakes: intake(10, 2000), w: weights(90, -0.5));
    expect(r.status, AdaptiveStatus.notEnoughIntake);
    expect(r.suggestedTargetKcal, isNull);
  });

  test('Zu wenige Wiegungen', () {
    final r = run(intakes: intake(28, 2000), w: weights(90, -0.5, every: 7));
    expect(r.status, AdaptiveStatus.notEnoughWeights);
  });

  test('Mindestwert wird nie unterschritten', () {
    final r = run(intakes: intake(28, 1400), w: weights(90, 0), current: 1600, floor: 1500);
    expect(r.suggestedTargetKcal, 1500);
  });

  test('Zunahme trotz Defizit-Ziel: Verbrauch niedriger als Aufnahme', () {
    final r = run(intakes: intake(28, 2200), w: weights(80, 0.25), current: 2100);
    // 0,25/7 × 7700 = 275 kcal Überschuss -> Verbrauch 1925, Ziel 1425 -> begrenzt auf 1800.
    expect(r.observedTdee, closeTo(1925, 1e-6));
    expect(r.suggestedTargetKcal, 1800);
  });
}
