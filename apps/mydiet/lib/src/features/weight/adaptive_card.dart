import 'package:drift/drift.dart' show Value;
import 'package:material_ui/material_ui.dart';

import '../../app.dart';
import '../../core/adaptive_target.dart';
import '../../core/dates.dart';
import '../../data/database.dart';
import '../../data/targets.dart';
import '../../ui/format.dart';
import '../../ui/widgets.dart';

/// Settings key: day on which the last suggestion was applied (yyyy-MM-dd).
const adaptiveAppliedKey = 'adaptive_last_applied';

/// Loads the last 28 days of diary totals and computes the adaptive target.
Future<AdaptiveResult> loadAdaptiveResult(
  AppDatabase db,
  Profile p,
  List<WeightEntry> weights, {
  DateTime? today,
}) async {
  final now = dateOnly(today ?? DateTime.now());
  final from = DateTime(now.year, now.month, now.day - 28);
  final to = DateTime(now.year, now.month, now.day - 1);
  final totals = await db.dailyTotals(dayKey(from), dayKey(to));
  final r = targetsFor(p, weights, today: now);
  return calculateAdaptiveTarget(
    AdaptiveInput(
      today: now,
      intakes: [for (final e in totals.entries) DayIntake(parseDayKey(e.key), e.value.kcal)],
      weights: weightPoints(weights),
      formulaTdee: r.tdee,
      desiredDailyDeltaKcal: r.dailyDeltaKcal,
      currentTargetKcal: r.targetKcal,
      floorKcal: p.sex == 'female' ? 1200 : 1500,
    ),
  );
}

/// "Wochen-Check": compares the formula with the real course and suggests a new target.
class AdaptiveCard extends StatefulWidget {
  const AdaptiveCard({super.key, required this.profile, required this.weights});

  final Profile profile;
  final List<WeightEntry> weights;

  @override
  State<AdaptiveCard> createState() => _AdaptiveCardState();
}

class _AdaptiveCardState extends State<AdaptiveCard> {
  Future<AdaptiveResult>? _future;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _future ??= loadAdaptiveResult(context.db, widget.profile, widget.weights);
  }

  @override
  void didUpdateWidget(AdaptiveCard old) {
    super.didUpdateWidget(old);
    if (old.weights != widget.weights || old.profile != widget.profile) {
      _future = loadAdaptiveResult(context.db, widget.profile, widget.weights);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final current = targetsFor(widget.profile, widget.weights).targetKcal;
    return FutureBuilder<AdaptiveResult>(
      future: _future,
      builder: (context, snap) {
        final r = snap.data;
        return SectionCard(
          title: 'Wochen-Check: Kalorienziel',
          icon: Icons.auto_graph,
          child: r == null
              ? const SizedBox(height: 40, child: Center(child: CircularProgressIndicator()))
              : _body(context, t, r, current),
        );
      },
    );
  }

  Widget _body(BuildContext context, ThemeData t, AdaptiveResult r, int current) {
    final muted = t.textTheme.bodySmall?.copyWith(color: t.colorScheme.onSurfaceVariant);
    if (!r.isReady) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final n in r.notes) Text(n),
          const SizedBox(height: 6),
          Text(
            'Die App vergleicht dann deine tatsächliche Aufnahme mit dem Gewichtsverlauf und berechnet daraus '
            'deinen echten Verbrauch. Bis dahin gilt das Ziel aus der Formel.',
            style: muted,
          ),
        ],
      );
    }
    final suggested = r.suggestedTargetKcal!;
    final change = suggested - current;
    final meaningful = change.abs() >= 50;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: StatValue(
                label: 'Echter Verbrauch',
                value: kcal(r.observedTdee!),
                sub: 'aus ${r.countedDays} Tagen',
              ),
            ),
            Expanded(
              child: StatValue(
                label: 'Vorschlag',
                value: kcal(suggested),
                sub: meaningful
                    ? '${change > 0 ? '+' : '−'}${kcal(change.abs())} zu jetzt'
                    : 'passt zum aktuellen Ziel',
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        for (final n in r.notes)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(n, style: muted),
          ),
        Theme(
          data: t.copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            tilePadding: EdgeInsets.zero,
            title: const Text('Rechenweg anzeigen'),
            children: [
              for (final s in r.steps)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(s.label, style: t.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                            Text(s.formula, style: muted),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(s.value, style: t.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
            ],
          ),
        ),
        if (meaningful)
          Align(
            alignment: Alignment.centerRight,
            child: FilledButton.icon(
              onPressed: () => _apply(context, suggested),
              icon: const Icon(Icons.check),
              label: Text('${kcal(suggested)} übernehmen'),
            ),
          ),
        StreamBuilder<String?>(
          stream: context.db.watchSetting(adaptiveAppliedKey),
          builder: (context, s) => s.data == null
              ? const SizedBox.shrink()
              : Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text('Zuletzt übernommen am ${dateShort(parseDayKey(s.data!))}.', style: muted),
                ),
        ),
      ],
    );
  }

  Future<void> _apply(BuildContext context, int kcalValue) async {
    final db = context.db;
    final ok = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Kalorienziel anpassen?'),
        content: Text(
          'Dein Kalorienziel wird auf ${kcal(kcalValue)} gesetzt (als eigenes Ziel im Profil). '
          'Du kannst es dort jederzeit ändern oder zurücksetzen.',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('Abbrechen')),
          FilledButton(onPressed: () => Navigator.pop(c, true), child: const Text('Übernehmen')),
        ],
      ),
    );
    if (ok != true) return;
    await db.saveProfile(widget.profile.toCompanion(true).copyWith(calorieOverride: Value(kcalValue)));
    await db.setSetting(adaptiveAppliedKey, dayKey(DateTime.now()));
  }
}
