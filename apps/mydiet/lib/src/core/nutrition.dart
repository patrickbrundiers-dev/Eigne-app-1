/// Nutrient values and their arithmetic. Pure Dart, unit tested.
library;

/// Nutrient amounts. For a food these are per 100 g (or 100 ml); for a diary
/// entry or a day they are absolute amounts.
class Nutrients {
  const Nutrients({
    this.kcal = 0,
    this.protein = 0,
    this.carbs = 0,
    this.sugar = 0,
    this.fat = 0,
    this.saturatedFat = 0,
    this.fiber = 0,
    this.salt = 0,
  });

  static const zero = Nutrients();

  final double kcal;
  final double protein;
  final double carbs;
  final double sugar;
  final double fat;
  final double saturatedFat;
  final double fiber;
  final double salt;

  /// Values for [amount] g/ml of a food whose values are per 100 g/ml.
  Nutrients forAmount(double amount) => this * (amount / 100);

  Nutrients operator *(double f) => Nutrients(
    kcal: kcal * f,
    protein: protein * f,
    carbs: carbs * f,
    sugar: sugar * f,
    fat: fat * f,
    saturatedFat: saturatedFat * f,
    fiber: fiber * f,
    salt: salt * f,
  );

  Nutrients operator +(Nutrients o) => Nutrients(
    kcal: kcal + o.kcal,
    protein: protein + o.protein,
    carbs: carbs + o.carbs,
    sugar: sugar + o.sugar,
    fat: fat + o.fat,
    saturatedFat: saturatedFat + o.saturatedFat,
    fiber: fiber + o.fiber,
    salt: salt + o.salt,
  );

  static Nutrients sum(Iterable<Nutrients> items) => items.fold(Nutrients.zero, (a, b) => a + b);

  /// Energy implied by the macros (EU labelling factors, Reg. 1169/2011).
  double get atwaterKcal => protein * 4 + carbs * 4 + fat * 9 + fiber * 2;

  Map<String, double> toJson() => {
    'kcal': kcal,
    'protein': protein,
    'carbs': carbs,
    'sugar': sugar,
    'fat': fat,
    'saturatedFat': saturatedFat,
    'fiber': fiber,
    'salt': salt,
  };

  @override
  bool operator ==(Object other) =>
      other is Nutrients &&
      other.kcal == kcal &&
      other.protein == protein &&
      other.carbs == carbs &&
      other.sugar == sugar &&
      other.fat == fat &&
      other.saturatedFat == saturatedFat &&
      other.fiber == fiber &&
      other.salt == salt;

  @override
  int get hashCode => Object.hash(kcal, protein, carbs, sugar, fat, saturatedFat, fiber, salt);

  @override
  String toString() => 'Nutrients(kcal: $kcal, P: $protein, C: $carbs, F: $fat, fiber: $fiber)';
}

/// Plausibility problems in per-100 values entered for a food.
/// Errors block saving; warnings are shown but allowed.
class NutrientCheck {
  const NutrientCheck(this.errors, this.warnings);
  final List<String> errors;
  final List<String> warnings;
  bool get ok => errors.isEmpty;
}

NutrientCheck checkPer100(Nutrients n) {
  final errors = <String>[];
  final warnings = <String>[];
  final values = n.toJson();
  for (final e in values.entries) {
    if (e.value.isNaN || e.value < 0) errors.add('${e.key} darf nicht negativ sein.');
  }
  if (n.kcal > 900) errors.add('Mehr als 900 kcal pro 100 g sind nicht möglich (reines Fett ≈ 900).');
  final mass = n.protein + n.carbs + n.fat + n.fiber + n.salt;
  if (mass > 100.5) {
    errors.add(
      'Eiweiß, Kohlenhydrate, Fett, Ballaststoffe und Salz ergeben zusammen '
      'mehr als 100 g pro 100 g.',
    );
  }
  if (n.sugar > n.carbs + 0.05) errors.add('Zucker kann nicht höher als die Kohlenhydrate sein.');
  if (n.saturatedFat > n.fat + 0.05) {
    errors.add('Gesättigte Fettsäuren können nicht höher als das Fett sein.');
  }
  final implied = n.atwaterKcal;
  if (errors.isEmpty && (n.kcal - implied).abs() > 20 + 0.15 * implied) {
    warnings.add(
      'Die Kalorien passen nicht zu den Makronährstoffen: '
      'aus den Nährwerten ergeben sich etwa ${implied.round()} kcal. Bitte Etikett prüfen.',
    );
  }
  return NutrientCheck(errors, warnings);
}

/// Normalises a food name for duplicate detection: lower case, umlauts folded,
/// punctuation removed, whitespace collapsed.
String normalizeName(String s) {
  var t = s.toLowerCase().trim();
  const map = {'ä': 'ae', 'ö': 'oe', 'ü': 'ue', 'ß': 'ss', 'é': 'e', 'è': 'e', 'á': 'a'};
  map.forEach((k, v) => t = t.replaceAll(k, v));
  t = t.replaceAll(RegExp(r'[^a-z0-9%]+'), ' ');
  return t.replaceAll(RegExp(r'\s+'), ' ').trim();
}

/// Key that identifies a food: name + brand, normalised.
String foodKey(String name, String? brand) {
  final b = normalizeName(brand ?? '');
  return b.isEmpty ? normalizeName(name) : '${normalizeName(name)}|$b';
}
