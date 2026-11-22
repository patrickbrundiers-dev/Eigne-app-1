import 'package:material_ui/material_ui.dart';

import '../../app.dart';
import '../../data/database.dart';
import '../../data/targets.dart' show todayDayKey;
import '../../core/micronutrients.dart';
import '../../core/supplements.dart';
import '../../ui/format.dart';
import '../../ui/widgets.dart';

String microAmount(double v, String unit) {
  return '${v >= 10 ? n0(v) : n1opt(v)} $unit';
}

/// One line: name, total vs. target, bar, where it comes from, status.
class MicroRowTile extends StatelessWidget {
  const MicroRowTile({super.key, required this.row});
  final MicroRow row;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final r = row;
    final u = r.info.unit;
    final (color, icon, label) = switch (r.status) {
      MicroStatus.overLimit => (t.colorScheme.error, Icons.error_outline, 'über der Höchstmenge'),
      MicroStatus.nearLimit => (t.colorScheme.tertiary, Icons.warning_amber_outlined, 'nahe der Höchstmenge'),
      MicroStatus.ok => (
        t.colorScheme.primary,
        Icons.check_circle_outline,
        r.target == null ? 'unter der Höchstmenge' : 'Ziel erreicht',
      ),
      MicroStatus.below => (t.colorScheme.outline, Icons.radio_button_unchecked, 'unter dem Ziel'),
      MicroStatus.unknown => (t.colorScheme.outline, Icons.remove, ''),
    };
    final pct = r.targetPercent;
    final parts = <String>[
      if (r.food > 0) 'Essen ${microAmount(r.food, u)}',
      if (r.supplements > 0) 'Supplemente ${microAmount(r.supplements, u)}',
    ];
    final ul = r.info.ul;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Semantics(
        label: '${r.info.name}: ${microAmount(r.total, u)}, $label',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(icon, size: 18, color: color),
                const SizedBox(width: 8),
                Expanded(child: Text(r.info.name, style: t.textTheme.bodyLarge)),
                Text(
                  r.target == null
                      ? microAmount(r.total, u)
                      : '${microAmount(r.total, u)} / ${microAmount(r.target!, u)}',
                  style: t.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
              ],
            ),
            if (pct != null)
              Padding(
                padding: const EdgeInsets.only(top: 4, left: 26),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: (pct / 100).clamp(0, 1).toDouble(),
                    minHeight: 6,
                    color: r.status == MicroStatus.overLimit ? t.colorScheme.error : null,
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.only(top: 2, left: 26),
              child: Text(
                [
                  if (parts.isNotEmpty) parts.join(' · ') else 'noch nichts',
                  if (pct != null) '${n0(pct)} % vom Ziel',
                  if (ul != null && (r.status == MicroStatus.overLimit || r.status == MicroStatus.nearLimit))
                    'Höchstmenge ${microAmount(ul, u)}'
                        '${r.info.ulScope == UpperLimitScope.supplementsOnly ? ' (nur Supplemente)' : ''}',
                ].join(' · '),
                style: t.textTheme.bodySmall?.copyWith(
                  color: r.status == MicroStatus.overLimit ? t.colorScheme.error : t.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String coverageText(MicroDay d) {
  if (d.entries == 0) return 'Noch keine Einträge im Tagebuch.';
  if (d.entriesWithData == d.entries) {
    return d.entries == 1
        ? 'Werte für den Eintrag von heute vorhanden.'
        : 'Werte für alle ${d.entries} Einträge vorhanden.';
  }
  return 'Werte für ${d.entriesWithData} von ${d.entries} Einträgen. Ohne Werte zählt ein Eintrag hier nicht mit, '
      'die Summen sind dann zu niedrig.';
}

/// Full list for a day (Essen → Supplemente → Mikronährstoffe and the dashboard tile).
class MicrosPage extends StatelessWidget {
  const MicrosPage({super.key, this.day});
  final String? day;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final d = day ?? todayDayKey();
    return Scaffold(
      appBar: AppBar(title: const Text('Vitamine und Mineralstoffe')),
      body: StreamBuilder<MicroDay>(
        stream: context.db.watchMicroDay(d),
        builder: (context, snap) {
          final m = snap.data;
          if (m == null) return const Center(child: CircularProgressIndicator());
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                children: [
                  SectionCard(
                    title: d == todayDayKey() ? 'Heute' : d,
                    icon: Icons.science_outlined,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(coverageText(m), style: t.textTheme.bodySmall),
                        const SizedBox(height: 4),
                        for (final r in m.rows) MicroRowTile(row: r),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Ziele: D-A-CH-Referenzwerte für Erwachsene (DGE, gerundet). Höchstmengen: EFSA. '
                    'Supplemente zählen, sobald sie abgehakt sind. Lebensmittelwerte sind Richtwerte und '
                    'schwanken je nach Produkt. Die App gibt keine Dosierungsempfehlungen; bei Fragen zu '
                    'Mangel oder Überdosierung bitte ärztlich abklären.',
                    style: t.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Dashboard tile: everything over a limit plus the lowest few.
class MicrosTile extends StatelessWidget {
  const MicrosTile({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return SectionCard(
      title: 'Vitamine und Mineralstoffe',
      icon: Icons.science_outlined,
      onTap: () => Navigator.push(context, MaterialPageRoute<void>(builder: (_) => const MicrosPage())),
      child: StreamBuilder<MicroDay>(
        stream: context.db.watchMicroDay(todayDayKey()),
        builder: (context, snap) {
          final m = snap.data;
          if (m == null) return const SizedBox(height: 40);
          final warn = m.rows
              .where((r) => r.status == MicroStatus.overLimit || r.status == MicroStatus.nearLimit)
              .toList();
          final low = m.rows.where((r) => r.status == MicroStatus.below).toList()
            ..sort((a, b) => (a.targetPercent ?? 0).compareTo(b.targetPercent ?? 0));
          final shown = [...warn, ...low.take(3 - warn.length.clamp(0, 3))];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (shown.isEmpty)
                Text(
                  m.entries == 0 ? 'Noch keine Einträge heute.' : 'Alle Ziele erreicht, nichts über der Höchstmenge.',
                )
              else
                for (final r in shown) MicroRowTile(row: r),
              Text('Tippen für alle Werte', style: t.textTheme.bodySmall),
            ],
          );
        },
      ),
    );
  }
}
