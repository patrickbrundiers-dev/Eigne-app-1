import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mydiet_ai/src/core/meal_text.dart';
import 'package:mydiet_ai/src/data/database.dart';
import 'package:mydiet_ai/src/data/meal_text_match.dart';

void main() {
  group('Text zerlegen', () {
    test('Komma, „und“, Zeilenumbruch und + trennen Einträge', () {
      final l = parseMealText('200 g Hähnchen, 2 Eier und 1 Banane\nKaffee + 1 Apfel');
      expect(l.map((e) => e.query), ['haehnchen', 'eier', 'banane', 'kaffee', 'apfel']);
    });

    test('Gramm, Kilo, Milliliter, Liter, auch ohne Leerzeichen', () {
      expect(parseLine('200g Reis').amount, 200);
      expect(parseLine('200g Reis').unit, TextUnit.gram);
      expect(parseLine('0,5 kg Kartoffeln').amount, 500);
      expect(parseLine('0,5 kg Kartoffeln').unit, TextUnit.gram);
      expect(parseLine('250 ml Milch').unit, TextUnit.milliliter);
      expect(parseLine('1,5l Wasser').amount, 1500);
      expect(parseLine('33 cl Cola').amount, 330);
    });

    test('Zahlwörter, Brüche, ½', () {
      expect(parseLine('zwei Eier').amount, 2);
      expect(parseLine('eine Banane').amount, 1);
      expect(parseLine('halbe Avocado').amount, 0.5);
      expect(parseLine('1/2 Avocado').amount, 0.5);
      expect(parseLine('½ Avocado').amount, 0.5);
      expect(parseLine('½ Avocado').query, 'avocado');
    });

    test('Löffel und Portionswörter', () {
      final el = parseLine('2 EL Olivenöl');
      expect(el.unit, TextUnit.tablespoon);
      expect(el.amount, 2);
      expect(el.query, 'olivenoel');
      expect(parseLine('1 TL Honig').unit, TextUnit.teaspoon);
      final sc = parseLine('3 Scheiben Kochschinken');
      expect(sc.unit, TextUnit.piece);
      expect(sc.pieceWord, 'scheibe');
      expect(sc.query, 'kochschinken');
      expect(parseLine('1 Becher Skyr').pieceWord, 'becher');
    });

    test('Füllwörter fallen weg, Prozentangaben bleiben im Namen', () {
      expect(parseLine('ca. 150 g von dem Magerquark').query, 'magerquark');
      final m = parseLine('300 ml Milch 1,5 %');
      expect(m.amount, 300);
      expect(m.query, 'milch 1.5 %');
    });

    test('Ohne Zahl: Menge bleibt offen', () {
      final b = parseLine('Banane');
      expect(b.amount, isNull);
      expect(b.unit, TextUnit.none);
    });

    test('Leere Teile werden ignoriert', () {
      expect(parseMealText(' , und ,'), isEmpty);
    });
  });

  group('Suchbegriffe', () {
    test('Alltagswort zuerst über Synonym, dann Einzahl', () {
      expect(searchTermsFor('eier').first, 'huehnerei');
      expect(searchTermsFor('haehnchen').first, 'haehnchenbrust');
      expect(searchTermsFor('bananen'), contains('banane'));
      expect(searchTermsFor('gebratenes haehnchen'), contains('haehnchenbrust'));
    });
  });

  group('Menge umrechnen', () {
    const egg = FoodUnitInfo(unit: 'g', servingAmount: 60, servingLabel: 'Stück (M)');
    const quark = FoodUnitInfo(unit: 'g', servingAmount: 250, servingLabel: 'Becher');
    const milk = FoodUnitInfo(unit: 'ml', servingAmount: 250, servingLabel: 'Glas');
    const rice = FoodUnitInfo(unit: 'g');

    test('Stückzahl ohne Einheit nutzt die Portionsgröße, sicher', () {
      final r = resolveAmount(parseLine('2 Eier'), egg);
      expect(r.amount, 120);
      expect(r.isEstimate, isFalse);
    });

    test('Große Zahl ohne Einheit gilt als Gramm', () {
      final r = resolveAmount(parseLine('200 Reis'), rice);
      expect(r.amount, 200);
      expect(r.isEstimate, isFalse);
    });

    test('Passendes Portionswort ist sicher, anderes wird als Annahme markiert', () {
      expect(resolveAmount(parseLine('1 Becher Magerquark'), quark).isEstimate, isFalse);
      final r = resolveAmount(parseLine('1 Schale Magerquark'), quark);
      expect(r.amount, 250);
      expect(r.isEstimate, isTrue);
      expect(r.note, contains('Becher'));
    });

    test('Löffel: 15 bzw. 5 Einheiten, immer Annahme', () {
      final el = resolveAmount(parseLine('2 EL Rapsöl'), rice);
      expect(el.amount, 30);
      expect(el.isEstimate, isTrue);
      expect(resolveAmount(parseLine('1 TL Honig'), rice).amount, 5);
    });

    test('g bei Getränk und ml bei festem Lebensmittel: 1:1 als Annahme', () {
      final a = resolveAmount(parseLine('200 g Milch'), milk);
      expect(a.amount, 200);
      expect(a.isEstimate, isTrue);
      expect(resolveAmount(parseLine('250 ml Milch'), milk).isEstimate, isFalse);
      expect(resolveAmount(parseLine('100 ml Reis'), rice).isEstimate, isTrue);
    });

    test('Ohne Zahl: eine Portion als Annahme, sonst übliche Menge, sonst offen', () {
      final one = resolveAmount(parseLine('Ei'), egg);
      expect(one.amount, 60);
      expect(one.isEstimate, isTrue);
      final usual = resolveAmount(parseLine('Reis'), rice, usualAmount: 180);
      expect(usual.amount, 180);
      expect(usual.isEstimate, isTrue);
      expect(resolveAmount(parseLine('Reis'), rice).amount, isNull);
    });

    test('Stück ohne hinterlegte Portion: Menge offen statt geraten', () {
      final r = resolveAmount(parseLine('2 Stück Reis'), rice);
      expect(r.amount, isNull);
    });
  });

  group('Abgleich mit der eigenen Datenbank', () {
    late AppDatabase db;
    setUp(() async {
      driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
      db = AppDatabase(NativeDatabase.memory());
      await db.getProfile(); // opens the database and seeds the base foods
    });
    tearDown(() => db.close());

    test('Typische Mahlzeit wird vollständig erkannt', () async {
      final m = await matchMealText(db, '200 g Hähnchenbrustfilet, 2 Eier und 1 Banane');
      expect(m, hasLength(3));
      expect(m[0].food!.name, startsWith('Hähnchenbrust'));
      expect(m[0].amount.amount, 200);
      expect(m[1].food!.name, 'Hühnerei');
      expect(m[1].amount.amount, 120);
      expect(m[1].isCertain, isTrue);
      expect(m[2].food!.name, 'Banane');
    });

    test('Unbekanntes wird als nicht gefunden markiert, nichts erfunden', () async {
      final m = await matchMealText(db, '100 g Drachenfrucht-Sorbet');
      expect(m.single.food, isNull);
      expect(m.single.quality, MatchQuality.none);
      expect(m.single.amount.amount, isNull);
      expect(m.single.isCertain, isFalse);
    });

    test('Übliche Menge aus dem eigenen Tagebuch', () async {
      final slot = (await db.watchMealSlots().first).first;
      final rice = (await db.searchFoods('reis gekocht')).first;
      await db.logFood(day: '2026-03-01', mealSlotId: slot.id, food: rice, amount: 180);
      final m = await matchMealText(db, 'Reis gekocht');
      expect(m.single.food!.id, rice.id);
      expect(m.single.amount.amount, 180);
      expect(m.single.amount.isEstimate, isTrue);
      expect(m.single.isCertain, isFalse);
    });
  });
}
