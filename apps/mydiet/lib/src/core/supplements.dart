/// Supplement ingredients, daily totals and upper intake levels. Pure Dart, unit tested.
///
/// The app does not recommend doses. It adds up what the user takes and compares the
/// sum with published reference values:
/// - NRV: nutrient reference values for labelling, EU Regulation 1169/2011, Annex XIII.
/// - UL: tolerable upper intake levels for adults from EFSA (Overview on Tolerable Upper
///   Intake Levels, updated 2024), or EFSA's "safe level" where no UL was set.
library;

enum UpperLimitScope {
  /// The UL covers the total intake (food + supplements).
  total,

  /// The UL covers only supplements / added forms (e.g. magnesium, folic acid).
  supplementsOnly,
}

class NutrientInfo {
  const NutrientInfo(
    this.id,
    this.name,
    this.unit, {
    this.nrv,
    this.ul,
    this.ulScope = UpperLimitScope.total,
    this.ulNote,
  });

  final String id;
  final String name;

  /// µg, mg or g.
  final String unit;

  /// EU reference value per day (100 %), if one exists.
  final double? nrv;

  /// Upper level per day for adults, if one exists.
  final double? ul;
  final UpperLimitScope ulScope;
  final String? ulNote;
}

/// Catalogue of common supplement ingredients.
const nutrientCatalog = <NutrientInfo>[
  NutrientInfo('vit_a', 'Vitamin A (Retinol)', 'µg', nrv: 800, ul: 3000, ulNote: 'gilt für vorgeformtes Vitamin A'),
  NutrientInfo('vit_d', 'Vitamin D', 'µg', nrv: 5, ul: 100),
  NutrientInfo('vit_e', 'Vitamin E', 'mg', nrv: 12, ul: 300),
  NutrientInfo('vit_k', 'Vitamin K', 'µg', nrv: 75),
  NutrientInfo('vit_c', 'Vitamin C', 'mg', nrv: 80),
  NutrientInfo('vit_b1', 'Vitamin B1 (Thiamin)', 'mg', nrv: 1.1),
  NutrientInfo('vit_b2', 'Vitamin B2 (Riboflavin)', 'mg', nrv: 1.4),
  NutrientInfo(
    'niacin',
    'Niacin (Nicotinamid)',
    'mg',
    nrv: 16,
    ul: 900,
    ulScope: UpperLimitScope.supplementsOnly,
    ulNote: 'für Nicotinamid; für Nicotinsäure gilt 10 mg',
  ),
  NutrientInfo('pantothenic', 'Pantothensäure', 'mg', nrv: 6),
  NutrientInfo('vit_b6', 'Vitamin B6', 'mg', nrv: 1.4, ul: 12),
  NutrientInfo('biotin', 'Biotin', 'µg', nrv: 50),
  NutrientInfo('folate', 'Folsäure', 'µg', nrv: 200, ul: 1000, ulScope: UpperLimitScope.supplementsOnly),
  NutrientInfo('vit_b12', 'Vitamin B12', 'µg', nrv: 2.5),
  NutrientInfo('calcium', 'Calcium', 'mg', nrv: 800, ul: 2500),
  NutrientInfo('magnesium', 'Magnesium', 'mg', nrv: 375, ul: 250, ulScope: UpperLimitScope.supplementsOnly),
  NutrientInfo('iron', 'Eisen', 'mg', nrv: 14, ul: 40, ulNote: 'EFSA-Sicherheitswert (2024), kein UL'),
  NutrientInfo('zinc', 'Zink', 'mg', nrv: 10, ul: 25),
  NutrientInfo('copper', 'Kupfer', 'mg', nrv: 1, ul: 5),
  NutrientInfo('manganese', 'Mangan', 'mg', nrv: 2),
  NutrientInfo('selenium', 'Selen', 'µg', nrv: 55, ul: 255),
  NutrientInfo('iodine', 'Jod', 'µg', nrv: 150, ul: 600),
  NutrientInfo('chromium', 'Chrom', 'µg', nrv: 40),
  NutrientInfo('molybdenum', 'Molybdän', 'µg', nrv: 50, ul: 600),
  NutrientInfo('potassium', 'Kalium', 'mg', nrv: 2000),
  NutrientInfo(
    'omega3',
    'Omega-3 (EPA + DHA)',
    'mg',
    ul: 5000,
    ulScope: UpperLimitScope.supplementsOnly,
    ulNote: 'EFSA: bis 5 g/Tag unbedenklich',
  ),
  NutrientInfo('caffeine', 'Koffein', 'mg', ul: 400, ulNote: 'EFSA: bis 400 mg/Tag, einzeln bis 200 mg'),
  NutrientInfo('creatine', 'Kreatin', 'g'),
  NutrientInfo('protein', 'Eiweiß', 'g'),
];

NutrientInfo? nutrientById(String id) => nutrientCatalog.where((n) => n.id == id).firstOrNull;

/// 1 µg vitamin D = 40 IE (I.U.).
double vitaminDIuToUg(double iu) => iu / 40;

/// One ingredient of a supplement per serving (e.g. per capsule).
class SupplementDose {
  const SupplementDose({required this.nutrientId, required this.amount, required this.unit, this.name});

  /// Catalogue id, or `custom:NAME` for an ingredient that is not in the catalogue.
  final String nutrientId;
  final double amount;
  final String unit;
  final String? name;

  String get displayName => nutrientById(nutrientId)?.name ?? name ?? nutrientId.replaceFirst('custom:', '');
}

/// Servings of one product combined with its ingredients.
class SupplementUse {
  const SupplementUse({required this.product, required this.servings, required this.doses});
  final String product;
  final double servings;
  final List<SupplementDose> doses;
}

enum LimitStatus { none, ok, near, over }

class NutrientTotal {
  NutrientTotal({required this.nutrientId, required this.name, required this.unit, this.info});
  final String nutrientId;
  final String name;
  final String unit;
  final NutrientInfo? info;
  double amount = 0;

  /// Contribution per product name.
  final Map<String, double> sources = {};

  double? get nrvPercent => info?.nrv == null ? null : amount / info!.nrv! * 100;
  double? get ulPercent => info?.ul == null ? null : amount / info!.ul! * 100;

  /// near from 80 % of the UL, over above 100 %.
  LimitStatus get status {
    final p = ulPercent;
    if (p == null) return LimitStatus.none;
    if (p > 100 + 1e-9) return LimitStatus.over;
    if (p >= 80) return LimitStatus.near;
    return LimitStatus.ok;
  }
}

/// Sums every ingredient over all products. Ingredients are merged by catalogue id
/// (e.g. vitamin D from a multivitamin and from a D3/K2 product). Amounts in a
/// different unit of the same nutrient are converted (µg/mg/g).
List<NutrientTotal> sumSupplements(Iterable<SupplementUse> uses) {
  final out = <String, NutrientTotal>{};
  for (final u in uses) {
    if (!(u.servings > 0)) continue;
    for (final d in u.doses) {
      final info = nutrientById(d.nutrientId);
      final unit = info?.unit ?? d.unit;
      final amount = convertUnit(d.amount, from: d.unit, to: unit) * u.servings;
      final key = info?.id ?? 'custom:${d.displayName.toLowerCase()}|$unit';
      final t = out.putIfAbsent(
        key,
        () => NutrientTotal(nutrientId: d.nutrientId, name: d.displayName, unit: unit, info: info),
      );
      t.amount += amount;
      t.sources[u.product] = (t.sources[u.product] ?? 0) + amount;
    }
  }
  final list = out.values.toList()
    ..sort((a, b) {
      final s = b.status.index.compareTo(a.status.index);
      if (s != 0) return s;
      final ia = a.info == null ? 999 : nutrientCatalog.indexOf(a.info!);
      final ib = b.info == null ? 999 : nutrientCatalog.indexOf(b.info!);
      return ia != ib ? ia.compareTo(ib) : a.name.compareTo(b.name);
    });
  return list;
}

const _factors = {'µg': 1e-6, 'mg': 1e-3, 'g': 1.0};

/// Converts between µg, mg and g. Other units are returned unchanged.
double convertUnit(double v, {required String from, required String to}) {
  final f = _factors[from];
  final t = _factors[to];
  if (f == null || t == null || from == to) return v;
  return v * f / t;
}

/// Days the stock lasts at the planned daily servings.
int? stockDays({double? stockServings, required double servingsPerDay}) {
  if (stockServings == null || !(servingsPerDay > 0)) return null;
  return (stockServings / servingsPerDay).floor();
}
