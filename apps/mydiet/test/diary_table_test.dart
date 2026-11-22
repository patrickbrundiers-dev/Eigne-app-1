import 'package:flutter_test/flutter_test.dart';
import 'package:mydiet_ai/src/features/diary/diary_table.dart';
import 'package:mydiet_ai/src/features/foods/food_table.dart';

void main() {
  test('Tagebuch-Spalten: Standard, Speichern, Unbekanntes ignorieren', () {
    expect(parseDiaryColumns(null), defaultDiaryColumns);
    expect(parseDiaryColumns('kaputt'), defaultDiaryColumns);
    final enc = encodeDiaryColumns([DiaryColumn.salt, DiaryColumn.amount]);
    expect(parseDiaryColumns(enc), [DiaryColumn.amount, DiaryColumn.salt]);
    expect(parseDiaryColumns('["kcal","gibtsnicht"]'), [DiaryColumn.kcal]);
  });

  test('Zahlen ausblenden lässt nur Menge und Marke', () {
    expect(visibleDiaryColumns(DiaryColumn.values, hideNumbers: true), [DiaryColumn.amount, DiaryColumn.brand]);
    expect(visibleDiaryColumns(defaultDiaryColumns, hideNumbers: false), defaultDiaryColumns);
  });

  test('Lebensmittel-Spalten nutzen dieselbe Speicherung', () {
    expect(parseFoodColumns(encodeFoodColumns([FoodColumn.fiber])), [FoodColumn.fiber]);
  });
}
