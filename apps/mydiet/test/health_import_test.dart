import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mydiet_ai/src/core/health_export.dart';
import 'package:mydiet_ai/src/core/health_import.dart';
import 'package:mydiet_ai/src/core/nutrition.dart';
import 'package:mydiet_ai/src/data/database.dart';
import 'package:mydiet_ai/src/data/health_source.dart';
import 'package:mydiet_ai/src/data/health_sync.dart';

class FakeHealth implements HealthSource {
  FakeHealth(this.data);
  HealthRead data;
  int reads = 0;
  @override
  Future<HealthAvailability> availability() async => HealthAvailability.available;
  @override
  Future<bool> hasPermissions() async => true;
  @override
  Future<void> install() async {}
  @override
  Future<bool> requestPermissions() async => true;
  @override
  Future<HealthRead> read(DateTime from, DateTime to) async {
    reads++;
    return data;
  }

  bool canWrite = true;
  final written = <String, List<HealthMeal>>{};
  @override
  Future<bool> hasWritePermission() async => canWrite;
  @override
  Future<bool> requestWritePermission() async => canWrite;
  @override
  Future<void> writeDay(String day, List<HealthMeal> meals) async => written[day] = meals;
}

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  final days = {'2026-11-20', '2026-11-21'};

  group('Zusammenführen', () {
    test('Training eigener Eintrag, Alltag ohne Doppelzählung', () {
      final read = HealthRead(
        stepsByDay: {'2026-11-20': 9500, '2026-11-21': 0},
        activeKcal: [
          HealthValueSample(DateTime(2026, 11, 20, 8), DateTime(2026, 11, 20, 9), 300),
          HealthValueSample(DateTime(2026, 11, 20, 18), DateTime(2026, 11, 20, 19), 250),
          HealthValueSample(DateTime(2026, 11, 19, 18), DateTime(2026, 11, 19, 19), 999), // außerhalb
        ],
        workouts: [
          HealthWorkout(
            id: 'w1',
            type: 'RUNNING',
            start: DateTime(2026, 11, 20, 18),
            end: DateTime(2026, 11, 20, 18, 45),
            kcal: 400,
          ),
          HealthWorkout(id: 'w2', type: 'PADDLE', start: DateTime(2026, 11, 21, 10), end: DateTime(2026, 11, 21, 11)),
        ],
      );
      final p = planHealthImport(read, days: days);
      final byId = {for (final a in p.activities) a.externalId: a};
      expect(byId['hc:w1']!.label, 'Laufen (Health Connect)');
      expect(byId['hc:w1']!.minutes, 45);
      expect(byId['hc:w1']!.kcal, 400);
      expect(byId['hc:w2']!.label, 'Training (Health Connect)');
      expect(byId['hc:w2']!.kcal, 0);
      final day = byId['hc-day:2026-11-20']!;
      expect(day.steps, 9500);
      expect(day.kcal, 150, reason: '550 aktive kcal − 400 im Training');
      expect(byId.containsKey('hc-day:2026-11-21'), isFalse, reason: 'keine Schritte, keine Restkalorien');
    });

    test('Gewicht: letzter Wert des Tages, eigene Einträge haben Vorrang, unplausible weg', () {
      final read = HealthRead(
        weights: [
          HealthValueSample(DateTime(2026, 11, 20, 7), DateTime(2026, 11, 20, 7), 91.26),
          HealthValueSample(DateTime(2026, 11, 20, 21), DateTime(2026, 11, 20, 21), 92.04),
          HealthValueSample(DateTime(2026, 11, 21, 7), DateTime(2026, 11, 21, 7), 90.8),
          HealthValueSample(DateTime(2026, 11, 21, 8), DateTime(2026, 11, 21, 8), 900),
        ],
      );
      expect(planHealthImport(read, days: days).weights, {'2026-11-20': 92.0, '2026-11-21': 90.8});
      expect(planHealthImport(read, days: days, ownWeightDays: {'2026-11-21'}).weights, {'2026-11-20': 92.0});
    });

    test('Tage und Namen', () {
      expect(lastDays(DateTime(2026, 11, 2, 15), 3), {'2026-11-02', '2026-11-01', '2026-10-31'});
      expect(workoutLabel('biking'), 'Radfahren');
    });
  });

  group('Mahlzeiten schreiben', () {
    test('Art der Mahlzeit aus Name, sonst Uhrzeit', () {
      expect(mealKindFor('Frühstück', null), MealKind.breakfast);
      expect(mealKindFor('Mittagessen', 13 * 60), MealKind.lunch);
      expect(mealKindFor('Abendbrot', null), MealKind.dinner);
      expect(mealKindFor('Snacks', 8 * 60), MealKind.snack);
      expect(mealKindFor('Mahlzeit 1', 7 * 60), MealKind.breakfast);
      expect(mealKindFor('Mahlzeit 4', 19 * 60), MealKind.dinner);
      expect(mealKindFor('Mahlzeit 5', null), MealKind.snack);
    });

    test('Eine Aufzeichnung je Mahlzeit, leere weg, Uhrzeit aus Einstellung oder typisch', () {
      final meals = planNutritionExport(
        day: '2026-11-22',
        slots: [
          (id: 'a', name: 'Frühstück', minuteOfDay: 7 * 60 + 15),
          (id: 'b', name: 'Mittagessen', minuteOfDay: null),
          (id: 'c', name: 'Abendessen', minuteOfDay: null),
        ],
        totalsBySlot: {
          'a': const Nutrients(kcal: 420, protein: 25),
          'b': const Nutrients(kcal: 0.4),
          'c': const Nutrients(kcal: 700),
          'gone': const Nutrients(kcal: 90),
        },
      );
      expect(meals.map((m) => m.clientId), ['sattly:2026-11-22:a', 'sattly:2026-11-22:c', 'sattly:2026-11-22:gone']);
      expect(meals[0].start, DateTime(2026, 11, 22, 7, 15));
      expect(meals[0].end, DateTime(2026, 11, 22, 7, 45));
      expect(meals[0].nutrients.protein, 25);
      expect(meals[1].start, DateTime(2026, 11, 22, 18, 30));
      expect(meals[1].kind, MealKind.dinner);
      expect(meals[2].kind, MealKind.snack);
    });
  });

  group('Übernehmen in die Datenbank', () {
    late AppDatabase db;
    setUp(() => db = AppDatabase(NativeDatabase.memory()));
    tearDown(() => db.close());

    test('Erneutes Übernehmen aktualisiert statt zu verdoppeln, Gelöschtes bleibt gelöscht', () async {
      final now = DateTime(2026, 11, 21, 20);
      final src = FakeHealth(
        HealthRead(
          stepsByDay: {'2026-11-21': 4000},
          workouts: [
            HealthWorkout(
              id: 'w1',
              type: 'BIKING',
              start: DateTime(2026, 11, 21, 9),
              end: DateTime(2026, 11, 21, 10),
              kcal: 500,
            ),
          ],
          weights: [HealthValueSample(DateTime(2026, 11, 21, 7), DateTime(2026, 11, 21, 7), 88.4)],
        ),
      );
      final r = await importHealth(db, src, days: 2, now: now);
      expect(r.activities, 2);
      expect(r.weights, 1);
      var acts = await db.watchActivities('2026-11-21').first;
      expect(acts, hasLength(2));
      expect(acts.map((a) => a.source).toSet(), {healthSourceTag});

      src.data = HealthRead(stepsByDay: {'2026-11-21': 8000}, workouts: src.data.workouts, weights: src.data.weights);
      await importHealth(db, src, days: 2, now: now);
      acts = await db.watchActivities('2026-11-21').first;
      expect(acts, hasLength(2));
      expect(acts.firstWhere((a) => a.externalId == 'hc-day:2026-11-21').steps, 8000);

      await db.deleteActivity(acts.firstWhere((a) => a.externalId == 'hc:w1').id);
      await importHealth(db, src, days: 2, now: now);
      acts = await db.watchActivities('2026-11-21').first;
      expect(acts.map((a) => a.externalId), ['hc-day:2026-11-21']);

      // Eigenes Gewicht wird nicht überschrieben.
      await db.saveWeight(day: '2026-11-21', weightKg: 87.0);
      await importHealth(db, src, days: 2, now: now);
      final w = (await db.watchWeights().first).firstWhere((w) => w.dayKey == '2026-11-21');
      expect(w.weightKg, 87.0);

      final s = HealthSettings.parse(await db.getSetting(healthSettingsKey));
      expect(s.lastImport, now);
    });

    test('Mahlzeiten der letzten Tage schreiben, nur mit Schalter und Freigabe', () async {
      final now = DateTime(2026, 11, 22, 20);
      final slot = (await db.watchMealSlots().first).first;
      final skyr = (await db.searchFoods('Skyr')).first;
      await db.logFood(day: '2026-11-22', mealSlotId: slot.id, food: skyr, amount: 200);
      await db.logFood(day: '2026-11-22', mealSlotId: slot.id, food: skyr, amount: 100);
      final src = FakeHealth(const HealthRead());
      await importHealth(db, src, days: 2, now: now);
      expect(src.written, isEmpty, reason: 'Schreiben ist aus');

      await db.setSetting(healthSettingsKey, const HealthSettings(enabled: true, writeNutrition: true).toJson());
      final r = await importHealth(db, src, days: 2, now: now);
      expect(r.mealsWritten, 1);
      expect(src.written.keys.toSet(), {'2026-11-21', '2026-11-22'});
      expect(src.written['2026-11-21'], isEmpty, reason: 'leerer Tag wird geleert, damit Gelöschtes verschwindet');
      final m = src.written['2026-11-22']!.single;
      expect(m.nutrients.kcal, closeTo(skyr.kcal * 3, 0.01));
      expect(HealthSettings.parse(await db.getSetting(healthSettingsKey)).writeNutrition, isTrue);

      src.canWrite = false;
      src.written.clear();
      expect((await importHealth(db, src, days: 2, now: now)).mealsWritten, isNull);
      expect(src.written, isEmpty);
    });

    test('Automatisch nur wenn eingeschaltet und höchstens alle 3 Stunden', () async {
      final src = FakeHealth(const HealthRead(stepsByDay: {}));
      healthSourceFactory = () => src;
      addTearDown(() => healthSourceFactory = HealthConnectSource.new);
      final t = DateTime(2026, 11, 21, 12);
      await autoImportHealth(db, now: t);
      expect(src.reads, 0);
      await db.setSetting(healthSettingsKey, const HealthSettings(enabled: true).toJson());
      await autoImportHealth(db, now: t);
      expect(src.reads, 1);
      await autoImportHealth(db, now: t.add(const Duration(hours: 1)));
      expect(src.reads, 1);
      await autoImportHealth(db, now: t.add(const Duration(hours: 4)));
      expect(src.reads, 2);
      expect(HealthSettings.parse('kaputt').enabled, isFalse);
    });
  });
}
