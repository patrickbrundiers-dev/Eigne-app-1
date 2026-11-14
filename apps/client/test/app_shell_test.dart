import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:paperless_ai/src/app.dart';
import 'package:paperless_ai/src/shell/app_shell.dart';
import 'package:paperless_ai/src/shell/destinations.dart';

Future<void> pumpAt(WidgetTester tester, Size size,
    {Brightness brightness = Brightness.light}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  tester.platformDispatcher.platformBrightnessTestValue = brightness;
  addTearDown(tester.view.reset);
  addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);
  await tester.pumpWidget(const PaperlessAiApp());
  await tester.pumpAndSettle();
}

void main() {
  group('layoutForWidth', () {
    test('maps widths to Material window size classes', () {
      expect(layoutForWidth(360), ShellLayout.compact);
      expect(layoutForWidth(599.9), ShellLayout.compact);
      expect(layoutForWidth(600), ShellLayout.medium);
      expect(layoutForWidth(1199), ShellLayout.medium);
      expect(layoutForWidth(1200), ShellLayout.expanded);
    });
  });

  group('responsive shell', () {
    testWidgets('phone width uses a bottom navigation bar', (tester) async {
      await pumpAt(tester, const Size(390, 844));
      expect(find.byKey(const Key('shell.navigationBar')), findsOneWidget);
      expect(find.byType(NavigationRail), findsNothing);
      expect(tester.takeException(), isNull);
    });

    testWidgets('tablet width uses a compact navigation rail', (tester) async {
      await pumpAt(tester, const Size(900, 700));
      final rail = tester.widget<NavigationRail>(find.byType(NavigationRail));
      expect(rail.extended, isFalse);
      expect(find.byType(NavigationBar), findsNothing);
      expect(tester.takeException(), isNull);
    });

    testWidgets('desktop width uses an extended navigation rail',
        (tester) async {
      await pumpAt(tester, const Size(1440, 900));
      final rail = tester.widget<NavigationRail>(find.byType(NavigationRail));
      expect(rail.extended, isTrue);
      expect(tester.takeException(), isNull);
    });

    testWidgets('every destination is reachable on phone', (tester) async {
      await pumpAt(tester, const Size(390, 844));
      for (var i = 0; i < appDestinations.length; i++) {
        await tester.tap(find.byType(NavigationDestination).at(i));
        await tester.pumpAndSettle();
        final bar = tester.widget<NavigationBar>(find.byType(NavigationBar));
        expect(bar.selectedIndex, i);
        expect(find.widgetWithText(AppBar, appDestinations[i].label),
            findsOneWidget);
      }
    });

    testWidgets('selecting a rail destination shows its page on desktop',
        (tester) async {
      await pumpAt(tester, const Size(1440, 900));
      await tester.tap(find.text('Fristen').first);
      await tester.pumpAndSettle();
      expect(find.text('Keine Fristen'), findsOneWidget);
    });
  });

  group('themes', () {
    testWidgets('follows system light/dark brightness', (tester) async {
      await pumpAt(tester, const Size(1440, 900));
      var theme = Theme.of(tester.element(find.byType(AppShell)));
      expect(theme.brightness, Brightness.light);

      await pumpAt(tester, const Size(1440, 900), brightness: Brightness.dark);
      theme = Theme.of(tester.element(find.byType(AppShell)));
      expect(theme.brightness, Brightness.dark);
    });
  });
}
