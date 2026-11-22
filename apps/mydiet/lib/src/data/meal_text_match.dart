import 'package:drift/drift.dart';

import '../core/meal_text.dart';
import 'database.dart';
import 'food_search.dart';

/// One recognised line: the parsed text, the best food and alternatives from the user's
/// own database, and the amount in the food's unit. Nothing is stored here.
class TextMatch {
  TextMatch({
    required this.line,
    required this.candidates,
    required this.food,
    required this.quality,
    required this.amount,
  });

  final ParsedLine line;

  /// Up to 6 foods found for the line, best first.
  final List<Food> candidates;
  Food? food;
  MatchQuality quality;
  ResolvedAmount amount;

  /// Lines without guesswork are pre-selected; everything else needs a tap to confirm.
  bool get isCertain => food != null && quality == MatchQuality.good && amount.amount != null && !amount.isEstimate;
}

/// Most recent amount the user logged for [foodId], used as "usual amount" when the
/// text has no unit and the food has no serving size.
Future<double?> lastLoggedAmount(AppDatabase db, String foodId) async {
  final row =
      await (db.select(db.diaryEntries)
            ..where((e) => e.foodId.equals(foodId) & e.deletedAt.isNull())
            ..orderBy([(e) => OrderingTerm.desc(e.createdAt)])
            ..limit(1))
          .getSingleOrNull();
  return row?.amount;
}

/// Resolves the amount of [line] for [food], using the user's last amount as a hint.
Future<ResolvedAmount> resolveFor(AppDatabase db, ParsedLine line, Food food) async {
  final usual = await lastLoggedAmount(db, food.id);
  return resolveAmount(
    line,
    FoodUnitInfo(unit: food.unit, servingAmount: food.servingAmount, servingLabel: food.servingLabel),
    usualAmount: usual,
  );
}

/// Parses [text] and looks every line up in the local database (offline, nothing is sent).
Future<List<TextMatch>> matchMealText(AppDatabase db, String text) async {
  final out = <TextMatch>[];
  for (final line in parseMealText(text)) {
    final terms = searchTermsFor(line.query);
    var found = <Food>[];
    var termIndex = -1;
    for (var i = 0; i < terms.length; i++) {
      found = await db.searchFoods(terms[i], limit: 6);
      if (found.isNotEmpty) {
        termIndex = i;
        break;
      }
    }
    var fuzzy = false;
    if (found.isEmpty) {
      // Typo tolerance: similar names are offered, but never preselected.
      found = await fuzzyFoods(db, line.query, limit: 6);
      fuzzy = found.isNotEmpty;
    }
    if (found.isEmpty) {
      out.add(
        TextMatch(
          line: line,
          candidates: const [],
          food: null,
          quality: MatchQuality.none,
          amount: const ResolvedAmount(null, note: 'nicht in deinen Lebensmitteln gefunden'),
        ),
      );
      continue;
    }
    final best = found.first;
    out.add(
      TextMatch(
        line: line,
        candidates: found,
        food: best,
        quality: fuzzy
            ? MatchQuality.uncertain
            : matchQuality(foodName: best.name, term: terms[termIndex], termIndex: termIndex),
        amount: await resolveFor(db, line, best),
      ),
    );
  }
  return out;
}
