/// Vitamins and minerals from food plus supplements (ARBEITSPLAN W5). Pure Dart, unit tested.
///
/// Targets: D-A-CH reference values for adults (DGE/ÖGE/SGE, rounded, values for 25 to under 51 years
/// where they differ by age). Upper levels: EFSA, see [nutrientCatalog]. The app does not recommend
/// doses; it only shows sums against these published values.
library;

import 'supplements.dart';

/// Daily reference values (D-A-CH) for adults, in the catalogue unit.
class MicroTarget {
  const MicroTarget(this.male, this.female, {this.femaleFrom51, this.note});
  final double male;
  final double female;

  /// Value for women from 51 years where it differs (iron after the menopause).
  final double? femaleFrom51;
  final String? note;

  double forPerson({required bool female, required int age}) =>
      female ? (age >= 51 && femaleFrom51 != null ? femaleFrom51! : this.female) : male;
}

const dachTargets = <String, MicroTarget>{
  'vit_d': MicroTarget(20, 20, note: 'Schätzwert bei fehlender Eigenbildung in der Haut'),
  'vit_e': MicroTarget(14, 12),
  'vit_c': MicroTarget(110, 95),
  'vit_b1': MicroTarget(1.2, 1.0),
  'vit_b2': MicroTarget(1.4, 1.1),
  'vit_b6': MicroTarget(1.6, 1.4),
  'folate': MicroTarget(300, 300, note: 'Folat-Äquivalente'),
  'vit_b12': MicroTarget(4, 4),
  'calcium': MicroTarget(1000, 1000),
  'magnesium': MicroTarget(350, 300),
  'iron': MicroTarget(11, 16, femaleFrom51: 14),
  'zinc': MicroTarget(14, 8, note: 'bei mittlerer Phytatzufuhr'),
  'iodine': MicroTarget(200, 200, note: 'Deutschland; Österreich und Schweiz 150 µg'),
  'selenium': MicroTarget(70, 60),
  'potassium': MicroTarget(4000, 4000),
};

/// Nutrients shown on the overview, in this order.
const microOverviewIds = [
  'vit_d',
  'vit_b12',
  'folate',
  'vit_c',
  'calcium',
  'magnesium',
  'iron',
  'zinc',
  'iodine',
  'potassium',
  'omega3',
];

enum MicroStatus {
  /// No target and no upper level known.
  unknown,
  below,
  ok,

  /// 80–100 % of the upper level.
  nearLimit,
  overLimit,
}

class MicroRow {
  MicroRow({required this.info, required this.food, required this.supplements, this.target});

  final NutrientInfo info;
  final double food;
  final double supplements;
  final double? target;

  final Map<String, double> supplementSources = {};

  double get total => food + supplements;

  /// The amount the upper level applies to: everything, or only supplements (e.g. magnesium).
  double get limitBasis => info.ulScope == UpperLimitScope.supplementsOnly ? supplements : total;

  double? get targetPercent => target == null || target! <= 0 ? null : total / target! * 100;
  double? get limitPercent => info.ul == null ? null : limitBasis / info.ul! * 100;

  MicroStatus get status {
    final l = limitPercent;
    if (l != null && l > 100 + 1e-9) return MicroStatus.overLimit;
    if (l != null && l >= 80) return MicroStatus.nearLimit;
    final t = targetPercent;
    if (t == null) return l == null ? MicroStatus.unknown : MicroStatus.ok;
    return t + 1e-9 >= 100 ? MicroStatus.ok : MicroStatus.below;
  }
}

/// One eaten portion: grams (or ml) and the food's micronutrients per 100.
class MicroPortion {
  const MicroPortion({required this.amount, required this.per100});
  final double amount;

  /// nutrientId → amount per 100 g/ml in the catalogue unit. Empty: no data.
  final Map<String, double> per100;
}

class MicroDay {
  const MicroDay({required this.rows, required this.entries, required this.entriesWithData});
  final List<MicroRow> rows;

  /// Diary entries of the day, and how many of them have micronutrient data.
  final int entries;
  final int entriesWithData;

  MicroRow? row(String id) => rows.where((r) => r.info.id == id).firstOrNull;
}

/// Adds up food portions and supplement intakes for one day.
MicroDay sumMicros({
  required Iterable<MicroPortion> portions,
  required Iterable<SupplementUse> supplements,
  required bool female,
  required int age,
  List<String> ids = microOverviewIds,
}) {
  final food = <String, double>{};
  var entries = 0, withData = 0;
  for (final p in portions) {
    entries++;
    if (p.per100.isEmpty) continue;
    withData++;
    if (!(p.amount > 0)) continue;
    p.per100.forEach((id, v) {
      if (v.isFinite && v >= 0) food[id] = (food[id] ?? 0) + v * p.amount / 100;
    });
  }
  final sup = {for (final t in sumSupplements(supplements)) t.info?.id ?? t.nutrientId: t};
  final rows = <MicroRow>[];
  for (final id in ids) {
    final info = nutrientById(id);
    if (info == null) continue;
    final s = sup[id];
    final row = MicroRow(
      info: info,
      food: food[id] ?? 0,
      supplements: s?.amount ?? 0,
      target: dachTargets[id]?.forPerson(female: female, age: age),
    );
    if (s != null) row.supplementSources.addAll(s.sources);
    rows.add(row);
  }
  return MicroDay(rows: rows, entries: entries, entriesWithData: withData);
}

/// For the supplement form: other active products that contain the same nutrients,
/// with the combined daily amount ("enthält ebenfalls Zink, zusammen 38 mg").
List<({NutrientInfo info, double combined, List<String> others, bool overLimit})> supplementOverlaps({
  required List<SupplementDose> newDoses,
  required double newServingsPerDay,
  required Iterable<SupplementUse> others,
}) {
  final out = <({NutrientInfo info, double combined, List<String> others, bool overLimit})>[];
  final totals = {for (final t in sumSupplements(others)) t.info?.id ?? t.nutrientId: t};
  final seen = <String>{};
  for (final d in newDoses) {
    final info = nutrientById(d.nutrientId);
    if (info == null || !seen.add(info.id)) continue;
    final t = totals[info.id];
    if (t == null || t.amount <= 0) continue;
    final mine = newDoses
        .where((x) => x.nutrientId == info.id)
        .fold<double>(0, (a, x) => a + convertUnit(x.amount, from: x.unit, to: info.unit) * newServingsPerDay);
    final combined = mine + t.amount;
    out.add((
      info: info,
      combined: combined,
      others: t.sources.keys.toList()..sort(),
      overLimit: info.ul != null && combined > info.ul! + 1e-9,
    ));
  }
  return out;
}
