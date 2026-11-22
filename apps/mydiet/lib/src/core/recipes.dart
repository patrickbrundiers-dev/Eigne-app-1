/// Recipe nutrition and shopping list aggregation. Pure Dart, unit tested.
library;

import 'nutrition.dart';

/// One ingredient: nutrients per 100 g/ml and the amount used in the recipe.
class Ingredient {
  const Ingredient({required this.per100, required this.amount, this.unit = 'g'});
  final Nutrients per100;
  final double amount;
  final String unit;

  Nutrients get nutrients => per100.forAmount(amount);
}

class RecipeNutrition {
  const RecipeNutrition({
    required this.total,
    required this.servings,
    required this.rawWeight,
    required this.finalWeight,
    required this.usesCookedWeight,
  });

  /// Sum over all ingredients.
  final Nutrients total;
  final double servings;

  /// Sum of the ingredient amounts (ml counted as g).
  final double rawWeight;

  /// Weight of the finished dish: the weighed cooked weight if known, else [rawWeight].
  final double finalWeight;
  final bool usesCookedWeight;

  Nutrients get perServing => servings > 0 ? total * (1 / servings) : Nutrients.zero;

  /// Per 100 g of the finished dish. Used to log a recipe by weight.
  Nutrients get per100 => finalWeight > 0 ? total * (100 / finalWeight) : Nutrients.zero;

  /// Grams of the finished dish per serving.
  double get servingWeight => servings > 0 ? finalWeight / servings : 0;
}

/// Totals, per serving and per 100 g of a recipe.
///
/// Cooking changes the weight (water evaporates, pasta absorbs water) but not the
/// nutrients, so the cooked weight only changes the values per 100 g.
RecipeNutrition recipeNutrition(List<Ingredient> items, {required double servings, double? cookedWeight}) {
  if (!(servings > 0)) throw ArgumentError('Portionen müssen größer als 0 sein.');
  final total = Nutrients.sum(items.map((i) => i.nutrients));
  final raw = items.fold<double>(0, (a, i) => a + i.amount);
  final useCooked = cookedWeight != null && cookedWeight > 0;
  return RecipeNutrition(
    total: total,
    servings: servings,
    rawWeight: raw,
    finalWeight: useCooked ? cookedWeight : raw,
    usesCookedWeight: useCooked,
  );
}

/// A line for the shopping list. Lines with the same [key] and [unit] are merged.
class ShoppingLine {
  const ShoppingLine({required this.key, required this.label, this.amount, this.unit});
  final String key;
  final String label;
  final double? amount;
  final String? unit;

  ShoppingLine copyWith({double? amount}) => ShoppingLine(key: key, label: label, amount: amount, unit: unit);
}

/// Merges lines with the same key and unit; amounts are added. A line without an
/// amount stays without one unless another line brings an amount.
List<ShoppingLine> mergeShopping(Iterable<ShoppingLine> lines) {
  final out = <String, ShoppingLine>{};
  for (final l in lines) {
    final k = '${l.key}|${l.unit ?? ''}';
    final prev = out[k];
    if (prev == null) {
      out[k] = l;
    } else if (l.amount != null || prev.amount != null) {
      out[k] = prev.copyWith(amount: (prev.amount ?? 0) + (l.amount ?? 0));
    }
  }
  return out.values.toList();
}

/// Scales ingredient amounts from the recipe's servings to the wanted servings.
double scaleAmount(double amount, {required double recipeServings, required double wantedServings}) {
  if (!(recipeServings > 0) || !(wantedServings > 0)) throw ArgumentError('Portionen müssen größer als 0 sein.');
  return amount * wantedServings / recipeServings;
}
