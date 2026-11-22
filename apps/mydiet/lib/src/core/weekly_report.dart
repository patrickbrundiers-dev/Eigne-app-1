/// Weekly report (AI_TASK_QUEUE 5.4, Phase 3 coach without AI). Pure Dart, unit tested.
///
/// Looks at one calendar week (Monday to Sunday) and turns the numbers into a few plain
/// findings and at most three suggestions for the next week. Every finding names the
/// figures it is based on. No diagnoses, no guilt words, no calorie target below the
/// safety floors: changes to the target are left to the adaptive target (with confirmation).
library;

import 'weight_progress.dart' show minLoggedDayKcal, proteinHitShare;
import 'weight_trend.dart';

/// Logged nutrition of one day.
class ReportDay {
  const ReportDay(this.date, {required this.kcal, required this.protein, this.fiber = 0});
  final DateTime date;
  final double kcal;
  final double protein;
  final double fiber;
}

/// Average share of the target for one vitamin or mineral over the logged days (0–100+ %).
class ReportMicro {
  const ReportMicro({required this.name, required this.targetPercent});
  final String name;
  final double targetPercent;
}

enum FindingKind { good, watch, info }

class Finding {
  const Finding(this.kind, this.title, this.detail);
  final FindingKind kind;
  final String title;
  final String detail;
}

class WeeklyReport {
  const WeeklyReport({
    required this.monday,
    required this.loggedDays,
    required this.averageKcal,
    required this.averageProtein,
    required this.averageFiber,
    required this.targetKcal,
    required this.proteinTargetG,
    required this.fiberTargetG,
    required this.daysNearTarget,
    required this.proteinHitDays,
    required this.weekendExtraKcal,
    required this.previousAverageKcal,
    required this.weightAverageKg,
    required this.previousWeightAverageKg,
    required this.findings,
    required this.suggestions,
  });

  final DateTime monday;

  /// Days with at least [minLoggedDayKcal] (shorter days count as not fully logged).
  final int loggedDays;
  final double? averageKcal;
  final double? averageProtein;
  final double? averageFiber;
  final int targetKcal;
  final double proteinTargetG;
  final double fiberTargetG;

  /// Logged days within ±[nearTargetShare] of the calorie target.
  final int daysNearTarget;
  final int proteinHitDays;

  /// Average of Sat/Sun minus average of Mon–Fri (logged days only); null if either is missing.
  final double? weekendExtraKcal;
  final double? previousAverageKcal;

  /// 7-day weight average at Sunday and one week before.
  final double? weightAverageKg;
  final double? previousWeightAverageKg;

  final List<Finding> findings;

  /// At most three, most useful first.
  final List<String> suggestions;

  DateTime get sunday => DateTime(monday.year, monday.month, monday.day + 6);
  double? get weightChangeKg =>
      weightAverageKg == null || previousWeightAverageKg == null ? null : weightAverageKg! - previousWeightAverageKg!;
}

/// A day counts as "on target" within ±10 %.
const double nearTargetShare = 0.10;

/// Vitamins and minerals below this share of the target (on average) are mentioned.
const double lowMicroPercent = 70;

/// Weekend difference that is worth a remark.
const double weekendRemarkKcal = 300;

DateTime _d(DateTime x) => DateTime(x.year, x.month, x.day);
String _n0(num v) => v.round().toString();
String _kg(double v) => '${v >= 0 ? '+' : '−'}${v.abs().toStringAsFixed(1).replaceAll('.', ',')} kg';

/// Builds the report for the week starting on [monday]. [days] may contain any dates; only
/// the seven days of the week (and, for the comparison, the week before) are used.
WeeklyReport buildWeeklyReport({
  required DateTime monday,
  required List<ReportDay> days,
  required int targetKcal,
  required double proteinTargetG,
  double fiberTargetG = 30,
  List<WeightPoint> weights = const [],
  List<ReportMicro> micros = const [],
  GoalLoseOrGain goal = GoalLoseOrGain.lose,
  List<String> proteinIdeas = const [],
}) {
  final mon = _d(monday);
  final sun = DateTime(mon.year, mon.month, mon.day + 6);
  final prevMon = DateTime(mon.year, mon.month, mon.day - 7);
  bool inRange(DateTime d, DateTime a, DateTime b) => !_d(d).isBefore(a) && !_d(d).isAfter(b);

  final week = days.where((x) => inRange(x.date, mon, sun) && x.kcal >= minLoggedDayKcal).toList();
  final prev = days
      .where((x) => inRange(x.date, prevMon, DateTime(mon.year, mon.month, mon.day - 1)) && x.kcal >= minLoggedDayKcal)
      .toList();
  double? avg(Iterable<double> xs) => xs.isEmpty ? null : xs.reduce((a, b) => a + b) / xs.length;

  final n = week.length;
  final aKcal = avg(week.map((x) => x.kcal));
  final aProt = avg(week.map((x) => x.protein));
  final aFiber = avg(week.map((x) => x.fiber));
  final near = week.where((x) => (x.kcal - targetKcal).abs() <= targetKcal * nearTargetShare).length;
  final protHits = proteinTargetG <= 0 ? 0 : week.where((x) => x.protein >= proteinTargetG * proteinHitShare).length;
  final weekend = week.where((x) => x.date.weekday >= DateTime.saturday).map((x) => x.kcal);
  final workdays = week.where((x) => x.date.weekday < DateTime.saturday).map((x) => x.kcal);
  final wAvg = avg(weekend), dAvg = avg(workdays);
  final weekendExtra = wAvg == null || dAvg == null ? null : wAvg - dAvg;
  final prevAvg = avg(prev.map((x) => x.kcal));

  final sorted = sortPoints(weights);
  final wNow = sorted.isEmpty ? null : trailingAverage(sorted, sun);
  final wPrev = sorted.isEmpty ? null : trailingAverage(sorted, DateTime(sun.year, sun.month, sun.day - 7));

  final findings = <Finding>[];
  final suggestions = <String>[];

  // 1. How complete is the week?
  if (n == 0) {
    findings.add(
      const Finding(
        FindingKind.info,
        'Diese Woche ist kaum etwas eingetragen',
        'Für eine Auswertung zählen Tage ab 800 kcal. Schon drei eingetragene Tage reichen für erste Aussagen.',
      ),
    );
    suggestions.add('Nächste Woche an mindestens drei Tagen alles eintragen, dann gibt es hier eine echte Auswertung.');
    return WeeklyReport(
      monday: mon,
      loggedDays: 0,
      averageKcal: null,
      averageProtein: null,
      averageFiber: null,
      targetKcal: targetKcal,
      proteinTargetG: proteinTargetG,
      fiberTargetG: fiberTargetG,
      daysNearTarget: 0,
      proteinHitDays: 0,
      weekendExtraKcal: null,
      previousAverageKcal: prevAvg,
      weightAverageKg: wNow,
      previousWeightAverageKg: wPrev,
      findings: findings,
      suggestions: suggestions,
    );
  }
  if (n < 4) {
    findings.add(
      Finding(
        FindingKind.info,
        '$n von 7 Tagen vollständig eingetragen',
        'Die Durchschnitte beruhen auf wenigen Tagen und können sich noch deutlich verschieben.',
      ),
    );
  } else {
    findings.add(
      Finding(FindingKind.good, '$n von 7 Tagen eingetragen', 'Genug Daten für eine aussagekräftige Woche.'),
    );
  }

  // 2. Energy.
  final diff = aKcal! - targetKcal;
  final share = diff / targetKcal;
  final energyDetail =
      'Ø ${_n0(aKcal)} kcal bei einem Ziel von ${_n0(targetKcal)} kcal (${diff >= 0 ? '+' : '−'}${_n0(diff.abs())}); '
      '$near von $n Tagen lagen im Bereich ±10 %.'
      '${prevAvg == null ? '' : ' Vorwoche: Ø ${_n0(prevAvg)} kcal.'}';
  if (share.abs() <= nearTargetShare) {
    findings.add(Finding(FindingKind.good, 'Kalorien im Zielbereich', energyDetail));
  } else {
    final veryLow = share < -0.2;
    findings.add(
      Finding(
        FindingKind.watch,
        share > 0 ? 'Über dem Kalorienziel' : 'Unter dem Kalorienziel',
        '$energyDetail${veryLow ? ' Sehr wenig zu essen ist auf Dauer schwer durchzuhalten und kostet Muskeln.' : ''}',
      ),
    );
    if (veryLow) {
      suggestions.add('Die Tage nicht zu knapp halten: lieber nah am Ziel bleiben, das ist leichter durchzuhalten.');
    }
  }

  // 3. Weekend pattern.
  if (weekendExtra != null && weekendExtra >= weekendRemarkKcal) {
    findings.add(
      Finding(
        FindingKind.watch,
        'Am Wochenende mehr gegessen',
        'Samstag/Sonntag im Schnitt ${_n0(weekendExtra)} kcal mehr als unter der Woche. Das ist häufig und kein Problem, '
            'wenn es eingeplant ist.',
      ),
    );
    suggestions.add(
      'Das Wochenende vorab einplanen, z. B. mit dem Wochenbudget (Einstellungen) oder einer geplanten Mahlzeit im Wochenplan.',
    );
  }

  // 4. Protein.
  if (proteinTargetG > 0 && aProt != null) {
    final detail = 'Ø ${_n0(aProt)} g bei ${_n0(proteinTargetG)} g Ziel; an $protHits von $n Tagen mindestens 90 %.';
    if (protHits >= (n * 0.7).ceil()) {
      findings.add(Finding(FindingKind.good, 'Protein meistens erreicht', detail));
    } else {
      findings.add(Finding(FindingKind.watch, 'Protein oft unter dem Ziel', detail));
      final ideas = proteinIdeas.take(3).join(', ');
      suggestions.add('Zu jeder Hauptmahlzeit eine Eiweißquelle einplanen${ideas.isEmpty ? '' : ', z. B. $ideas'}.');
    }
  }

  // 5. Fibre.
  if (fiberTargetG > 0 && aFiber != null && aFiber < fiberTargetG * 0.7) {
    findings.add(
      Finding(
        FindingKind.watch,
        'Wenig Ballaststoffe',
        'Ø ${_n0(aFiber)} g bei ${_n0(fiberTargetG)} g Ziel. Ballaststoffe sättigen länger.',
      ),
    );
    suggestions.add('Mehr Gemüse, Hülsenfrüchte, Vollkorn oder Haferflocken einbauen.');
  }

  // 6. Vitamins and minerals (only those with data).
  final low = micros.where((m) => m.targetPercent < lowMicroPercent).toList()
    ..sort((a, b) => a.targetPercent.compareTo(b.targetPercent));
  if (low.isNotEmpty) {
    findings.add(
      Finding(
        FindingKind.info,
        'Vitamine und Mineralstoffe: ${low.take(3).map((m) => m.name).join(', ')} eher niedrig',
        '${low.take(3).map((m) => '${m.name} Ø ${_n0(m.targetPercent)} %').join(', ')} des D-A-CH-Ziels (aus Essen und '
            'abgehakten Supplementen; Lebensmittel ohne Werte fehlen in der Summe). Kein Grund zur Sorge, eher ein Hinweis '
            'für die Auswahl. Bei Fragen zu Mangel bitte ärztlich abklären.',
      ),
    );
  }

  // 7. Weight.
  final change = wNow == null || wPrev == null ? null : wNow - wPrev;
  if (change != null) {
    final towardsGoal = goal == GoalLoseOrGain.lose ? change < -0.05 : change > 0.05;
    final kind = towardsGoal ? FindingKind.good : FindingKind.info;
    findings.add(
      Finding(
        kind,
        'Gewicht (7-Tage-Mittel) ${_kg(change)}',
        'Von ${wPrev!.toStringAsFixed(1).replaceAll('.', ',')} auf ${wNow!.toStringAsFixed(1).replaceAll('.', ',')} kg. '
            'Wochenwerte schwanken durch Wasser und Salz; aussagekräftig ist der Trend über mehrere Wochen '
            '(Gewicht → Fortschritt).',
      ),
    );
  }

  if (suggestions.isEmpty) {
    suggestions.add(
      'So weitermachen. Wenn sich das Gewicht über Wochen anders entwickelt als geplant, schlägt die App unter Gewicht eine Anpassung des Kalorienziels vor.',
    );
  }

  return WeeklyReport(
    monday: mon,
    loggedDays: n,
    averageKcal: aKcal,
    averageProtein: aProt,
    averageFiber: aFiber,
    targetKcal: targetKcal,
    proteinTargetG: proteinTargetG,
    fiberTargetG: fiberTargetG,
    daysNearTarget: near,
    proteinHitDays: protHits,
    weekendExtraKcal: weekendExtra,
    previousAverageKcal: prevAvg,
    weightAverageKg: wNow,
    previousWeightAverageKg: wPrev,
    findings: findings,
    suggestions: suggestions.take(3).toList(),
  );
}

/// Direction of the goal, from the profile (target weight below or above the start weight).
enum GoalLoseOrGain { lose, keep, gain }

GoalLoseOrGain goalFrom({required double currentKg, required double targetKg}) {
  if (targetKg < currentKg - 0.5) return GoalLoseOrGain.lose;
  if (targetKg > currentKg + 0.5) return GoalLoseOrGain.gain;
  return GoalLoseOrGain.keep;
}
