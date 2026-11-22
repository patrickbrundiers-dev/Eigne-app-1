import 'package:material_ui/material_ui.dart';

import '../../app.dart';
import '../../core/dates.dart';
import '../../core/energy.dart';
import '../../core/weight_trend.dart';
import '../../data/database.dart';
import '../../data/targets.dart';
import '../../ui/design/components.dart';
import '../../ui/design/tokens.dart';
import '../../ui/format.dart';
import '../../ui/widgets.dart';
import '../home_shell.dart';
import 'adaptive_card.dart';
import 'progress_card.dart';
import 'weight_chart.dart';
import 'weight_entry_sheet.dart';

/// Weigh-ins shown at once in the list.
const weightPageSize = 120;

class WeightPage extends StatefulWidget {
  const WeightPage({super.key});

  @override
  State<WeightPage> createState() => _WeightPageState();
}

class _WeightPageState extends State<WeightPage> {
  int? _days = 90;

  /// Entries shown in the list; „Ältere anzeigen“ adds [weightPageSize] more.
  int _shown = weightPageSize;
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    final db = context.db;
    return Scaffold(
      appBar: AppBar(title: const Text('Fortschritt')),
      body: StreamBuilder<List<Object?>>(
        stream: combineLatest([db.watchProfile(), db.watchWeights()]),
        builder: (context, snap) {
          final v = snap.data;
          if (v == null || v[0] == null) return const Center(child: CircularProgressIndicator());
          final p = v[0] as Profile;
          final weights = v[1] as List<WeightEntry>;
          final pts = weightPoints(weights);
          final a = analyzeWeight(pts, targetKg: p.targetWeightKg);
          final cur = currentWeight(p, a);
          return PageBody(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
              children: [
                _stats(context, p, a, cur),
                const SizedBox(height: 12),
                WeightProgressCard(profile: p, weights: weights),
                const SizedBox(height: 12),
                AdaptiveCard(profile: p, weights: weights),
                const SizedBox(height: 12),
                SectionCard(
                  title: 'Verlauf',
                  icon: Icons.show_chart,
                  trailing: SegmentedButton<int?>(
                    showSelectedIcon: false,
                    style: const ButtonStyle(visualDensity: VisualDensity.compact),
                    segments: const [
                      ButtonSegment(value: 30, label: Text('30 T')),
                      ButtonSegment(value: 90, label: Text('90 T')),
                      ButtonSegment(value: 365, label: Text('1 J')),
                      ButtonSegment(value: null, label: Text('Alle')),
                    ],
                    selected: {_days},
                    onSelectionChanged: (s) => setState(() => _days = s.first),
                  ),
                  child: SizedBox(
                    height: 260,
                    child: WeightChart(entries: weights, targetKg: p.targetWeightKg, days: _days),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Punkte = einzelne Messungen, Linie = 7-Tage-Durchschnitt. Tempo und Prognose beruhen auf '
                  'einer Ausgleichsgeraden über bis zu 28 Tage, damit einzelne Schwankungen nichts verfälschen.',
                  style: Theme.of(context).textTheme.bodySmall
                      ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                ),
                const SizedBox(height: 12),
                SegmentedButton<int>(
                  segments: const [
                    ButtonSegment(value: 0, label: Text('Einträge')),
                    ButtonSegment(value: 1, label: Text('Wochen')),
                    ButtonSegment(value: 2, label: Text('Monate')),
                  ],
                  selected: {_tab},
                  onSelectionChanged: (s) => setState(() => _tab = s.first),
                ),
                const SizedBox(height: 8),
                Card(child: _list(context, weights, pts)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _stats(BuildContext context, Profile p, WeightAnalysis a, double cur) {
    final t = Theme.of(context);
    final tk = context.tokens;
    final b = bmi(cur, p.heightCm);
    final rate = a.weeklyRateKg;
    final label = TextStyle(
      fontFamily: SattlyFonts.numbers,
      fontSize: 13,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.8,
      color: tk.muted,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(SattlySpace.l),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Semantics(
                        label: 'Trendgewicht ${kg(cur)}',
                        excludeSemantics: true,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('TREND (7 TAGE)', style: label),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerLeft,
                              child: Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: n1(cur),
                                      style: numberStyle(52, color: tk.ink),
                                    ),
                                    TextSpan(
                                      text: ' kg',
                                      style: numberStyle(22, color: tk.muted, weight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            if (a.latest != null)
                              Text(
                                'zuletzt ${kg(a.latest!.kg)}',
                                style: t.textTheme.bodySmall?.copyWith(color: tk.muted),
                              ),
                          ],
                        ),
                      ),
                    ),
                    IconButton.filled(
                      tooltip: 'Gewicht eintragen',
                      icon: const Icon(Icons.add),
                      style: IconButton.styleFrom(
                        minimumSize: const Size.square(minTouchTarget),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(SattlyRadius.control)),
                        ),
                      ),
                      onPressed: () => showWeightEntrySheet(context),
                    ),
                  ],
                ),
                const SizedBox(height: SattlySpace.l),
                StatStrip(
                  items: [
                    (
                      'Pro Woche',
                      rate == null ? '–' : '${rate <= 0 ? '−' : '+'}${n1(rate.abs())} kg',
                      rate == null || rate.abs() < 0.05 ? tk.muted : (rate < 0 ? tk.good : tk.warn),
                    ),
                    ('BMI', n1(b), tk.water),
                    (
                      'Ziel ${kg(p.targetWeightKg)}',
                      a.forecastDate == null ? '–' : dateShort(a.forecastDate!),
                      tk.primary,
                    ),
                  ],
                  notes: [
                    rate == null ? 'mind. 4 Messungen über 10 Tage' : 'über ${a.rateBasisDays} Tage',
                    bmiCategory(b),
                    a.forecastDate == null ? 'noch keine Prognose' : 'Prognose aus Trend',
                  ],
                ),
              ],
            ),
          ),
        ),
        if (a.isPlateau) ...[
          const SizedBox(height: 12),
          Card(
            color: Color.alphaBlend(tk.warn.withValues(alpha: 0.12), tk.surface),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(Icons.hourglass_bottom, color: tk.warn),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Plateau erkannt: In den letzten drei Wochen hat sich dein Trendgewicht um weniger als '
                      '0,1 kg pro Woche verändert. Das ist häufig und oft Wassereinlagerung. Prüfe, ob die '
                      'Einträge im Tagebuch vollständig sind. Eine Anpassung des Kalorienziels schlägt der '
                      'Wochen-Check unten vor; du entscheidest selbst.',
                      style: TextStyle(color: tk.ink),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _list(BuildContext context, List<WeightEntry> weights, List<WeightPoint> pts) {
    final t = Theme.of(context);
    if (weights.isEmpty) {
      return const Padding(padding: EdgeInsets.all(24), child: Text('Noch keine Einträge.'));
    }
    if (_tab == 0) {
      final rev = weights.reversed.toList();
      return Column(
        children: [
          for (var i = 0; i < rev.length && i < _shown; i++)
            ListTile(
              title: Text(kg(rev[i].weightKg), style: numberStyle(19, color: t.colorScheme.onSurface)),
              subtitle: Text(
                [
                  weekdayShort(parseDayKey(rev[i].dayKey)),
                  if (rev[i].bodyFatPercent != null) '${n1(rev[i].bodyFatPercent!)} % KFA',
                  if (rev[i].waistCm != null) '${n1opt(rev[i].waistCm!)} cm Bauch',
                  if (rev[i].note != null) rev[i].note!,
                ].join(' · '),
              ),
              trailing: i + 1 < rev.length ? _delta(t, rev[i].weightKg - rev[i + 1].weightKg) : null,
              onTap: () => showWeightEntrySheet(context, entry: rev[i]),
              onLongPress: () => _confirmDelete(context, rev[i]),
            ),
          if (rev.length > _shown)
            Padding(
              padding: const EdgeInsets.all(12),
              child: OutlinedButton.icon(
                onPressed: () => setState(() => _shown += weightPageSize),
                icon: const Icon(Icons.expand_more),
                label: Text('Ältere anzeigen (noch ${rev.length - _shown})'),
              ),
            ),
        ],
      );
    }
    final groups = _tab == 1 ? weeklyAverages(pts) : monthlyAverages(pts);
    return Column(
      children: [
        for (var i = 0; i < groups.length; i++)
          ListTile(
            title: Text(
              _tab == 1
                  ? 'Woche ab ${dateTiny(groups[i].start)}'
                  : '${_months[groups[i].start.month - 1]} ${groups[i].start.year}',
            ),
            subtitle: Text('Ø aus ${groups[i].count} ${groups[i].count == 1 ? 'Messung' : 'Messungen'}'),
            leading: Text(kg(groups[i].averageKg), style: numberStyle(19, color: t.colorScheme.onSurface)),
            trailing: i + 1 < groups.length ? _delta(t, groups[i].averageKg - groups[i + 1].averageKg) : null,
          ),
      ],
    );
  }

  Widget _delta(ThemeData t, double d) => Text(
    '${d <= 0 ? '−' : '+'}${n1(d.abs())}',
    style: numberStyle(
      17,
      color: d < 0 ? t.colorScheme.primary : (d > 0 ? t.colorScheme.error : t.colorScheme.onSurfaceVariant),
      weight: FontWeight.w600,
    ),
  );

  Future<void> _confirmDelete(BuildContext context, WeightEntry e) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Eintrag löschen?'),
        content: Text('${kg(e.weightKg)} vom ${dateShort(parseDayKey(e.dayKey))}'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('Abbrechen')),
          FilledButton(onPressed: () => Navigator.pop(c, true), child: const Text('Löschen')),
        ],
      ),
    );
    if (ok == true && context.mounted) await context.db.deleteWeight(e.id);
  }
}

const _months = [
  'Januar',
  'Februar',
  'März',
  'April',
  'Mai',
  'Juni',
  'Juli',
  'August',
  'September',
  'Oktober',
  'November',
  'Dezember',
];
