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

// ---------------------------------------------------------------------------
// Profile filters (AI_TASK_QUEUE 4.1): intolerances, dislikes, preferences.

/// Lower case, umlauts and ß folded, so "Käse", "kaese" and "KÄSE" compare equal.
String foldText(String s) => s
    .toLowerCase()
    .replaceAll('ä', 'ae')
    .replaceAll('ö', 'oe')
    .replaceAll('ü', 'ue')
    .replaceAll('ß', 'ss')
    .replaceAll(RegExp(r'[^a-z0-9 ]'), ' ')
    .trim();

/// What an intolerance or allergy entry stands for. Entries not listed here match themselves.
/// Deliberately broad: a recipe wrongly left out is harmless, one wrongly planned is not.
const avoidSynonyms = <String, List<String>>{
  'laktose': [
    'milch',
    'joghurt',
    'jogurt',
    'kaese',
    'quark',
    'sahne',
    'butter',
    'skyr',
    'kefir',
    'mozzarella',
    'feta',
    'parmesan',
    'frischkaese',
    'molke',
    'schmand',
    'creme fraiche',
  ],
  'lactose': [
    'milch',
    'joghurt',
    'kaese',
    'quark',
    'sahne',
    'butter',
    'skyr',
    'kefir',
    'mozzarella',
    'feta',
    'parmesan',
  ],
  'milch': ['milch', 'joghurt', 'kaese', 'quark', 'sahne', 'butter', 'skyr', 'kefir', 'mozzarella', 'feta', 'parmesan'],
  'gluten': [
    'weizen',
    'dinkel',
    'roggen',
    'gerste',
    'hafer',
    'nudel',
    'pasta',
    'spaghetti',
    'brot',
    'broetchen',
    'mehl',
    'couscous',
    'bulgur',
    'seitan',
    'graupen',
    'gruenkern',
    'toast',
    'semmel',
    'paniermehl',
  ],
  'zoeliakie': [
    'weizen',
    'dinkel',
    'roggen',
    'gerste',
    'hafer',
    'nudel',
    'pasta',
    'brot',
    'mehl',
    'couscous',
    'bulgur',
  ],
  'nuesse': [
    'nuss',
    'nuesse',
    'mandel',
    'haselnuss',
    'walnuss',
    'cashew',
    'pistazie',
    'pekannuss',
    'macadamia',
    'paranuss',
  ],
  'nuss': [
    'nuss',
    'nuesse',
    'mandel',
    'haselnuss',
    'walnuss',
    'cashew',
    'pistazie',
    'pekannuss',
    'macadamia',
    'paranuss',
  ],
  'erdnuss': ['erdnuss', 'erdnuesse', 'erdnussbutter'],
  'erdnuesse': ['erdnuss', 'erdnuesse', 'erdnussbutter'],
  'ei': ['ei', 'eier', 'eigelb', 'eiweiss', 'eiklar', 'ruehrei', 'spiegelei', 'huehnerei', 'mayonnaise'],
  'eier': ['ei', 'eier', 'eigelb', 'eiweiss', 'eiklar', 'ruehrei', 'spiegelei', 'huehnerei', 'mayonnaise'],
  'fisch': [
    'fisch',
    'lachs',
    'thunfisch',
    'kabeljau',
    'seelachs',
    'forelle',
    'hering',
    'makrele',
    'sardine',
    'dorsch',
    'alaska',
  ],
  'meeresfruechte': ['garnele', 'shrimp', 'krabbe', 'muschel', 'tintenfisch', 'hummer', 'scampi'],
  'krebstiere': ['garnele', 'shrimp', 'krabbe', 'hummer', 'scampi', 'krebs'],
  'soja': ['soja', 'tofu', 'tempeh', 'edamame', 'miso'],
  'sellerie': ['sellerie'],
  'senf': ['senf'],
  'sesam': ['sesam', 'tahin', 'tahini'],
  'fruktose': ['honig', 'apfel', 'birne', 'mango', 'trauben', 'agave'],
  'histamin': ['salami', 'rotwein', 'sauerkraut', 'parmesan', 'thunfisch', 'tomate'],
};

/// Folded search terms for one profile entry ("Laktose" → milk products, "Nüsse" → nuts …).
Set<String> avoidTermsFor(String entry) {
  final e = foldText(entry);
  if (e.isEmpty) return const {};
  return {e, ...?avoidSynonyms[e]};
}

/// Whether [term] occurs in [text] (both folded): short terms (up to three letters, e.g. "ei") only as a
/// whole word, longer ones anywhere, also inside compound words ("Vollmilchschokolade", "Haselnussmus").
/// Errs on the side of a match: leaving out a recipe too many is harmless, planning a wrong one is not.
bool mentions(String text, String term) {
  if (term.isEmpty) return false;
  if (term.length >= 4) return text.contains(term);
  return text.split(' ').contains(term);
}

/// Why a recipe is left out, or null. [names] are the recipe's name and its ingredient names.
/// Returns the profile entry and the word that matched, e.g. ("Laktose", "Joghurt").
({String entry, String found})? excludedBy(List<String> names, {List<String> avoid = const []}) {
  final folded = [for (final n in names) (raw: n, f: foldText(n))];
  for (final a in avoid) {
    for (final term in avoidTermsFor(a)) {
      for (final n in folded) {
        if (mentions(n.f, term)) return (entry: a.trim(), found: n.raw);
      }
    }
  }
  return null;
}

/// How many of the [preferred] entries a recipe contains (for ordering, not filtering).
int preferenceScore(List<String> names, List<String> preferred) {
  final folded = [for (final n in names) foldText(n)];
  var score = 0;
  for (final p in preferred) {
    final term = foldText(p);
    if (term.isNotEmpty && folded.any((n) => mentions(n, term))) score++;
  }
  return score;
}

/// Order for the generator: recipes with preferred foods first, the rest keep their order.
List<PlanRecipe> preferFirst(List<PlanRecipe> pool, Map<String, int> scores) {
  final indexed = [for (var i = 0; i < pool.length; i++) (i, pool[i])];
  indexed.sort((a, b) {
    final s = (scores[b.$2.id] ?? 0).compareTo(scores[a.$2.id] ?? 0);
    return s != 0 ? s : a.$1.compareTo(b.$1);
  });
  return [for (final e in indexed) e.$2];
}

/// Result of filling a plan: planned meals, and recipes left out (recipe name → reason).
class PlanFill {
  const PlanFill({required this.planned, this.skipped = const {}});
  final int planned;
  final Map<String, String> skipped;

  /// "Ausgelassen: Porridge (Gluten (Haferflocken)), Shake (Laktose (Milch))", at most [max] names.
  String? skippedText({int max = 3}) {
    if (skipped.isEmpty) return null;
    final shown = skipped.entries.take(max).map((e) => '${e.key} (${e.value})').join(', ');
    final more = skipped.length > max ? ' und ${skipped.length - max} weitere' : '';
    return 'Wegen Unverträglichkeiten oder Abneigungen im Profil ausgelassen: $shown$more.';
  }
}
