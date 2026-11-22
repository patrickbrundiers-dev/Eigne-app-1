/// Meal entry from everyday text, without AI:
/// "200 g Hähnchen, 2 Eier und 1 Banane" → three lines with amount, unit and search words.
///
/// The parser only reads what was typed. Nutrition values always come from foods in the
/// user's own database; nothing is invented. Every guess (unit conversion, standard
/// portion, uncertain match) is flagged so the user confirms it before anything is saved.
library;

import 'nutrition.dart' show normalizeName;

/// What the amount in a line refers to.
enum TextUnit {
  gram,
  milliliter,

  /// Pieces or a named portion ("Stück", "Scheibe", "Becher", "Glas", "Portion" ...).
  piece,

  /// Tablespoon / teaspoon, converted with standard volumes.
  tablespoon,
  teaspoon,

  /// Only a number was typed ("2 Eier", "200 Hähnchen").
  none,
}

class ParsedLine {
  const ParsedLine({required this.raw, required this.query, this.amount, this.unit = TextUnit.none, this.pieceWord});

  /// The text of this line as typed.
  final String raw;

  /// Remaining words that name the food (normalised, filler words removed).
  final String query;

  /// Number typed for this line; null when there was none ("Banane").
  final double? amount;
  final TextUnit unit;

  /// The portion word that was typed ("scheibe", "becher" ...), for matching the food's serving label.
  final String? pieceWord;

  @override
  String toString() => 'ParsedLine($amount $unit "$query")';
}

/// Splits text into lines at commas, semicolons, line breaks, "+" and the word "und".
List<ParsedLine> parseMealText(String text) {
  final parts = text
      .split(RegExp(r'[,;\n+]|\s+und\s+|\s+sowie\s+', caseSensitive: false))
      .map((s) => s.trim())
      .where((s) => s.isNotEmpty);
  return [for (final p in parts) parseLine(p)].where((l) => l.query.isNotEmpty).toList();
}

const _numberWords = {
  'ein': 1.0,
  'eine': 1.0,
  'einen': 1.0,
  'einem': 1.0,
  'einer': 1.0,
  'zwei': 2.0,
  'drei': 3.0,
  'vier': 4.0,
  'fuenf': 5.0,
  'sechs': 6.0,
  'sieben': 7.0,
  'acht': 8.0,
  'neun': 9.0,
  'zehn': 10.0,
  'halbe': 0.5,
  'halber': 0.5,
  'halbes': 0.5,
  'halb': 0.5,
  'paar': 2.0,
};

const _gramWords = {'g', 'gr', 'gramm'};
const _kiloWords = {'kg', 'kilo', 'kilogramm'};
const _mlWords = {'ml', 'milliliter'};
const _literWords = {'l', 'liter'};
const _clWords = {'cl'};
const _tbspWords = {'el', 'essloeffel', 'essloeffeln'};
const _tspWords = {'tl', 'teeloeffel', 'teeloeffeln'};

/// Portion words, normalised, mapped to their singular.
const pieceWords = {
  'stueck': 'stueck',
  'stk': 'stueck',
  'scheibe': 'scheibe',
  'scheiben': 'scheibe',
  'becher': 'becher',
  'glas': 'glas',
  'glaeser': 'glas',
  'tasse': 'tasse',
  'tassen': 'tasse',
  'portion': 'portion',
  'portionen': 'portion',
  'handvoll': 'handvoll',
  'riegel': 'riegel',
  'dose': 'dose',
  'dosen': 'dose',
  'flasche': 'flasche',
  'flaschen': 'flasche',
  'packung': 'packung',
  'packungen': 'packung',
  'schale': 'schale',
  'schalen': 'schale',
  'teller': 'teller',
};

/// Words that carry no meaning for the search.
const _filler = {
  'ca',
  'circa',
  'etwa',
  'ungefaehr',
  'rund',
  'mit',
  'von',
  'vom',
  'der',
  'die',
  'das',
  'dem',
  'den',
  'des',
  'etwas',
  'bisschen',
  'noch',
  'gegessen',
  'getrunken',
  'hatte',
  'habe',
  'ich',
};

/// Parses one line. Numbers may use a comma ("1,5"), fractions ("1/2", "½") or words
/// ("zwei", "halbe"); units may stick to the number ("200g").
ParsedLine parseLine(String raw) {
  var s = raw.replaceAll('½', ' 0.5 ').replaceAll('¼', ' 0.25 ').replaceAll('¾', ' 0.75 ');
  // "200g" -> "200 g", "1,5l" -> "1,5 l"
  s = s.replaceAllMapped(RegExp(r'(\d)([a-zA-ZäöüÄÖÜß])'), (m) => '${m[1]} ${m[2]}');
  // Decimal comma between digits -> dot, before normalising removes the comma.
  s = s.replaceAllMapped(RegExp(r'(\d),(\d)'), (m) => '${m[1]}.${m[2]}');
  // Fractions "1/2" -> 0.5
  s = s.replaceAllMapped(RegExp(r'(\d+)\s*/\s*(\d+)'), (m) {
    final a = double.parse(m[1]!), b = double.parse(m[2]!);
    return b == 0 ? m[0]! : ' ${a / b} ';
  });
  final tokens = s
      .toLowerCase()
      .replaceAll('ä', 'ae')
      .replaceAll('ö', 'oe')
      .replaceAll('ü', 'ue')
      .replaceAll('ß', 'ss')
      .split(RegExp(r'[^a-z0-9.%]+'))
      // Dots only matter inside numbers ("1.5"); "ca." becomes "ca".
      .map((t) => double.tryParse(t) != null ? t : t.replaceAll('.', ''))
      .where((t) => t.isNotEmpty)
      .toList();

  double? amount;
  var unit = TextUnit.none;
  String? piece;
  final rest = <String>[];
  for (var i = 0; i < tokens.length; i++) {
    final tok = tokens[i];
    final n = double.tryParse(tok);
    if (n != null && amount == null && !_isPartOfName(tokens, i)) {
      amount = n;
      continue;
    }
    if (amount == null && _numberWords.containsKey(tok) && i + 1 < tokens.length) {
      amount = _numberWords[tok];
      continue;
    }
    if (unit == TextUnit.none) {
      if (_gramWords.contains(tok)) {
        unit = TextUnit.gram;
        continue;
      }
      if (_kiloWords.contains(tok)) {
        unit = TextUnit.gram;
        amount = (amount ?? 1) * 1000;
        continue;
      }
      if (_mlWords.contains(tok)) {
        unit = TextUnit.milliliter;
        continue;
      }
      if (_literWords.contains(tok)) {
        unit = TextUnit.milliliter;
        amount = (amount ?? 1) * 1000;
        continue;
      }
      if (_clWords.contains(tok)) {
        unit = TextUnit.milliliter;
        amount = (amount ?? 1) * 10;
        continue;
      }
      if (_tbspWords.contains(tok)) {
        unit = TextUnit.tablespoon;
        continue;
      }
      if (_tspWords.contains(tok)) {
        unit = TextUnit.teaspoon;
        continue;
      }
      if (pieceWords.containsKey(tok)) {
        unit = TextUnit.piece;
        piece = pieceWords[tok];
        continue;
      }
    }
    if (_filler.contains(tok)) continue;
    rest.add(tok);
  }
  return ParsedLine(raw: raw.trim(), query: rest.join(' '), amount: amount, unit: unit, pieceWord: piece);
}

/// A number directly followed by "%" belongs to the name ("Milch 1.5 %" is handled by
/// the tokenizer keeping "%"), as does a number after the first name word ("Cola 0").
bool _isPartOfName(List<String> tokens, int i) => i + 1 < tokens.length && tokens[i + 1] == '%';

/// Search terms for a parsed query, best first: synonyms, the whole query, then each
/// word in singular forms. The database search is tried with each until something matches.
List<String> searchTermsFor(String query) {
  final q = normalizeName(query);
  if (q.isEmpty) return const [];
  final out = <String>[];
  void add(String s) {
    final n = normalizeName(s);
    if (n.isNotEmpty && !out.contains(n)) out.add(n);
  }

  final syn = _synonyms[q] ?? _synonyms[_singular(q)];
  if (syn != null) add(syn);
  add(q);
  final words = q.split(' ');
  if (words.length > 1) {
    add(words.map(_singular).join(' '));
  } else {
    add(_singular(q));
  }
  for (final w in words) {
    final s = _synonyms[w] ?? _synonyms[_singular(w)];
    if (s != null) add(s);
  }
  // Longest word alone as a last resort ("gebratenes haehnchen" -> "haehnchen").
  final longest = [...words]..sort((a, b) => b.length.compareTo(a.length));
  if (longest.first.length >= 4) add(_singular(longest.first));
  return out;
}

/// Everyday words for foods in the base database (normalised keys).
const _synonyms = {
  'ei': 'huehnerei',
  'eier': 'huehnerei',
  'spiegelei': 'huehnerei',
  'ruehrei': 'huehnerei',
  'haehnchen': 'haehnchenbrust',
  'huehnchen': 'haehnchenbrust',
  'haehnchenbrust': 'haehnchenbrust',
  'pute': 'putenbrust',
  'hack': 'rinderhackfleisch',
  'hackfleisch': 'rinderhackfleisch',
  'kartoffel': 'kartoffeln',
  'pommes': 'pommes frites',
  'nudel': 'nudeln',
  'pasta': 'nudeln',
  'spaghetti': 'nudeln',
  'joghurt': 'naturjoghurt',
  'quark': 'magerquark',
  'milch': 'milch 1 5',
  'kaffee': 'kaffee schwarz',
  'apfel': 'apfel',
  'aepfel': 'apfel',
  'toast': 'toastbrot',
  'muesli': 'muesli',
  'oel': 'olivenoel',
  'linsen': 'rote linsen',
  'thunfisch': 'thunfisch',
  'lachs': 'lachs roh',
  'reis': 'reis gekocht',
};

/// Simple German plural → singular for search ("bananen" -> "banane", "eier" -> "ei").
String _singular(String w) {
  if (w.length <= 3) return w;
  if (w.endsWith('nen')) return w.substring(0, w.length - 1); // bananen -> banane
  if (w.endsWith('en')) return w.substring(0, w.length - 1); // tomaten -> tomate? keep 'e'
  if (w.endsWith('er') && w.length > 4) return w.substring(0, w.length - 2); // eier -> ei
  if (w.endsWith('n') || w.endsWith('s')) return w.substring(0, w.length - 1);
  return w;
}

// ---------------------------------------------------------------- amounts

/// The minimal food facts the amount resolution needs.
class FoodUnitInfo {
  const FoodUnitInfo({required this.unit, this.servingAmount, this.servingLabel});

  /// "g" or "ml".
  final String unit;
  final double? servingAmount;
  final String? servingLabel;
}

class ResolvedAmount {
  const ResolvedAmount(this.amount, {this.note, this.isEstimate = false});

  /// In the food's unit (g or ml); null when the user has to enter it.
  final double? amount;

  /// Why the amount is an assumption, shown next to the line.
  final String? note;
  final bool isEstimate;
}

/// Standard volumes (DIN measuring spoons, level): 1 EL = 15 ml, 1 TL = 5 ml.
const double tablespoonMl = 15;
const double teaspoonMl = 5;

/// Numbers without a unit up to this value are pieces ("2 Eier"), above it grams ("200 Hähnchen").
const double maxPiecesWithoutUnit = 10;

/// Converts what was typed into an amount in the food's own unit.
ResolvedAmount resolveAmount(ParsedLine line, FoodUnitInfo food, {double? usualAmount}) {
  final n = line.amount;
  final serving = food.servingAmount;
  final label = food.servingLabel;
  final foodIsMl = food.unit == 'ml';
  switch (line.unit) {
    case TextUnit.gram:
      return ResolvedAmount(n, note: foodIsMl ? '1 g ≈ 1 ml angenommen' : null, isEstimate: foodIsMl);
    case TextUnit.milliliter:
      return ResolvedAmount(n, note: foodIsMl ? null : '1 ml ≈ 1 g angenommen', isEstimate: !foodIsMl);
    case TextUnit.tablespoon:
      return ResolvedAmount((n ?? 1) * tablespoonMl, note: '1 EL ≈ 15 ${food.unit} angenommen', isEstimate: true);
    case TextUnit.teaspoon:
      return ResolvedAmount((n ?? 1) * teaspoonMl, note: '1 TL ≈ 5 ${food.unit} angenommen', isEstimate: true);
    case TextUnit.piece:
      if (serving == null) {
        return const ResolvedAmount(null, note: 'keine Portionsgröße hinterlegt, bitte Menge angeben');
      }
      final matches = line.pieceWord == null || label == null || _labelMatches(label, line.pieceWord!);
      return ResolvedAmount(
        (n ?? 1) * serving,
        note: matches ? null : '1 ${_cap(line.pieceWord!)} als 1 $label (${_fmt(serving)} ${food.unit}) angenommen',
        isEstimate: !matches,
      );
    case TextUnit.none:
      if (n != null && n > maxPiecesWithoutUnit) {
        return ResolvedAmount(n, note: 'als ${food.unit} gelesen', isEstimate: false);
      }
      if (serving != null) {
        return ResolvedAmount(
          (n ?? 1) * serving,
          note: n == null ? '1 $label angenommen' : null,
          isEstimate: n == null,
        );
      }
      if (usualAmount != null) {
        return ResolvedAmount(
          (n ?? 1) * usualAmount,
          note: 'deine übliche Menge (${_fmt(usualAmount)} ${food.unit})',
          isEstimate: true,
        );
      }
      return const ResolvedAmount(null, note: 'Menge fehlt');
  }
}

bool _labelMatches(String label, String piece) {
  final l = normalizeName(label);
  return l.startsWith(piece) || (piece == 'stueck' && l.startsWith('stueck'));
}

String _cap(String s) => s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);

String _fmt(double v) => v == v.roundToDouble() ? v.toStringAsFixed(0) : v.toStringAsFixed(1).replaceAll('.', ',');

// ---------------------------------------------------------------- match quality

/// How well a found food fits the typed words.
enum MatchQuality {
  /// Name starts with the search term or equals it.
  good,

  /// Only contained somewhere in the name, or found through a fallback term.
  uncertain,

  /// Nothing found.
  none,
}

/// Rates the best candidate: good when its normalised name starts with [term] and the
/// term was one of the first two (synonym or the whole query).
MatchQuality matchQuality({required String foodName, required String term, required int termIndex}) {
  final k = normalizeName(foodName);
  if (termIndex <= 1 && (k == term || k.startsWith('$term ') || k.startsWith(term))) return MatchQuality.good;
  return MatchQuality.uncertain;
}
