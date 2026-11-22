import '../core/nutrition.dart';
import 'database.dart';

/// CSV for spreadsheets with German settings: ";" as separator, "," as decimal mark,
/// UTF-8 with BOM so Excel shows umlauts correctly.
const csvBom = '﻿';

String _cell(Object? v) {
  if (v == null) return '';
  final s = v is double ? _num(v) : v.toString();
  if (s.contains(';') || s.contains('"') || s.contains('\n') || s.contains('\r')) {
    return '"${s.replaceAll('"', '""')}"';
  }
  return s;
}

String _num(double v) {
  final r = (v * 10).roundToDouble() / 10;
  final s = r == r.roundToDouble() ? r.toStringAsFixed(0) : r.toStringAsFixed(1);
  return s.replaceAll('.', ',');
}

String _rows(List<String> header, Iterable<List<Object?>> rows) {
  final b = StringBuffer(csvBom)..writeln(header.map(_cell).join(';'));
  for (final r in rows) {
    b.writeln(r.map(_cell).join(';'));
  }
  return b.toString();
}

String diaryCsv(List<DiaryEntry> entries, Map<String, String> slotNames) => _rows(
  [
    'Datum',
    'Mahlzeit',
    'Lebensmittel',
    'Marke',
    'Menge',
    'Einheit',
    'kcal',
    'Protein g',
    'Kohlenhydrate g',
    'Zucker g',
    'Fett g',
    'ges. Fettsäuren g',
    'Ballaststoffe g',
    'Salz g',
  ],
  [
    for (final e in entries)
      () {
        final Nutrients n = e.nutrients;
        return <Object?>[
          e.dayKey,
          slotNames[e.mealSlotId] ?? '',
          e.foodName,
          e.brand,
          e.amount,
          e.unit,
          n.kcal,
          n.protein,
          n.carbs,
          n.sugar,
          n.fat,
          n.saturatedFat,
          n.fiber,
          n.salt,
        ];
      }(),
  ],
);

String weightCsv(List<WeightEntry> entries) => _rows(
  ['Datum', 'Gewicht kg', 'Körperfett %', 'Bauchumfang cm', 'Notiz'],
  [
    for (final e in entries) <Object?>[e.dayKey, e.weightKg, e.bodyFatPercent, e.waistCm, e.note],
  ],
);
