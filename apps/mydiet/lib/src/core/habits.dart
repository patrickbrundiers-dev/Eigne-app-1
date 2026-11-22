/// Recurring meals ("Gewohnheiten"): the same foods in the same meal on several days.
/// Pure Dart; the data layer turns a suggestion into a meal template after the user agrees.
library;

/// One logged meal: a day, a meal slot and the foods in it (food id, or the name for entries
/// without a food).
class LoggedMeal {
  const LoggedMeal({required this.day, required this.slotId, required this.foods, this.names = const {}});
  final DateTime day;
  final String slotId;
  final Set<String> foods;

  /// Display name per food key.
  final Map<String, String> names;
}

class HabitSuggestion {
  const HabitSuggestion({
    required this.slotId,
    required this.foods,
    required this.names,
    required this.count,
    required this.windowDays,
    required this.lastDay,
  });

  final String slotId;

  /// The food keys that came together; sorted for a stable [key].
  final List<String> foods;
  final List<String> names;

  /// Meals in the window that contained all of [foods].
  final int count;
  final int windowDays;

  /// The latest day on which exactly this meal was eaten (the template is copied from it).
  final DateTime lastDay;

  /// Identifies the suggestion, e.g. for "nicht mehr vorschlagen".
  String get key => '$slotId:${foods.join('+')}';

  String get title => names.join(', ');
  String get reason => '$count× in den letzten ${windowDays ~/ 7} Wochen';
}

/// Rules: meals with at least [minFoods] foods, in the last [windowDays] days up to [today].
/// A meal is a habit when at least [minCount] meals of the same slot contain all its foods.
/// Meals already saved as a template ([templates], each a set of food keys for that slot)
/// and dismissed suggestions ([dismissed] keys) are left out. Best first: more often, then more foods.
List<HabitSuggestion> findHabits({
  required List<LoggedMeal> meals,
  required DateTime today,
  Map<String, List<Set<String>>> templates = const {},
  Set<String> dismissed = const {},
  int windowDays = 28,
  int minCount = 3,
  int minFoods = 2,
  int max = 3,
}) {
  final end = DateTime(today.year, today.month, today.day);
  final start = end.subtract(Duration(days: windowDays - 1));
  final recent = [
    for (final m in meals)
      if (!m.day.isBefore(start) && !m.day.isAfter(end) && m.foods.length >= minFoods) m,
  ];
  final out = <String, HabitSuggestion>{};
  for (final cand in recent) {
    final sorted = cand.foods.toList()..sort();
    final key = '${cand.slotId}:${sorted.join('+')}';
    if (out.containsKey(key) || dismissed.contains(key)) continue;
    final same = recent.where((m) => m.slotId == cand.slotId && m.foods.containsAll(cand.foods)).toList();
    if (same.length < minCount) continue;
    final known = templates[cand.slotId] ?? const [];
    if (known.any((t) => t.length == cand.foods.length && t.containsAll(cand.foods))) continue;
    final exact = recent.where((m) => m.slotId == cand.slotId && _sameSet(m.foods, cand.foods));
    final last = exact.map((m) => m.day).reduce((a, b) => a.isAfter(b) ? a : b);
    out[key] = HabitSuggestion(
      slotId: cand.slotId,
      foods: sorted,
      names: [for (final f in sorted) cand.names[f] ?? f],
      count: same.length,
      windowDays: windowDays,
      lastDay: last,
    );
  }
  // Drop suggestions that are a subset of a bigger one with the same count (the bigger meal says more).
  final list = out.values.where((s) {
    return !out.values.any(
      (o) =>
          o != s &&
          o.slotId == s.slotId &&
          o.count >= s.count &&
          o.foods.length > s.foods.length &&
          o.foods.toSet().containsAll(s.foods),
    );
  }).toList();
  list.sort((a, b) {
    final c = b.count.compareTo(a.count);
    if (c != 0) return c;
    return b.foods.length.compareTo(a.foods.length);
  });
  return list.take(max).toList();
}

bool _sameSet(Set<String> a, Set<String> b) => a.length == b.length && a.containsAll(b);
