import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mydiet_ai/src/app.dart';
import 'package:mydiet_ai/src/branding.dart';
import 'package:mydiet_ai/src/core/supplements.dart';
import 'package:mydiet_ai/src/data/database.dart';
import 'package:mydiet_ai/src/data/targets.dart';
import 'package:mydiet_ai/src/data/off_client.dart';
import 'package:mydiet_ai/src/features/foods/barcode.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

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
    expect(find.text(appName), findsOneWidget);
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

  testWidgets('Zahlen ausblenden und Wochenbudget', (tester) async {
    final db = (await tester.runAsync(() => openDb(withProfile: true)))!;
    await tester.runAsync(() async {
      await db.setSetting('hideNumbers', 'true');
      await db.setSetting('budgetMode', 'week');
    });
    await pumpApp(tester, db);
    expect(find.text('Gut im Rahmen'), findsOneWidget);
    expect(find.text('189 kcal'), findsNothing);
    expect(find.text('Wochenbudget aktiv. Zahlen sind ausgeblendet.'), findsOneWidget);

    await tester.runAsync(() => db.setSetting('hideNumbers', 'false'));
    await pumpApp(tester, db);
    expect(find.text('Heute aus Wochenbudget'), findsOneWidget);
    expect(find.text('189 kcal'), findsWidgets);
    await closeDb(tester, db);
  });

  testWidgets('Essen: Rezepte und Einkaufsliste', (tester) async {
    final db = (await tester.runAsync(() => openDb(withProfile: true)))!;
    await tester.runAsync(() async {
      final oats = (await db.searchFoods('Haferflocken')).first;
      final id = await db.saveRecipe(name: 'Overnight Oats', servings: 2, items: [IngredientInput.fromFood(oats, 120)]);
      await db.addRecipeToShopping(id);
    });
    await pumpApp(tester, db);
    await tester.tap(find.text('Essen'));
    await pumpApp(tester, db);
    expect(find.text('Lebensmittel'), findsOneWidget); // Tab
    await tester.ensureVisible(find.text('Rezepte'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Rezepte'));
    await tester.pumpAndSettle(); // tab animation
    await pumpApp(tester, db);
    expect(find.text('Overnight Oats'), findsOneWidget);
    expect(find.textContaining('pro Portion'), findsOneWidget);

    await tester.tap(find.text('Overnight Oats'));
    await pumpApp(tester, db);
    expect(find.text('Pro Portion'), findsOneWidget);
    expect(find.text('Heute eintragen'), findsOneWidget);
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
    await pumpApp(tester, db);

    await tester.ensureVisible(find.text('Einkauf'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Einkauf'));
    await tester.pumpAndSettle();
    await pumpApp(tester, db);
    expect(find.textContaining('120 g Haferflocken'), findsOneWidget);
    expect(find.text('für Overnight Oats'), findsOneWidget);
    await closeDb(tester, db);
  });

  testWidgets('Supplemente: Summe über Produkte, Warnung, Abhaken', (tester) async {
    final db = (await tester.runAsync(() => openDb(withProfile: true)))!;
    await tester.runAsync(() async {
      await db.saveSupplement(
        name: 'Multivitamin',
        times: [480],
        doses: const [SupplementDose(nutrientId: 'vit_d', amount: 25, unit: 'µg')],
      );
      await db.saveSupplement(
        name: 'Vitamin D3',
        doses: const [SupplementDose(nutrientId: 'vit_d', amount: 100, unit: 'µg')],
      );
      await db.setDashTileVisible('supplements', true);
    });
    await pumpApp(tester, db);
    expect(find.text('Supplemente heute'), findsOneWidget);
    await tester.tap(find.text('Essen'));
    await pumpApp(tester, db);
    await tester.ensureVisible(find.text('Supplemente'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Supplemente'));
    await tester.pumpAndSettle();
    await pumpApp(tester, db);
    expect(find.textContaining('Über der tolerierbaren Höchstmenge'), findsOneWidget);
    expect(find.text('125 µg'), findsOneWidget); // geplant
    expect(find.text('125 %'), findsOneWidget);
    await tester.tap(find.text('Multivitamin').first);
    await pumpApp(tester, db);
    final intakes = await tester.runAsync(() => db.watchIntakes(todayDayKey()).first);
    expect(intakes!.single.plannedMinute, 480);
    await closeDb(tester, db);
  });

  testWidgets('Wochenplan und Fasten', (tester) async {
    final db = (await tester.runAsync(() => openDb(withProfile: true)))!;
    await tester.runAsync(() async {
      final oats = (await db.searchFoods('Haferflocken')).first;
      final id = await db.saveRecipe(name: 'Porridge', servings: 2, items: [IngredientInput.fromFood(oats, 200)]);
      final slot = (await db.watchMealSlots().first).first;
      await db.planRecipe(day: todayDayKey(), mealSlotId: slot.id, recipe: (await db.getRecipe(id))!, grams: 150);
      await db.setDashTileVisible('fasting', true);
      await db.startFast(targetHours: 16, at: DateTime.now().subtract(const Duration(hours: 2)));
    });
    await pumpApp(tester, db);
    await tester.drag(find.byType(Scrollable).first, const Offset(0, -3000));
    await pumpApp(tester, db);
    expect(find.text('Intervallfasten'), findsOneWidget);
    expect(find.text('Beenden'), findsOneWidget);

    await tester.tap(find.text('Essen'));
    await pumpApp(tester, db);
    await tester.ensureVisible(find.text('Wochenplan'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Wochenplan'));
    await tester.pumpAndSettle();
    await pumpApp(tester, db);
    expect(find.text('Porridge'), findsOneWidget);
    expect(find.textContaining('· heute'), findsOneWidget);
    await tester.ensureVisible(find.text('Tag ins Tagebuch'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Tag ins Tagebuch'));
    await pumpApp(tester, db);
    final diary = await tester.runAsync(() => db.diaryForDay(todayDayKey()));
    expect(diary!.map((e) => e.foodName), contains('Porridge'));
    await closeDb(tester, db);
  });

  testWidgets('Barcode: Open Food Facts füllt das Formular vor', (tester) async {
    debugCameraScan = false;
    offClientFactory = () => OffClient(
      client: MockClient(
        (_) async => http.Response(
          '{"status":1,"product":{"product_name":"Testmüsli","brands":"Marke",'
          '"nutriments":{"energy-kcal_100g":380,"proteins_100g":10,"carbohydrates_100g":60,'
          '"sugars_100g":12,"fat_100g":10,"saturated-fat_100g":2,"fiber_100g":8,"salt_100g":0.1}}}',
          200,
          headers: {'content-type': 'application/json; charset=utf-8'},
        ),
      ),
    );
    addTearDown(() {
      debugCameraScan = null;
      offClientFactory = OffClient.new;
    });
    final db = (await tester.runAsync(() => openDb(withProfile: true)))!;
    await pumpApp(tester, db);
    await tester.tap(find.text('Essen'));
    await pumpApp(tester, db);
    await tester.tap(find.byTooltip('Barcode scannen'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), '4006381333931');
    await tester.pump();
    await tester.tap(find.byTooltip('Suchen'));
    for (var i = 0; i < 4; i++) {
      await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 50)));
      await tester.pumpAndSettle();
    }
    expect(find.text('Testmüsli'), findsWidgets);
    expect(find.textContaining('Open Food Facts'), findsWidgets);
    await tester.tap(find.text('Speichern').first);
    await pumpApp(tester, db);
    final saved = (await tester.runAsync(() => db.findFoodByBarcode('4006381333931')))!;
    expect(saved.source, 'off');
    expect(saved.kcal, 380);
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
