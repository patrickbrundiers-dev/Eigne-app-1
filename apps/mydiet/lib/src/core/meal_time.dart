/// Which meal fits a point in time (for "Eintragen" without choosing a meal first).
library;

/// Index of the meal that is due at [nowMinute] (minutes since midnight): the last meal whose time is at most
/// 45 minutes ahead. Before the first meal it is the first one; meals without a time are skipped.
/// Returns 0 if no meal has a time, and -1 for an empty list.
int currentMealIndex(List<int?> minutes, int nowMinute) {
  if (minutes.isEmpty) return -1;
  var best = -1;
  var bestMinute = -1;
  var first = -1;
  var firstMinute = 1 << 30;
  for (var i = 0; i < minutes.length; i++) {
    final m = minutes[i];
    if (m == null) continue;
    if (m < firstMinute) {
      first = i;
      firstMinute = m;
    }
    if (m <= nowMinute + 45 && m > bestMinute) {
      best = i;
      bestMinute = m;
    }
  }
  if (best >= 0) return best;
  return first >= 0 ? first : 0;
}
