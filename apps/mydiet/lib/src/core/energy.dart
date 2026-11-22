/// Energy and goal calculations.
///
/// Pure Dart, no Flutter imports: everything here is unit tested and every result
/// carries the steps that produced it, so the app can show the full calculation.
library;

import 'dart:math' as math;

enum Sex { male, female }

/// Physical activity at work and in daily life, without sport (sport is added separately).
///
/// Values sit at the lower end of the DGE reference ranges (sitting 1.4-1.5, sitting with
/// some walking 1.6-1.7, standing 1.8-1.9, heavy 2.0-2.4), because predictive BMR formulas
/// tend to overestimate the needs of people with a higher body weight. The weekly analysis
/// (Phase 3) corrects the target from the real weight trend.
enum JobActivity {
  sedentary(1.25, 'Kaum Bewegung', 'überwiegend sitzend oder liegend, kaum Wege'),
  sitting(1.4, 'Sitzend', 'Büro, kaum Wege zu Fuß'),
  mixed(1.55, 'Sitzend mit Bewegung', 'Büro mit Wegen, Haushalt, Kinder'),
  standing(1.75, 'Überwiegend stehend/gehend', 'Verkauf, Pflege, leichtes Handwerk'),
  heavy(2.0, 'Körperlich schwer', 'Bau, Landwirtschaft, Lager');

  const JobActivity(this.pal, this.label, this.example);
  final double pal;
  final String label;
  final String example;
}

/// One line of a transparent calculation ("Rechenweg").
class CalcStep {
  const CalcStep(this.label, this.formula, this.value);
  final String label;
  final String formula;
  final String value;
}

/// kcal stored in one kilogram of body weight change (common planning value).
const double kcalPerKg = 7700;

/// PAL added per hour of sport per week. DGE: 4-5 x 30-60 min/week = +0.3,
/// i.e. ~3.4 h -> +0.3, so ~0.09 per weekly hour. Capped to stay plausible.
const double palPerWeeklySportHour = 0.09;
const double maxSportPal = 0.6;

double bmrMifflinStJeor({required Sex sex, required double weightKg, required double heightCm, required int ageYears}) {
  final base = 10 * weightKg + 6.25 * heightCm - 5 * ageYears;
  return sex == Sex.male ? base + 5 : base - 161;
}

double bmrKatchMcArdle({required double weightKg, required double bodyFatPercent}) {
  final leanMass = weightKg * (1 - bodyFatPercent / 100);
  return 370 + 21.6 * leanMass;
}

double bmi(double weightKg, double heightCm) {
  final m = heightCm / 100;
  return weightKg / (m * m);
}

String bmiCategory(double value) {
  if (value < 18.5) return 'Untergewicht';
  if (value < 25) return 'Normalgewicht';
  if (value < 30) return 'Übergewicht';
  if (value < 35) return 'Adipositas Grad I';
  if (value < 40) return 'Adipositas Grad II';
  return 'Adipositas Grad III';
}

int ageOn(DateTime birthDate, DateTime day) {
  var age = day.year - birthDate.year;
  final hadBirthday = day.month > birthDate.month || (day.month == birthDate.month && day.day >= birthDate.day);
  if (!hadBirthday) age--;
  return age;
}

/// Everything the energy calculation needs. Weight is the current (trend) weight.
class EnergyInput {
  const EnergyInput({
    required this.sex,
    required this.ageYears,
    required this.heightCm,
    required this.weightKg,
    required this.targetWeightKg,
    required this.jobActivity,
    this.sportMinutesPerWeek = 0,
    this.bodyFatPercent,
    this.targetDate,
    this.today,
    this.proteinPerKg = 1.8,
    this.fatPercent = 30,
    this.fiberTargetG = 30,
    this.calorieOverride,
    this.proteinOverrideG,
    this.waterOverrideMl,
  });

  final Sex sex;
  final int ageYears;
  final double heightCm;
  final double weightKg;
  final double targetWeightKg;
  final JobActivity jobActivity;
  final int sportMinutesPerWeek;
  final double? bodyFatPercent;
  final DateTime? targetDate;
  final DateTime? today;
  final double proteinPerKg;
  final double fatPercent;
  final double fiberTargetG;
  final int? calorieOverride;
  final int? proteinOverrideG;
  final int? waterOverrideMl;
}

enum GoalDirection { lose, maintain, gain }

class EnergyResult {
  EnergyResult({
    required this.bmr,
    required this.bmrMethod,
    required this.pal,
    required this.tdee,
    required this.direction,
    required this.dailyDeltaKcal,
    required this.calculatedTargetKcal,
    required this.targetKcal,
    required this.isCalorieOverridden,
    required this.proteinG,
    required this.isProteinOverridden,
    required this.fatG,
    required this.carbsG,
    required this.fiberG,
    required this.waterMl,
    required this.weeklyChangeKg,
    required this.projectedGoalDate,
    required this.steps,
    required this.warnings,
  });

  final double bmr;
  final String bmrMethod;
  final double pal;
  final double tdee;
  final GoalDirection direction;

  /// Negative for a deficit, positive for a surplus (after safety limits).
  final double dailyDeltaKcal;
  final int calculatedTargetKcal;

  /// The target in use: the manual override if set, else the calculated target.
  final int targetKcal;
  final bool isCalorieOverridden;
  final int proteinG;
  final bool isProteinOverridden;
  final int fatG;
  final int carbsG;
  final int fiberG;
  final int waterMl;

  /// Expected weight change per week at [targetKcal] (negative = loss).
  final double weeklyChangeKg;

  /// When the target weight is reached at [targetKcal]; null if never/maintain.
  final DateTime? projectedGoalDate;
  final List<CalcStep> steps;
  final List<String> warnings;
}

String _kcal(num v) => '${v.round()} kcal';
String _f1(num v) => v.toStringAsFixed(1).replaceAll('.', ',');

/// Computes BMR, TDEE, the daily calorie target and macro targets.
///
/// Safety limits (each produces a visible warning):
/// - weight loss is capped at 1 % of body weight per week,
/// - weight gain at 0.5 % per week,
/// - the target never goes below 1500 kcal (men) / 1200 kcal (women).
EnergyResult calculateEnergy(EnergyInput i) {
  final steps = <CalcStep>[];
  final warnings = <String>[];

  // 1) Basal metabolic rate.
  late double bmr;
  late String method;
  final bf = i.bodyFatPercent;
  if (bf != null && bf > 3 && bf < 70) {
    bmr = bmrKatchMcArdle(weightKg: i.weightKg, bodyFatPercent: bf);
    method = 'Katch-McArdle';
    final lbm = i.weightKg * (1 - bf / 100);
    steps.add(CalcStep('Magermasse', '${_f1(i.weightKg)} kg × (1 − ${_f1(bf)} %)', '${_f1(lbm)} kg'));
    steps.add(CalcStep('Grundumsatz (Katch-McArdle)', '370 + 21,6 × ${_f1(lbm)}', _kcal(bmr)));
  } else {
    bmr = bmrMifflinStJeor(sex: i.sex, weightKg: i.weightKg, heightCm: i.heightCm, ageYears: i.ageYears);
    method = 'Mifflin-St Jeor';
    steps.add(
      CalcStep(
        'Grundumsatz (Mifflin-St Jeor)',
        '10 × ${_f1(i.weightKg)} + 6,25 × ${_f1(i.heightCm)} − 5 × ${i.ageYears} '
            '${i.sex == Sex.male ? '+ 5' : '− 161'}',
        _kcal(bmr),
      ),
    );
  }

  // 2) Total daily energy expenditure.
  final sportHours = math.max(0, i.sportMinutesPerWeek) / 60;
  final sportPal = math.min(maxSportPal, sportHours * palPerWeeklySportHour);
  final pal = i.jobActivity.pal + sportPal;
  final tdee = bmr * pal;
  steps.add(
    CalcStep(
      'Aktivitätsfaktor (PAL)',
      '${_f1(i.jobActivity.pal)} (${i.jobActivity.label}) + ${_f1(sportHours)} h Sport/Woche × 0,09',
      pal.toStringAsFixed(2).replaceAll('.', ','),
    ),
  );
  steps.add(CalcStep('Gesamtumsatz', '${_kcal(bmr)} × ${pal.toStringAsFixed(2).replaceAll('.', ',')}', _kcal(tdee)));

  // 3) Goal: deficit or surplus.
  final diffKg = i.targetWeightKg - i.weightKg;
  final direction = diffKg.abs() < 0.25
      ? GoalDirection.maintain
      : (diffKg < 0 ? GoalDirection.lose : GoalDirection.gain);
  final today = _dateOnly(i.today ?? DateTime.now());
  double delta = 0;
  if (direction != GoalDirection.maintain) {
    final maxWeeklyKg = i.weightKg * (direction == GoalDirection.lose ? 0.01 : 0.005);
    final maxDaily = maxWeeklyKg * kcalPerKg / 7;
    final target = i.targetDate;
    if (target != null && target.isAfter(today)) {
      final days = _dayDiff(today, _dateOnly(target));
      final needed = diffKg.abs() * kcalPerKg / days;
      steps.add(
        CalcStep('Benötigte Bilanz pro Tag', '${_f1(diffKg.abs())} kg × 7700 kcal ÷ $days Tage', _kcal(needed)),
      );
      delta = math.min(needed, maxDaily);
      if (needed > maxDaily) {
        warnings.add(
          direction == GoalDirection.lose
              ? 'Der Zeitraum erfordert mehr als 1 % Gewichtsverlust pro Woche. '
                    'Das Defizit wurde auf ${_kcal(maxDaily)} pro Tag begrenzt.'
              : 'Der Zeitraum erfordert mehr als 0,5 % Zunahme pro Woche. '
                    'Der Überschuss wurde auf ${_kcal(maxDaily)} pro Tag begrenzt.',
        );
      }
    } else {
      // No (valid) date: use a moderate default of 0.5 %/week loss, 0.25 %/week gain.
      delta = maxDaily / 2;
      steps.add(
        CalcStep(
          'Standardtempo (kein Zieldatum)',
          '${direction == GoalDirection.lose ? '0,5' : '0,25'} % von ${_f1(i.weightKg)} kg pro Woche',
          _kcal(delta),
        ),
      );
    }
    if (direction == GoalDirection.lose) delta = -delta;
  }

  var calculated = tdee + delta;
  final floor = i.sex == Sex.male ? 1500.0 : 1200.0;
  if (calculated < floor) {
    warnings.add(
      'Das berechnete Ziel lag unter ${_kcal(floor)}; es wurde auf diesen Mindestwert '
      'angehoben. Sprich sehr niedrige Kalorienziele bitte ärztlich ab.',
    );
    calculated = floor;
    delta = calculated - tdee;
  }
  final calculatedTarget = calculated.round();
  steps.add(
    CalcStep('Kalorienziel', '${_kcal(tdee)} ${delta < 0 ? '−' : '+'} ${_kcal(delta.abs())}', _kcal(calculatedTarget)),
  );

  final override = i.calorieOverride;
  final targetKcal = override ?? calculatedTarget;
  if (override != null) {
    steps.add(CalcStep('Eigenes Kalorienziel', 'manuell festgelegt', _kcal(override)));
    if (override < floor) {
      warnings.add('Dein eigenes Kalorienziel liegt unter ${_kcal(floor)}.');
    }
  }

  // 4) Macros.
  final refWeight = direction == GoalDirection.lose ? i.targetWeightKg : i.weightKg;
  final calculatedProtein = (i.proteinPerKg * refWeight).round();
  final proteinG = i.proteinOverrideG ?? calculatedProtein;
  steps.add(
    CalcStep(
      'Protein',
      i.proteinOverrideG != null
          ? 'manuell festgelegt'
          : '${_f1(i.proteinPerKg)} g × ${_f1(refWeight)} kg '
                '(${direction == GoalDirection.lose ? 'Zielgewicht' : 'aktuelles Gewicht'})',
      '$proteinG g',
    ),
  );
  final fatG = (targetKcal * i.fatPercent / 100 / 9).round();
  steps.add(CalcStep('Fett', '${_kcal(targetKcal)} × ${_f1(i.fatPercent)} % ÷ 9', '$fatG g'));
  final carbKcal = targetKcal - proteinG * 4 - fatG * 9;
  final carbsG = math.max(0, carbKcal / 4).round();
  steps.add(CalcStep('Kohlenhydrate', '(${_kcal(targetKcal)} − $proteinG g × 4 − $fatG g × 9) ÷ 4', '$carbsG g'));
  if (carbKcal < 0) {
    warnings.add('Protein und Fett übersteigen das Kalorienziel; für Kohlenhydrate bleibt nichts übrig.');
  }
  final fiberG = i.fiberTargetG.round();

  final waterMl = i.waterOverrideMl ?? (i.weightKg * 30).clamp(1500, 3500).round();
  steps.add(
    CalcStep(
      'Wasser',
      i.waterOverrideMl != null ? 'manuell festgelegt' : '30 ml × ${_f1(i.weightKg)} kg (1,5–3,5 l)',
      '$waterMl ml',
    ),
  );

  // 5) Projection at the target in use.
  final effectiveDelta = targetKcal - tdee;
  final weekly = effectiveDelta * 7 / kcalPerKg;
  DateTime? goalDate;
  if (direction != GoalDirection.maintain && weekly != 0 && (weekly < 0) == (diffKg < 0)) {
    final days = (diffKg.abs() / (weekly.abs() / 7)).ceil();
    goalDate = DateTime(today.year, today.month, today.day + days);
  }

  return EnergyResult(
    bmr: bmr,
    bmrMethod: method,
    pal: pal,
    tdee: tdee,
    direction: direction,
    dailyDeltaKcal: delta,
    calculatedTargetKcal: calculatedTarget,
    targetKcal: targetKcal,
    isCalorieOverridden: override != null,
    proteinG: proteinG,
    isProteinOverridden: i.proteinOverrideG != null,
    fatG: fatG,
    carbsG: carbsG,
    fiberG: fiberG,
    waterMl: waterMl,
    weeklyChangeKg: weekly,
    projectedGoalDate: goalDate,
    steps: steps,
    warnings: warnings,
  );
}

DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

/// Whole calendar days between two dates (DST-safe).
int _dayDiff(DateTime a, DateTime b) =>
    DateTime.utc(b.year, b.month, b.day).difference(DateTime.utc(a.year, a.month, a.day)).inDays;
