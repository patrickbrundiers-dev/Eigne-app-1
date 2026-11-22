import 'package:flutter_test/flutter_test.dart';
import 'package:mydiet_ai/src/core/day_budget.dart';
import 'package:mydiet_ai/src/core/nutrition.dart';
import 'package:mydiet_ai/src/data/seed_foods.dart';

void main() {
  group('Nährwerte', () {
    const chicken = Nutrients(kcal: 106, protein: 23.5, carbs: 0, fat: 1.2);
    const potato = Nutrients(kcal: 72, protein: 2, carbs: 15, fat: 0.1, fiber: 1.6);
    const broccoli = Nutrients(kcal: 35, protein: 2.8, carbs: 4, fat: 0.4, fiber: 2.6);

    test('Menge wird linear umgerechnet', () {
      final n = chicken.forAmount(200);
      expect(n.kcal, closeTo(212, 1e-9));
      expect(n.protein, closeTo(47, 1e-9));
      expect(chicken.forAmount(0), Nutrients.zero);
    });

    test('Beispiel: 200 g Hähnchen, 250 g Kartoffeln, 300 g Brokkoli', () {
      final total = Nutrients.sum([chicken.forAmount(200), potato.forAmount(250), broccoli.forAmount(300)]);
      expect(total.kcal, closeTo(212 + 180 + 105, 1e-9)); // 497
      expect(total.protein, closeTo(47 + 5 + 8.4, 1e-9)); // 60,4
      expect(total.carbs, closeTo(0 + 37.5 + 12, 1e-9));
      expect(total.fiber, closeTo(4 + 7.8, 1e-9));
    });

    test('Atwater-Energie (EU-Faktoren)', () {
      const n = Nutrients(protein: 10, carbs: 10, fat: 10, fiber: 10);
      expect(n.atwaterKcal, 40 + 40 + 90 + 20);
    });
  });

  group('Plausibilitätsprüfung', () {
    test('Gültige Werte', () {
      final c = checkPer100(const Nutrients(kcal: 106, protein: 23.5, fat: 1.2, saturatedFat: 0.3));
      expect(c.ok, isTrue);
      expect(c.warnings, isEmpty);
    });

    test('Negative Werte und mehr als 100 g sind Fehler', () {
      expect(checkPer100(const Nutrients(kcal: -1)).ok, isFalse);
      expect(checkPer100(const Nutrients(kcal: 500, protein: 60, carbs: 50)).errors, isNotEmpty);
      expect(checkPer100(const Nutrients(kcal: 950)).ok, isFalse);
    });

    test('Zucker > Kohlenhydrate und gesättigt > Fett sind Fehler', () {
      expect(checkPer100(const Nutrients(kcal: 40, carbs: 5, sugar: 8)).ok, isFalse);
      expect(checkPer100(const Nutrients(kcal: 90, fat: 10, saturatedFat: 12)).ok, isFalse);
    });

    test('Kalorien passen nicht zu den Makros: Warnung, kein Fehler', () {
      final c = checkPer100(const Nutrients(kcal: 500, protein: 10, carbs: 10, fat: 1));
      expect(c.ok, isTrue);
      expect(c.warnings, isNotEmpty);
    });

    test('Alle Basis-Lebensmittel sind plausibel', () {
      for (final f in referenceFoods) {
        final n = Nutrients(
          kcal: f.kcal,
          protein: f.protein,
          carbs: f.carbs,
          sugar: f.sugar,
          fat: f.fat,
          saturatedFat: f.satFat,
          fiber: f.fiber,
          salt: f.salt,
        );
        final c = checkPer100(n);
        expect(c.errors, isEmpty, reason: f.name);
        expect(c.warnings, isEmpty, reason: '${f.name}: ${c.warnings}');
      }
    });

    test('Basis-Lebensmittel haben keine Duplikate', () {
      final keys = referenceFoods.map((f) => foodKey(f.name, null)).toList();
      expect(keys.toSet().length, keys.length);
    });
  });

  group('Namen normalisieren', () {
    test('Groß/klein, Umlaute, Satzzeichen', () {
      expect(normalizeName('  Hähnchen-Brust, ROH '), 'haehnchen brust roh');
      expect(foodKey('Skyr', 'Arla'), foodKey('skyr ', ' ARLA'));
      expect(foodKey('Skyr', null), isNot(foodKey('Skyr', 'Arla')));
    });
  });

  group('Tagesbudget und Aktivität', () {
    test('Standard: Aktivität wird nicht addiert (steckt im PAL)', () {
      final b = dayBudget(
        targetKcal: 2000,
        consumed: const Nutrients(kcal: 1500),
        activities: const [ActivityItem(kcal: 400, source: 'manual', id: 'a')],
        creditPercent: 0,
      );
      expect(b.activityKcal, 400);
      expect(b.budgetKcal, 2000);
      expect(b.remainingKcal, 500);
    });

    test('Anteilige Anrechnung', () {
      final b = dayBudget(
        targetKcal: 2000,
        consumed: Nutrients.zero,
        activities: const [ActivityItem(kcal: 400, source: 'manual', id: 'a')],
        creditPercent: 50,
      );
      expect(b.budgetKcal, 2200);
    });

    test('Dieselbe importierte Aktivität zählt nur einmal', () {
      const items = [
        ActivityItem(kcal: 300, source: 'garmin', externalId: 'run-1', id: 'r1'),
        ActivityItem(kcal: 300, source: 'garmin', externalId: 'run-1', id: 'r2'),
        ActivityItem(kcal: 200, source: 'health_connect', externalId: 'run-1', id: 'r3'),
        ActivityItem(kcal: 100, source: 'manual', id: 'm1'),
      ];
      expect(totalActivityKcal(items), 600);
    });

    test('Prozent wird auf 0-100 begrenzt, negative kcal ignoriert', () {
      final b = dayBudget(
        targetKcal: 2000,
        consumed: Nutrients.zero,
        activities: const [
          ActivityItem(kcal: 100, source: 'manual', id: 'a'),
          ActivityItem(kcal: -50, source: 'manual', id: 'b'),
        ],
        creditPercent: 250,
      );
      expect(b.activityCreditKcal, 100);
    });
  });
}
