import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mydiet_ai/src/app.dart' show buildTheme, colorSchemes;
import 'package:mydiet_ai/src/ui/design/components.dart';
import 'package:mydiet_ai/src/ui/design/theme.dart';
import 'package:mydiet_ai/src/ui/design/tokens.dart';
import 'package:mydiet_ai/src/ui/widgets.dart';

/// Kontrast nach WCAG 2.1 (relative Leuchtdichte).
double contrast(Color a, Color b) {
  double lum(Color c) {
    double ch(double v) => v <= 0.04045 ? v / 12.92 : math.pow((v + 0.055) / 1.055, 2.4).toDouble();
    return 0.2126 * ch(c.r) + 0.7152 * ch(c.g) + 0.0722 * ch(c.b);
  }

  final x = lum(a), y = lum(b);
  return (math.max(x, y) + 0.05) / (math.min(x, y) + 0.05);
}

void main() {
  for (final (name, t) in [('hell', SattlyTokens.light), ('dunkel', SattlyTokens.dark)]) {
    group('Kontraste $name (WCAG AA)', () {
      test('Text auf Hintergrund und Karten mindestens 4,5:1', () {
        expect(contrast(t.ink, t.bg), greaterThanOrEqualTo(7));
        expect(contrast(t.ink, t.surface), greaterThanOrEqualTo(7));
        expect(contrast(t.muted, t.bg), greaterThanOrEqualTo(4.5));
        expect(contrast(t.muted, t.surface), greaterThanOrEqualTo(4.5));
        expect(contrast(t.onPrimary, t.primary), greaterThanOrEqualTo(4.5));
        expect(contrast(t.primaryInk, t.primarySoft), greaterThanOrEqualTo(4.5));
      });
      test('Farben in Balken, Ringen und Status mindestens 3:1 zur Karte', () {
        for (final c in [t.primary, t.protein, t.carbs, t.fat, t.fiber, t.water, t.good, t.warn, t.danger]) {
          expect(contrast(c, t.surface), greaterThanOrEqualTo(3), reason: '$c');
        }
      });
    });
  }

  test('Theme trägt die Tokens, Schrift Barlow, Kennzahlen Barlow Condensed', () {
    final th = sattlyTheme(Brightness.dark);
    expect(th.extension<SattlyTokens>(), SattlyTokens.dark);
    expect(th.colorScheme.primary, SattlyTokens.dark.primary);
    expect(th.scaffoldBackgroundColor, SattlyTokens.dark.bg);
    expect(th.textTheme.bodyMedium?.fontFamily, SattlyFonts.body);
    expect(th.textTheme.displaySmall?.fontFamily, SattlyFonts.numbers);
  });

  test('Gleiches Theme bei jedem Neuaufbau (kein Überblenden)', () {
    expect(identical(sattlyTheme(Brightness.light), sattlyTheme(Brightness.light)), isTrue);
    final green = colorSchemes['green']!.$2;
    expect(identical(buildTheme(green, Brightness.dark), sattlyTheme(Brightness.dark)), isTrue);
  });

  test('Anderes Farbschema ersetzt nur den Akzent', () {
    final blue = buildTheme(colorSchemes['blue']!.$2, Brightness.light);
    final t = blue.extension<SattlyTokens>()!;
    expect(t.primary, isNot(SattlyTokens.light.primary));
    expect(t.bg, SattlyTokens.light.bg);
    expect(t.protein, SattlyTokens.light.protein);
  });

  testWidgets('Makrofarben kommen aus den Tokens', (tester) async {
    late BuildContext ctx;
    await tester.pumpWidget(
      MaterialApp(
        theme: sattlyTheme(Brightness.light),
        home: Builder(
          builder: (c) {
            ctx = c;
            return const SizedBox();
          },
        ),
      ),
    );
    expect(MacroColors.protein(ctx), SattlyTokens.light.protein);
    expect(MacroColors.water(ctx), SattlyTokens.light.water);
  });

  testWidgets('Ringe und Kennzahl-Leiste: Screenreader-Text, Beschriftung groß', (tester) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(
      MaterialApp(
        theme: sattlyTheme(Brightness.dark),
        home: const Scaffold(
          body: Column(
            children: [
              ConcentricRings(
                size: 120,
                rings: [RingValue(1.2, Colors.green), RingValue(0.5, Colors.purple)],
                semanticLabel: 'Kalorien heute: 100 kcal zu viel',
              ),
              StatStrip(items: [('Gegessen', '982 kcal', Colors.orange)]),
            ],
          ),
        ),
      ),
    );
    expect(find.bySemanticsLabel('Kalorien heute: 100 kcal zu viel'), findsOneWidget);
    expect(find.text('GEGESSEN'), findsOneWidget);
    expect(find.text('982 kcal'), findsOneWidget);
    expect(tester.takeException(), isNull);
    handle.dispose();
  });
}
