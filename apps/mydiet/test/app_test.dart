import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mydiet_ai/src/app.dart';
import 'package:mydiet_ai/src/data/database.dart';
import 'package:mydiet_ai/src/data/targets.dart';

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  setUpAll(() async {
    await initializeDateFormatting('de_DE');
    // Real font, so layout overflows in tests match the app.
    final loader = FontLoader('Inter');
    for (final w in ['Regular', 'Medium', 'SemiBold', 'Bold', 'ExtraBold']) {
      loader.addFont(rootBundle.load('assets/fonts/Inter-$w.ttf'));
    }
    await loader.load();
  });

  Future<AppDatabase> openDb({bool withProfile = false}) async {
    final db = AppDatabase(NativeDatabase.memory());
    if (withProfile) {
      await db.saveProfile(
        ProfilesCompanion.insert(
          sex: 'male',
          birthDate: DateTime(1986, 4, 1),
          heightCm: 182,
          startWeightKg: 104,
          targetWeightKg: 88,
          jobActivity: 'sitting',
          displayName: const Value('Patrick'),
        ),
      );
      await db.saveWeight(day: todayDayKey(), weightKg: 102.5);
      final slot = (await db.watchMealSlots().first).first;
      final skyr = (await db.searchFoods('Skyr')).first;
      await db.logFood(day: todayDayKey(), mealSlotId: slot.id, food: skyr, amount: 300);
    }
    return db;
  }

  Future<void> pumpApp(WidgetTester tester, AppDatabase db, {Size size = const Size(420, 900)}) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(MyDietApp(db: db));
    // Let drift's streams deliver (real async), then settle frames.
    for (var i = 0; i < 5; i++) {
      await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 50)));
      await tester.pump(const Duration(milliseconds: 50));
    }
  }

  Future<void> closeDb(WidgetTester tester, AppDatabase db) async {
    // Unmount first so drift cancels its stream queries, then let its cleanup timers run.
    await tester.pumpWidget(const SizedBox());
    for (var i = 0; i < 5; i++) {
      await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 20)));
      await tester.pump(const Duration(seconds: 1));
    }
    // The in-memory database is dropped with the test; closing it inside the fake-async
    // zone of a widget test would wait forever.
  }

  testWidgets('Ohne Profil startet die Einrichtung', (tester) async {
    final db = (await tester.runAsync(openDb))!;
    await pumpApp(tester, db);
    expect(find.text('MyDiet AI'), findsOneWidget);
    expect(find.text('Über dich'), findsOneWidget);
    expect(find.text('Dein Ziel'), findsOneWidget);
    await closeDb(tester, db);
  });

  testWidgets('Mit Profil: Dashboard zeigt echte Werte, Navigation funktioniert', (tester) async {
    final db = (await tester.runAsync(() => openDb(withProfile: true)))!;
    await pumpApp(tester, db);
    expect(find.text('Kalorien heute'), findsOneWidget);
    expect(find.textContaining('Patrick'), findsOneWidget);
    // 300 g Skyr = 189 kcal
    expect(find.text('189 kcal'), findsWidgets);

    await tester.tap(find.text('Tagebuch'));
    await pumpApp(tester, db);
    expect(find.text('Frühstück'), findsWidgets);
    expect(find.text('Skyr natur'), findsOneWidget);

    await tester.tap(find.text('Profil'));
    await pumpApp(tester, db);
    expect(find.text('Deine Tagesziele'), findsOneWidget);
    expect(find.text('Grundumsatz'), findsOneWidget);
    await closeDb(tester, db);
  });

  testWidgets('Breites Fenster nutzt die Seitennavigation', (tester) async {
    final db = (await tester.runAsync(() => openDb(withProfile: true)))!;
    await pumpApp(tester, db, size: const Size(1400, 900));
    expect(find.byType(NavigationRail), findsOneWidget);
    expect(find.byType(NavigationBar), findsNothing);
    await closeDb(tester, db);
  });
}
