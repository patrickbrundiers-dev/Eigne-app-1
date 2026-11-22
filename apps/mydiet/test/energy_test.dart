import 'package:flutter_test/flutter_test.dart';
import 'package:mydiet_ai/src/core/energy.dart';

void main() {
  final today = DateTime(2026, 1, 1);

  group('Grundumsatz', () {
    test('Mifflin-St Jeor Mann: 10*100 + 6.25*180 - 5*40 + 5 = 1930', () {
      expect(bmrMifflinStJeor(sex: Sex.male, weightKg: 100, heightCm: 180, ageYears: 40), 1930);
    });

    test('Mifflin-St Jeor Frau: 10*70 + 6.25*165 - 5*30 - 161 = 1420.25', () {
      expect(bmrMifflinStJeor(sex: Sex.female, weightKg: 70, heightCm: 165, ageYears: 30), closeTo(1420.25, 1e-9));
    });

    test('Katch-McArdle: 370 + 21.6 * Magermasse', () {
      // 100 kg, 25 % -> 75 kg LBM -> 370 + 1620 = 1990
      expect(bmrKatchMcArdle(weightKg: 100, bodyFatPercent: 25), closeTo(1990, 1e-9));
    });

    test('Katch-McArdle wird verwendet, wenn Körperfett angegeben ist', () {
      final r = calculateEnergy(
        EnergyInput(
          sex: Sex.male,
          ageYears: 40,
          heightCm: 180,
          weightKg: 100,
          targetWeightKg: 100,
          jobActivity: JobActivity.sitting,
          bodyFatPercent: 25,
          today: today,
        ),
      );
      expect(r.bmrMethod, 'Katch-McArdle');
      expect(r.bmr, closeTo(1990, 1e-9));
    });
  });

  group('BMI und Alter', () {
    test('BMI 100 kg / 1,80 m = 30,86', () {
      expect(bmi(100, 180), closeTo(30.864, 0.001));
      expect(bmiCategory(30.86), 'Adipositas Grad I');
      expect(bmiCategory(24.9), 'Normalgewicht');
      expect(bmiCategory(18.4), 'Untergewicht');
    });

    test('Alter zählt erst ab dem Geburtstag', () {
      expect(ageOn(DateTime(1990, 6, 15), DateTime(2026, 6, 14)), 35);
      expect(ageOn(DateTime(1990, 6, 15), DateTime(2026, 6, 15)), 36);
    });
  });

  group('Gesamtumsatz und Ziel', () {
    test('PAL = Alltag + 0,09 je Stunde Sport/Woche', () {
      final r = calculateEnergy(
        EnergyInput(
          sex: Sex.male,
          ageYears: 40,
          heightCm: 180,
          weightKg: 100,
          targetWeightKg: 100,
          jobActivity: JobActivity.sitting,
          sportMinutesPerWeek: 180,
          today: today,
        ),
      );
      expect(r.pal, closeTo(1.4 + 0.27, 1e-9));
      expect(r.tdee, closeTo(1930 * 1.67, 1e-6));
      expect(r.direction, GoalDirection.maintain);
      expect(r.targetKcal, (1930 * 1.67).round());
    });

    test('Sport-PAL ist gedeckelt', () {
      final r = calculateEnergy(
        EnergyInput(
          sex: Sex.male,
          ageYears: 40,
          heightCm: 180,
          weightKg: 100,
          targetWeightKg: 100,
          jobActivity: JobActivity.sitting,
          sportMinutesPerWeek: 3000,
          today: today,
        ),
      );
      expect(r.pal, closeTo(1.4 + maxSportPal, 1e-9));
    });

    test('Defizit aus Zielgewicht und Zieldatum', () {
      // 10 kg in 200 Tagen: 77000 / 200 = 385 kcal/Tag (unter der 1-%-Grenze von 1100)
      final r = calculateEnergy(
        EnergyInput(
          sex: Sex.male,
          ageYears: 40,
          heightCm: 180,
          weightKg: 100,
          targetWeightKg: 90,
          jobActivity: JobActivity.sitting,
          today: today,
          targetDate: today.add(const Duration(days: 200)),
        ),
      );
      expect(r.direction, GoalDirection.lose);
      expect(r.dailyDeltaKcal, closeTo(-385, 1e-9));
      expect(r.calculatedTargetKcal, (1930 * 1.4 - 385).round());
      expect(r.warnings, isEmpty);
      // Rounding the target to whole kcal can move the projection by a day.
      final days = r.projectedGoalDate!.difference(today).inHours / 24;
      expect(days, closeTo(200, 1.1));
    });

    test('Zu schnelles Ziel wird auf 1 % pro Woche begrenzt', () {
      // 20 kg in 30 Tagen wäre 5133 kcal/Tag; Grenze: 1 kg/Woche * 7700 / 7 = 1100
      final r = calculateEnergy(
        EnergyInput(
          sex: Sex.male,
          ageYears: 40,
          heightCm: 180,
          weightKg: 100,
          targetWeightKg: 80,
          jobActivity: JobActivity.standing,
          today: today,
          targetDate: today.add(const Duration(days: 30)),
        ),
      );
      expect(r.dailyDeltaKcal, closeTo(-1100, 1e-9));
      expect(r.warnings.single, contains('1 %'));
      expect(r.weeklyChangeKg, closeTo(-1.0, 0.001));
    });

    test('Ohne Zieldatum: 0,5 % pro Woche', () {
      final r = calculateEnergy(
        EnergyInput(
          sex: Sex.male,
          ageYears: 40,
          heightCm: 180,
          weightKg: 100,
          targetWeightKg: 90,
          jobActivity: JobActivity.mixed,
          today: today,
        ),
      );
      expect(r.dailyDeltaKcal, closeTo(-550, 1e-9));
      expect(r.weeklyChangeKg, closeTo(-0.5, 0.001));
      // 10 kg bei 0,5 kg/Woche = 140 Tage
      expect(r.projectedGoalDate!.difference(today).inHours / 24, closeTo(140, 1.1));
    });

    test('Mindestzufuhr: nie unter 1200 kcal (Frau)', () {
      final r = calculateEnergy(
        EnergyInput(
          sex: Sex.female,
          ageYears: 60,
          heightCm: 155,
          weightKg: 60,
          targetWeightKg: 50,
          jobActivity: JobActivity.sedentary,
          today: today,
          targetDate: today.add(const Duration(days: 30)),
        ),
      );
      expect(r.calculatedTargetKcal, 1200);
      expect(r.warnings.any((w) => w.contains('1200 kcal')), isTrue);
    });

    test('Zunahme ist auf 0,5 % pro Woche begrenzt', () {
      final r = calculateEnergy(
        EnergyInput(
          sex: Sex.male,
          ageYears: 25,
          heightCm: 180,
          weightKg: 60,
          targetWeightKg: 70,
          jobActivity: JobActivity.sitting,
          today: today,
          targetDate: today.add(const Duration(days: 14)),
        ),
      );
      expect(r.direction, GoalDirection.gain);
      expect(r.dailyDeltaKcal, closeTo(60 * 0.005 * 7700 / 7, 1e-9));
    });

    test('Manuelle Ziele überschreiben die Berechnung', () {
      final r = calculateEnergy(
        EnergyInput(
          sex: Sex.male,
          ageYears: 40,
          heightCm: 180,
          weightKg: 100,
          targetWeightKg: 90,
          jobActivity: JobActivity.sitting,
          today: today,
          calorieOverride: 2000,
          proteinOverrideG: 180,
          waterOverrideMl: 3000,
        ),
      );
      expect(r.targetKcal, 2000);
      expect(r.isCalorieOverridden, isTrue);
      expect(r.calculatedTargetKcal, isNot(2000));
      expect(r.proteinG, 180);
      expect(r.waterMl, 3000);
    });
  });

  group('Makros', () {
    test('Protein vom Zielgewicht beim Abnehmen, Fett-%, Rest Kohlenhydrate', () {
      final r = calculateEnergy(
        EnergyInput(
          sex: Sex.male,
          ageYears: 40,
          heightCm: 180,
          weightKg: 100,
          targetWeightKg: 85,
          jobActivity: JobActivity.sitting,
          today: today,
          calorieOverride: 2200,
        ),
      );
      expect(r.proteinG, (1.8 * 85).round()); // 153
      expect(r.fatG, (2200 * 0.30 / 9).round()); // 73
      expect(r.carbsG, ((2200 - 153 * 4 - 73 * 9) / 4).round()); // 233
      final kcalFromMacros = r.proteinG * 4 + r.carbsG * 4 + r.fatG * 9;
      expect((kcalFromMacros - 2200).abs(), lessThanOrEqualTo(4));
      expect(r.fiberG, 30);
      expect(r.waterMl, 3000);
    });

    test('Wasser: 30 ml/kg, begrenzt auf 1,5 bis 3,5 Liter', () {
      final small = calculateEnergy(
        EnergyInput(
          sex: Sex.female,
          ageYears: 30,
          heightCm: 150,
          weightKg: 40,
          targetWeightKg: 40,
          jobActivity: JobActivity.sitting,
          today: today,
        ),
      );
      expect(small.waterMl, 1500);
      final big = calculateEnergy(
        EnergyInput(
          sex: Sex.male,
          ageYears: 30,
          heightCm: 200,
          weightKg: 150,
          targetWeightKg: 150,
          jobActivity: JobActivity.sitting,
          today: today,
        ),
      );
      expect(big.waterMl, 3500);
    });

    test('Warnung, wenn Protein und Fett das Ziel übersteigen', () {
      final r = calculateEnergy(
        EnergyInput(
          sex: Sex.male,
          ageYears: 40,
          heightCm: 180,
          weightKg: 100,
          targetWeightKg: 100,
          jobActivity: JobActivity.sitting,
          today: today,
          calorieOverride: 1000,
          proteinOverrideG: 250,
        ),
      );
      expect(r.carbsG, 0);
      expect(r.warnings.any((w) => w.contains('Kohlenhydrate')), isTrue);
    });

    test('Rechenweg enthält jeden Schritt', () {
      final r = calculateEnergy(
        EnergyInput(
          sex: Sex.male,
          ageYears: 40,
          heightCm: 180,
          weightKg: 100,
          targetWeightKg: 90,
          jobActivity: JobActivity.sitting,
          today: today,
        ),
      );
      final labels = r.steps.map((s) => s.label).toList();
      expect(
        labels,
        containsAll([
          'Grundumsatz (Mifflin-St Jeor)',
          'Aktivitätsfaktor (PAL)',
          'Gesamtumsatz',
          'Kalorienziel',
          'Protein',
          'Fett',
          'Kohlenhydrate',
          'Wasser',
        ]),
      );
    });
  });
}
