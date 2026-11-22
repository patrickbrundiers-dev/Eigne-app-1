import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mydiet_ai/src/core/nutrition.dart';
import 'package:mydiet_ai/src/data/database.dart';
import 'package:mydiet_ai/src/data/seed_foods.dart';

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  late AppDatabase db;

  setUp(() => db = AppDatabase(NativeDatabase.memory()));
  tearDown(() => db.close());

  const skyr = Nutrients(kcal: 63, protein: 11, carbs: 4, sugar: 4, fat: 0.2, saturatedFat: 0.1, salt: 0.1);

  group('Start', () {
    test('Basis-Lebensmittel werden genau einmal angelegt', () async {
      final foods = await db.watchFoods().first;
      expect(foods.length, referenceFoods.length);
      await db.setSetting('seedVersion', '0');
      await db.seedReferenceFoods();
      expect((await db.watchFoods().first).length, referenceFoods.length);
    });

    test('Vier Standard-Mahlzeiten', () async {
      final slots = await db.watchMealSlots().first;
      expect(slots.map((s) => s.name), ['Frühstück', 'Mittagessen', 'Abendessen', 'Snacks']);
    });
  });

  group('Lebensmittel', () {
    test('Suche findet Umlaute und Teilwörter, beste Treffer zuerst', () async {
      final r = await db.searchFoods('hahnchen');
      expect(r, isEmpty); // "ae" normalisation: users type "hähnchen" or "haehnchen"
      final r2 = await db.searchFoods('Hähnchen');
      expect(r2.first.name, startsWith('Hähnchen'));
      final r3 = await db.searchFoods('quark mager');
      expect(r3.single.name, 'Magerquark');
    });

    test('Doppelte Lebensmittel werden verhindert (Name + Marke, normalisiert)', () async {
      await db.saveFood(name: 'Skyr Natur', brand: 'Arla', per100: skyr);
      expect(
        () => db.saveFood(name: '  skyr  natur', brand: 'ARLA', per100: skyr),
        throwsA(isA<DuplicateFoodException>()),
      );
      // Andere Marke ist erlaubt
      await db.saveFood(name: 'Skyr Natur', brand: 'Milbona', per100: skyr);
      // Gleicher Name wie ein Basis-Lebensmittel ohne Marke ist ein Duplikat
      expect(() => db.saveFood(name: 'skyr natur', per100: skyr), throwsA(isA<DuplicateFoodException>()));
    });

    test('Barcode ist eindeutig', () async {
      await db.saveFood(name: 'Whey A', barcode: '4006381333931', per100: skyr);
      expect(
        () => db.saveFood(name: 'Whey B', barcode: '4006 3813 33931', per100: skyr),
        throwsA(isA<DuplicateFoodException>()),
      );
    });

    test('Unplausible Werte werden abgelehnt', () async {
      expect(
        () => db.saveFood(name: 'Kaputt', per100: const Nutrients(kcal: 100, protein: 80, carbs: 80)),
        throwsA(isA<InvalidFoodException>()),
      );
    });

    test('Bearbeiten behält die id; Löschen gibt Name und Barcode frei', () async {
      final id = await db.saveFood(name: 'Protein Pudding', barcode: '12345678', per100: skyr);
      expect(await db.saveFood(id: id, name: 'Protein Pudding', barcode: '12345678', per100: skyr * 1), id);
      await db.deleteFood(id);
      expect((await db.searchFoods('protein pudding')), isEmpty);
      final id2 = await db.saveFood(name: 'Protein Pudding', barcode: '12345678', per100: skyr);
      expect(id2, isNot(id));
    });
  });

  group('Tagebuch', () {
    Future<Food> food(String q) async => (await db.searchFoods(q)).first;

    test('Eintrag speichert Nährwerte als Kopie; spätere Änderungen am Lebensmittel wirken nicht zurück', () async {
      final slot = (await db.watchMealSlots().first).first;
      final id = await db.saveFood(
        name: 'Mein Brot',
        per100: const Nutrients(kcal: 250, protein: 9, carbs: 45, fat: 3, fiber: 6),
      );
      final f = (await db.getFood(id))!;
      await db.logFood(day: '2026-01-05', mealSlotId: slot.id, food: f, amount: 80);
      await db.saveFood(
        id: id,
        name: 'Mein Brot',
        per100: const Nutrients(kcal: 300, protein: 9, carbs: 50, fat: 6, fiber: 6),
      );
      final e = (await db.diaryForDay('2026-01-05')).single;
      expect(e.nutrients.kcal, closeTo(200, 1e-9));
    });

    test('Tagessumme, Löschen und Wiederherstellen', () async {
      final slot = (await db.watchMealSlots().first)[1];
      final chicken = await food('Hähnchenbrustfilet');
      final potato = await food('Kartoffeln, gekocht');
      final broccoli = await food('Brokkoli');
      await db.logFood(day: '2026-01-05', mealSlotId: slot.id, food: chicken, amount: 200);
      await db.logFood(day: '2026-01-05', mealSlotId: slot.id, food: potato, amount: 250);
      final bId = await db.logFood(day: '2026-01-05', mealSlotId: slot.id, food: broccoli, amount: 300);
      var totals = await db.dailyTotals('2026-01-05', '2026-01-05');
      expect(totals['2026-01-05']!.kcal, closeTo(212 + 180 + 105, 1e-9));
      expect(totals['2026-01-05']!.protein, closeTo(47 + 5 + 8.4, 1e-9));

      await db.deleteDiaryEntry(bId);
      totals = await db.dailyTotals('2026-01-05', '2026-01-05');
      expect(totals['2026-01-05']!.kcal, closeTo(392, 1e-9));
      await db.restoreDiaryEntry(bId);
      expect((await db.diaryForDay('2026-01-05')).length, 3);
    });

    test('Menge ändern und ungültige Mengen', () async {
      final slot = (await db.watchMealSlots().first).first;
      final skyrFood = await food('Skyr');
      final id = await db.logFood(day: '2026-01-05', mealSlotId: slot.id, food: skyrFood, amount: 150);
      await db.updateDiaryEntry(id, amount: 300);
      expect((await db.diaryForDay('2026-01-05')).single.nutrients.protein, closeTo(33, 1e-9));
      expect(() => db.logFood(day: '2026-01-05', mealSlotId: slot.id, food: skyrFood, amount: 0), throwsArgumentError);
      expect(() => db.updateDiaryEntry(id, amount: -5), throwsArgumentError);
    });

    test('Mahlzeit vom Vortag übernehmen kopiert, statt zu verschieben', () async {
      final slots = await db.watchMealSlots().first;
      final oats = await food('Haferflocken');
      await db.logFood(day: '2026-01-04', mealSlotId: slots[0].id, food: oats, amount: 60);
      await db.logFood(day: '2026-01-04', mealSlotId: slots[2].id, food: oats, amount: 10);
      final n = await db.copyMeal(fromDay: '2026-01-04', fromSlotId: slots[0].id, toDay: '2026-01-05');
      expect(n, 1);
      expect((await db.diaryForDay('2026-01-04')).length, 2);
      final copied = (await db.diaryForDay('2026-01-05')).single;
      expect(copied.amount, 60);
      expect(copied.mealSlotId, slots[0].id);
    });

    test('Zuletzt verwendet: neueste zuerst, ohne Duplikate', () async {
      final slot = (await db.watchMealSlots().first).first;
      final a = await food('Apfel');
      final b = await food('Banane');
      await db.logFood(day: '2026-01-05', mealSlotId: slot.id, food: a, amount: 100);
      await Future<void>.delayed(const Duration(milliseconds: 5));
      await db.logFood(day: '2026-01-05', mealSlotId: slot.id, food: b, amount: 100);
      final recent = await db.recentFoods();
      expect(recent.map((f) => f.name), ['Banane', 'Apfel']);
    });
  });

  group('Schnell-Erfassung', () {
    test('Vorschläge je Mahlzeit: häufig zuerst, nur passende Mahlzeit, mind. zweimal', () async {
      final slots = await db.watchMealSlots().first;
      final breakfast = slots[0], dinner = slots[2];
      final skyrF = (await db.searchFoods('Magerquark')).first;
      final oats = (await db.searchFoods('Haferflocken')).first;
      final potato = (await db.searchFoods('Kartoffeln, gekocht')).first;
      for (var d = 1; d <= 3; d++) {
        await db.logFood(day: '2026-03-0$d', mealSlotId: breakfast.id, food: oats, amount: 50);
      }
      for (var d = 1; d <= 2; d++) {
        await db.logFood(day: '2026-03-0$d', mealSlotId: breakfast.id, food: skyrF, amount: 200);
      }
      await db.logFood(day: '2026-03-04', mealSlotId: breakfast.id, food: potato, amount: 100);
      for (var d = 1; d <= 4; d++) {
        await db.logFood(day: '2026-03-0$d', mealSlotId: dinner.id, food: potato, amount: 250);
      }
      final now = DateTime(2026, 3, 5);
      final b = await db.suggestedFoods(mealSlotId: breakfast.id, now: now);
      expect(b.map((f) => f.id), [oats.id, skyrF.id]);
      final d = await db.suggestedFoods(mealSlotId: dinner.id, now: now);
      expect(d.map((f) => f.id), [potato.id]);
      // Older than the window: nothing.
      expect(await db.suggestedFoods(mealSlotId: breakfast.id, now: DateTime(2026, 6, 1)), isEmpty);
    });

    test('Schnelleintrag nur mit Kalorien, als Schätzung gekennzeichnet', () async {
      final slot = (await db.watchMealSlots().first)[1];
      await db.logQuickEntry(day: '2026-03-01', mealSlotId: slot.id, label: 'Pizza', kcal: 850, protein: 30, fat: 35);
      final e = (await db.diaryForDay('2026-03-01')).single;
      expect(e.foodName, 'Pizza');
      expect(e.brand, AppDatabase.quickEntryBrand);
      expect(e.nutrients.kcal, closeTo(850, 1e-9));
      expect(e.nutrients.protein, closeTo(30, 1e-9));
      expect(e.nutrients.carbs, 0);
      final totals = await db.dailyTotals('2026-03-01', '2026-03-01');
      expect(totals['2026-03-01']!.kcal, closeTo(850, 1e-9));
      await expectLater(
        db.logQuickEntry(day: '2026-03-01', mealSlotId: slot.id, label: '', kcal: 0),
        throwsArgumentError,
      );
    });

    test('Vorlage aus Mahlzeit speichern, eintragen, ersetzen, löschen', () async {
      final slots = await db.watchMealSlots().first;
      final breakfast = slots[0];
      final oats = (await db.searchFoods('Haferflocken')).first;
      final quark = (await db.searchFoods('Magerquark')).first;
      await db.logFood(day: '2026-03-01', mealSlotId: breakfast.id, food: oats, amount: 60);
      await db.logFood(day: '2026-03-01', mealSlotId: breakfast.id, food: quark, amount: 250);
      final id = await db.saveTemplateFromMeal(name: 'Mein Frühstück', day: '2026-03-01', mealSlotId: breakfast.id);
      expect((await db.templateItemsOf(id)).map((i) => i.foodName), [oats.name, quark.name]);

      expect(await db.logTemplate(templateId: id, day: '2026-03-02', mealSlotId: breakfast.id), 2);
      final logged = await db.diaryForDay('2026-03-02');
      expect(logged.map((e) => e.amount), [60, 250]);
      expect((await db.watchTemplates().first).single.useCount, 1);

      // Same name replaces the items.
      await db.logFood(day: '2026-03-03', mealSlotId: breakfast.id, food: oats, amount: 80);
      final id2 = await db.saveTemplateFromMeal(name: 'mein frühstück', day: '2026-03-03', mealSlotId: breakfast.id);
      expect(id2, id);
      expect((await db.templateItemsOf(id)).single.amount, 80);

      await expectLater(
        db.saveTemplateFromMeal(name: 'Leer', day: '2026-03-09', mealSlotId: breakfast.id),
        throwsArgumentError,
      );
      await db.deleteTemplate(id);
      expect(await db.watchTemplates().first, isEmpty);
      // Diary entries stay, a new template may reuse the name.
      expect((await db.diaryForDay('2026-03-02')).length, 2);
      await db.saveTemplateFromMeal(name: 'Mein Frühstück', day: '2026-03-01', mealSlotId: breakfast.id);
      expect((await db.watchTemplates().first).length, 1);
    });

    test('Mahlzeit auf beliebiges Datum kopieren', () async {
      final slot = (await db.watchMealSlots().first).first;
      final oats = (await db.searchFoods('Haferflocken')).first;
      await db.logFood(day: '2026-03-01', mealSlotId: slot.id, food: oats, amount: 60);
      expect(await db.copyMeal(fromDay: '2026-03-01', fromSlotId: slot.id, toDay: '2026-03-10'), 1);
      expect((await db.diaryForDay('2026-03-10')).single.amount, 60);
    });
  });

  group('Mahlzeiten', () {
    test('1 bis 6 Mahlzeiten; entfernte behalten ihre Einträge', () async {
      final slots = await db.watchMealSlots().first;
      final f = (await db.searchFoods('Apfel')).first;
      await db.logFood(day: '2026-01-05', mealSlotId: slots[1].id, food: f, amount: 150);
      await db.saveMealSlots([
        (id: slots[0].id, name: 'Frühstück', minuteOfDay: 6 * 60),
        (id: null, name: 'Spätes Mittag', minuteOfDay: 14 * 60),
      ]);
      final now = await db.watchMealSlots().first;
      expect(now.map((s) => s.name), ['Frühstück', 'Spätes Mittag']);
      expect((await db.diaryForDay('2026-01-05')).single.mealSlotId, slots[1].id);
      expect(() => db.saveMealSlots([]), throwsArgumentError);
      expect(
        () => db.saveMealSlots([for (var i = 0; i < 7; i++) (id: null, name: 'M$i', minuteOfDay: null)]),
        throwsArgumentError,
      );
    });
  });

  group('Gewicht, Wasser, Aktivität', () {
    test('Ein Gewicht pro Tag: neuer Wert ersetzt den alten', () async {
      await db.saveWeight(day: '2026-01-05', weightKg: 100.2);
      await db.saveWeight(day: '2026-01-05', weightKg: 99.8, bodyFatPercent: 28);
      final all = await db.allWeights();
      expect(all.single.weightKg, 99.8);
      expect(all.single.bodyFatPercent, 28);
      await db.deleteWeight(all.single.id);
      expect(await db.allWeights(), isEmpty);
      await db.saveWeight(day: '2026-01-05', weightKg: 99.5);
      expect((await db.allWeights()).single.weightKg, 99.5);
      expect(() => db.saveWeight(day: '2026-01-06', weightKg: 5), throwsArgumentError);
    });

    test('Wasser summiert und lässt sich zurücknehmen', () async {
      await db.addWater('2026-01-05', 250);
      await db.addWater('2026-01-05', 500);
      expect(await db.watchWaterMl('2026-01-05').first, 750);
      expect(await db.undoLastWater('2026-01-05'), isTrue);
      expect(await db.watchWaterMl('2026-01-05').first, 250);
      expect(await db.watchWaterMl('2026-01-06').first, 0);
    });

    test('Importierte Aktivität ist pro Quelle eindeutig', () async {
      await db.addActivity(day: '2026-01-05', label: 'Laufen', minutes: 30, kcal: 300);
      await db
          .into(db.activityEntries)
          .insert(
            ActivityEntriesCompanion.insert(
              dayKey: '2026-01-05',
              label: 'Run',
              source: const Value('garmin'),
              externalId: const Value('x1'),
            ),
          );
      expect(
        () => db
            .into(db.activityEntries)
            .insert(
              ActivityEntriesCompanion.insert(
                dayKey: '2026-01-05',
                label: 'Run',
                source: const Value('garmin'),
                externalId: const Value('x1'),
              ),
            ),
        throwsA(isA<SqliteException>()),
      );
      expect((await db.watchActivities('2026-01-05').first).length, 2);
    });
  });

  group('Export und Import', () {
    test('Export → Import in neue Datenbank ergibt denselben Stand', () async {
      final slot = (await db.watchMealSlots().first).first;
      await db.saveFood(
        name: 'Eigenes Müsli',
        brand: 'Selbst',
        per100: const Nutrients(kcal: 380, protein: 12, carbs: 60, fat: 9, fiber: 8),
      );
      final f = (await db.searchFoods('Eigenes Müsli')).single;
      await db.logFood(day: '2026-01-05', mealSlotId: slot.id, food: f, amount: 70);
      await db.saveWeight(day: '2026-01-05', weightKg: 98.4, waistCm: 101);
      await db.addWater('2026-01-05', 500);
      await db.setSetting('themeMode', 'dark');
      final json = await db.exportJson();

      final other = AppDatabase(NativeDatabase.memory());
      addTearDown(other.close);
      await other.watchFoods().first; // opened + seeded
      final counts = await other.importJson(json);
      expect(counts['diary_entries'], 1);
      expect((await other.diaryForDay('2026-01-05')).single.nutrients.kcal, closeTo(266, 1e-9));
      expect((await other.allWeights()).single.waistCm, 101);
      expect(await other.watchWaterMl('2026-01-05').first, 500);
      expect(await other.getSetting('themeMode'), 'dark');
      expect((await other.watchFoods().first).length, referenceFoods.length + 1);
      final again = await other.exportJson();
      String strip(String s) => s.replaceAll(RegExp(r'"exportedAt": "[^"]*"'), '');
      expect(strip(again), strip(json));
    });

    test('Ungültige Datei ändert nichts', () async {
      await db.saveWeight(day: '2026-01-05', weightKg: 98.4);
      await expectLater(db.importJson('{"format":"other"}'), throwsFormatException);
      await expectLater(db.importJson('not json'), throwsFormatException);
      // Kaputte Zeile mitten im Import: Transaktion wird zurückgerollt
      final json = await db.exportJson();
      final broken = json.replaceFirst('"weight_kg": 98.4', '"weight_kg": null');
      await expectLater(db.importJson(broken), throwsA(anything));
      expect((await db.allWeights()).single.weightKg, 98.4);
    });
  });
}
