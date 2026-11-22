import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mydiet_ai/src/data/database.dart';
import 'package:mydiet_ai/src/features/foods/food_table.dart';

void main() {
  test('Spaltenwahl: Standard, Speichern, Unbekanntes ignorieren', () {
    expect(parseFoodColumns(null), defaultFoodColumns);
    expect(parseFoodColumns('kaputt'), defaultFoodColumns);
    final enc = encodeFoodColumns([FoodColumn.salt, FoodColumn.kcal]);
    expect(parseFoodColumns(enc), [FoodColumn.kcal, FoodColumn.salt]); // Reihenfolge wie im Enum
    expect(parseFoodColumns('["kcal","gibtsnicht"]'), [FoodColumn.kcal]);
    expect(parseFoodColumns('[]'), isEmpty);
  });

  test('Sortieren nach Name und nach Nährwert', () async {
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    await db.getProfile();
    final foods = [
      ...await db.searchFoods('banane'),
      ...await db.searchFoods('haferflocken'),
      ...await db.searchFoods('skyr'),
    ];
    final byName = sortFoods(foods, null);
    expect(byName.first.name.toLowerCase().compareTo(byName.last.name.toLowerCase()), lessThan(0));
    final byProteinDesc = sortFoods(foods, FoodColumn.protein, ascending: false);
    for (var i = 1; i < byProteinDesc.length; i++) {
      expect(byProteinDesc[i - 1].protein, greaterThanOrEqualTo(byProteinDesc[i].protein));
    }
    expect(FoodColumn.kcal.text(byName.first), isNotEmpty);
  });
}
