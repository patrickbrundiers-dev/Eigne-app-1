// Runs on a real Android device or emulator (CI job "android-emulator"):
//   flutter test integration_test -d <device>
// Checks what unit tests cannot: native SQLite, file paths, plugins and the app start on Android.
import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mydiet_ai/src/app.dart';
import 'package:mydiet_ai/src/core/app_lock.dart';
import 'package:mydiet_ai/src/data/targets.dart';
import 'package:mydiet_ai/src/core/widget_summary.dart';
import 'package:mydiet_ai/src/data/app_lock_store.dart';
import 'package:mydiet_ai/src/data/database.dart';
import 'package:mydiet_ai/src/data/home_widget_sync.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  setUpAll(() => initializeDateFormatting('de_DE'));

  Future<void> settle(WidgetTester tester, [int frames = 20]) async {
    for (var i = 0; i < frames; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
  }

  Future<void> addProfile(AppDatabase db) async {
    await db
        .into(db.profiles)
        .insert(
          ProfilesCompanion.insert(
            sex: 'male',
            birthDate: DateTime(1986, 4, 1),
            heightCm: 182,
            startWeightKg: 104,
            targetWeightKg: 88,
            jobActivity: 'sitting',
            displayName: const Value('Test'),
          ),
        );
    await db.saveWeight(day: todayDayKey(), weightKg: 102.5);
  }

  testWidgets('Datenbank als Datei: Schreiben, Schließen, wieder Öffnen', (tester) async {
    final name = 'integration_${DateTime.now().millisecondsSinceEpoch}';
    var db = AppDatabase(driftDatabase(name: name));
    await addProfile(db);
    final slot = (await db.watchMealSlots().first).first;
    final skyr = (await db.searchFoods('Skyr')).first;
    await db.logFood(day: todayDayKey(), mealSlotId: slot.id, food: skyr, amount: 300);
    await db.close();

    db = AppDatabase(driftDatabase(name: name));
    final entries = await db.watchDiary(todayDayKey()).first;
    expect(entries.single.amount, 300);
    expect((await db.searchFoods('Banane')).isNotEmpty, isTrue); // Basisdaten eingespielt
    await db.close();
  });

  testWidgets('App-Sperre: Datei im App-Speicher', (tester) async {
    final store = FileLockStore();
    final before = await store.read();
    await store.write(const LockConfig(lockAfterSeconds: 300));
    expect((await store.read()).lockAfterSeconds, 300);
    await store.write(before);
  });

  testWidgets('Homescreen-Widget: Daten an Android übergeben', (tester) async {
    final bridge = homeWidgetBridgeFactory();
    expect(bridge, isA<AndroidHomeWidget>());
    await bridge.push(
      widgetSummary(day: todayDayKey(), budgetKcal: 2000, eatenKcal: 500, proteinG: 40, proteinTargetG: 140),
    );
  });

  testWidgets('App startet: Einrichtung, dann Dashboard und Tagebuch', (tester) async {
    final empty = AppDatabase(NativeDatabase.memory());
    await tester.pumpWidget(MyDietApp(db: empty));
    await settle(tester);
    expect(find.text('Über dich'), findsOneWidget);

    final db = AppDatabase(NativeDatabase.memory());
    await addProfile(db);
    final slot = (await db.watchMealSlots().first).first;
    final skyr = (await db.searchFoods('Skyr')).first;
    await db.logFood(day: todayDayKey(), mealSlotId: slot.id, food: skyr, amount: 300);
    await tester.pumpWidget(MyDietApp(db: db));
    await settle(tester);
    expect(find.text('Kalorien heute'), findsOneWidget);

    await tester.tap(find.text('Tagebuch').last);
    await settle(tester);
    expect(find.textContaining('Skyr'), findsWidgets);
    expect(tester.takeException(), isNull);
  });
}
