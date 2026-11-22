/// Daily calorie budget including the (optional) activity credit.
///
/// Double counting is prevented twice:
/// 1. Planned sport is already part of the activity factor (PAL) of the calorie target.
///    Activity calories are therefore credited only to the share the user chose
///    (default 0 %), never automatically in full.
/// 2. The same activity from one source is counted once ([ActivityItem.dedupKey]).
library;

import 'nutrition.dart';

class ActivityItem {
  const ActivityItem({required this.kcal, required this.source, this.externalId, this.id});
  final double kcal;
  final String source;
  final String? externalId;
  final String? id;

  /// Imported activities carry an external id; manual ones are unique by row id.
  String get dedupKey => externalId != null ? '$source:$externalId' : 'row:$id';
}

class DayBudget {
  const DayBudget({
    required this.targetKcal,
    required this.consumed,
    required this.activityKcal,
    required this.activityCreditKcal,
  });

  final int targetKcal;
  final Nutrients consumed;
  final double activityKcal;
  final double activityCreditKcal;

  double get budgetKcal => targetKcal + activityCreditKcal;
  double get remainingKcal => budgetKcal - consumed.kcal;
  double get progress => budgetKcal <= 0 ? 0 : (consumed.kcal / budgetKcal);
}

double totalActivityKcal(Iterable<ActivityItem> items) {
  final seen = <String>{};
  var sum = 0.0;
  for (final a in items) {
    if (seen.add(a.dedupKey)) sum += a.kcal < 0 ? 0 : a.kcal;
  }
  return sum;
}

DayBudget dayBudget({
  required int targetKcal,
  required Nutrients consumed,
  required Iterable<ActivityItem> activities,
  required int creditPercent,
}) {
  final total = totalActivityKcal(activities);
  final pct = creditPercent.clamp(0, 100);
  return DayBudget(
    targetKcal: targetKcal,
    consumed: consumed,
    activityKcal: total,
    activityCreditKcal: total * pct / 100,
  );
}
