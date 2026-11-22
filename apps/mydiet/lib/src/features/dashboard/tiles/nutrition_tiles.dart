part of '../dashboard_page.dart';

class _CaloriesTile extends StatelessWidget {
  const _CaloriesTile(this.d);
  final DashData d;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final tk = context.tokens;
    final b = d.budget;
    final remaining = b.remainingKcal;
    final proteinTarget = d.targets.proteinG;
    final pP = proteinTarget <= 0 ? 0.0 : d.consumed.protein / proteinTarget;
    final pW = d.targets.waterMl <= 0 ? 0.0 : d.waterMl / d.targets.waterMl;
    String pct(double v) => '${(v * 100).round()} %';
    final moved = d.activities.fold<int>(0, (a, e) => a + e.kcal.round());
    final w = d.week;
    final sub = [
      if (w != null && w.shiftKcal != 0) '${w.shiftKcal > 0 ? '+' : '−'}${kcal(w.shiftKcal.abs())} ausgleichend',
      if (w != null) 'noch ${w.daysLeft} Tag(e) in der Woche',
      if (b.activityCreditKcal > 0) 'inkl. ${kcal(b.activityCreditKcal)} Aktivität',
      if (w == null && b.activityCreditKcal <= 0) d.targets.isCalorieOverridden ? 'eigenes Ziel' : 'berechnet',
    ].join(' · ');
    return SectionCard(
      title: 'Kalorien heute',
      icon: Icons.local_fire_department_outlined,
      onTap: () => HomeShellState.of(context)?.go(1),
      child: LayoutBuilder(
        builder: (context, c) {
          final ringSize = c.maxWidth < 330 ? 116.0 : 140.0;
          final rings = ConcentricRings(
            size: ringSize,
            stroke: ringSize < 130 ? 11 : 13,
            rings: [RingValue(b.progress, tk.primary), RingValue(pP, tk.protein), RingValue(pW, tk.water)],
            semanticLabel: d.hideNumbers
                ? 'Kalorien heute: ${gentleStatus(b.progress)}'
                : 'Kalorien heute: ${n0(remaining.abs())} ${remaining < 0 ? 'kcal zu viel' : 'kcal übrig'}, '
                      'Protein ${pct(pP)}, Wasser ${pct(pW)}',
          );
          final legend = [
            LegendRow(color: tk.primary, label: 'Kalorien', value: pct(b.progress)),
            const SizedBox(height: 2),
            LegendRow(color: tk.protein, label: 'Protein', value: pct(pP)),
            const SizedBox(height: 2),
            LegendRow(color: tk.water, label: 'Wasser', value: pct(pW)),
          ];
          if (d.hideNumbers) {
            return Row(
              children: [
                rings,
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(gentleStatus(b.progress), style: t.textTheme.titleMedium),
                      const SizedBox(height: 8),
                      Text(
                        w == null
                            ? 'Zahlen sind ausgeblendet. Du kannst sie in den Einstellungen wieder einblenden.'
                            : 'Wochenbudget aktiv. Zahlen sind ausgeblendet.',
                        style: t.textTheme.bodySmall?.copyWith(color: t.colorScheme.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  rings,
                  const SizedBox(width: 18),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            n0(remaining.abs()),
                            style: numberStyle(56, color: remaining < 0 ? tk.danger : tk.ink),
                          ),
                        ),
                        Text(
                          remaining < 0 ? 'kcal zu viel' : 'kcal übrig',
                          style: t.textTheme.labelLarge?.copyWith(color: tk.muted, letterSpacing: 0.6),
                        ),
                        const SizedBox(height: 10),
                        ...legend,
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              StatStrip(
                items: [
                  ('Gegessen', kcal(b.consumed.kcal), tk.carbs),
                  (w == null ? 'Tagesbudget' : 'Heute aus Wochenbudget', kcal(b.budgetKcal), tk.muted),
                  ('Bewegt', kcal(moved), tk.fat),
                ],
              ),
              if (sub.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(sub, style: t.textTheme.bodySmall?.copyWith(color: tk.muted)),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _MacrosTile extends StatelessWidget {
  const _MacrosTile(this.d);
  final DashData d;

  @override
  Widget build(BuildContext context) {
    final c = d.consumed;
    final tg = d.targets;
    final rows = [
      ('Protein', c.protein, tg.proteinG, MacroColors.protein(context)),
      ('Kohlenhydrate', c.carbs, tg.carbsG, MacroColors.carbs(context)),
      ('Fett', c.fat, tg.fatG, MacroColors.fat(context)),
      ('Ballaststoffe', c.fiber, tg.fiberG, MacroColors.fiber(context)),
    ];
    return SectionCard(
      title: 'Makronährstoffe',
      icon: Icons.pie_chart_outline,
      child: Column(
        children: [
          for (final (i, (label, value, target, color)) in rows.indexed) ...[
            if (i > 0) const SizedBox(height: 12),
            MacroBar(label: label, value: value, target: target.toDouble(), color: color, showPercent: true),
          ],
        ],
      ),
    );
  }
}

class _ProteinTile extends StatelessWidget {
  const _ProteinTile(this.d);
  final DashData d;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final target = d.targets.proteinG;
    final v = d.consumed.protein;
    return SectionCard(
      title: 'Protein',
      icon: Icons.fitness_center,
      child: Row(
        children: [
          RingGauge(
            progress: target == 0 ? 0 : v / target,
            size: 84,
            stroke: 9,
            color: MacroColors.protein(context),
            semanticLabel: 'Protein: ${n0(v)} von $target g',
            child: Text(
              '${(target == 0 ? 0 : v / target * 100).round()} %',
              style: t.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: StatValue(
              label: 'Aufgenommen',
              value: grams(v),
              sub: v >= target ? 'Tagesziel erreicht' : 'noch ${grams(target - v)} bis $target g',
            ),
          ),
        ],
      ),
    );
  }
}
