/// Writing the diary's meals to Health Connect (ROADMAP Phase 4, queue 6.1 part 2).
/// Pure Dart, unit tested; the platform write is in `data/health_source.dart`.
///
/// Rules (see docs/BERECHNUNGEN.md, "Health Connect"):
/// - One nutrition record per meal of a day (sum of its entries), nothing for empty meals.
/// - Time: the meal's time from the settings, otherwise a typical time for the kind of meal.
/// - Rewriting a day first removes what Sattly wrote for that day, so edits and deletions carry over
///   and nothing is doubled.
library;

import 'nutrition.dart';

enum MealKind { breakfast, lunch, dinner, snack }

/// One meal as it is written.
class HealthMeal {
  const HealthMeal({
    required this.clientId,
    required this.day,
    required this.name,
    required this.kind,
    required this.start,
    required this.end,
    required this.nutrients,
  });

  /// Stable id per day and meal (`sattly:2026-11-22:<slotId>`).
  final String clientId;
  final String day;
  final String name;
  final MealKind kind;
  final DateTime start;
  final DateTime end;
  final Nutrients nutrients;

  @override
  String toString() => 'HealthMeal($clientId, $name, $kind, $start, ${nutrients.kcal} kcal)';
}

/// A meal slot of the diary as needed here.
typedef SlotInfo = ({String id, String name, int? minuteOfDay});

const _breakfast = ['frühstück', 'fruhstuck', 'fruehstueck', 'breakfast', 'morgen'];
const _lunch = ['mittag', 'lunch'];
const _dinner = ['abend', 'dinner', 'nacht'];
const _snack = ['snack', 'zwischen', 'imbiss', 'kaffee'];

/// Kind of meal from the name ("Frühstück", "Mittagessen" …), else from the time of day.
MealKind mealKindFor(String name, int? minuteOfDay) {
  final n = name.toLowerCase();
  bool any(List<String> words) => words.any(n.contains);
  if (any(_snack)) return MealKind.snack;
  if (any(_breakfast)) return MealKind.breakfast;
  if (any(_lunch)) return MealKind.lunch;
  if (any(_dinner)) return MealKind.dinner;
  final m = minuteOfDay;
  if (m == null) return MealKind.snack;
  if (m >= 4 * 60 && m < 10 * 60 + 30) return MealKind.breakfast;
  if (m >= 11 * 60 && m < 14 * 60 + 30) return MealKind.lunch;
  if (m >= 17 * 60 && m < 22 * 60) return MealKind.dinner;
  return MealKind.snack;
}

/// Typical time when a slot has none: 08:00, 12:30, 18:30, snacks 15:30.
int defaultMinuteFor(MealKind kind) => switch (kind) {
  MealKind.breakfast => 8 * 60,
  MealKind.lunch => 12 * 60 + 30,
  MealKind.dinner => 18 * 60 + 30,
  MealKind.snack => 15 * 60 + 30,
};

/// Meals of [day] (yyyy-MM-dd) from the totals per slot id. Slots without calories are left out,
/// unknown slot ids are written as snacks.
List<HealthMeal> planNutritionExport({
  required String day,
  required List<SlotInfo> slots,
  required Map<String, Nutrients> totalsBySlot,
}) {
  final date = DateTime.parse(day);
  final byId = {for (final s in slots) s.id: s};
  final order = [
    ...slots.map((s) => s.id).where(totalsBySlot.containsKey),
    ...totalsBySlot.keys.where((id) => !byId.containsKey(id)),
  ];
  final out = <HealthMeal>[];
  for (final id in order) {
    final n = totalsBySlot[id]!;
    if (!(n.kcal >= 1) || !n.kcal.isFinite) continue;
    final slot = byId[id];
    final name = slot?.name ?? 'Snack';
    final kind = mealKindFor(name, slot?.minuteOfDay);
    final minute = (slot?.minuteOfDay ?? defaultMinuteFor(kind)).clamp(0, 24 * 60 - 31);
    final start = DateTime(date.year, date.month, date.day, minute ~/ 60, minute % 60);
    out.add(
      HealthMeal(
        clientId: 'sattly:$day:$id',
        day: day,
        name: name,
        kind: kind,
        start: start,
        end: start.add(const Duration(minutes: 30)),
        nutrients: n,
      ),
    );
  }
  return out;
}
