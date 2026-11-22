import '../core/dates.dart';
import '../core/energy.dart';
import '../core/weight_trend.dart';
import 'database.dart';

List<WeightPoint> weightPoints(List<WeightEntry> entries) => [
  for (final e in entries) WeightPoint(parseDayKey(e.dayKey), e.weightKg),
];

/// Current weight used for calculations: the 7-day trend, falling back to the
/// latest entry and then to the start weight from the profile.
double currentWeight(Profile p, WeightAnalysis a) => a.trendKg ?? a.latest?.kg ?? p.startWeightKg;

/// Latest body fat value: the most recent weight entry that has one, else the profile.
double? currentBodyFat(Profile p, List<WeightEntry> entries) {
  for (final e in entries.reversed) {
    if (e.bodyFatPercent != null) return e.bodyFatPercent;
  }
  return p.bodyFatPercent;
}

EnergyInput energyInputFor(Profile p, List<WeightEntry> weights, {DateTime? today}) {
  final now = today ?? DateTime.now();
  final analysis = analyzeWeight(weightPoints(weights), targetKg: p.targetWeightKg);
  return EnergyInput(
    sex: p.sex == 'female' ? Sex.female : Sex.male,
    ageYears: ageOn(p.birthDate, now),
    heightCm: p.heightCm,
    weightKg: currentWeight(p, analysis),
    targetWeightKg: p.targetWeightKg,
    jobActivity: JobActivity.values.firstWhere((j) => j.name == p.jobActivity, orElse: () => JobActivity.sitting),
    sportMinutesPerWeek: p.sportMinutesPerWeek,
    bodyFatPercent: currentBodyFat(p, weights),
    targetDate: p.targetDate,
    today: now,
    proteinPerKg: p.proteinPerKg,
    fatPercent: p.fatPercent,
    carbCapG: p.carbCapG,
    fiberTargetG: p.fiberTargetG,
    calorieOverride: p.calorieOverride,
    proteinOverrideG: p.proteinOverrideG,
    waterOverrideMl: p.waterOverrideMl,
  );
}

EnergyResult targetsFor(Profile p, List<WeightEntry> weights, {DateTime? today}) =>
    calculateEnergy(energyInputFor(p, weights, today: today));

String todayDayKey() => dayKey(DateTime.now());
