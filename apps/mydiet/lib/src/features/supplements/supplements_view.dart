import 'package:material_ui/material_ui.dart';

import '../../app.dart';
import '../../core/supplements.dart';
import '../../data/database.dart';
import '../../data/targets.dart';
import '../../ui/format.dart';
import '../../ui/widgets.dart';
import '../micros/micros_view.dart';
import 'supplement_form_page.dart';

/// Today's supplement state: products, intakes and both totals.
class SupplementDay {
  SupplementDay(this.products, this.intakes)
    : taken = sumSupplements([
        for (final i in intakes)
          for (final p in products.where((p) => p.supplement.id == i.supplementId))
            SupplementUse(product: p.label, servings: i.servings, doses: p.doses),
      ]),
      planned = sumSupplements([
        for (final p in products.where((p) => p.supplement.active))
          SupplementUse(product: p.label, servings: p.supplement.servingsPerDay, doses: p.doses),
      ]);

  final List<SupplementWithDoses> products;
  final List<SupplementIntake> intakes;
  final List<NutrientTotal> taken;
  final List<NutrientTotal> planned;

  bool isTaken(String supplementId, int minute) =>
      intakes.any((i) => i.supplementId == supplementId && i.plannedMinute == minute);

  /// Planned intakes of active products, by time (no time last).
  List<({SupplementWithDoses p, int minute, double servings})> get schedule {
    final out = [
      for (final p in products.where((p) => p.supplement.active))
        for (final s in p.slots) (p: p, minute: s.minute, servings: s.servings),
    ];
    out.sort((a, b) {
      final ma = a.minute < 0 ? 9999 : a.minute;
      final mb = b.minute < 0 ? 9999 : b.minute;
      return ma != mb ? ma.compareTo(mb) : a.p.supplement.name.compareTo(b.p.supplement.name);
    });
    return out;
  }

  static Stream<SupplementDay> watch(AppDatabase db, String day) =>
      combineLatest([db.watchSupplements(), db.watchIntakes(day)])
          .map((v) => SupplementDay(v[0] as List<SupplementWithDoses>, v[1] as List<SupplementIntake>));
}

/// Supplements tab: today's checklist, daily totals with upper limits, products.
class SupplementsView extends StatelessWidget {
  const SupplementsView({super.key});

  @override
  Widget build(BuildContext context) {
    final db = context.db;
    final t = Theme.of(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'supplement-new',
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SupplementFormPage())),
        icon: const Icon(Icons.add),
        label: const Text('Supplement'),
      ),
      body: StreamBuilder<SupplementDay>(
        stream: SupplementDay.watch(db, todayDayKey()),
        builder: (context, snap) {
          final d = snap.data;
          if (d == null) return const Center(child: CircularProgressIndicator());
          if (d.products.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'Noch keine Supplemente. Lege deine Produkte mit den Werten vom Etikett an. Die App zählt '
                  'alle Inhaltsstoffe zusammen, z. B. Vitamin D aus Multivitamin und D3/K2, und zeigt, wenn die '
                  'Summe die tolerierbare Höchstmenge der EFSA überschreitet.',
                  textAlign: TextAlign.center,
                  style: t.textTheme.bodyLarge,
                ),
              ),
            );
          }
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
            children: [
              SectionCard(
                title: 'Heute einnehmen',
                icon: Icons.checklist,
                child: SupplementChecklist(day: d),
              ),
              const SizedBox(height: 12),
              SectionCard(
                title: 'Tagessumme',
                icon: Icons.functions,
                child: SupplementTotals(day: d),
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                icon: const Icon(Icons.science_outlined),
                label: const Text('Mit Essen zusammen: Vitamine und Mineralstoffe heute'),
                onPressed: () => Navigator.push(context, MaterialPageRoute<void>(builder: (_) => const MicrosPage())),
              ),
              const SizedBox(height: 12),
              SectionCard(
                title: 'Produkte',
                icon: Icons.medication_outlined,
                child: Column(
                  children: [
                    for (final p in d.products)
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(p.label),
                        subtitle: Text(_productLine(p)),
                        trailing: p.supplement.active
                            ? const Icon(Icons.chevron_right)
                            : const Chip(label: Text('pausiert')),
                        onTap: () =>
                            Navigator.push(context, MaterialPageRoute(builder: (_) => SupplementFormPage(existing: p))),
                      ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  'Die App gibt keine Dosierungsempfehlungen. Höchstmengen: EFSA, Erwachsene. '
                  'Lebensmittel sind in den Summen nicht enthalten; bei Werten nahe der Höchstmenge zählt '
                  'die Nahrung für die meisten Stoffe noch dazu. Fragen zur Einnahme bitte mit Arzt oder Apotheke klären.',
                  style: t.textTheme.bodySmall?.copyWith(color: t.colorScheme.onSurfaceVariant),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  static String _productLine(SupplementWithDoses p) {
    final s = p.supplement;
    final days = stockDays(stockServings: s.stockServings, servingsPerDay: s.servingsPerDay);
    return [
      '${n1opt(s.servingsPerDay)} × ${s.servingLabel} täglich',
      if (s.times.isNotEmpty) s.times.map(timeOfDay).join(', '),
      p.doses.length == 1 ? '1 Inhaltsstoff' : '${p.doses.length} Inhaltsstoffe',
      if (days != null) 'Vorrat ${days == 1 ? '1 Tag' : '$days Tage'}',
    ].join(' · ');
  }
}

/// Checkboxes for today's planned intakes.
class SupplementChecklist extends StatelessWidget {
  const SupplementChecklist({super.key, required this.day, this.dense = false});
  final SupplementDay day;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    final db = context.db;
    final schedule = day.schedule;
    if (schedule.isEmpty) return const Text('Heute ist nichts geplant.');
    final today = todayDayKey();
    return Column(
      children: [
        for (final s in schedule)
          CheckboxListTile(
            dense: dense,
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
            value: day.isTaken(s.p.supplement.id, s.minute),
            title: Text(s.p.label),
            subtitle: Text(
              [
                if (s.minute >= 0) timeOfDay(s.minute),
                '${n1opt(s.servings)} × ${s.p.supplement.servingLabel}',
              ].join(' · '),
            ),
            onChanged: (v) async {
              try {
                await db.setIntake(
                  supplementId: s.p.supplement.id,
                  day: today,
                  plannedMinute: s.minute,
                  servings: s.servings,
                  taken: v ?? false,
                );
              } catch (e) {
                if (context.mounted) showMessage(context, errorText(e));
              }
            },
          ),
      ],
    );
  }
}

/// Sum per ingredient: taken today / planned per day, with the share of the upper limit.
class SupplementTotals extends StatelessWidget {
  const SupplementTotals({super.key, required this.day, this.onlyWarnings = false});
  final SupplementDay day;
  final bool onlyWarnings;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final takenById = {for (final n in day.taken) _key(n): n};
    final rows = onlyWarnings
        ? day.planned.where((n) => n.status == LimitStatus.over || n.status == LimitStatus.near).toList()
        : day.planned;
    final over = day.planned.where((n) => n.status == LimitStatus.over).toList();
    if (rows.isEmpty && onlyWarnings) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (over.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: t.colorScheme.errorContainer, borderRadius: BorderRadius.circular(12)),
            child: Text(
              'Über der tolerierbaren Höchstmenge (EFSA): ${over.map((n) => n.name).join(', ')}. '
              'Bitte die Einnahme mit Arzt oder Apotheke besprechen.',
              style: TextStyle(color: t.colorScheme.onErrorContainer),
            ),
          ),
        if (!onlyWarnings)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              children: [
                const Expanded(child: SizedBox()),
                SizedBox(
                  width: 76,
                  child: Text('heute', textAlign: TextAlign.end, style: t.textTheme.labelSmall),
                ),
                SizedBox(
                  width: 76,
                  child: Text('geplant', textAlign: TextAlign.end, style: t.textTheme.labelSmall),
                ),
                SizedBox(
                  width: 48,
                  child: Text('UL', textAlign: TextAlign.end, style: t.textTheme.labelSmall),
                ),
              ],
            ),
          ),
        for (final n in rows) _row(context, n, takenById[_key(n)]),
      ],
    );
  }

  static String _key(NutrientTotal n) => '${n.info?.id ?? n.name.toLowerCase()}|${n.unit}';

  Widget _row(BuildContext context, NutrientTotal n, NutrientTotal? taken) {
    final t = Theme.of(context);
    final color = switch (n.status) {
      LimitStatus.over => t.colorScheme.error,
      LimitStatus.near => t.colorScheme.tertiary,
      _ => t.colorScheme.onSurfaceVariant,
    };
    final ul = n.ulPercent;
    return Tooltip(
      message: [
        for (final e in n.sources.entries) '${e.key}: ${n1opt(e.value)} ${n.unit}',
        if (n.info?.ul != null)
          'Höchstmenge ${n1opt(n.info!.ul!)} ${n.unit}${n.info!.ulNote != null ? ' (${n.info!.ulNote})' : ''}',
        if (n.info?.ulScope == UpperLimitScope.supplementsOnly) 'gilt nur für Nahrungsergänzung',
      ].join('\n'),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Expanded(child: Text(n.name, overflow: TextOverflow.ellipsis)),
            SizedBox(
              width: 76,
              child: Text(
                '${n1opt(taken?.amount ?? 0)} ${n.unit}',
                textAlign: TextAlign.end,
                style: t.textTheme.bodySmall,
              ),
            ),
            SizedBox(
              width: 76,
              child: Text(
                '${n1opt(n.amount)} ${n.unit}',
                textAlign: TextAlign.end,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            SizedBox(
              width: 48,
              child: Text(
                ul == null ? '–' : '${n0(ul)} %',
                textAlign: TextAlign.end,
                style: TextStyle(color: color, fontWeight: n.status == LimitStatus.over ? FontWeight.w700 : null),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
