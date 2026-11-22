/// Data quality of food values (ARBEITSPLAN W2) and Open Food Facts parsing.
/// Pure Dart, unit tested.
library;

import 'nutrition.dart';

/// Where a food's values come from. Stored in `foods.source`.
enum FoodSource {
  base('Basisdatenbank'),
  user('Eigene Eingabe'),
  off('Open Food Facts'),
  ai('KI-Schätzung');

  const FoodSource(this.label);
  final String label;

  static FoodSource parse(String? s) => FoodSource.values.where((v) => v.name == s).firstOrNull ?? FoodSource.user;
}

enum FoodQuality {
  /// Rounded reference values from nutrition tables.
  reference('Richtwert'),

  /// Entered by the user from the label.
  fromLabel('vom Etikett'),

  /// Imported, all main values present and plausible.
  complete('vollständig'),

  /// Imported, values missing or energy does not match the macros.
  incomplete('prüfen'),

  /// Estimated (AI or quick entry).
  estimate('Schätzung');

  const FoodQuality(this.label);
  final String label;
}

/// Quality of a food from its source and values. Imported values are checked with
/// the Atwater factors; a mismatch over 15 % (+20 kcal) marks the food "prüfen".
FoodQuality assessQuality(FoodSource source, Nutrients per100, {bool missingValues = false}) {
  switch (source) {
    case FoodSource.base:
      return FoodQuality.reference;
    case FoodSource.user:
      return FoodQuality.fromLabel;
    case FoodSource.ai:
      return FoodQuality.estimate;
    case FoodSource.off:
      if (missingValues) return FoodQuality.incomplete;
      final check = checkPer100(per100);
      return check.ok && check.warnings.isEmpty ? FoodQuality.complete : FoodQuality.incomplete;
  }
}

/// A product read from Open Food Facts, ready to prefill the food form.
class OffProduct {
  const OffProduct({
    required this.barcode,
    required this.name,
    this.brand,
    required this.unit,
    required this.per100,
    this.servingAmount,
    this.servingLabel,
    this.missing = const [],
    this.category,
  });

  final String barcode;
  final String name;
  final String? brand;
  final String unit;
  final Nutrients per100;
  final double? servingAmount;
  final String? servingLabel;

  /// German names of values that were missing in the source (set to 0).
  final List<String> missing;
  final String? category;

  FoodQuality get quality => assessQuality(FoodSource.off, per100, missingValues: missing.isNotEmpty);
}

/// Fields requested from the Open Food Facts API (v2).
const offFields =
    'code,product_name,product_name_de,generic_name_de,brands,quantity,serving_quantity,serving_size,'
    'nutrition_data_per,nutriments,categories_tags';

/// Parses the JSON of `GET /api/v2/product/{code}.json`. Returns null if the product
/// is unknown or has no usable energy value.
OffProduct? parseOffProduct(Map<String, dynamic> json, String barcode) {
  if (json['status'] != 1 && json['status'] != 'success') return null;
  final p = json['product'];
  if (p is! Map) return null;
  final n = p['nutriments'];
  if (n is! Map) return null;

  double? num100(String key) {
    final v = n['${key}_100g'] ?? n['${key}_100ml'];
    if (v is num) return v.toDouble();
    if (v is String) return double.tryParse(v.replaceAll(',', '.'));
    return null;
  }

  final missing = <String>[];
  double val(String key, String label) {
    final v = num100(key);
    if (v == null) missing.add(label);
    return v == null || v.isNaN || v < 0 ? 0 : v;
  }

  var kcal = num100('energy-kcal');
  if (kcal == null) {
    final kj = num100('energy-kj') ?? num100('energy');
    if (kj != null) kcal = kj / 4.184;
  }
  if (kcal == null) return null;

  final salt = num100('salt') ?? (num100('sodium') == null ? null : num100('sodium')! * 2.5);
  if (salt == null) missing.add('Salz');
  final per100 = Nutrients(
    kcal: kcal,
    protein: val('proteins', 'Eiweiß'),
    carbs: val('carbohydrates', 'Kohlenhydrate'),
    sugar: val('sugars', 'Zucker'),
    fat: val('fat', 'Fett'),
    saturatedFat: val('saturated-fat', 'gesättigte Fettsäuren'),
    fiber: val('fiber', 'Ballaststoffe'),
    salt: salt ?? 0,
  );

  String? str(String k) {
    final v = p[k];
    return v is String && v.trim().isNotEmpty ? v.trim() : null;
  }

  final name = str('product_name_de') ?? str('product_name') ?? str('generic_name_de') ?? 'Produkt $barcode';
  final brand = str('brands')?.split(',').first.trim();
  final per = str('nutrition_data_per') ?? '';
  final quantity = (str('quantity') ?? '').toLowerCase();
  final isMl =
      per.contains('ml') ||
      n.containsKey('energy-kcal_100ml') ||
      RegExp(r'\d\s*(ml|cl|l)\b').hasMatch(quantity) && !RegExp(r'\d\s*(g|kg)\b').hasMatch(quantity);
  final serving = p['serving_quantity'];
  final servingAmount = serving is num
      ? serving.toDouble()
      : (serving is String ? double.tryParse(serving.replaceAll(',', '.')) : null);
  return OffProduct(
    barcode: barcode,
    name: name.length > 120 ? name.substring(0, 120) : name,
    brand: brand,
    unit: isMl ? 'ml' : 'g',
    per100: per100,
    servingAmount: servingAmount != null && servingAmount > 0 && servingAmount <= 5000 ? servingAmount : null,
    servingLabel: str('serving_size'),
    missing: missing,
  );
}

/// EAN-8, UPC-A (12), EAN-13 or GTIN-14 with a valid check digit.
bool isValidGtin(String code) {
  final c = code.replaceAll(RegExp(r'\s'), '');
  if (!RegExp(r'^\d+$').hasMatch(c) || ![8, 12, 13, 14].contains(c.length)) return false;
  var sum = 0;
  for (var i = 0; i < c.length - 1; i++) {
    final d = int.parse(c[c.length - 2 - i]);
    sum += i.isEven ? d * 3 : d;
  }
  final check = (10 - sum % 10) % 10;
  return check == int.parse(c[c.length - 1]);
}
