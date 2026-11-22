import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mydiet_ai/src/core/fuzzy_search.dart';
import 'package:mydiet_ai/src/core/meal_text.dart';
import 'package:mydiet_ai/src/data/database.dart';
import 'package:mydiet_ai/src/data/food_search.dart';
import 'package:mydiet_ai/src/data/meal_text_match.dart';

void main() {
  group('Editierdistanz', () {
    test('Grundfälle', () {
      expect(editDistance('banane', 'banane'), 0);
      expect(editDistance('banane', 'banae'), 1); // fehlender Buchstabe
      expect(editDistance('joghurd', 'joghurt'), 1); // falscher Buchstabe
      expect(editDistance('haferflokcen', 'haferflocken'), 1); // vertauscht
      expect(editDistance('', 'abc'), 3);
    });

    test('Abbruch über dem Maximum', () {
      expect(editDistance('apfel', 'zucchini', max: 2), 3);
    });
  });

  group('Wortvergleich', () {
    test('Kurze Wörter brauchen exakte Treffer', () {
      expect(allowedTypos('ei'), 0);
      expect(wordScore('eu', 'ei'), 0);
      expect(allowedTypos('apfel'), 1);
      expect(allowedTypos('haferflocken'), 2);
    });

    test('Exakt vor Anfang vor Tippfehler', () {
      final exact = wordScore('banane', 'banane');
      final prefix = wordScore('ban', 'banane');
      final typo = wordScore('banae', 'banane');
      final typoPrefix = wordScore('haferflok', 'haferflocken');
      expect(exact, 1);
      expect(prefix, greaterThan(typo));
      expect(typo, greaterThan(0));
      expect(typoPrefix, greaterThan(0));
    });

    test('Ganzer Name: jedes Suchwort muss passen', () {
      expect(nameScore(['vollkorn', 'brot'], 'vollkornbrot'), greaterThan(0));
      expect(nameScore(['joghurd', 'natur'], 'joghurt natur 3 5%'), greaterThan(0.5));
      expect(nameScore(['joghurd', 'erdbeer'], 'joghurt natur 3 5%'), 0);
    });
  });

  group('Rangfolge', () {
    test('Bei gleicher Passung gewinnt, was oft gegessen wird', () {
      final r = rankCandidates<String>(
        queryWords: ['apfel'],
        items: ['apfel gruen', 'apfel rot'],
        key: (s) => s,
        usage: (s) => s == 'apfel gruen' ? 7 : 1,
      );
      expect(r.first, 'apfel gruen');
    });

    test('Bessere Passung schlägt Nutzung', () {
      final r = rankCandidates<String>(
        queryWords: ['banane'],
        items: ['bananenchips', 'banane'],
        key: (s) => s,
        usage: (s) => s == 'bananenchips' ? 20 : 0,
      );
      expect(r.first, 'banane');
    });

    test('Unpassendes fällt heraus', () {
      final r = rankCandidates<String>(queryWords: ['apfel'], items: ['zucchini', 'lachs'], key: (s) => s);
      expect(r, isEmpty);
    });
  });

  group('Suche in der Datenbank', () {
    late AppDatabase db;
    setUp(() async {
      driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
      db = AppDatabase(NativeDatabase.memory());
      await db.getProfile();
    });
    tearDown(() => db.close());

    test('Tippfehler finden das Lebensmittel trotzdem', () async {
      expect(await db.searchFoods('Haferflokcen'), isEmpty);
      final r = await smartSearchFoods(db, 'Haferflokcen');
      expect(r.first.name, startsWith('Haferflocken'));
      final b = await smartSearchFoods(db, 'Banae');
      expect(b.first.name, 'Banane');
    });

    test('Umlaute ohne Punkte und als ae/oe/ue', () async {
      final a = await smartSearchFoods(db, 'Huhnerei');
      expect(a.first.name, 'Hühnerei');
      final b = await smartSearchFoods(db, 'Huehnerei');
      expect(b.first.name, 'Hühnerei');
    });

    test('Oft gegessenes steht vorne', () async {
      final slot = (await db.watchMealSlots().first).first;
      final before = await smartSearchFoods(db, 'reis');
      expect(before.first.name, 'Reis, roh'); // gleich gut passend, kürzerer Name
      final cooked = before.firstWhere((f) => f.name == 'Reis, gekocht');
      final today = DateTime.now();
      for (var i = 1; i <= 3; i++) {
        final d = today.subtract(Duration(days: i));
        final key = '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
        await db.logFood(day: key, mealSlotId: slot.id, food: cooked, amount: 150);
      }
      expect((await foodUsage(db))[cooked.id], 3);
      expect((await foodUsage(db, now: today.add(const Duration(days: 400))))[cooked.id], isNull);
      final after = await smartSearchFoods(db, 'reis');
      expect(after.first.id, cooked.id);
      // Ein schlechter passender Name rückt durch Nutzung nicht vor einen exakten.
      expect(after.indexWhere((f) => f.name == 'Reiswaffeln'), greaterThan(1));
    });

    test('Leere Suche liefert nichts', () async {
      expect(await smartSearchFoods(db, '  '), isEmpty);
    });

    test('Text-Eintrag: Tippfehler wird angeboten, aber nicht sicher', () async {
      final m = await matchMealText(db, '50 g Haferflokcen');
      expect(m.single.food!.name, startsWith('Haferflocken'));
      expect(m.single.quality, MatchQuality.uncertain);
      expect(m.single.isCertain, isFalse);
    });
  });
}
