import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mydiet_ai/src/app.dart';
import 'package:mydiet_ai/src/branding.dart';
import 'package:mydiet_ai/src/core/dates.dart';
import 'package:mydiet_ai/src/core/supplements.dart';
import 'package:mydiet_ai/src/core/weight_trend.dart' show weekStart;
import 'package:mydiet_ai/src/ui/format.dart' show weekdayShort;
import 'package:mydiet_ai/src/data/database.dart';
import 'package:mydiet_ai/src/data/targets.dart';
import 'package:mydiet_ai/src/data/reminder_scheduler.dart';
import 'package:mydiet_ai/src/core/reminders.dart';
import 'package:mydiet_ai/src/features/settings/reminders_page.dart';
import 'package:mydiet_ai/src/features/micros/micros_view.dart';
import 'package:mydiet_ai/src/features/diary/food_picker_page.dart';
import 'package:mydiet_ai/src/data/off_client.dart';
import 'package:mydiet_ai/src/data/recipe_import_client.dart';
import 'package:mydiet_ai/src/data/weekly_report_data.dart';
import 'package:mydiet_ai/src/features/report/weekly_report_page.dart';
import 'package:mydiet_ai/src/core/health_export.dart';
import 'package:mydiet_ai/src/core/health_import.dart';
import 'package:mydiet_ai/src/data/health_source.dart';
import 'package:mydiet_ai/src/features/settings/health_page.dart';
import 'package:mydiet_ai/src/core/app_lock.dart';
import 'package:mydiet_ai/src/data/app_lock_store.dart';
import 'package:mydiet_ai/src/features/lock/app_lock_page.dart';
import 'package:mydiet_ai/src/features/lock/lock_gate.dart';
import 'package:mydiet_ai/src/features/foods/barcode.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  setUpAll(() async {
    await initializeDateFormatting('de_DE');
    reminderScheduler = NoopReminderScheduler(); // no notification plugin in tests
    lockStoreFactory = MemoryLockStore.new; // no app lock unless a test sets one
    biometricsFactory = _NoBiometrics.new;
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
    expect(find.textContaining(RegExp(r'Protein \d+ / \d+ g')), findsWidgets); // Anteil am Tagesziel je Mahlzeit

    await tester.tap(find.text('Profil'));
    await pumpApp(tester, db);
    expect(find.text('Deine Tagesziele'), findsOneWidget);
    expect(find.text('Grundumsatz'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Vitamine und Mineralstoffe'),
      300,
      scrollable: find.byType(Scrollable).last,
    );
    expect(find.textContaining('D-A-CH-Referenzwerten für Männer'), findsOneWidget);
    expect(find.text('20 µg'), findsWidgets); // Vitamin D
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

  testWidgets('Rezept von Webseite übernehmen: Zutaten zuordnen, speichern', (tester) async {
    const html = '''<script type="application/ld+json">{"@type":"Recipe","name":"Bananen-Porridge",
      "recipeYield":"2 Portionen","recipeIngredient":["160 g Haferflocken","Salz","2 Bananen"],
      "recipeInstructions":"Alles kochen."}</script>''';
    Uri? asked;
    recipePageClientFactory = () => RecipePageClient(
      client: MockClient((req) async {
        asked = req.url;
        return http.Response(html, 200);
      }),
    );
    addTearDown(() => recipePageClientFactory = RecipePageClient.new);
    final db = (await tester.runAsync(() => openDb(withProfile: true)))!;
    Future<void> settle() async {
      for (var i = 0; i < 6; i++) {
        await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 50)));
        await tester.pump(const Duration(milliseconds: 50));
      }
    }

    await pumpApp(tester, db);
    await tester.tap(find.text('Essen'));
    await pumpApp(tester, db);
    await tester.tap(find.text('Rezepte'));
    await tester.pumpAndSettle();
    await pumpApp(tester, db);
    await tester.tap(find.byTooltip('Rezept von Webseite oder Text übernehmen'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, 'https://example.org/porridge');
    await tester.pump();
    await tester.tap(find.text('Laden'));
    await settle();
    expect(asked.toString(), 'https://example.org/porridge');
    expect(find.text('Bananen-Porridge'), findsOneWidget);
    expect(find.textContaining('ohne Nährwerte'), findsOneWidget); // Salz
    expect(find.textContaining('Haferflocken'), findsWidgets);
    final save = find.textContaining('Rezept mit');
    await tester.ensureVisible(save);
    await tester.tap(save);
    await settle();
    final recipes = (await tester.runAsync(() => db.watchRecipes().first))!;
    final r = recipes.firstWhere((r) => r.name == 'Bananen-Porridge');
    expect(r.servings, 2);
    final items = (await tester.runAsync(() => db.recipeItemsOf(r.id)))!;
    expect(items.map((i) => i.foodName), contains(startsWith('Haferflocken')));
    expect(items.firstWhere((i) => i.foodName.startsWith('Haferflocken')).amount, 160);
    expect(r.instructions, contains('Quelle: https://example.org/porridge'));
    expect(find.text('Pro Portion'), findsOneWidget); // detail page opened
    await closeDb(tester, db);
  });

  testWidgets('Wochenbericht: Befunde und Vorschläge der letzten Woche', (tester) async {
    final db = (await tester.runAsync(() => openDb(withProfile: true)))!;
    final mon = defaultReportMonday(DateTime.now());
    await tester.runAsync(() async {
      final slot = (await db.watchMealSlots().first).first;
      final oats = (await db.searchFoods('Haferflocken')).first;
      for (var i = 0; i < 5; i++) {
        final d = DateTime(mon.year, mon.month, mon.day + i);
        await db.logFood(day: dayKey(d), mealSlotId: slot.id, food: oats, amount: 400); // ~1500 kcal, wenig Protein
      }
    });
    await pumpApp(tester, db);
    final tile = find.text('Wochenbericht');
    expect(find.byType(WeeklyReportTile), findsOneWidget);
    await tester.ensureVisible(tile);
    await tester.pump();
    await tester.tap(tile);
    for (var i = 0; i < 40; i++) {
      await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 50)));
      await tester.pump(const Duration(milliseconds: 50));
    }
    expect(find.byType(WeeklyReportPage), findsOneWidget);
    expect(find.text('5 von 7 Tagen eingetragen'), findsOneWidget);
    expect(find.text('Protein oft unter dem Ziel'), findsOneWidget);
    expect(find.text('Vorschläge für nächste Woche'), findsOneWidget);
    expect(find.textContaining('1. '), findsWidgets);
    await closeDb(tester, db);
  });

  testWidgets('Health Connect: verbinden übernimmt Training, Schritte und Gewicht', (tester) async {
    final db = (await tester.runAsync(() => openDb(withProfile: true)))!;
    final now = DateTime.now();
    final src = _FakeHealthSource(
      HealthRead(
        stepsByDay: {dayKey(now): 7200},
        workouts: [
          HealthWorkout(
            id: 'g1',
            type: 'RUNNING',
            start: DateTime(now.year, now.month, now.day, 0, 5),
            end: DateTime(now.year, now.month, now.day, 0, 35),
            kcal: 320,
          ),
        ],
      ),
    );
    healthSourceFactory = () => src;
    addTearDown(() => healthSourceFactory = HealthConnectSource.new);
    await pumpApp(tester, db);
    tester
        .state<NavigatorState>(find.byType(Navigator).first)
        .push(MaterialPageRoute<void>(builder: (_) => const HealthPage()));
    Future<void> settle() async {
      for (var i = 0; i < 20; i++) {
        await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 50)));
        await tester.pump(const Duration(milliseconds: 50));
      }
    }

    await settle();
    expect(find.textContaining('Garmin Connect'), findsOneWidget);
    await tester.tap(find.text('Verbinden und Freigaben erteilen'));
    await settle();
    expect(src.requested, isTrue);
    expect(find.textContaining('2 Aktivitätseinträge'), findsOneWidget);
    expect(find.text('Beim Öffnen automatisch übernehmen'), findsOneWidget);
    final acts = (await tester.runAsync(() => db.watchActivities(dayKey(now)).first))!;
    expect(acts.map((a) => a.label).toSet(), {'Laufen (Health Connect)', dailyActivityLabel});

    final write = find.text('Mahlzeiten nach Health Connect schreiben');
    await tester.ensureVisible(write);
    await tester.pump();
    await tester.tap(write);
    await settle();
    expect(src.written[dayKey(now)], hasLength(1), reason: 'Skyr aus dem Profil-Setup');
    expect(find.textContaining('Mahlzeiten der letzten 7 Tage nach Health Connect geschrieben'), findsOneWidget);
    await closeDb(tester, db);
  });

  testWidgets('App-Sperre: PIN setzen, gesperrt starten, falsche und richtige PIN', (tester) async {
    final db = (await tester.runAsync(() => openDb(withProfile: true)))!;
    final store = MemoryLockStore();
    lockStoreFactory = () => store;
    addTearDown(() => lockStoreFactory = MemoryLockStore.new);
    Future<void> settle() async {
      for (var i = 0; i < 10; i++) {
        await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 30)));
        await tester.pump(const Duration(milliseconds: 50));
      }
    }

    await pumpApp(tester, db);
    expect(find.byType(LockScreen), findsNothing);
    tester
        .state<NavigatorState>(find.byType(Navigator).first)
        .push(MaterialPageRoute<void>(builder: (_) => const AppLockPage()));
    await settle();
    await tester.tap(find.text('App mit PIN sperren'));
    await settle();
    final fields = find.byType(TextField);
    await tester.enterText(fields.at(0), '1234');
    await tester.enterText(fields.at(1), '1234');
    await tester.tap(find.text('Speichern'));
    await settle();
    expect(find.text('Keine einfache Zahlenfolge'), findsOneWidget);
    await tester.enterText(fields.at(0), '4711');
    await tester.enterText(fields.at(1), '4711');
    await tester.tap(find.text('Speichern'));
    await settle();
    expect(store.config.enabled, isTrue);
    expect(store.config.toJsonString(), isNot(contains('4711')));

    // Neustart: gesperrt.
    await tester.pumpWidget(const SizedBox());
    await pumpApp(tester, db);
    await settle();
    expect(find.byType(LockScreen), findsOneWidget);
    expect(find.text('Sattly ist gesperrt'), findsOneWidget);
    for (final d in ['0', '0', '0', '1']) {
      await tester.tap(find.widgetWithText(FilledButton, d));
      await tester.pump();
    }
    await tester.tap(find.bySemanticsLabel('Entsperren'));
    await settle();
    expect(find.text('Falsche PIN'), findsOneWidget);
    expect(store.config.failed, 1);
    for (final d in ['4', '7', '1', '1']) {
      await tester.tap(find.widgetWithText(FilledButton, d));
      await tester.pump();
    }
    await tester.tap(find.bySemanticsLabel('Entsperren'));
    await settle();
    expect(find.byType(LockScreen), findsNothing);
    expect(store.config.failed, 0);
    expect(LockConfig.parse(store.config.toJsonString()).enabled, isTrue);
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

  testWidgets('Open Food Facts: Textsuche aus der Auswahl, prüfen, speichern, eintragen', (tester) async {
    Uri? sent;
    offClientFactory = () => OffClient(
      client: MockClient((req) async {
        sent = req.url;
        return http.Response(
          '{"products":[{"code":"40011234","product_name":"Testmüsli","brands":"Marke",'
          '"nutriments":{"energy-kcal_100g":380,"proteins_100g":10,"carbohydrates_100g":60,'
          '"sugars_100g":12,"fat_100g":10,"saturated-fat_100g":2,"fiber_100g":8,"salt_100g":0.1}}]}',
          200,
          headers: {'content-type': 'application/json; charset=utf-8'},
        );
      }),
    );
    addTearDown(() => offClientFactory = OffClient.new);
    final db = (await tester.runAsync(() => openDb(withProfile: true)))!;
    await pumpApp(tester, db);
    await tester.tap(find.text('Tagebuch'));
    await pumpApp(tester, db);
    await tester.tap(find.byTooltip('Frühstück hinzufügen'));
    await pumpApp(tester, db);
    await tester.enterText(find.byType(SearchBar), 'Testmüsli');
    await pumpApp(tester, db);
    expect(sent, isNull, reason: 'ohne Knopfdruck wird nichts gesendet');
    await tester.tap(find.text('Bei Open Food Facts suchen'));
    await pumpApp(tester, db);
    await tester.tap(find.widgetWithText(FilledButton, 'Suchen'));
    for (var i = 0; i < 4; i++) {
      await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 50)));
      await tester.pumpAndSettle();
    }
    expect(sent!.queryParameters['search_terms'], 'Testmüsli');
    await tester.tap(find.widgetWithText(ListTile, 'Testmüsli'));
    await pumpApp(tester, db);
    await tester.tap(find.text('Speichern').first);
    await pumpApp(tester, db);
    await pumpApp(tester, db);
    expect(find.text('Hinzufügen'), findsOneWidget);
    await tester.tap(find.text('Hinzufügen'));
    await pumpApp(tester, db);
    final saved = (await tester.runAsync(() => db.findFoodByBarcode('40011234')))!;
    expect(saved.source, 'off');
    final entries = (await tester.runAsync(() => db.diaryForDay(todayDayKey())))!;
    expect(entries.map((e) => e.foodName), contains('Testmüsli'));
    expect(tester.takeException(), isNull);
    await closeDb(tester, db);
  });

  testWidgets('Erinnerungen: Wasser einschalten plant Benachrichtigungen', (tester) async {
    final sched = NoopReminderScheduler();
    reminderScheduler = sched;
    addTearDown(() => reminderScheduler = NoopReminderScheduler());
    final db = (await tester.runAsync(() => openDb(withProfile: true)))!;
    await pumpApp(tester, db);
    expect(sched.applied, isNotEmpty); // synced at start
    expect(sched.applied.last, isEmpty);
    final ctx = tester.element(find.byType(Scaffold).first);
    Navigator.of(ctx).push(MaterialPageRoute<void>(builder: (_) => const RemindersPage()));
    await pumpApp(tester, db);
    await tester.tap(find.text('Ans Trinken erinnern'));
    await pumpApp(tester, db);
    expect(find.textContaining('6× am Tag, 09:00–20:00'), findsOneWidget);
    expect(sched.applied.last.where((r) => r.kind == ReminderKind.water), hasLength(6));
    await closeDb(tester, db);
  });

  testWidgets('Mikronährstoffe: Essen und Supplemente zusammen', (tester) async {
    final db = (await tester.runAsync(() => openDb(withProfile: true)))!;
    await tester.runAsync(() async {
      final sid = await db.saveSupplement(
        name: 'Magnesium 400',
        times: const [1260],
        doses: const [SupplementDose(nutrientId: 'magnesium', amount: 400, unit: 'mg')],
      );
      await db.setIntake(supplementId: sid, day: todayDayKey(), plannedMinute: 1260, servings: 1, taken: true);
    });
    await pumpApp(tester, db);
    final ctx = tester.element(find.byType(Scaffold).first);
    Navigator.of(ctx).push(MaterialPageRoute<void>(builder: (_) => const MicrosPage()));
    await pumpApp(tester, db);
    expect(find.text('Vitamine und Mineralstoffe'), findsOneWidget);
    expect(find.textContaining('Werte für den Eintrag'), findsOneWidget); // Skyr from openDb
    expect(find.text('Magnesium'), findsOneWidget);
    expect(find.textContaining('Höchstmenge 250 mg (nur Supplemente)'), findsOneWidget);
    await closeDb(tester, db);
  });

  testWidgets('PC: Wochenplan nebeneinander, Ziehen auf anderen Tag, Tastenkürzel', (tester) async {
    final db = (await tester.runAsync(() => openDb(withProfile: true)))!;
    final mon = weekStart(DateTime.now());
    final tue = DateTime(mon.year, mon.month, mon.day + 1);
    await tester.runAsync(() async {
      final oats = (await db.searchFoods('Haferflocken')).first;
      final slot = (await db.watchMealSlots().first).first;
      await db.planFood(day: dayKey(mon), mealSlotId: slot.id, food: oats, amount: 80);
    });
    await pumpApp(tester, db, size: const Size(1700, 1000));

    Future<void> keys(List<LogicalKeyboardKey> mods, LogicalKeyboardKey key) async {
      for (final m in mods) {
        await tester.sendKeyDownEvent(m);
      }
      await tester.sendKeyEvent(key);
      for (final m in mods.reversed) {
        await tester.sendKeyUpEvent(m);
      }
      await tester.pumpAndSettle();
    }

    // Strg+4 → Essen, then the weekly plan tab.
    await keys([LogicalKeyboardKey.controlLeft], LogicalKeyboardKey.digit4);
    expect(find.text('Wochenplan'), findsOneWidget);
    await tester.tap(find.text('Wochenplan'));
    await tester.pumpAndSettle();
    await pumpApp(tester, db, size: const Size(1700, 1000));
    final entry = find.textContaining('Haferflocken');
    expect(entry, findsOneWidget);
    expect(find.textContaining('Tipp: Einträge mit der Maus'), findsOneWidget);
    // Days side by side: Monday and Tuesday on the same row.
    final monTitle = find.textContaining(weekdayShort(mon));
    final tueTitle = find.textContaining(weekdayShort(tue));
    expect(tester.getTopLeft(monTitle.first).dy, tester.getTopLeft(tueTitle.first).dy);

    // Long press and drag the entry onto Tuesday.
    final g = await tester.startGesture(tester.getCenter(entry));
    await tester.pump(const Duration(milliseconds: 700));
    await g.moveTo(tester.getCenter(tueTitle.first) + const Offset(0, 40));
    await tester.pump();
    await g.moveTo(tester.getCenter(tueTitle.first) + const Offset(0, 50));
    await tester.pump();
    await g.up();
    await tester.pump();
    for (var i = 0; i < 5; i++) {
      await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 50)));
      await tester.pump(const Duration(milliseconds: 50));
    }
    final moved = (await tester.runAsync(() => db.planEntries(dayKey(mon), dayKey(tue))))!;
    expect(moved.single.dayKey, dayKey(tue));
    expect(find.textContaining('verschoben'), findsOneWidget);

    // Alt+→ next week: nothing planned there.
    await keys([LogicalKeyboardKey.altLeft], LogicalKeyboardKey.arrowRight);
    await pumpApp(tester, db, size: const Size(1700, 1000));
    final planned = find.descendant(of: find.byType(ListTile), matching: find.textContaining('Haferflocken'));
    expect(planned, findsNothing);
    await keys([LogicalKeyboardKey.altLeft], LogicalKeyboardKey.home);
    await pumpApp(tester, db, size: const Size(1700, 1000));
    expect(planned, findsOneWidget);

    // Diary: Strg+2, Alt+← one day back, Alt+Pos1 back to today.
    await keys([LogicalKeyboardKey.controlLeft], LogicalKeyboardKey.digit2);
    expect(find.widgetWithText(TextButton, 'Heute'), findsOneWidget);
    await keys([LogicalKeyboardKey.altLeft], LogicalKeyboardKey.arrowLeft);
    expect(find.widgetWithText(TextButton, 'Heute'), findsNothing);
    await keys([LogicalKeyboardKey.altLeft], LogicalKeyboardKey.home);
    expect(find.widgetWithText(TextButton, 'Heute'), findsOneWidget);

    // F1: overview.
    await keys([], LogicalKeyboardKey.f1);
    expect(find.text('Tastenkürzel'), findsOneWidget);
    expect(find.text('Strg+E'), findsOneWidget);
    await tester.tap(find.text('Schließen'));
    await tester.pumpAndSettle();

    // Strg+E opens the food search for today.
    await keys([LogicalKeyboardKey.controlLeft], LogicalKeyboardKey.keyE);
    for (var i = 0; i < 5; i++) {
      await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 50)));
      await tester.pump(const Duration(milliseconds: 50));
    }
    expect(find.byType(FoodPickerPage), findsOneWidget);
    await closeDb(tester, db);
  });

  testWidgets('PC: Lebensmittel als Tabelle mit wählbaren Spalten', (tester) async {
    final db = (await tester.runAsync(() => openDb(withProfile: true)))!;
    await pumpApp(tester, db, size: const Size(1400, 900));
    await tester.tap(find.text('Essen').last);
    await pumpApp(tester, db, size: const Size(1400, 900));
    expect(find.byType(DataTable), findsOneWidget);
    final before = find.text('Zucker').evaluate().length; // auch ein Lebensmittel heißt so
    await tester.tap(find.byTooltip('Spalten wählen'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(CheckboxListTile, 'Zucker'));
    await tester.tap(find.text('Übernehmen'));
    await pumpApp(tester, db, size: const Size(1400, 900));
    expect(find.text('Zucker').evaluate().length, before + 1);
    expect((await tester.runAsync(() => db.getSetting('foodTableColumns')))!, contains('sugar'));
    await tester.tap(find.text('kcal')); // sortieren
    await pumpApp(tester, db, size: const Size(1400, 900));
    expect(tester.takeException(), isNull);
    await closeDb(tester, db);
  });

  testWidgets('PC: Tagebuch als Tabelle mit wählbaren Spalten', (tester) async {
    final db = (await tester.runAsync(() => openDb(withProfile: true)))!;
    await pumpApp(tester, db, size: const Size(1400, 900));
    await tester.tap(find.text('Tagebuch').last);
    await pumpApp(tester, db, size: const Size(1400, 900));
    expect(find.byType(DataTable), findsWidgets);
    expect(find.text('300 g'), findsOneWidget); // Skyr in der Spalte „Menge“
    expect(find.text('Zucker'), findsNothing);
    await tester.tap(find.byTooltip('Spalten im Tagebuch wählen'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(CheckboxListTile, 'Zucker'));
    await tester.tap(find.text('Übernehmen'));
    await pumpApp(tester, db, size: const Size(1400, 900));
    expect(find.text('Zucker'), findsWidgets);
    expect((await tester.runAsync(() => db.getSetting('diaryTableColumns')))!, contains('sugar'));
    await tester.tap(find.byTooltip(RegExp(r'entfernen$')).first);
    await pumpApp(tester, db, size: const Size(1400, 900));
    expect(find.text('300 g'), findsNothing);
    expect(find.text('Rückgängig'), findsOneWidget);
    await closeDb(tester, db);
  });

  testWidgets('Breites Fenster nutzt die Seitennavigation', (tester) async {
    final db = (await tester.runAsync(() => openDb(withProfile: true)))!;
    await pumpApp(tester, db, size: const Size(1400, 900));
    expect(find.byType(NavigationRail), findsOneWidget);
    expect(find.byType(NavigationBar), findsNothing);
    await closeDb(tester, db);
  });

  testWidgets('Gewicht: mehr als 120 Einträge, ältere lassen sich nachladen', (tester) async {
    final db = (await tester.runAsync(() => openDb(withProfile: true)))!;
    await tester.runAsync(() async {
      final now = DateTime.now();
      for (var i = 1; i <= 130; i++) {
        await db.saveWeight(day: dayKey(DateTime(now.year, now.month, now.day - i)), weightKg: 100 + i / 100);
      }
    });
    await pumpApp(tester, db);
    await tester.tap(find.text('Gewicht').last);
    await pumpApp(tester, db);
    final more = find.textContaining('Ältere anzeigen (noch 11)');
    await tester.scrollUntilVisible(more, 2000, scrollable: find.byType(Scrollable).last);
    await tester.drag(find.byType(Scrollable).last, const Offset(0, -300)); // nicht hinter dem Knopf „Eintragen“
    await tester.pumpAndSettle();
    await tester.tap(more);
    await pumpApp(tester, db);
    expect(find.textContaining('Ältere anzeigen'), findsNothing);
    expect(tester.takeException(), isNull);
    await closeDb(tester, db);
  });

  testWidgets('Gewicht: Fortschritt mit Start, Trend, Bilanz und Proteinziel', (tester) async {
    final db = (await tester.runAsync(() => openDb(withProfile: true)))!;
    await tester.runAsync(() async {
      final now = DateTime.now();
      for (var i = 30; i >= 1; i--) {
        final d = DateTime(now.year, now.month, now.day - i);
        await db.saveWeight(day: dayKey(d), weightKg: 104 - 0.05 * (30 - i));
      }
      final slot = (await db.watchMealSlots().first).first;
      final skyr = (await db.searchFoods('Skyr')).first;
      for (var i = 1; i <= 5; i++) {
        final d = DateTime(now.year, now.month, now.day - i);
        await db.logFood(day: dayKey(d), mealSlotId: slot.id, food: skyr, amount: 1500);
      }
    });
    for (final size in const [Size(420, 900), Size(1280, 900)]) {
      await pumpApp(tester, db, size: size);
      await tester.tap(find.text('Gewicht').last);
      await pumpApp(tester, db, size: size);
      expect(find.text('Fortschritt'), findsOneWidget);
      expect(find.text('Bisher abgenommen'), findsOneWidget);
      expect(find.text('Noch bis Ziel'), findsOneWidget);
      expect(find.text('30-Tage-Trend'), findsOneWidget);
      expect(find.text('Proteinziel erreicht'), findsOneWidget);
      expect(find.textContaining('Gezählt: 5 von 7 Tagen'), findsOneWidget);
      expect(tester.takeException(), isNull);
    }
    await closeDb(tester, db);
  });

  testWidgets('Dashboard: Eintragen in drei Taps (Mahlzeit wählen, Nur Kalorien)', (tester) async {
    final db = (await tester.runAsync(() => openDb(withProfile: true)))!;
    await pumpApp(tester, db);
    expect(find.textContaining('30 Tage:'), findsOneWidget);
    await tester.tap(find.widgetWithText(FloatingActionButton, 'Eintragen'));
    await pumpApp(tester, db);
    expect(find.text('Eintragen für'), findsOneWidget);
    await tester.tap(find.widgetWithText(ChoiceChip, 'Abendessen'));
    await pumpApp(tester, db);
    await tester.tap(find.text('Nur Kalorien'));
    await pumpApp(tester, db);
    expect(find.text('Schnelleintrag'), findsOneWidget);
    expect(find.text('Abendessen hinzufügen'), findsOneWidget);
    await tester.enterText(find.widgetWithText(TextField, 'Kalorien'), '250');
    await tester.tap(find.widgetWithText(FilledButton, 'Eintragen'));
    await pumpApp(tester, db);
    final slots = (await tester.runAsync(() => db.watchMealSlots().first))!;
    final dinner = slots.firstWhere((s) => s.name == 'Abendessen');
    final entries = (await tester.runAsync(() => db.diaryForDay(todayDayKey())))!;
    expect(entries.where((e) => e.mealSlotId == dinner.id && e.kcal100 > 0), isNotEmpty);
    expect(tester.takeException(), isNull);
    await closeDb(tester, db);
  });

  testWidgets('Barrierefreiheit: 200 % Schrift ohne Überlauf auf allen Hauptseiten', (tester) async {
    final db = (await tester.runAsync(() => openDb(withProfile: true)))!;
    tester.platformDispatcher.textScaleFactorTestValue = 2.0;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await pumpApp(tester, db);
    expect(tester.takeException(), isNull, reason: 'Dashboard');
    for (final page in ['Tagebuch', 'Gewicht', 'Essen', 'Profil']) {
      await tester.tap(find.text(page).last);
      await pumpApp(tester, db);
      expect(tester.takeException(), isNull, reason: page);
    }
    await closeDb(tester, db);
  });

  testWidgets('Barrierefreiheit: Ringe und Fortschritt haben Screenreader-Texte', (tester) async {
    final handle = tester.ensureSemantics();
    final db = (await tester.runAsync(() => openDb(withProfile: true)))!;
    await pumpApp(tester, db);
    expect(find.bySemanticsLabel(RegExp(r'Kalorien heute: [\d.]+ kcal (übrig|zu viel)')), findsWidgets);
    expect(find.bySemanticsLabel(RegExp(r'Protein: [\d.]+ von [\d.]+ g')), findsWidgets);
    await tester.tap(find.text('Gewicht').last);
    await pumpApp(tester, db);
    expect(find.bySemanticsLabel(RegExp(r'Fortschritt zum Ziel')), findsWidgets);
    handle.dispose();
    await closeDb(tester, db);
  });

  testWidgets('Als Text eintragen: Mahlzeit erkennen, Unsicheres bestätigen, eintragen', (tester) async {
    final db = (await tester.runAsync(() => openDb(withProfile: true)))!;
    await pumpApp(tester, db);
    await tester.tap(find.text('Tagebuch'));
    await pumpApp(tester, db);
    await tester.tap(find.byTooltip('Frühstück hinzufügen'));
    await pumpApp(tester, db);
    await tester.enterText(find.byType(SearchBar), '2 Eier, 1 Banane und 1 EL Olivenöl');
    await pumpApp(tester, db);
    await tester.tap(find.text('Ganze Mahlzeit erkennen'));
    await pumpApp(tester, db);
    expect(find.text('Als Text eintragen'), findsOneWidget);
    expect(find.text('Hühnerei'), findsOneWidget);
    expect(find.text('Banane'), findsOneWidget);
    // Löffel sind eine Annahme: Zeile nicht vorausgewählt.
    expect(find.textContaining('1 EL ≈ 15 g angenommen'), findsOneWidget);
    expect(find.text('2 eintragen'), findsOneWidget);
    await tester.tap(find.byType(Checkbox).last);
    await pumpApp(tester, db);
    await tester.tap(find.text('3 eintragen'));
    await pumpApp(tester, db);
    final entries = (await tester.runAsync(() => db.diaryForDay(todayDayKey())))!;
    expect(entries.map((e) => e.foodName), containsAll(['Hühnerei', 'Banane', 'Olivenöl']));
    expect(entries.firstWhere((e) => e.foodName == 'Hühnerei').amount, 120);
    expect(entries.firstWhere((e) => e.foodName == 'Olivenöl').amount, 15);
    expect(tester.takeException(), isNull);
    await closeDb(tester, db);
  });

  testWidgets('Alle Daten löschen: erst nach Bestätigungswort, danach Neustart der Einrichtung', (tester) async {
    final db = (await tester.runAsync(() => openDb(withProfile: true)))!;
    await pumpApp(tester, db, size: const Size(420, 1400));
    await tester.tap(find.text('Profil'));
    await pumpApp(tester, db, size: const Size(420, 1400));
    await tester.tap(find.byTooltip('Einstellungen'));
    await pumpApp(tester, db, size: const Size(420, 1400));
    await tester.scrollUntilVisible(find.text('Alle Daten löschen'), 200, scrollable: find.byType(Scrollable).last);
    await tester.tap(find.text('Alle Daten löschen'));
    await pumpApp(tester, db, size: const Size(420, 1400));
    final button = find.widgetWithText(FilledButton, 'Endgültig löschen');
    expect(tester.widget<FilledButton>(button).onPressed, isNull);
    await tester.enterText(find.byType(TextField).last, 'löschen');
    await tester.pump();
    expect(tester.widget<FilledButton>(button).onPressed, isNotNull);
    // Sicherungen behalten, damit der Test keine Dateien anfasst.
    await tester.tap(find.byType(Checkbox).last);
    await tester.pump();
    await tester.tap(button);
    await pumpApp(tester, db, size: const Size(420, 1400));
    expect((await tester.runAsync(db.getProfile)), isNull);
    expect((await tester.runAsync(() => db.diaryForDay(todayDayKey())))!, isEmpty);
    expect(find.textContaining('Alle Daten gelöscht'), findsOneWidget);
    await closeDb(tester, db);
  });
}

class _FakeHealthSource implements HealthSource {
  _FakeHealthSource(this.data);
  final HealthRead data;
  bool requested = false;
  @override
  Future<HealthAvailability> availability() async => HealthAvailability.available;
  @override
  Future<bool> hasPermissions() async => requested;
  @override
  Future<void> install() async {}
  @override
  Future<bool> requestPermissions() async => requested = true;
  @override
  Future<HealthRead> read(DateTime from, DateTime to) async => data;
  final written = <String, List<HealthMeal>>{};
  @override
  Future<bool> hasWritePermission() async => false;
  @override
  Future<bool> requestWritePermission() async => true;
  @override
  Future<void> writeDay(String day, List<HealthMeal> meals) async => written[day] = meals;
}

class _NoBiometrics implements Biometrics {
  @override
  Future<bool> available() async => false;
  @override
  Future<bool> authenticate() async => false;
}
