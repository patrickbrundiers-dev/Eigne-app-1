import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mydiet_ai/src/core/nutrition.dart';
import 'package:mydiet_ai/src/core/recipes.dart';
import 'package:mydiet_ai/src/data/database.dart';
import 'package:mydiet_ai/src/features/recipes/recipe_detail_page.dart';
import 'package:mydiet_ai/src/features/recipes/shopping_view.dart';

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  group('Rezept-Rechnung', () {
    // 200 g Haferflocken (370 kcal, 13 P) + 500 ml Milch 1,5 % (47 kcal, 3,4 P)
    const oats = Ingredient(per100: Nutrients(kcal: 370, protein: 13, carbs: 59, fat: 7), amount: 200);
    const milk = Ingredient(per100: Nutrients(kcal: 47, protein: 3.4, carbs: 4.8, fat: 1.5), amount: 500, unit: 'ml');

    test('Summe, pro Portion und pro 100 g', () {
      final n = recipeNutrition([oats, milk], servings: 4);
      expect(n.total.kcal, closeTo(740 + 235, 1e-9));
      expect(n.total.protein, closeTo(26 + 17, 1e-9));
      expect(n.perServing.kcal, closeTo(975 / 4, 1e-9));
      expect(n.rawWeight, 700);
      expect(n.per100.kcal, closeTo(975 / 7, 1e-9));
      expect(n.servingWeight, 175);
      expect(n.usesCookedWeight, isFalse);
    });

    test('Gewicht nach dem Kochen ändert nur die Werte pro 100 g', () {
      final n = recipeNutrition([oats, milk], servings: 4, cookedWeight: 650);
      expect(n.total.kcal, closeTo(975, 1e-9));
      expect(n.perServing.kcal, closeTo(243.75, 1e-9));
      expect(n.per100.kcal, closeTo(150, 1e-9));
      expect(n.servingWeight, 162.5);
      // 1 Portion nach Gewicht = 1 Portion nach Anteil
      expect(n.per100.forAmount(n.servingWeight).kcal, closeTo(n.perServing.kcal, 1e-9));
    });

    test('Ungültige Portionen werden abgelehnt', () {
      expect(() => recipeNutrition([oats], servings: 0), throwsArgumentError);
    });

    test('Einkaufsliste: gleiche Zutat und Einheit wird zusammengefasst', () {
      final merged = mergeShopping(const [
        ShoppingLine(key: 'milch', label: 'Milch', amount: 500, unit: 'ml'),
        ShoppingLine(key: 'milch', label: 'Milch', amount: 250, unit: 'ml'),
        ShoppingLine(key: 'milch', label: 'Milch', amount: 2, unit: 'Packung'),
        ShoppingLine(key: 'salz', label: 'Salz'),
        ShoppingLine(key: 'salz', label: 'Salz'),
      ]);
      expect(merged.length, 3);
      expect(merged.firstWhere((l) => l.unit == 'ml').amount, 750);
      expect(merged.firstWhere((l) => l.key == 'salz').amount, isNull);
      expect(scaleAmount(200, recipeServings: 4, wantedServings: 6), 300);
    });
  });

  test('Einkaufszeile wird in Menge, Einheit und Bezeichnung zerlegt', () {
    var p = ShoppingViewParser.parse('500 g Hackfleisch');
    expect((p.amount, p.unit, p.label), (500.0, 'g', 'Hackfleisch'));
    p = ShoppingViewParser.parse('2 Paprika rot');
    expect((p.amount, p.unit, p.label), (2.0, null, 'Paprika rot'));
    p = ShoppingViewParser.parse('1,5 l Milch');
    expect((p.amount, p.unit, p.label), (1.5, 'l', 'Milch'));
    p = ShoppingViewParser.parse('Zimt');
    expect((p.amount, p.unit, p.label), (null, null, 'Zimt'));
  });

  test('Vorauswahl der Mahlzeit nach Uhrzeit', () {
    final now = DateTime(2026, 11, 22);
    MealSlot slot(String id, int? m, int o) =>
        MealSlot(id: id, name: id, minuteOfDay: m, sortOrder: o, createdAt: now, updatedAt: now);
    final slots = [slot('F', 450, 0), slot('M', 750, 1), slot('A', 1110, 2), slot('S', null, 3)];
    expect(slotForNow(slots, DateTime(2026, 11, 22, 6)).id, 'F');
    expect(slotForNow(slots, DateTime(2026, 11, 22, 13)).id, 'M');
    expect(slotForNow(slots, DateTime(2026, 11, 22, 21)).id, 'A');
  });

  group('Rezepte in der Datenbank', () {
    late AppDatabase db;
    setUp(() => db = AppDatabase(NativeDatabase.memory()));
    tearDown(() => db.close());

    Future<Food> food(String q) async => (await db.searchFoods(q)).first;

    Future<String> porridge() async {
      final oats = await food('Haferflocken');
      final milk = await food('Milch 1,5');
      return db.saveRecipe(
        name: 'Porridge',
        servings: 2,
        items: [IngredientInput.fromFood(oats, 100), IngredientInput.fromFood(milk, 300)],
      );
    }

    test('Speichern, Nährwerte, doppelter Name', () async {
      final id = await porridge();
      final r = (await db.getRecipe(id))!;
      final n = await db.recipeNutritionOf(r);
      final oats = await food('Haferflocken');
      final milk = await food('Milch 1,5');
      expect(n.total.kcal, closeTo(oats.kcal + milk.kcal * 3, 1e-9));
      expect(n.rawWeight, 400);
      expect(
        () => db.saveRecipe(name: ' porridge ', servings: 1, items: [IngredientInput.fromFood(oats, 50)]),
        throwsA(isA<DuplicateRecipeException>()),
      );
      expect(() => db.saveRecipe(name: 'Leer', servings: 1, items: const []), throwsA(isA<InvalidFoodException>()));
    });

    test('Bearbeiten ersetzt die Zutaten, ohne Altlasten', () async {
      final id = await porridge();
      final oats = await food('Haferflocken');
      await db.saveRecipe(id: id, name: 'Porridge', servings: 1, items: [IngredientInput.fromFood(oats, 80)]);
      final items = await db.recipeItemsOf(id);
      expect(items.single.amount, 80);
      expect((await db.watchRecipes().first).length, 1);
    });

    test('Ins Tagebuch: 1 Portion = Gesamt ÷ Portionen, Werte bleiben eingefroren', () async {
      final id = await porridge();
      final r = (await db.getRecipe(id))!;
      final n = await db.recipeNutritionOf(r);
      final slot = (await db.watchMealSlots().first).first;
      await db.logRecipe(day: '2026-11-22', mealSlotId: slot.id, recipe: r, grams: n.servingWeight);
      final e = (await db.diaryForDay('2026-11-22')).single;
      expect(e.recipeId, id);
      expect(e.foodName, 'Porridge');
      expect(e.nutrients.kcal, closeTo(n.perServing.kcal, 1e-9));
      expect(e.nutrients.protein, closeTo(n.perServing.protein, 1e-9));

      // Rezept ändern oder löschen ändert den vergangenen Tag nicht
      final oats = await food('Haferflocken');
      await db.saveRecipe(id: id, name: 'Porridge', servings: 2, items: [IngredientInput.fromFood(oats, 300)]);
      await db.deleteRecipe(id);
      final after = (await db.diaryForDay('2026-11-22')).single;
      expect(after.nutrients.kcal, closeTo(n.perServing.kcal, 1e-9));
      // Name ist wieder frei
      await db.saveRecipe(name: 'Porridge', servings: 1, items: [IngredientInput.fromFood(oats, 50)]);
    });

    test('Gelöschtes Lebensmittel bleibt im Rezept erhalten', () async {
      final custom = await db.saveFood(
        name: 'Eigenes Proteinpulver',
        per100: const Nutrients(kcal: 380, protein: 80, carbs: 6, fat: 5),
      );
      final f = (await db.getFood(custom))!;
      final id = await db.saveRecipe(name: 'Shake', servings: 1, items: [IngredientInput.fromFood(f, 30)]);
      await db.deleteFood(custom);
      final n = await db.recipeNutritionOf((await db.getRecipe(id))!);
      expect(n.total.protein, closeTo(24, 1e-9));
    });

    test('Einkaufsliste: Rezept skaliert, zusammengeführt, abgehakt', () async {
      final id = await porridge();
      await db.addRecipeToShopping(id, servings: 4); // doppelte Menge
      await db.addRecipeToShopping(id); // 2 Portionen
      var list = await db.watchShopping().first;
      expect(list.length, 2);
      final oats = list.firstWhere((s) => s.label.startsWith('Haferflocken'));
      expect(oats.amount, 300);
      expect(oats.fromRecipes, 'Porridge');

      await db.addShoppingItem(label: 'Zimt');
      await db.addShoppingItem(label: ' zimt ');
      list = await db.watchShopping().first;
      expect(list.where((s) => s.itemKey == 'zimt').length, 1);

      // Abgehakte Zeilen werden nicht mehr erweitert, sondern neu angelegt
      await db.setShoppingChecked(oats.id, true);
      await db.addRecipeToShopping(id);
      list = await db.watchShopping().first;
      expect(list.where((s) => s.foodId == oats.foodId).length, 2);
      expect(await db.clearCheckedShopping(), 1);
      list = await db.watchShopping().first;
      expect(list.firstWhere((s) => s.foodId == oats.foodId).amount, 100);
    });

    test('Export und Import enthalten Rezepte und Einkaufsliste', () async {
      final id = await porridge();
      await db.addRecipeToShopping(id);
      final json = await db.exportJson();
      final db2 = AppDatabase(NativeDatabase.memory());
      await db2.importJson(json);
      final r = (await db2.getRecipe(id))!;
      expect((await db2.recipeItemsOf(id)).length, 2);
      expect((await db2.recipeNutritionOf(r)).rawWeight, 400);
      expect((await db2.watchShopping().first).length, 2);
      await db2.close();
    });
  });
}
