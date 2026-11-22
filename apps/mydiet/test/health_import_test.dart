import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mydiet_ai/src/core/health_import.dart';
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
