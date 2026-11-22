import 'package:flutter_test/flutter_test.dart';
import 'package:mydiet_ai/src/core/meal_plan.dart';

void main() {
  test('Text vereinheitlichen', () {
    expect(foldText('Käse-Spätzle, Grüße!'), 'kaese spaetzle  gruesse');
  });

  test('Wörter und zusammengesetzte Wörter', () {
    expect(mentions('vollmilch', 'milch'), isTrue);
    expect(mentions('milchreis', 'milch'), isTrue);
    expect(mentions('haselnuesse gemahlen', 'nuesse'), isTrue);
    expect(mentions('vollmilchschokolade', 'milch'), isTrue);
    expect(mentions('weizenmehl', 'mehl'), isTrue);
    expect(mentions('ei', 'ei'), isTrue);
    expect(mentions('weizen', 'ei'), isFalse, reason: 'kurze Begriffe nur als ganzes Wort');
    expect(mentions('reis', 'ei'), isFalse);
    expect(mentions('creme fraiche', 'creme fraiche'), isTrue);
  });

  test('Unverträglichkeiten stehen für ganze Gruppen', () {
    expect(avoidTermsFor('Laktose'), containsAll(['milch', 'joghurt', 'kaese']));
    expect(avoidTermsFor('Nüsse'), containsAll(['mandel', 'walnuss']));
    expect(avoidTermsFor('Koriander'), {'koriander'});
    expect(avoidTermsFor('  '), isEmpty);
  });

  test('Ausschluss mit Grund', () {
    final why = excludedBy(['Overnight Oats', 'Haferflocken', 'Naturjoghurt'], avoid: ['Laktose', 'Fisch']);
    expect(why?.entry, 'Laktose');
    expect(why?.found, 'Naturjoghurt');
    expect(excludedBy(['Gemüsepfanne', 'Paprika', 'Reis'], avoid: ['Laktose', 'Gluten', 'Ei']), isNull);
    expect(excludedBy(['Spaghetti Bolognese'], avoid: ['Gluten'])?.found, 'Spaghetti Bolognese');
    expect(excludedBy(['Thunfischsalat'], avoid: ['fisch'])?.entry, 'fisch');
    expect(excludedBy(['Rührei'], avoid: ['Eier']), isNotNull);
  });

  test('Vorlieben zählen und sortieren stabil', () {
    expect(preferenceScore(['Hähnchenpfanne', 'Reis', 'Brokkoli'], ['Hähnchen', 'Brokkoli', 'Tofu']), 2);
    const a = PlanRecipe(id: 'a', kcalPer100: 100, servingWeight: 300);
    const b = PlanRecipe(id: 'b', kcalPer100: 100, servingWeight: 300);
    const c = PlanRecipe(id: 'c', kcalPer100: 100, servingWeight: 300);
    expect(preferFirst([a, b, c], {'c': 1}).map((r) => r.id), ['c', 'a', 'b']);
    expect(preferFirst([a, b, c], {}).map((r) => r.id), ['a', 'b', 'c']);
  });

  test('Text zu ausgelassenen Rezepten', () {
    expect(const PlanFill(planned: 2).skippedText(), isNull);
    final t = const PlanFill(
      planned: 1,
      skipped: {'A': 'Laktose', 'B': 'Fisch', 'C': 'Gluten', 'D': 'Ei'},
    ).skippedText(max: 2);
    expect(t, contains('A (Laktose), B (Fisch) und 2 weitere'));
  });
}
