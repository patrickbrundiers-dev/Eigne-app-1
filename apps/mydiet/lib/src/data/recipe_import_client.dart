import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../core/meal_text.dart';
import '../core/recipe_import.dart';
import 'database.dart';
import 'meal_text_match.dart';

class RecipeImportException implements Exception {
  RecipeImportException(this.message);
  final String message;
  @override
  String toString() => message;
}

/// Loads a recipe page. Only the address the user entered is requested; no account, no cookies,
/// nothing about the user is sent.
class RecipePageClient {
  RecipePageClient({http.Client? client}) : _client = client ?? http.Client();
  final http.Client _client;

  static const userAgent = 'Mozilla/5.0 (compatible; RecipeImport/1.0)';
  static const maxBytes = 3 * 1024 * 1024;

  Future<ImportedRecipe> load(Uri uri) async {
    if (!(uri.isScheme('https') || uri.isScheme('http')) || uri.host.isEmpty) {
      throw RecipeImportException('Bitte eine Webadresse eingeben, die mit https:// beginnt.');
    }
    http.Response res;
    try {
      res = await _client
          .get(uri, headers: {'User-Agent': userAgent, 'Accept': 'text/html,application/xhtml+xml'})
          .timeout(const Duration(seconds: 15));
    } on TimeoutException {
      throw RecipeImportException('Die Seite antwortet nicht. Bitte später erneut versuchen.');
    } catch (_) {
      throw RecipeImportException('Die Seite konnte nicht geladen werden. Besteht eine Internetverbindung?');
    }
    if (res.statusCode != 200) throw RecipeImportException('Die Seite meldet Fehler ${res.statusCode}.');
    if (res.bodyBytes.length > maxBytes) throw RecipeImportException('Die Seite ist zu groß für den Import.');
    final html = utf8.decode(res.bodyBytes, allowMalformed: true);
    final r = parseRecipeHtml(html, source: uri);
    if (r == null) {
      throw RecipeImportException(
        'Auf dieser Seite wurden keine Rezeptdaten gefunden. Du kannst die Zutatenliste kopieren und hier einfügen.',
      );
    }
    return r;
  }
}

/// Replaceable in tests.
RecipePageClient Function() recipePageClientFactory = RecipePageClient.new;

/// Pasted text instead of an address: one ingredient per line.
ImportedRecipe recipeFromPastedText(String text, {String name = 'Importiertes Rezept'}) => ImportedRecipe(
  name: name,
  ingredients: [
    for (final l in text.split(RegExp(r'\r?\n')))
      if (cleanText(l.replaceFirst(RegExp(r'^\s*[-•*·]\s*'), '')).isNotEmpty)
        cleanText(l.replaceFirst(RegExp(r'^\s*[-•*·]\s*'), '')),
  ],
);

/// One ingredient line of an imported recipe and what it was matched to (nothing stored yet).
class IngredientMatch {
  IngredientMatch({required this.raw, required this.match, this.negligible = false});
  final String raw;

  /// Null for lines that are only a heading or "Salz, Pfeffer".
  final TextMatch? match;
  final bool negligible;
}

/// Matches every ingredient line against the user's own foods (offline). Lines with several foods
/// ("Salz und Pfeffer") give several entries.
Future<List<IngredientMatch>> matchIngredients(AppDatabase db, List<String> lines) async {
  final out = <IngredientMatch>[];
  for (final raw in lines) {
    final core = ingredientCore(raw);
    if (core.isEmpty || isNegligibleIngredient(core)) {
      out.add(IngredientMatch(raw: raw, match: null, negligible: true));
      continue;
    }
    final ms = await matchMealText(db, core);
    if (ms.isEmpty) {
      out.add(
        IngredientMatch(
          raw: raw,
          match: TextMatch(
            line: parseLine(core),
            candidates: const [],
            food: null,
            quality: MatchQuality.none,
            amount: const ResolvedAmount(null, note: 'nicht in deinen Lebensmitteln gefunden'),
          ),
        ),
      );
      continue;
    }
    for (final m in ms) {
      out.add(IngredientMatch(raw: ms.length == 1 ? raw : '$raw (${m.line.raw})', match: m));
    }
  }
  return out;
}
