/// Rule-based daily hints (no AI, no medical advice). Each rule is explicit and
/// unit tested; Phase 3 replaces the wording with the AI coach but keeps the rules
/// as guard rails.
library;

import 'nutrition.dart';

enum HintLevel { good, info, warn }

class Hint {
  const Hint(this.level, this.text);
  final HintLevel level;
  final String text;
}

class _ProteinIdea {
  const _ProteinIdea(this.label, {this.animal = false, this.dairy = false, this.egg = false, this.fish = false});
  final String label;
  final bool animal, dairy, egg, fish;
}

const _ideas = [
  _ProteinIdea('eine Portion Skyr oder Magerquark', animal: true, dairy: true),
  _ProteinIdea('Hähnchen- oder Putenbrust', animal: true),
  _ProteinIdea('Thunfisch oder Lachs', animal: true, fish: true),
  _ProteinIdea('Eier', animal: true, egg: true),
  _ProteinIdea('Hüttenkäse', animal: true, dairy: true),
  _ProteinIdea('Tofu'),
  _ProteinIdea('Linsen oder Kichererbsen'),
];

List<String> proteinIdeas({String? dietStyle, List<String> avoid = const []}) {
  final a = avoid.map(normalizeName).where((x) => x.length >= 2).toList();
  bool any(List<String> words) => a.any((x) => words.any((w) => x.contains(w)));
  final noDairy = any(['laktose', 'milch', 'skyr', 'quark']);
  final noEgg = a.any((x) => x == 'ei' || x == 'eier' || x.contains('huehnerei'));
  final noFish = any(['fisch', 'thunfisch', 'lachs']);
  bool namedInLabel(String label) {
    final words = normalizeName(label).split(' ');
    return a
        .where((x) => x.length >= 3)
        .any((x) => words.any((w) => w.length >= 3 && (w.startsWith(x) || x.startsWith(w))));
  }

  return [
    for (final i in _ideas)
      if (!(dietStyle == 'vegan' && i.animal) &&
          !(dietStyle == 'vegetarian' && i.animal && !i.dairy && !i.egg) &&
          !(dietStyle == 'pescetarian' && i.animal && !i.dairy && !i.egg && !i.fish) &&
          !(i.dairy && noDairy) &&
          !(i.egg && noEgg) &&
          !(i.fish && noFish) &&
          !namedInLabel(i.label))
        i.label,
  ];
}

List<Hint> dailyHints({
  required DateTime now,
  required Nutrients consumed,
  required double budgetKcal,
  required double proteinTarget,
  required double fiberTarget,
  required int waterMl,
  required int waterTarget,
  required int entryCount,
  String? dietStyle,
  List<String> avoid = const [],
}) {
  final hints = <Hint>[];
  final h = now.hour + now.minute / 60;

  if (entryCount == 0) {
    if (h >= 10) hints.add(const Hint(HintLevel.info, 'Heute ist noch nichts eingetragen.'));
    return hints;
  }

  final missingProtein = proteinTarget - consumed.protein;
  if (missingProtein > 15 && h >= 12) {
    final ideas = proteinIdeas(dietStyle: dietStyle, avoid: avoid).take(2).toList();
    hints.add(
      Hint(
        HintLevel.info,
        'Du hast heute ${consumed.protein.round()} g Protein aufgenommen. Für dein Tagesziel fehlen '
        'noch ungefähr ${missingProtein.round()} g.'
        '${ideas.isEmpty ? '' : ' Passen würde z. B. ${ideas.join(' oder ')}.'}',
      ),
    );
  }

  final over = consumed.kcal - budgetKcal;
  if (over > 100) {
    hints.add(
      Hint(
        HintLevel.warn,
        'Du liegst ${over.round()} kcal über deinem Tagesbudget. Ein einzelner Tag ist kein Problem, '
        'entscheidend ist der Durchschnitt der Woche.',
      ),
    );
  } else if (h >= 20 && -over > 600) {
    hints.add(
      Hint(
        HintLevel.info,
        'Es sind noch ${(-over).round()} kcal offen. Ein sehr großes Defizit ist auf Dauer schwer '
        'durchzuhalten; eine kleine eiweißreiche Mahlzeit wäre in Ordnung.',
      ),
    );
  }

  if (h >= 17 && consumed.fiber < fiberTarget * 0.5) {
    hints.add(
      Hint(
        HintLevel.info,
        'Erst ${consumed.fiber.round()} g Ballaststoffe. Gemüse, Vollkorn oder Hülsenfrüchte helfen, '
        'die ${fiberTarget.round()} g zu erreichen.',
      ),
    );
  }

  if (h >= 14 && waterTarget > 0) {
    final expected = waterTarget * ((h - 7) / 14).clamp(0.0, 1.0);
    if (waterMl < expected * 0.6) {
      hints.add(
        Hint(
          HintLevel.info,
          'Du hast erst ${(waterMl / 1000).toStringAsFixed(1).replaceAll('.', ',')} l getrunken. '
          'Ein Glas Wasser zwischendurch bringt dich näher an dein Ziel.',
        ),
      );
    }
  }

  if (hints.isEmpty &&
      consumed.protein >= proteinTarget * 0.9 &&
      (consumed.kcal - budgetKcal).abs() <= budgetKcal * 0.1) {
    hints.add(const Hint(HintLevel.good, 'Kalorien und Protein liegen heute im Ziel. Weiter so!'));
  }
  return hints;
}
