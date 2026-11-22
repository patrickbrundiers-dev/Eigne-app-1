import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mydiet_ai/src/core/supplements.dart';
import 'package:mydiet_ai/src/data/database.dart';

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  const multi = [
    SupplementDose(nutrientId: 'vit_d', amount: 20, unit: 'µg'),
    SupplementDose(nutrientId: 'zinc', amount: 10, unit: 'mg'),
    SupplementDose(nutrientId: 'magnesium', amount: 100, unit: 'mg'),
  ];
  const d3k2 = [
    SupplementDose(nutrientId: 'vit_d', amount: 0.075, unit: 'mg'), // 75 µg
    SupplementDose(nutrientId: 'vit_k', amount: 100, unit: 'µg'),
  ];

  group('Summen', () {
    test('Vitamin D aus Multi + D3/K2 wird addiert, Einheiten umgerechnet', () {
      final t = sumSupplements(const [
        SupplementUse(product: 'Multi', servings: 1, doses: multi),
        SupplementUse(product: 'D3K2', servings: 1, doses: d3k2),
      ]);
      final d = t.firstWhere((n) => n.nutrientId == 'vit_d');
      expect(d.amount, closeTo(95, 1e-9));
      expect(d.unit, 'µg');
      expect(d.sources, {'Multi': 20, 'D3K2': closeTo(75, 1e-9)});
      expect(d.ulPercent, closeTo(95, 1e-9));
      expect(d.status, LimitStatus.near);
      expect(d.nrvPercent, closeTo(1900, 1e-9));
      expect(t.firstWhere((n) => n.nutrientId == 'vit_k').status, LimitStatus.none);
    });

    test('Über der Höchstmenge wird erkannt und zuerst sortiert', () {
      final t = sumSupplements(const [
        SupplementUse(product: 'Multi', servings: 2, doses: multi),
        SupplementUse(product: 'D3K2', servings: 1, doses: d3k2),
      ]);
      expect(t.first.nutrientId, 'vit_d');
      expect(t.first.amount, closeTo(115, 1e-9));
      expect(t.first.status, LimitStatus.over);
      final zinc = t.firstWhere((n) => n.nutrientId == 'zinc');
      expect(zinc.amount, 20);
      expect(zinc.status, LimitStatus.near); // 80 % von 25 mg
      final mg = t.firstWhere((n) => n.nutrientId == 'magnesium');
      expect(mg.info!.ulScope, UpperLimitScope.supplementsOnly);
      expect(mg.status, LimitStatus.near); // 200 von 250 mg = 80 %
    });

    test('Grenzwerte: genau 80 % = Hinweis, genau 100 % = noch nicht darüber', () {
      NutrientTotal z(double mg) => sumSupplements([
        SupplementUse(
          product: 'Z',
          servings: 1,
          doses: [SupplementDose(nutrientId: 'zinc', amount: mg, unit: 'mg')],
        ),
      ]).single;
      expect(z(19.9).status, LimitStatus.ok);
      expect(z(20).status, LimitStatus.near);
      expect(z(25).status, LimitStatus.near);
      expect(z(25.1).status, LimitStatus.over);
    });

    test('Eigene Inhaltsstoffe und Hilfsfunktionen', () {
      final t = sumSupplements(const [
        SupplementUse(
          product: 'A',
          servings: 1,
          doses: [SupplementDose(nutrientId: 'custom:Ashwagandha', amount: 300, unit: 'mg', name: 'Ashwagandha')],
        ),
        SupplementUse(
          product: 'B',
          servings: 1,
          doses: [SupplementDose(nutrientId: 'custom:ashwagandha', amount: 200, unit: 'mg', name: 'ashwagandha')],
        ),
      ]);
      expect(t.single.amount, 500);
      expect(t.single.status, LimitStatus.none);
      expect(vitaminDIuToUg(4000), 100);
      expect(convertUnit(1, from: 'g', to: 'mg'), 1000);
      expect(stockDays(stockServings: 90, servingsPerDay: 2), 45);
      expect(stockDays(servingsPerDay: 2), isNull);
    });

    test('Katalog: IDs eindeutig, Werte plausibel', () {
      expect(nutrientCatalog.map((n) => n.id).toSet().length, nutrientCatalog.length);
      for (final n in nutrientCatalog) {
        expect(['µg', 'mg', 'g'], contains(n.unit));
        if (n.ul != null && n.nrv != null && n.ulScope == UpperLimitScope.total) {
          expect(n.ul!, greaterThan(n.nrv!), reason: n.name);
        }
      }
      expect(nutrientById('vit_d')!.ul, 100);
    });
  });

  group('Datenbank', () {
    late AppDatabase db;
    setUp(() => db = AppDatabase(NativeDatabase.memory()));
    tearDown(() => db.close());

    test('Speichern, doppelter Name, doppelter Inhaltsstoff', () async {
      final id = await db.saveSupplement(
        name: 'Multi Aktiv',
        brand: 'X',
        servingsPerDay: 1,
        times: [480],
        doses: multi,
      );
      final list = await db.watchSupplements().first;
      expect(list.single.supplement.id, id);
      expect(list.single.doses.length, 3);
      expect(list.single.supplement.times, [480]);
      expect(() => db.saveSupplement(name: 'multi aktiv', brand: 'x', doses: multi), throwsArgumentError);
      expect(
        () => db.saveSupplement(
          name: 'Doppelt',
          doses: const [
            ...d3k2,
            SupplementDose(nutrientId: 'vit_d', amount: 1, unit: 'µg'),
          ],
        ),
        throwsA(isA<InvalidFoodException>()),
      );
    });

    test('Einnahme abhaken: kein Doppelzählen, Vorrat geht runter und wieder hoch', () async {
      final id = await db.saveSupplement(
        name: 'D3K2',
        servingsPerDay: 2,
        times: [480, 1200],
        stockServings: 60,
        doses: d3k2,
      );
      final sw = (await db.watchSupplements().first).single;
      expect(sw.slots, [(minute: 480, servings: 1.0), (minute: 1200, servings: 1.0)]);
      Future<void> take(bool t, [int m = 480]) =>
          db.setIntake(supplementId: id, day: '2026-11-22', plannedMinute: m, servings: 1, taken: t);
      await take(true);
      await take(true); // zweimal abhaken zählt einmal
      expect((await db.watchIntakes('2026-11-22').first).length, 1);
      expect((await db.getSupplement(id))!.stockServings, 59);
      await take(false);
      expect((await db.watchIntakes('2026-11-22').first), isEmpty);
      expect((await db.getSupplement(id))!.stockServings, 60);
      await take(true);
      await take(true, 1200);
      expect((await db.watchIntakes('2026-11-22').first).length, 2);
      expect((await db.getSupplement(id))!.stockServings, 58);
    });

    test('Bearbeiten ersetzt Inhaltsstoffe; Löschen gibt Namen frei; Export enthält alles', () async {
      final id = await db.saveSupplement(
        name: 'Zink',
        doses: const [SupplementDose(nutrientId: 'zinc', amount: 25, unit: 'mg')],
      );
      await db.saveSupplement(
        id: id,
        name: 'Zink',
        doses: const [SupplementDose(nutrientId: 'zinc', amount: 10, unit: 'mg')],
      );
      expect((await db.watchSupplements().first).single.doses.single.amount, 10);
      await db.setIntake(supplementId: id, day: '2026-11-22', plannedMinute: -1, servings: 1, taken: true);
      final json = await db.exportJson();
      final db2 = AppDatabase(NativeDatabase.memory());
      await db2.importJson(json);
      expect((await db2.watchSupplements().first).single.doses.single.amount, 10);
      expect((await db2.watchIntakes('2026-11-22').first).length, 1);
      await db2.close();
      await db.deleteSupplement(id);
      expect(await db.watchSupplements().first, isEmpty);
      await db.saveSupplement(
        name: 'Zink',
        doses: const [SupplementDose(nutrientId: 'zinc', amount: 10, unit: 'mg')],
      );
    });
  });
}
