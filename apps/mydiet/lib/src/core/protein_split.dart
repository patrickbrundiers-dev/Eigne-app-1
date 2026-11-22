/// Protein spread over the day: a share of the daily protein target per meal.
/// Pure Dart. Only a guide for the diary; nothing is enforced.
library;

/// Weight of a meal without a fixed time (e.g. "Snacks") compared with a main meal.
const double untimedMealWeight = 0.5;

/// Protein target per meal: the daily target divided by the meal weights. Meals with a time
/// count 1, meals without a time count [untimedMealWeight].
/// Example: 150 g, Frühstück/Mittag/Abend + Snacks → 150 ÷ 3,5 = 43 g per main meal, 21 g for snacks.
/// [hasTime] has one entry per meal, in order; the result has the same order.
List<double> proteinPerMeal(double dailyTargetG, List<bool> hasTime) {
  if (hasTime.isEmpty || dailyTargetG <= 0) return [for (final _ in hasTime) 0];
  final weights = [for (final t in hasTime) t ? 1.0 : untimedMealWeight];
  final total = weights.reduce((a, b) => a + b);
  return [for (final w in weights) dailyTargetG * w / total];
}
