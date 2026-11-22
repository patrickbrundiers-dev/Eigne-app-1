/// Typo-tolerant food search ranking, pure Dart.
///
/// The database search finds names that contain every typed word. When that finds
/// little (typos like "Haferflokcen", "Joghurd", missing letters), names are scored
/// word by word with an edit distance, and the user's own usage breaks ties:
/// foods eaten often come first.
library;

import 'dart:math' as math;

/// Optimal string alignment distance (Levenshtein plus swapped neighbours, "kc" ↔ "ck").
int editDistance(String a, String b, {int? max}) {
  if (a == b) return 0;
  if (a.isEmpty) return b.length;
  if (b.isEmpty) return a.length;
  if (max != null && (a.length - b.length).abs() > max) return max + 1;
  var prev2 = List<int>.filled(b.length + 1, 0);
  var prev = List<int>.generate(b.length + 1, (j) => j);
  var cur = List<int>.filled(b.length + 1, 0);
  for (var i = 1; i <= a.length; i++) {
    cur[0] = i;
    var rowMin = cur[0];
    for (var j = 1; j <= b.length; j++) {
      final cost = a.codeUnitAt(i - 1) == b.codeUnitAt(j - 1) ? 0 : 1;
      var v = math.min(math.min(prev[j] + 1, cur[j - 1] + 1), prev[j - 1] + cost);
      if (i > 1 && j > 1 && a.codeUnitAt(i - 1) == b.codeUnitAt(j - 2) && a.codeUnitAt(i - 2) == b.codeUnitAt(j - 1)) {
        v = math.min(v, prev2[j - 2] + 1);
      }
      cur[j] = v;
      if (v < rowMin) rowMin = v;
    }
    if (max != null && rowMin > max) return max + 1;
    final t = prev2;
    prev2 = prev;
    prev = cur;
    cur = t;
  }
  return prev[b.length];
}

/// Typos allowed for a typed word: none up to 3 letters, 1 up to 6, then 2.
int allowedTypos(String word) => word.length <= 3 ? 0 : (word.length <= 6 ? 1 : 2);

/// How well one typed word fits a name word, 0 (no) to 1 (exact).
/// Prefixes count ("hafer" fits "haferflocken"), also with typos in the typed part.
double wordScore(String typed, String nameWord) {
  if (typed.isEmpty || nameWord.isEmpty) return 0;
  if (nameWord == typed) return 1;
  if (nameWord.startsWith(typed)) return 0.9;
  if (nameWord.contains(typed) && typed.length >= 4) return 0.75;
  final allowed = allowedTypos(typed);
  if (allowed == 0) return 0;
  final whole = editDistance(typed, nameWord, max: allowed);
  if (whole <= allowed) return 0.8 - 0.15 * whole;
  // Typo inside a prefix: compare with the start of the name word.
  if (nameWord.length > typed.length) {
    final head = nameWord.substring(0, math.min(nameWord.length, typed.length + allowed));
    var best = allowed + 1;
    for (var len = math.max(1, typed.length - allowed); len <= head.length; len++) {
      best = math.min(best, editDistance(typed, head.substring(0, len), max: allowed));
    }
    if (best <= allowed) return 0.7 - 0.15 * best;
  }
  return 0;
}

/// Score of a whole normalised name for normalised query words: every typed word must
/// fit some name word, the average fit is the score; 0 when any word does not fit.
double nameScore(List<String> queryWords, String normalisedName) {
  final words = normalisedName.split(' ').where((w) => w.isNotEmpty).toList();
  if (queryWords.isEmpty || words.isEmpty) return 0;
  var sum = 0.0;
  for (final q in queryWords) {
    var best = 0.0;
    for (final w in words) {
      final s = wordScore(q, w);
      if (s > best) best = s;
      if (best == 1) break;
    }
    if (best == 0) return 0;
    sum += best;
  }
  // Earlier match of the first word is slightly better ("apfel" before "apfelmus" over "bratapfel").
  final firstBonus = wordScore(queryWords.first, words.first) > 0 ? 0.05 : 0;
  return sum / queryWords.length + firstBonus;
}

class Ranked<T> {
  const Ranked(this.item, this.score);
  final T item;
  final double score;
}

/// Sorts candidates by fit, then usage count, then favourite, then shorter name.
List<T> rankCandidates<T>({
  required List<String> queryWords,
  required Iterable<T> items,
  required String Function(T) key,
  int Function(T)? usage,
  bool Function(T)? favorite,
  double minScore = 0.5,
}) {
  final scored = <Ranked<T>>[];
  for (final it in items) {
    final s = nameScore(queryWords, key(it));
    if (s >= minScore) scored.add(Ranked(it, s));
  }
  scored.sort((a, b) {
    // Scores within 0.05 count as equal, so usage can decide.
    final d = b.score - a.score;
    if (d.abs() > 0.05) return d > 0 ? 1 : -1;
    final ua = usage?.call(a.item) ?? 0, ub = usage?.call(b.item) ?? 0;
    if (ua != ub) return ub.compareTo(ua);
    final fa = favorite?.call(a.item) ?? false, fb = favorite?.call(b.item) ?? false;
    if (fa != fb) return fa ? -1 : 1;
    return key(a.item).length.compareTo(key(b.item).length);
  });
  return [for (final r in scored) r.item];
}
