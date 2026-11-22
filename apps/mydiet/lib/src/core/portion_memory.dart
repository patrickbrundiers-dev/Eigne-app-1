/// Learned portions: the amount the user usually logs for a food.
library;

/// The usual amount from the user's recent amounts for one food, newest first.
///
/// Rule: of the last [window] amounts (rounded to whole g/ml), the one that occurs most often; on a tie the
/// more recent one. One entry is enough (that amount is the best guess there is). Null without entries.
double? usualAmount(List<double> recentNewestFirst, {int window = 10}) {
  final recent = [
    for (final a in recentNewestFirst.take(window))
      if (a > 0) a.roundToDouble(),
  ];
  if (recent.isEmpty) return null;
  final counts = <double, int>{};
  for (final a in recent) {
    counts[a] = (counts[a] ?? 0) + 1;
  }
  var best = recent.first;
  for (final a in recent) {
    // `recent` is newest first, so the first amount reaching the top count wins a tie.
    if (counts[a]! > counts[best]!) best = a;
  }
  return best;
}
