import 'package:material_ui/material_ui.dart';

import '../../app.dart';
import '../../core/weekly_report.dart';
import '../../data/display_prefs.dart';
import '../../data/weekly_report_data.dart';
import '../../ui/format.dart';
import '../../ui/widgets.dart';

/// Weekly report: findings with the figures behind them and up to three suggestions.
class WeeklyReportPage extends StatefulWidget {
  const WeeklyReportPage({super.key, this.monday});
  final DateTime? monday;

  @override
  State<WeeklyReportPage> createState() => _WeeklyReportPageState();
}

class _WeeklyReportPageState extends State<WeeklyReportPage> {
  late DateTime _monday = widget.monday ?? defaultReportMonday(DateTime.now());
  Future<WeeklyReport?>? _report;
  bool _hide = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _load();
  }

  void _load() {
    final db = context.db;
    _report = loadWeeklyReport(db, _monday);
    db.watchSetting(hideNumbersKey).first.then((v) {
      if (mounted) setState(() => _hide = v == 'true');
    });
  }

  void _shift(int weeks) => setState(() {
    _monday = DateTime(_monday.year, _monday.month, _monday.day + 7 * weeks);
    _load();
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final sunday = DateTime(_monday.year, _monday.month, _monday.day + 6);
    final isFuture = _monday.isAfter(DateTime.now());
    return Scaffold(
      appBar: AppBar(title: const Text('Wochenbericht')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
            children: [
              Row(
                children: [
                  IconButton(
                    tooltip: 'Vorige Woche',
                    icon: const Icon(Icons.chevron_left),
                    onPressed: () => _shift(-1),
                  ),
                  Expanded(
                    child: Text(
                      '${dateTiny(_monday)} – ${dateTiny(sunday)}',
                      textAlign: TextAlign.center,
                      style: t.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Nächste Woche',
                    icon: const Icon(Icons.chevron_right),
                    onPressed: DateTime(sunday.year, sunday.month, sunday.day + 1).isAfter(DateTime.now())
                        ? null
                        : () => _shift(1),
                  ),
                ],
              ),
              if (isFuture)
                const Text('Diese Woche hat noch nicht begonnen.')
              else
                FutureBuilder<WeeklyReport?>(
                  future: _report,
                  builder: (context, snap) {
                    if (snap.connectionState != ConnectionState.done) {
                      return const Padding(
                        padding: EdgeInsets.all(32),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    final r = snap.data;
                    if (r == null) return const Text('Bitte zuerst das Profil ausfüllen.');
                    return _ReportBody(report: r, hideNumbers: _hide);
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReportBody extends StatelessWidget {
  const _ReportBody({required this.report, required this.hideNumbers});
  final WeeklyReport report;
  final bool hideNumbers;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final r = report;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (!hideNumbers && r.loggedDays > 0)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _Stat('Ø Kalorien', kcal(r.averageKcal!), 'Ziel ${kcal(r.targetKcal)}'),
                _Stat('Ø Protein', grams(r.averageProtein!), 'Ziel ${grams(r.proteinTargetG)}'),
                _Stat('Im Zielbereich', '${r.daysNearTarget} / ${r.loggedDays}', 'Tage ±10 %'),
                if (r.weightChangeKg != null)
                  _Stat(
                    'Gewicht',
                    '${r.weightChangeKg! >= 0 ? '+' : '−'}${n1opt(r.weightChangeKg!.abs())} kg',
                    '7-Tage-Mittel',
                  ),
              ],
            ),
          ),
        SectionCard(
          title: 'Was die Woche zeigt',
          icon: Icons.insights_outlined,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final f in r.findings)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(
                    switch (f.kind) {
                      FindingKind.good => Icons.check_circle_outline,
                      FindingKind.watch => Icons.visibility_outlined,
                      FindingKind.info => Icons.info_outline,
                    },
                    color: switch (f.kind) {
                      FindingKind.good => t.colorScheme.primary,
                      FindingKind.watch => t.colorScheme.tertiary,
                      FindingKind.info => t.colorScheme.outline,
                    },
                  ),
                  title: Text(f.title),
                  subtitle: hideNumbers ? null : Text(f.detail),
                ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SectionCard(
          title: 'Vorschläge für nächste Woche',
          icon: Icons.lightbulb_outline,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final (i, s) in r.suggestions.indexed)
                Padding(padding: const EdgeInsets.symmetric(vertical: 4), child: Text('${i + 1}. $s')),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Regelbasiert aus deinen Einträgen, ohne KI und ohne Daten zu senden. Tage unter 800 kcal zählen als '
          'nicht vollständig eingetragen. Keine medizinische Beratung.',
          style: t.textTheme.bodySmall,
        ),
      ],
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat(this.label, this.value, this.sub);
  final String label, value, sub;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return Container(
      width: 160,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: t.colorScheme.surfaceContainerHighest, borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: t.textTheme.labelMedium),
          Text(value, style: t.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
          Text(sub, style: t.textTheme.bodySmall),
        ],
      ),
    );
  }
}

/// Dashboard tile: the last finished week in two lines.
class WeeklyReportTile extends StatefulWidget {
  const WeeklyReportTile({super.key});

  @override
  State<WeeklyReportTile> createState() => _WeeklyReportTileState();
}

class _WeeklyReportTileState extends State<WeeklyReportTile> {
  Future<WeeklyReport?>? _report;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Once per app start is enough: the report covers a finished week.
    _report ??= loadWeeklyReport(context.db, defaultReportMonday(DateTime.now()));
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return SectionCard(
      title: 'Wochenbericht',
      icon: Icons.insights_outlined,
      onTap: () => Navigator.push(context, MaterialPageRoute<void>(builder: (_) => const WeeklyReportPage())),
      child: FutureBuilder<WeeklyReport?>(
        future: _report,
        builder: (context, snap) {
          final r = snap.data;
          if (r == null) return const SizedBox(height: 40);
          final watch = r.findings.where((f) => f.kind == FindingKind.watch).take(2).toList();
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (watch.isEmpty)
                Text(r.loggedDays == 0 ? 'Letzte Woche ist kaum etwas eingetragen.' : 'Letzte Woche lief rund.')
              else
                for (final f in watch) Text('• ${f.title}'),
              const SizedBox(height: 4),
              Text('Tippen für Auswertung und Vorschläge', style: t.textTheme.bodySmall),
            ],
          );
        },
      ),
    );
  }
}
