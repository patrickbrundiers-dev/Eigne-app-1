import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:mydiet_ai/src/core/meal_text.dart';
import 'package:mydiet_ai/src/core/recipe_import.dart';
import 'package:mydiet_ai/src/data/database.dart';
import 'package:mydiet_ai/src/data/recipe_import_client.dart';

const page = '''
<html><head>
<script type="application/ld+json">{"@context":"https://schema.org","@type":"WebSite","name":"Kochseite"}</script>
<script type="application/ld+json">
{"@context":"https://schema.org","@graph":[
  {"@type":"BreadcrumbList","itemListElement":[]},
  {"@type":["Recipe","NewsArticle"],"name":"Spaghetti mit Tomatensoße &amp; Basilikum",
   "recipeYield":["4","4 Portionen"],
   "prepTime":"PT15M","cookTime":"PT20M",
   "keywords":"vegetarisch, schnell, Pasta",
   "recipeCategory":"Hauptgericht",
   "recipeIngredient":["400 g Spaghetti","1 Zwiebel, fein gewürfelt","2 EL Olivenöl",
     "500 g passierte Tomaten (aus der Packung)","Salz und Pfeffer","½ TL Zucker"],
   "recipeInstructions":[{"@type":"HowToStep","text":"Zwiebel <b>andünsten</b>."},{"@type":"HowToStep","text":"Tomaten dazu."}],
   "nutrition":{"calories":"9999 kcal"}}
]}
</script></head><body></body></html>
''';

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  group('schema.org-Rezept lesen', () {
    test('Rezept aus @graph mit mehreren Typen', () {
      final r = parseRecipeHtml(page, source: Uri.parse('https://example.org/r/1'))!;
      expect(r.name, 'Spaghetti mit Tomatensoße & Basilikum');
      expect(r.servings, 4);
      expect(r.totalMinutes, 35);
      expect(r.ingredients, hasLength(6));
      expect(r.ingredients[1], '1 Zwiebel, fein gewürfelt');
      expect(r.tags, containsAll(['vegetarisch', 'schnell', 'Pasta', 'Hauptgericht']));
      expect(r.instructions, '1. Zwiebel andünsten.\n2. Tomaten dazu.');
      expect(r.source.toString(), 'https://example.org/r/1');
    });

    test('Seiten ohne Rezept oder mit kaputtem JSON', () {
      expect(parseRecipeHtml('<html><p>Hallo</p></html>'), isNull);
      expect(parseRecipeHtml('<script type="application/ld+json">{kaputt</script>'), isNull);
      expect(
        parseRecipeHtml('<script type="application/ld+json">{"@type":"Recipe","name":"Leer"}</script>'),
        isNull,
        reason: 'ohne Zutaten nicht übernehmen',
      );
    });

    test('Portionen, Zeiten, Text', () {
      expect(parseYield('2-3 Personen'), 2);
      expect(parseYield(6), 6);
      expect(parseYield('1,5'), 1.5);
      expect(parseYield('viele'), isNull);
      expect(parseYield(0), isNull);
      expect(parseIsoMinutes('PT1H30M'), 90);
      expect(parseIsoMinutes('P0DT2H'), 120);
      expect(parseIsoMinutes('PT0S'), isNull);
      expect(parseIsoMinutes('30 Minuten'), isNull);
      expect(cleanText('M&uuml;sli&nbsp; <i>mit</i>&#32;N&#xFC;ssen'), 'Müsli mit Nüssen');
    });

    test('Zutatenzeile ohne Zubereitungshinweis', () {
      expect(ingredientCore('1 Zwiebel, fein gewürfelt'), '1 Zwiebel');
      expect(ingredientCore('500 g passierte Tomaten (aus der Packung)'), '500 g passierte Tomaten');
      expect(ingredientCore('½ TL Zucker'), '0,5 TL Zucker');
      expect(ingredientCore('1½ kg Kartoffeln, festkochend'), '1,5 kg Kartoffeln');
      expect(ingredientCore('0,5 l Milch'), '0,5 l Milch');
      expect(isNegligibleIngredient('Salz und Pfeffer'), isTrue);
      expect(isNegligibleIngredient('Für die Soße:'), isTrue);
      expect(isNegligibleIngredient('etwas Petersilie'), isTrue);
      expect(isNegligibleIngredient('2 EL Olivenöl'), isFalse);
    });

    test('Eingefügter Text: eine Zutat pro Zeile, Aufzählungszeichen weg', () {
      final r = recipeFromPastedText('- 200 g Haferflocken\n\n• 300 ml Milch\r\n1 Banane');
      expect(r.ingredients, ['200 g Haferflocken', '300 ml Milch', '1 Banane']);
      expect(r.servings, isNull);
    });
  });

  group('Laden und zuordnen', () {
    late AppDatabase db;
    setUp(() => db = AppDatabase(NativeDatabase.memory()));
    tearDown(() => db.close());

    test('Seite laden: nur die Adresse wird abgefragt, Fehler verständlich', () async {
      Uri? asked;
      final ok = RecipePageClient(
        client: MockClient((req) async {
          asked = req.url;
          expect(req.headers['User-Agent'], RecipePageClient.userAgent);
          return http.Response(page, 200, headers: {'content-type': 'text/html; charset=utf-8'});
        }),
      );
      final r = await ok.load(Uri.parse('https://example.org/r/1'));
      expect(asked.toString(), 'https://example.org/r/1');
      expect(r.ingredients, hasLength(6));

      final none = RecipePageClient(client: MockClient((_) async => http.Response('<html></html>', 200)));
      expect(
        () => none.load(Uri.parse('https://example.org/x')),
        throwsA(isA<RecipeImportException>().having((e) => e.message, 'm', contains('einfügen'))),
      );
      final err = RecipePageClient(client: MockClient((_) async => http.Response('', 404)));
      expect(() => err.load(Uri.parse('https://example.org/x')), throwsA(isA<RecipeImportException>()));
      expect(() => ok.load(Uri.parse('file:///etc/passwd')), throwsA(isA<RecipeImportException>()));
    });

    test('Zutaten werden der eigenen Datenbank zugeordnet', () async {
      final r = parseRecipeHtml(page)!;
      final m = await matchIngredients(db, r.ingredients);
      final byRaw = {for (final x in m) x.raw: x};
      expect(byRaw['Salz und Pfeffer']!.negligible, isTrue);
      final pasta = byRaw['400 g Spaghetti']!.match!;
      expect(pasta.food, isNotNull);
      expect(pasta.amount.amount, 400);
      final oil = byRaw['2 EL Olivenöl']!.match!;
      expect(oil.food?.name, contains('Olivenöl'));
      expect(oil.amount.amount, isNotNull);
      expect(oil.amount.isEstimate || oil.amount.note != null, isTrue, reason: 'EL ist umgerechnet');
      final onion = byRaw['1 Zwiebel, fein gewürfelt']!.match!;
      expect(onion.line.unit, anyOf(TextUnit.none, TextUnit.piece));
    });
  });
}
