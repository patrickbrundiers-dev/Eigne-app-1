import 'package:flutter_test/flutter_test.dart';
import 'package:mydiet_ai/src/core/daily_hints.dart';
import 'package:mydiet_ai/src/core/dashboard_layout.dart';
import 'package:mydiet_ai/src/core/nutrition.dart';

void main() {
  group('Tageshinweise', () {
    List<Hint> hints({
      DateTime? now,
      Nutrients consumed = const Nutrients(kcal: 1500, protein: 85, fiber: 25),
      int water = 2000,
      int entries = 3,
      String? diet,
      List<String> avoid = const [],
    }) => dailyHints(
      now: now ?? DateTime(2026, 1, 1, 18),
      consumed: consumed,
      budgetKcal: 2000,
      proteinTarget: 145,
      fiberTarget: 30,
      waterMl: water,
      waterTarget: 2500,
      entryCount: entries,
      dietStyle: diet,
      avoid: avoid,
    );

    test('Proteinlücke wie im Beispiel: 85 g, es fehlen 60 g', () {
      final h = hints();
      expect(h.first.text, contains('85 g Protein'));
      expect(h.first.text, contains('noch ungefähr 60 g'));
      expect(h.first.text, contains('Skyr'));
    });

    test('Vegan: keine tierischen Vorschläge', () {
      final text = hints(diet: 'vegan').first.text;
      expect(text, isNot(contains('Skyr')));
      expect(text, contains('Tofu'));
    });

    test('Laktoseintoleranz und Abneigungen werden beachtet', () {
      final ideas = proteinIdeas(avoid: ['Laktose', 'Tofu']);
      expect(ideas.any((i) => i.contains('Skyr') || i.contains('Hüttenkäse')), isFalse);
      expect(ideas.any((i) => i.contains('Tofu')), isFalse);
      expect(ideas, contains('Eier'));
      expect(proteinIdeas(avoid: ['Ei']).contains('Eier'), isFalse);
      expect(proteinIdeas(avoid: ['Ei']).any((i) => i.contains('Skyr')), isTrue);
    });

    test('Über dem Budget: Warnung', () {
      final h = hints(consumed: const Nutrients(kcal: 2300, protein: 150, fiber: 30));
      expect(h.any((x) => x.level == HintLevel.warn && x.text.contains('300 kcal')), isTrue);
    });

    test('Morgens noch keine Proteinwarnung', () {
      final h = hints(now: DateTime(2026, 1, 1, 9), consumed: const Nutrients(kcal: 300, protein: 20));
      expect(h, isEmpty);
    });

    test('Leerer Tag', () {
      expect(hints(entries: 0).single.text, contains('noch nichts'));
    });

    test('Alles im Ziel: positives Feedback', () {
      final h = hints(consumed: const Nutrients(kcal: 1950, protein: 140, fiber: 32), water: 2600);
      expect(h.single.level, HintLevel.good);
    });
  });

  group('Dashboard-Layout', () {
    test('Standard enthält jede Kachel genau einmal', () {
      final l = defaultLayout();
      expect(l.map((e) => e.tile).toSet().length, DashTile.values.length);
    });

    test('Speichern und Laden erhält Reihenfolge und Sichtbarkeit', () {
      final l = defaultLayout().reversed.map((c) => c.copyWith(visible: c.tile == DashTile.water)).toList();
      final back = parseLayout(encodeLayout(l));
      expect(back.map((e) => e.tile), l.map((e) => e.tile));
      expect(back.where((e) => e.visible).single.tile, DashTile.water);
    });

    test('Unbekannte, doppelte und fehlende Kacheln', () {
      final back = parseLayout(
        '[{"id":"water","visible":true},{"id":"water","visible":false},{"id":"gone","visible":true}]',
      );
      expect(back.first.tile, DashTile.water);
      expect(back.first.visible, isTrue);
      expect(back.length, DashTile.values.length);
      expect(back.skip(1).every((e) => !e.visible), isTrue);
    });

    test('Kaputtes JSON fällt auf Standard zurück', () {
      expect(parseLayout('{nope').length, DashTile.values.length);
    });
  });
}
