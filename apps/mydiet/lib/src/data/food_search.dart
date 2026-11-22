import 'package:drift/drift.dart';

import '../core/fuzzy_search.dart';
import '../core/nutrition.dart' show normalizeName;
import 'database.dart';

/// How often each food was logged in the last [days] days (local, for sorting only).
Future<Map<String, int>> foodUsage(AppDatabase db, {int days = 180, DateTime? now}) async {
  final t = now ?? DateTime.now();
  final from = DateTime(t.year, t.month, t.day - days);
  final fromKey =
      '${from.year.toString().padLeft(4, '0')}-${from.month.toString().padLeft(2, '0')}-${from.day.toString().padLeft(2, '0')}';
  final rows = await db
      .customSelect(
        'SELECT food_id, COUNT(*) AS n FROM diary_entries '
        'WHERE deleted_at IS NULL AND food_id IS NOT NULL AND day_key >= ? GROUP BY food_id',
        variables: [Variable(fromKey)],
        readsFrom: {db.diaryEntries},
      )
      .get();
  return {for (final r in rows) r.read<String>('food_id'): r.read<int>('n')};
}

/// Search that forgives typos and puts what the user eats often first.
///
/// 1. The exact database search (all words contained). Its hits are re-sorted by usage
///    within equal fit.
/// 2. If it finds fewer than [fuzzyBelow] foods, all live foods are scored with an edit
///    distance per word and the best are added after the exact hits.
Future<List<Food>> smartSearchFoods(AppDatabase db, String query, {int limit = 50, int fuzzyBelow = 5}) async =>
    (await smartSearch(db, query, limit: limit, fuzzyBelow: fuzzyBelow)).foods;

/// Result of [smartSearch]: the foods to show and how many of them contain all
/// search words ([exactHits]); the rest are typo-tolerant guesses.
class FoodSearchResult {
  const FoodSearchResult(this.foods, this.exactHits);
  final List<Food> foods;
  final int exactHits;
  static const empty = FoodSearchResult([], 0);
}

/// Like [smartSearchFoods], but also says how many hits are exact (used to decide
/// whether Open Food Facts is asked while typing, core/online_search.dart).
Future<FoodSearchResult> smartSearch(AppDatabase db, String query, {int limit = 50, int fuzzyBelow = 5}) async {
  final words = normalizeName(query).split(' ').where((w) => w.isNotEmpty).toList();
  if (words.isEmpty) return FoodSearchResult.empty;
  final exact = await db.searchFoods(query, limit: limit);
  final usage = await foodUsage(db);
  final ranked = rankCandidates<Food>(
    queryWords: words,
    items: exact,
    key: (f) => f.foodKey.split('|').first,
    usage: (f) => usage[f.id] ?? 0,
    favorite: (f) => f.isFavorite,
    minScore: 0,
  );
  if (ranked.length >= fuzzyBelow) return FoodSearchResult(ranked.take(limit).toList(), ranked.length);
  final fuzzy = await fuzzyFoods(db, query, limit: limit, exclude: {for (final f in ranked) f.id}, usage: usage);
  return FoodSearchResult([...ranked, ...fuzzy].take(limit).toList(), ranked.length);
}

/// Only the typo-tolerant part: live foods whose name is similar to [query] (see
/// core/fuzzy_search.dart), best first.
Future<List<Food>> fuzzyFoods(
  AppDatabase db,
  String query, {
  int limit = 50,
  Set<String> exclude = const {},
  Map<String, int>? usage,
}) async {
  final words = normalizeName(query).split(' ').where((w) => w.isNotEmpty).toList();
  if (words.isEmpty) return const [];
  final counts = usage ?? await foodUsage(db);
  final all = await (db.select(db.foods)..where((f) => f.deletedAt.isNull())).get();
  return rankCandidates<Food>(
    queryWords: words,
    items: all.where((f) => !exclude.contains(f.id)),
    key: (f) => f.foodKey.split('|').first,
    usage: (f) => counts[f.id] ?? 0,
    favorite: (f) => f.isFavorite,
  ).take(limit).toList();
}
