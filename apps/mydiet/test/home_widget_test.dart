import 'dart:async';

import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mydiet_ai/src/core/dates.dart';
import 'package:mydiet_ai/src/core/widget_summary.dart';
import 'package:mydiet_ai/src/data/database.dart';
import 'package:mydiet_ai/src/data/display_prefs.dart';
import 'package:mydiet_ai/src/data/home_widget_sync.dart';
import 'package:mydiet_ai/src/data/targets.dart';

class FakeBridge implements HomeWidgetBridge {
  final pushed = <WidgetSummary>[];
  final clicks = StreamController<Uri?>();
  @override
  Future<void> push(WidgetSummary s) async => pushed.add(s);
  @override
  Stream<Uri?> launches() => clicks.stream;
}

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  group('Text', () {
    test('Rest, Überschreitung, Protein', () {
      final s = widgetSummary(day: 'd', budgetKcal: 2100, eatenKcal: 850.4, proteinG: 60.2, proteinTargetG: 140);
      expect(s.headline, 'Noch 1.250 kcal');
      expect(s.detail, '850 / 2.100 kcal · Protein 60 / 140 g');
      expect(s.percent, 40);
      final over = widgetSummary(day: 'd', budgetKcal: 2000, eatenKcal: 2300, proteinG: 0, proteinTargetG: 100);
      expect(over.headline, '300 kcal über dem Ziel');
      expect(over.percent, 100);
    });

    test('Zahlen ausblenden', () {
      final s = widgetSummary(
        day: 'd',
        budgetKcal: 2000,
        eatenKcal: 1000,
        proteinG: 50,
        proteinTargetG: 100,
        hideNumbers: true,
      );
      expect(s.headline, 'Gut im Rahmen');
      expect(s.detail, isNot(contains('kcal')));
      expect(gentleStatus(1.0), 'Ziel erreicht');
    });

    test('Wasser-Text und Widget-Link', () {
      expect(waterText(0), '0 ml');
      expect(waterText(750), '750 ml');
      expect(waterText(1000), '1 l');
      expect(waterText(1250), '1,25 l');
      expect(waterText(2500), '2,5 l');
      expect(waterFromWidgetLink(Uri.parse('sattly://water?ml=250')), 250);
      expect(waterFromWidgetLink(Uri.parse('sattly://water?ml=5000')), isNull);
      expect(waterFromWidgetLink(Uri.parse('sattly://water')), isNull);
      expect(waterFromWidgetLink(Uri.parse('https://water?ml=250')), isNull);
      expect(waterFromWidgetLink(null), isNull);
      expect(isAddFoodWidgetLink(Uri.parse(widgetAddFoodLink)), isTrue);
      expect(isAddFoodWidgetLink(Uri.parse('https://add')), isFalse);
      expect(isAddFoodWidgetLink(null), isFalse);
      expect(waterFromWidgetLink(Uri.parse(widgetAddFoodLink)), isNull);
      final s = widgetSummary(day: 'd', budgetKcal: 2000, eatenKcal: 0, proteinG: 0, proteinTargetG: 1, waterMl: 500);
      expect(s.water, 'Wasser 500 ml');
    });

    test('Tausenderpunkte', () {
      expect(groupThousands(0), '0');
      expect(groupThousands(999), '999');
      expect(groupThousands(12345), '12.345');
      expect(groupThousands(1234567), '1.234.567');
    });
  });

  group('Daten', () {
    late AppDatabase db;
    setUp(() => db = AppDatabase(NativeDatabase.memory()));
    tearDown(() => db.close());

    Future<Profile> profile() async {
      await db.saveProfile(
        ProfilesCompanion.insert(
          sex: 'male',
          birthDate: DateTime(1986, 4, 1),
          heightCm: 182,
          startWeightKg: 104,
          targetWeightKg: 88,
          jobActivity: 'sitting',
        ),
      );
      return (await db.watchProfile().first)!;
    }

    test('Gleiche Zahlen wie das Dashboard und Aktualisierung beim Eintragen', () async {
      final p = await profile();
      final target = targetsFor(p, const []).targetKcal;
      final today = todayDayKey();
      final bridge = FakeBridge();
      final sub = startHomeWidgetSync(db, bridge: bridge);
      await pumpEventQueue();
      expect(bridge.pushed.last.day, today);
      expect(bridge.pushed.last.headline, 'Noch ${groupThousands(target)} kcal');

      final slot = (await db.watchMealSlots().first).first;
      final skyr = (await db.searchFoods('Skyr')).first;
      await db.logFood(day: today, mealSlotId: slot.id, food: skyr, amount: 500);
      await pumpEventQueue();
      final eaten = (skyr.kcal * 5).round();
      expect(bridge.pushed.last.headline, 'Noch ${groupThousands(target - eaten)} kcal');

      final n = bridge.pushed.length;
      await db.setSetting('unrelated', 'x');
      await pumpEventQueue();
      expect(bridge.pushed.length, n, reason: 'unverändert wird nicht erneut gesendet');

      await db.setSetting(hideNumbersKey, 'true');
      await pumpEventQueue();
      expect(bridge.pushed.last.detail, 'Tippen zum Eintragen');

      bridge.clicks.add(Uri.parse('sattly://water?ml=$widgetWaterMl'));
      bridge.clicks.add(Uri.parse('sattly://other'));
      bridge.clicks.add(Uri.parse(widgetAddFoodLink)); // ohne onAddFood: nichts passiert
      bridge.clicks.add(null);
      await pumpEventQueue();
      expect(await db.watchWaterMl(today).first, widgetWaterMl);
      expect(bridge.pushed.last.water, 'Wasser 250 ml');
      await sub.cancel();
    });

    test('Knopf „+ Essen“ ruft den Schnell-Eintrag auf', () async {
      final bridge = FakeBridge();
      var opened = 0;
      final sub = startHomeWidgetSync(db, bridge: bridge, onAddFood: () => opened++);
      bridge.clicks.add(Uri.parse(widgetAddFoodLink));
      bridge.clicks.add(Uri.parse('sattly://water?ml=250'));
      await pumpEventQueue();
      expect(opened, 1);
      await sub.cancel();
    });

    test('Ohne Profil nichts', () async {
      final bridge = FakeBridge();
      final sub = startHomeWidgetSync(db, bridge: bridge);
      await pumpEventQueue();
      expect(bridge.pushed, isEmpty);
      await sub.cancel();
      expect(dayKey(DateTime(2026, 1, 2)), '2026-01-02');
    });
  });
}
