part of '../dashboard_page.dart';

class _WaterTile extends StatelessWidget {
  const _WaterTile(this.d);
  final DashData d;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final db = context.db;
    final target = d.targets.waterMl;
    final day = todayDayKey();
    return SectionCard(
      title: 'Wasser',
      icon: Icons.water_drop_outlined,
      trailing: d.waterMl > 0
          ? IconButton(
              tooltip: 'Letzten Eintrag zurücknehmen',
              visualDensity: VisualDensity.compact,
              icon: const Icon(Icons.undo, size: 18),
              onPressed: () => db.undoLastWater(day),
            )
          : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: n1(d.waterMl / 1000),
                  style: t.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: MacroColors.water(context),
                  ),
                ),
                TextSpan(text: ' / ${n1(target / 1000)} l', style: t.textTheme.bodyMedium),
              ],
            ),
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: (d.waterMl / math.max(1, target)).clamp(0.0, 1.0),
              minHeight: 8,
              color: MacroColors.water(context),
              backgroundColor: t.colorScheme.surfaceContainerHighest,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              for (final ml in const [250, 500])
                ActionChip(
                  avatar: const Icon(Icons.add, size: 16),
                  label: Text('$ml ml'),
                  onPressed: () => db.addWater(day, ml),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActivityTile extends StatelessWidget {
  const _ActivityTile(this.d);
  final DashData d;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final minutes = d.activities.fold<int>(0, (a, b) => a + b.minutes);
    final steps = d.activities.fold<int>(0, (a, b) => a + (b.steps ?? 0));
    final pct = d.profile.activityCreditPercent;
    return SectionCard(
      title: 'Aktivität',
      icon: Icons.directions_run,
      trailing: IconButton(
        tooltip: 'Aktivität eintragen',
        visualDensity: VisualDensity.compact,
        icon: const Icon(Icons.add_circle_outline, size: 20),
        onPressed: () => showActivitySheet(context),
      ),
      onTap: () => showActivitySheet(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: StatValue(label: 'Dauer', value: '$minutes min'),
              ),
              Expanded(
                child: StatValue(label: 'Verbrannt', value: kcal(d.budget.activityKcal)),
              ),
            ],
          ),
          if (steps > 0) ...[const SizedBox(height: 8), StatValue(label: 'Schritte', value: n0(steps))],
          const SizedBox(height: 8),
          Text(
            pct == 0
                ? 'Wird nicht zum Budget addiert: dein Sport steckt schon im Aktivitätsfaktor.'
                : '$pct % davon werden zum Budget addiert.',
            style: t.textTheme.bodySmall?.copyWith(color: t.colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

class _SupplementsTile extends StatelessWidget {
  const _SupplementsTile();

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'Supplemente heute',
      icon: Icons.medication_outlined,
      child: StreamBuilder<SupplementDay>(
        stream: SupplementDay.watch(context.db, todayDayKey()),
        builder: (context, snap) {
          final d = snap.data;
          if (d == null) return const SizedBox(height: 40);
          if (d.products.isEmpty) return const Text('Noch keine Supplemente angelegt (Essen → Supplemente).');
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SupplementTotals(day: d, onlyWarnings: true),
              SupplementChecklist(day: d, dense: true),
            ],
          );
        },
      ),
    );
  }
}

class _MealsTile extends StatelessWidget {
  const _MealsTile(this.d);
  final DashData d;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return SectionCard(
      title: 'Mahlzeiten heute',
      icon: Icons.restaurant_outlined,
      onTap: () => HomeShellState.of(context)?.go(1),
      child: Column(
        children: [
          for (final s in d.slots)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Row(
                children: [
                  Expanded(child: Text(s.name)),
                  Text(
                    kcal(Nutrients.sum(d.diary.where((e) => e.mealSlotId == s.id).map((e) => e.nutrients)).kcal),
                    style: t.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _HintsTile extends StatelessWidget {
  const _HintsTile(this.d);
  final DashData d;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final p = d.profile;
    final hints = dailyHints(
      now: DateTime.now(),
      consumed: d.consumed,
      budgetKcal: d.budget.budgetKcal,
      proteinTarget: d.targets.proteinG.toDouble(),
      fiberTarget: d.targets.fiberG.toDouble(),
      waterMl: d.waterMl,
      waterTarget: d.targets.waterMl,
      entryCount: d.diary.length,
      dietStyle: p.dietStyle,
      avoid: [...p.allergies, ...p.dislikedFoods],
    );
    return SectionCard(
      title: 'Tageshinweise',
      icon: Icons.tips_and_updates_outlined,
      trailing: Tooltip(
        message: 'Feste Regeln auf Basis deiner Ziele, keine KI und keine medizinische Beratung.',
        child: Text('regelbasiert', style: t.textTheme.labelSmall?.copyWith(color: t.colorScheme.outline)),
      ),
      child: hints.isEmpty
          ? Text('Keine Hinweise, alles im Rahmen.', style: t.textTheme.bodyMedium)
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final h in hints)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          switch (h.level) {
                            HintLevel.good => Icons.check_circle_outline,
                            HintLevel.info => Icons.info_outline,
                            HintLevel.warn => Icons.warning_amber_rounded,
                          },
                          size: 18,
                          color: switch (h.level) {
                            HintLevel.good => t.colorScheme.primary,
                            HintLevel.info => t.colorScheme.secondary,
                            HintLevel.warn => t.colorScheme.error,
                          },
                        ),
                        const SizedBox(width: 8),
                        Expanded(child: Text(h.text, style: t.textTheme.bodyMedium)),
                      ],
                    ),
                  ),
              ],
            ),
    );
  }
}
