/// Recipe import from a web page (ARBEITSPLAN W9). Pure Dart, unit tested.
///
/// Reads the schema.org "Recipe" data that most recipe sites embed as JSON-LD for search engines.
/// Only name, servings, ingredient lines, steps, time and keywords are taken; nutrition values on
/// the page are ignored on purpose, because the app computes them from the matched foods.
library;

import 'dart:convert';

class ImportedRecipe {
  const ImportedRecipe({
    required this.name,
    required this.ingredients,
    this.servings,
    this.instructions,
    this.totalMinutes,
    this.tags = const [],
    this.source,
  });

  final String name;

  /// Ingredient lines as written on the page ("200 g Spaghetti").
  final List<String> ingredients;

  /// From recipeYield; null when the page gives none (the user enters it).
  final double? servings;
  final String? instructions;
  final int? totalMinutes;
  final List<String> tags;
  final Uri? source;
}

/// Finds the first schema.org Recipe in the JSON-LD blocks of [html]. Null when the page has none.
ImportedRecipe? parseRecipeHtml(String html, {Uri? source}) {
  final blocks = RegExp(
    r'''<script[^>]*type\s*=\s*["']application/ld\+json["'][^>]*>([\s\S]*?)</script>''',
    caseSensitive: false,
  ).allMatches(html);
  for (final b in blocks) {
    Object? data;
    try {
      data = jsonDecode(b.group(1)!.trim());
    } on FormatException {
      continue;
    }
    final node = _findRecipe(data);
    if (node != null) {
      final r = recipeFromJsonLd(node, source: source);
      if (r != null) return r;
    }
  }
  return null;
}

Map<String, dynamic>? _findRecipe(Object? data, [int depth = 0]) {
  if (depth > 6 || data == null) return null;
  if (data is List) {
    for (final e in data) {
      final r = _findRecipe(e, depth + 1);
      if (r != null) return r;
    }
    return null;
  }
  if (data is! Map) return null;
  final m = data.cast<String, dynamic>();
  final type = m['@type'];
  final isRecipe = type is String
      ? type.toLowerCase() == 'recipe'
      : type is List && type.any((t) => t is String && t.toLowerCase() == 'recipe');
  if (isRecipe) return m;
  for (final key in const ['@graph', 'mainEntity', 'mainEntityOfPage', 'itemListElement', 'item']) {
    final r = _findRecipe(m[key], depth + 1);
    if (r != null) return r;
  }
  return null;
}

/// Builds an [ImportedRecipe] from one JSON-LD Recipe object. Null without name or ingredients.
ImportedRecipe? recipeFromJsonLd(Map<String, dynamic> m, {Uri? source}) {
  final name = cleanText(_string(m['name']) ?? '');
  final raw = m['recipeIngredient'] ?? m['ingredients'];
  final ingredients = [
    for (final s in raw is List ? raw : [raw])
      if (s is String && cleanText(s).isNotEmpty) cleanText(s),
  ];
  if (name.isEmpty || ingredients.isEmpty) return null;
  final tags = <String>{
    for (final key in const ['recipeCategory', 'recipeCuisine', 'keywords']) ..._list(m[key]),
  }.where((t) => t.length <= 30).take(8).toList();
  return ImportedRecipe(
    name: name.length > 120 ? name.substring(0, 120) : name,
    ingredients: ingredients,
    servings: parseYield(m['recipeYield']),
    instructions: _instructions(m['recipeInstructions']),
    totalMinutes: parseIsoMinutes(_string(m['totalTime'])) ?? _sumTimes(m),
    tags: tags,
    source: source,
  );
}

String? _string(Object? v) => switch (v) {
  final String s => s,
  final List l when l.isNotEmpty => _string(l.first),
  final Map mm => _string(mm['name'] ?? mm['text'] ?? mm['@value']),
  _ => null,
};

List<String> _list(Object? v) => switch (v) {
  final String s => [for (final p in s.split(',')) cleanText(p)].where((p) => p.isNotEmpty).toList(),
  final List l => [for (final e in l) ..._list(e)],
  final Map mm => _list(mm['name']),
  _ => const [],
};

int? _sumTimes(Map<String, dynamic> m) {
  final prep = parseIsoMinutes(_string(m['prepTime']));
  final cook = parseIsoMinutes(_string(m['cookTime']));
  if (prep == null && cook == null) return null;
  return (prep ?? 0) + (cook ?? 0);
}

String? _instructions(Object? v) {
  final steps = <String>[];
  void walk(Object? x) {
    switch (x) {
      case final String s:
        final t = cleanText(s);
        if (t.isNotEmpty) steps.add(t);
      case final List l:
        l.forEach(walk);
      case final Map mm:
        if (mm['itemListElement'] != null) {
          final title = _string(mm['name']);
          if (title != null && cleanText(title).isNotEmpty) steps.add('${cleanText(title)}:');
          walk(mm['itemListElement']);
        } else {
          walk(mm['text'] ?? mm['name']);
        }
    }
  }

  walk(v);
  if (steps.isEmpty) return null;
  final numbered = steps.length == 1
      ? steps.first
      : [for (var i = 0; i < steps.length; i++) steps[i].endsWith(':') ? steps[i] : '${i + 1}. ${steps[i]}'].join('\n');
  return numbered.length > 8000 ? numbered.substring(0, 8000) : numbered;
}

/// "4", "4 Portionen", ["4", "4 servings"], 4, "2-3 Personen" (takes the first number).
double? parseYield(Object? v) {
  final num? n = switch (v) {
    final num x => x,
    final String s => num.tryParse(RegExp(r'\d+(?:[.,]\d+)?').firstMatch(s)?.group(0)?.replaceAll(',', '.') ?? ''),
    final List l => l.map(parseYield).whereType<double>().firstOrNull,
    _ => null,
  };
  if (n == null || !(n > 0) || n > 100) return null;
  return n.toDouble();
}

/// ISO 8601 durations as used by schema.org: "PT1H30M" → 90, "PT45M" → 45, "P0DT2H" → 120.
int? parseIsoMinutes(String? s) {
  if (s == null) return null;
  final m = RegExp(r'^P(?:(\d+)D)?(?:T(?:(\d+)H)?(?:(\d+)M)?(?:(\d+)S)?)?$', caseSensitive: false).firstMatch(s.trim());
  if (m == null) return null;
  final d = int.tryParse(m.group(1) ?? '') ?? 0;
  final h = int.tryParse(m.group(2) ?? '') ?? 0;
  final min = int.tryParse(m.group(3) ?? '') ?? 0;
  final total = d * 1440 + h * 60 + min;
  return total > 0 ? total : null;
}

/// Removes HTML tags, decodes common entities and collapses white space.
String cleanText(String s) {
  var t = s.replaceAll(RegExp(r'<[^>]*>'), ' ');
  t = t.replaceAllMapped(RegExp(r'&#(x?)([0-9a-fA-F]+);'), (m) {
    final code = int.tryParse(m.group(2)!, radix: m.group(1)!.isEmpty ? 10 : 16);
    return code == null || code > 0x10FFFF ? '' : String.fromCharCode(code);
  });
  const entities = {
    '&amp;': '&',
    '&quot;': '"',
    '&apos;': "'",
    '&lt;': '<',
    '&gt;': '>',
    '&nbsp;': ' ',
    '&auml;': 'ä',
    '&ouml;': 'ö',
    '&uuml;': 'ü',
    '&Auml;': 'Ä',
    '&Ouml;': 'Ö',
    '&Uuml;': 'Ü',
    '&szlig;': 'ß',
    '&frac12;': '½',
    '&frac14;': '¼',
    '&frac34;': '¾',
  };
  entities.forEach((k, v) => t = t.replaceAll(k, v));
  return t.replaceAll(RegExp(r'\s+'), ' ').replaceAllMapped(RegExp(r' ([.,;:!?])'), (m) => m.group(1)!).trim();
}

/// The part of an ingredient line that names amount and food, without preparation notes:
/// "1 Zwiebel, fein gewürfelt" → "1 Zwiebel"; "200 g Mehl (Type 405)" → "200 g Mehl".
/// Unicode fractions become decimals ("½ TL Salz" → "0,5 TL Salz").
String ingredientCore(String line) {
  var t = line
      .replaceAll(RegExp(r'\([^)]*\)'), ' ')
      .replaceAll('½', ' 0,5 ')
      .replaceAll('¼', ' 0,25 ')
      .replaceAll('¾', ' 0,75 ')
      .replaceAll('⅓', ' 0,33 ')
      .replaceAll('⅔', ' 0,67 ');
  // "1 0,5" from "1½" → 1,5
  t = t.replaceAllMapped(RegExp(r'(\d+)\s+0,(\d+)'), (m) => '${m.group(1)},${m.group(2)}');
  final comma = t.indexOf(',', t.indexOf(RegExp(r'[A-Za-zÄÖÜäöüß]')).clamp(0, t.length));
  if (comma > 0) t = t.substring(0, comma);
  return t.replaceAll(RegExp(r'\s+'), ' ').trim();
}

/// Lines that are only a heading or a seasoning to taste are not matched to foods.
bool isNegligibleIngredient(String line) {
  final l = line.toLowerCase();
  return l.endsWith(':') ||
      RegExp(r'^(etwas |eine? prise |n\. ?b\. |nach belieben |optional:? )').hasMatch(l) ||
      RegExp(r'^(salz|pfeffer|salz und pfeffer|salz & pfeffer|wasser)$').hasMatch(l.trim());
}
