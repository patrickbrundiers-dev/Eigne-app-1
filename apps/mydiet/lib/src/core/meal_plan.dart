/// Weekly meal plan helpers: slot shares and a simple plan generator. Pure Dart, unit tested.
library;

import 'dart:math' as math;

/// Share of the daily calories for each meal. Snack slots get 10 % each, the
/// other meals split the rest equally.
Map<String, double> slotShares(List<({String id, String name})> slots) {
  bool isSnack(String n) => RegExp(r'snack|zwischen', caseSensitive: false).hasMatch(n);
  final snacks = slots.where((s) => isSnack(s.name)).length;
  final mains = slots.length - snacks;
  if (slots.isEmpty) return {};
  if (mains == 0) return {for (final s in slots) s.id: 1 / slots.length};
  final snackShare = math.min(0.1, 0.4 / math.max(1, snacks));
  final mainShare = (1 - snackShare * snacks) / mains;
  return {for (final s in slots) s.id: isSnack(s.name) ? snackShare : mainShare};
}

class PlanRecipe {
  const PlanRecipe({required this.id, required this.kcalPer100, required this.servingWeight, this.tags = const []});
  final String id;
  final double kcalPer100;

  /// Grams of the finished dish per serving.
  final double servingWeight;
  final List<String> tags;
}

class PlannedMeal {
  const PlannedMeal({required this.dayIndex, required this.slotId, required this.recipeId, required this.grams});
  final int dayIndex;
  final String slotId;
  final String recipeId;
  final double grams;

  @override
  String toString() => 'PlannedMeal($dayIndex, $slotId, $recipeId, $grams g)';
}

/// Fills [days] days with recipes from [pool] so that each meal gets its share of
/// [targetKcal]. Portions are scaled (0,5–2,5 servings, rounded to 10 g); a recipe is
/// not used twice on the same day and rotates through the week. Slots in [skipSlots]
/// (e.g. snacks) stay empty.
List<PlannedMeal> generatePlan({
  required List<PlanRecipe> pool,
  required Map<String, double> shares,
  required int days,
  required double targetKcal,
  Set<String> skipSlots = const {},
}) {
  final usable = pool.where((r) => r.kcalPer100 > 0 && r.servingWeight > 0).toList();
  if (usable.isEmpty || days <= 0 || !(targetKcal > 0)) return const [];
  final out = <PlannedMeal>[];
  var cursor = 0;
  for (var d = 0; d < days; d++) {
    final usedToday = <String>{};
    for (final e in shares.entries) {
      if (skipSlots.contains(e.key) || e.value <= 0) continue;
      PlanRecipe? pick;
      for (var k = 0; k < usable.length; k++) {
        final r = usable[(cursor + k) % usable.length];
        if (!usedToday.contains(r.id) || usable.length == 1) {
          pick = r;
          cursor = (cursor + k + 1) % usable.length;
          break;
        }
      }
      pick ??= usable[cursor++ % usable.length];
      usedToday.add(pick.id);
      final wantedKcal = targetKcal * e.value;
      var grams = wantedKcal / pick.kcalPer100 * 100;
      grams = grams.clamp(pick.servingWeight * 0.5, pick.servingWeight * 2.5);
      grams = (grams / 10).round() * 10.0;
      out.add(PlannedMeal(dayIndex: d, slotId: e.key, recipeId: pick.id, grams: math.max(10, grams)));
    }
  }
  return out;
}

/// Recipes whose tags contain all [wanted] tags (case-insensitive).
List<PlanRecipe> filterByTags(List<PlanRecipe> pool, Set<String> wanted) {
  if (wanted.isEmpty) return pool;
  final w = wanted.map((t) => t.toLowerCase()).toSet();
  return pool.where((r) => w.every((t) => r.tags.any((x) => x.toLowerCase() == t))).toList();
}
