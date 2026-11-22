/// Text for the Android home screen widget (queue 6.4, W13). Pure Dart, unit tested.
///
/// Same numbers as the dashboard: budget = target of the day (week mode included) plus the
/// activity credit, minus what was eaten. With "hide numbers" the widget shows only a gentle status.
library;

class WidgetSummary {
  const WidgetSummary({required this.day, required this.headline, required this.detail, required this.percent});

  /// yyyy-MM-dd the numbers belong to; the widget shows a neutral text on other days.
  final String day;
  final String headline;
  final String detail;

  /// 0–100 for the progress bar.
  final int percent;

  @override
  bool operator ==(Object other) =>
      other is WidgetSummary &&
      other.day == day &&
      other.headline == headline &&
      other.detail == detail &&
      other.percent == percent;

  @override
  int get hashCode => Object.hash(day, headline, detail, percent);

  @override
  String toString() => 'WidgetSummary($day, $headline, $detail, $percent %)';
}

/// German thousands separator without intl: 1234 → "1.234".
String groupThousands(int v) {
  final s = v.abs().toString();
  final b = StringBuffer(v < 0 ? '−' : '');
  for (var i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) b.write('.');
    b.write(s[i]);
  }
  return b.toString();
}

WidgetSummary widgetSummary({
  required String day,
  required double budgetKcal,
  required double eatenKcal,
  required double proteinG,
  required int proteinTargetG,
  bool hideNumbers = false,
}) {
  final progress = budgetKcal <= 0 ? 0.0 : eatenKcal / budgetKcal;
  final percent = (progress * 100).round().clamp(0, 100);
  if (hideNumbers) {
    return WidgetSummary(day: day, headline: gentle(progress), detail: 'Tippen zum Eintragen', percent: percent);
  }
  final remaining = (budgetKcal - eatenKcal).round();
  final headline = remaining >= 0
      ? 'Noch ${groupThousands(remaining)} kcal'
      : '${groupThousands(-remaining)} kcal über dem Ziel';
  final detail =
      '${groupThousands(eatenKcal.round())} / ${groupThousands(budgetKcal.round())} kcal · '
      'Protein ${proteinG.round()} / $proteinTargetG g';
  return WidgetSummary(day: day, headline: headline, detail: detail, percent: percent);
}

/// Text instead of numbers when "hide numbers" is on (also used by `gentleStatus`).
String gentle(double progress) {
  if (progress <= 0) return 'Noch nichts eingetragen';
  if (progress < 0.85) return 'Gut im Rahmen';
  if (progress <= 1.05) return 'Ziel erreicht';
  return 'Etwas über dem Ziel, kein Problem';
}
