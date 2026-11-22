part of '../dashboard_page.dart';

class _CaloriesTile extends StatelessWidget {
  const _CaloriesTile(this.d);
  final DashData d;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final b = d.budget;
    final remaining = b.remainingKcal;
    return SectionCard(
      title: 'Kalorien heute',
      icon: Icons.local_fire_department_outlined,
      onTap: () => HomeShellState.of(context)?.go(1),
      child: LayoutBuilder(
        builder: (context, c) {
          final ringSize = c.maxWidth < 330 ? 118.0 : 140.0;
          final ring = RingGauge(
            progress: b.progress,
            size: ringSize,
            color: t.colorScheme.primary,
            stroke: 13,
            semanticLabel: d.hideNumbers
                ? 'Kalorien heute: ${gentleStatus(b.progress)}'
                : 'Kalorien heute: ${n0(remaining.abs())} ${remaining < 0 ? 'kcal zu viel' : 'kcal übrig'}',
            child: d.hideNumbers
                ? Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(gentleStatus(b.progress), textAlign: TextAlign.center, style: t.textTheme.bodyMedium),
                  )
                : Padding(
                    padding: const EdgeInsets.all(16),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            n0(remaining.abs()),
                            style: t.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: remaining < 0 ? t.colorScheme.error : null,
                            ),
                          ),
                          Text(remaining < 0 ? 'kcal zu viel' : 'kcal übrig', style: t.textTheme.bodySmall),
                        ],
                      ),
                    ),
                  ),
          );
          final w = d.week;
          final stats = d.hideNumbers
              ? Text(
                  w == null
                      ? 'Zahlen sind ausgeblendet. Du kannst sie in den Einstellungen wieder einblenden.'
                      : 'Wochenbudget aktiv. Zahlen sind ausgeblendet.',
                  style: t.textTheme.bodySmall?.copyWith(color: t.colorScheme.onSurfaceVariant),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    StatValue(label: 'Gegessen', value: kcal(b.consumed.kcal)),
                    const SizedBox(height: 10),
                    StatValue(
                      label: w == null ? 'Tagesbudget' : 'Heute aus Wochenbudget',
                      value: kcal(b.budgetKcal),
                      sub: [
                        if (w != null && w.shiftKcal != 0)
                          '${w.shiftKcal > 0 ? '+' : '−'}${kcal(w.shiftKcal.abs())} ausgleichend',
                        if (w != null) 'noch ${w.daysLeft} Tag(e) in der Woche',
                        if (b.activityCreditKcal > 0) 'inkl. ${kcal(b.activityCreditKcal)} Aktivität',
                        if (w == null && b.activityCreditKcal <= 0)
                          d.targets.isCalorieOverridden ? 'eigenes Ziel' : 'berechnet',
                      ].join(' · '),
                    ),
                  ],
                );
          return Row(
            children: [
              ring,
              const SizedBox(width: 20),
              Expanded(child: stats),
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
    return SectionCard(
      title: 'Makronährstoffe',
      icon: Icons.pie_chart_outline,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: MacroBar(
                  label: 'Protein',
                  value: c.protein,
                  target: tg.proteinG.toDouble(),
                  color: MacroColors.protein(context),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: MacroBar(
                  label: 'Kohlenhydr.',
                  value: c.carbs,
                  target: tg.carbsG.toDouble(),
                  color: MacroColors.carbs(context),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: MacroBar(
                  label: 'Fett',
                  value: c.fat,
                  target: tg.fatG.toDouble(),
                  color: MacroColors.fat(context),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: MacroBar(
                  label: 'Ballaststoffe',
                  value: c.fiber,
                  target: tg.fiberG.toDouble(),
                  color: MacroColors.fiber(context),
                ),
              ),
            ],
          ),
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
