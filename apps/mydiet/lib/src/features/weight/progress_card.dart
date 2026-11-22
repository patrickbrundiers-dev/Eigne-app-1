import 'package:material_ui/material_ui.dart';

import '../../app.dart';
import '../../core/dates.dart';
import '../../core/nutrition.dart';
import '../../core/stall.dart';
import '../../core/weight_progress.dart';
import '../../data/database.dart';
import '../../data/display_prefs.dart';
import '../../data/targets.dart';
import '../../ui/format.dart';
import '../../ui/widgets.dart';

/// Weight dashboard: start → goal progress, 7-day average, 30-day trend, forecast,
/// and how the last 7 days of eating fit the goal (calorie balance, protein).
class WeightProgressCard extends StatefulWidget {
  const WeightProgressCard({super.key, required this.profile, required this.weights, this.today});

  final Profile profile;
  final List<WeightEntry> weights;

  /// For tests; defaults to now.
  final DateTime? today;

  @override
  State<WeightProgressCard> createState() => _WeightProgressCardState();
}

class _WeightProgressCardState extends State<WeightProgressCard> {
  Stream<List<Object?>>? _stream;
  bool _explain = false;

  DateTime get _today => dateOnly(widget.today ?? DateTime.now());

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_stream == null) {
      final t = _today;
      final db = context.db;
      _stream = combineLatest([
        db.watchDailyTotals(
          dayKey(DateTime(t.year, t.month, t.day - 21)),
          dayKey(DateTime(t.year, t.month, t.day - 1)),
        ),
        db.watchSetting(hideNumbersKey),
      ]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Object?>>(
      stream: _stream,
      builder: (context, snap) {
        final totals = (snap.data?[0] as Map<String, Nutrients>?) ?? const <String, Nutrients>{};
        final hide = snap.data?[1] == 'true';
        final p = widget.profile;
        final r = targetsFor(p, widget.weights, today: _today);
        final logs = [
          for (final e in totals.entries) DayLog(parseDayKey(e.key), kcal: e.value.kcal, protein: e.value.protein),
        ];
        final stall = analyzeStall(
          points: weightPoints(widget.weights),
          logs: logs,
          today: _today,
          startKg: p.startWeightKg,
          targetKg: p.targetWeightKg,
          targetKcal: r.targetKcal,
          tdeeKcal: r.tdee,
        );
        final prog = computeWeightProgress(
          points: weightPoints(widget.weights),
          startKg: p.startWeightKg,
          targetKg: p.targetWeightKg,
          today: _today,
          logs: logs,
          targetKcal: r.targetKcal,
          proteinTargetG: r.proteinG.toDouble(),
          tdeeKcal: r.tdee,
        );
        return SectionCard(
          title: 'Zielfortschritt',
          icon: Icons.flag_outlined,
          trailing: IconButton(
            tooltip: _explain ? 'Erklärung ausblenden' : 'Wie wird gerechnet?',
            icon: Icon(_explain ? Icons.expand_less : Icons.info_outline),
            onPressed: () => setState(() => _explain = !_explain),
          ),
          child: _content(context, prog, hide, stall),
        );
      },
    );
  }

  Widget _content(BuildContext context, WeightProgress g, bool hide, StallAnalysis? stall) {
    final t = Theme.of(context);
    final muted = t.textTheme.bodySmall?.copyWith(color: t.colorScheme.onSurfaceVariant);
    final wide = MediaQuery.sizeOf(context).width >= 640;
    final change = g.changeSinceStartKg;
    final towardsGoal = g.goalIsLoss ? change <= 0 : change >= 0;
    final wow = g.weekOverWeekKg;
    final tr = g.trend30;

    final items = <Widget>[
      StatValue(
        label: 'Start',
        value: kg(g.startKg),
        sub: g.startDate == null ? null : 'erste Messung ${dateTiny(g.startDate!)}',
      ),
      StatValue(
        label: g.goalIsLoss ? 'Bisher abgenommen' : 'Bisher verändert',
        value: '${change <= 0 ? '−' : '+'}${kg(change.abs())}',
        valueColor: change.abs() < 0.05 ? null : (towardsGoal ? t.colorScheme.primary : t.colorScheme.error),
        sub: '7-Tage-Ø gegen Start',
      ),
      StatValue(
        label: 'Noch bis Ziel',
        value: g.goalReached ? 'erreicht' : kg(g.remainingKg),
        sub: 'Ziel ${kg(g.targetKg)}',
      ),
      StatValue(
        label: 'Zur Vorwoche',
        value: wow == null ? '–' : '${wow <= 0 ? '−' : '+'}${kg(wow.abs())}',
        sub: wow == null ? 'Vorwoche fehlt' : '7-Tage-Ø gegen Vorwoche',
      ),
      StatValue(
        label: '30-Tage-Trend',
        value: tr.changeKg == null ? '–' : '${tr.changeKg! <= 0 ? '−' : '+'}${kg(tr.changeKg!.abs())}',
        sub: tr.weeklyRateKg == null
            ? reliabilityText(tr.reliability)
            : '${tr.weeklyRateKg! <= 0 ? '−' : '+'}${n1(tr.weeklyRateKg!.abs())} kg/Woche · ${reliabilityText(tr.reliability)}',
      ),
      StatValue(
        label: 'Tagesschwankung',
        value: tr.fluctuationKg == null ? '–' : '±${kg(tr.fluctuationKg!)}',
        sub: tr.fluctuationKg == null ? 'zu wenige Messungen' : 'normal, kein Grund zur Sorge',
      ),
    ];
    final perRow = wide ? 3 : 2;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Semantics(
          label: 'Fortschritt zum Ziel ${(g.progress * 100).round()} Prozent',
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(value: g.progress, minHeight: 10),
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Text(kg(g.startKg), style: muted),
            const Spacer(),
            Text('${(g.progress * 100).round()} %', style: t.textTheme.labelMedium),
            const Spacer(),
            Text(kg(g.targetKg), style: muted),
          ],
        ),
        const SizedBox(height: 12),
        for (var i = 0; i < items.length; i += perRow) ...[
          if (i > 0) const SizedBox(height: 12),
          Row(
            children: [
              for (var j = i; j < i + perRow; j++) Expanded(child: j < items.length ? items[j] : const SizedBox()),
            ],
          ),
        ],
        if (g.nutrition != null) ...[const Divider(height: 24), _nutrition(context, g.nutrition!, tr, hide)],
        if (stall != null && !hide) ...[const Divider(height: 24), _stall(context, stall)],
        if (_explain) ...[const Divider(height: 24), _explanation(context)],
      ],
    );
  }

  Widget _stall(BuildContext context, StallAnalysis s) {
    final t = Theme.of(context);
    final muted = t.textTheme.bodySmall?.copyWith(color: t.colorScheme.onSurfaceVariant);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Stillstand: woran es liegen kann', style: t.textTheme.titleSmall),
        const SizedBox(height: 2),
        Text(
          'Letzte ${s.days} Tage: ${s.weeklyRateKg <= 0 ? '−' : '+'}${n1(s.weeklyRateKg.abs())} kg/Woche. '
          '${s.causes.isEmpty ? 'In deinen Daten fällt nichts Bestimmtes auf.' : 'Auffällig in deinen Daten:'}',
          style: muted,
        ),
        for (final c in s.causes)
          ListTile(
            contentPadding: EdgeInsets.zero,
            dense: true,
            leading: const Icon(Icons.search_outlined),
            title: Text(c.title),
            subtitle: Text(c.detail),
          ),
        const SizedBox(height: 4),
        Text(StallAnalysis.waterNote, style: muted),
      ],
    );
  }

  Widget _nutrition(BuildContext context, NutritionWindow n, WeightTrendWindow tr, bool hide) {
    final t = Theme.of(context);
    final muted = t.textTheme.bodySmall?.copyWith(color: t.colorScheme.onSurfaceVariant);
    if (n.loggedDays == 0) {
      return Text(
        'Letzte 7 Tage: noch keine vollständig eingetragenen Tage. Sobald du isst und einträgst, '
        'siehst du hier Kalorienbilanz und Proteinziel.',
        style: muted,
      );
    }
    final bal = n.balanceVsTargetKcal!;
    final balText = hide
        ? (bal.abs() <= 100 ? 'im Rahmen' : (bal < 0 ? 'unter Ziel' : 'über Ziel'))
        : '${bal <= 0 ? '−' : '+'}${n0(bal.abs())} kcal';
    final exp = n.expectedWeeklyChangeKg!;
    final items = [
      StatValue(
        label: 'Ø gegen Kalorienziel',
        value: balText,
        sub: hide ? 'Ø der eingetragenen Tage' : 'Ø ${kcal(n.averageKcal!)} · Ziel ${kcal(n.targetKcal)}',
      ),
      StatValue(
        label: 'Proteinziel erreicht',
        value: '${n.proteinHitDays} von ${n.loggedDays}',
        valueColor: n.proteinHitShare >= 0.7 ? t.colorScheme.primary : null,
        sub: hide ? 'Tagen' : 'Tagen · Ø ${grams(n.averageProteinG!)} von ${grams(n.proteinTargetG)}',
      ),
    ];
    // Compare what the eating would explain with what the scale shows.
    String? compare;
    final rate = tr.weeklyRateKg;
    if (rate != null && tr.reliability != Reliability.none && n.loggedDays >= 4) {
      final expTxt = '${exp <= 0 ? '−' : '+'}${n1(exp.abs())} kg';
      final rateTxt = '${rate <= 0 ? '−' : '+'}${n1(rate.abs())} kg';
      final check = checkBalance(expectedWeeklyKg: exp, measuredWeeklyKg: rate);
      if (check == BalanceCheck.matches) {
        compare = 'Nach deiner Bilanz wären etwa $expTxt pro Woche zu erwarten, das passt zum gemessenen Trend.';
      } else if (check == BalanceCheck.scaleHigher) {
        compare =
            'Nach deiner Bilanz wären etwa $expTxt pro Woche zu erwarten, der Trend der Waage zeigt $rateTxt. '
            'Häufige Gründe: nicht alles eingetragen (Getränke, Öl, Snacks), Portionen geschätzt, '
            'Wassereinlagerung oder ein niedrigerer Verbrauch als die Formel annimmt. '
            'Der Wochen-Check unten rechnet mit deinem echten Verlauf.';
      } else {
        compare =
            'Nach deiner Bilanz wären etwa $expTxt pro Woche zu erwarten, der Trend der Waage zeigt $rateTxt. '
            'Dein Verbrauch ist vermutlich höher als geschätzt; der Wochen-Check unten rechnet genauer.';
      }
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Letzte 7 Tage (ohne heute)', style: t.textTheme.titleSmall),
        const SizedBox(height: 8),
        Row(children: [for (final i in items) Expanded(child: i)]),
        const SizedBox(height: 6),
        Text(
          'Gezählt: ${n.loggedDays} von ${n.days} Tagen. Tage unter ${n0(minLoggedDayKcal)} kcal gelten als '
          'unvollständig und zählen nicht mit.',
          style: muted,
        ),
        if (compare != null && !hide) ...[const SizedBox(height: 6), Text(compare, style: muted)],
      ],
    );
  }

  Widget _explanation(BuildContext context) {
    final t = Theme.of(context);
    final style = t.textTheme.bodySmall?.copyWith(color: t.colorScheme.onSurfaceVariant);
    return Text(
      '• „Bisher“ und „Noch bis Ziel“ rechnen mit dem 7-Tage-Durchschnitt, nicht mit der letzten Messung.\n'
      '• Tagesschwankung: so weit weichen einzelne Messungen typischerweise vom Trend ab (Wasser, Salz, '
      'Verdauung). Ein Tag mit mehr oder weniger auf der Waage sagt deshalb wenig aus.\n'
      '• Der 30-Tage-Trend ist eine Ausgleichsgerade durch alle Messungen der letzten 30 Tage. '
      'Die Veränderung wird entlang dieser Geraden abgelesen, deshalb verschieben einzelne Ausreißer sie kaum.\n'
      '• Aussagekraft: ab 4 Messungen über mindestens 10 Tage gering, ab 8 Messungen über 14 Tage mittel, '
      'ab 14 Messungen über 21 Tage gut.\n'
      '• Die Prognose verlängert den Trend der letzten 28 Tage bis zum Ziel. Sie ist eine Fortschreibung, '
      'kein Versprechen; das Tempo ändert sich mit der Zeit.\n'
      '• Bilanz: Ø eingetragene Kalorien minus geschätzter Verbrauch (Grundumsatz × Aktivitätsfaktor). '
      '7.700 kcal entsprechen etwa 1 kg Körpergewicht.\n'
      '• Proteinziel gilt ab 90 % als erreicht.',
      style: style,
    );
  }
}
