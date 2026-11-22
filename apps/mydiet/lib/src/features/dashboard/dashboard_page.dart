import 'dart:math' as math;

import 'package:material_ui/material_ui.dart';

import '../../app.dart';
import '../../core/daily_hints.dart';
import '../../core/dates.dart';
import '../../core/dashboard_layout.dart';
import '../../core/day_budget.dart';
import '../../core/energy.dart';
import '../../core/nutrition.dart';
import '../../core/weight_trend.dart';
import '../../data/database.dart';
import '../../data/targets.dart';
import '../../ui/format.dart';
import '../../ui/widgets.dart';
import '../home_shell.dart';
import '../weight/weight_chart.dart';
import '../weight/weight_entry_sheet.dart';
import 'activity_sheet.dart';

/// Everything the dashboard shows, recomputed whenever any source changes.
class DashData {
  DashData({
    required this.profile,
    required this.weights,
    required this.diary,
    required this.waterMl,
    required this.activities,
    required this.slots,
    required this.layout,
  }) : targets = targetsFor(profile, weights),
       analysis = analyzeWeight(weightPoints(weights), targetKg: profile.targetWeightKg),
       consumed = Nutrients.sum(diary.map((e) => e.nutrients)) {
    budget = dayBudget(
      targetKcal: targets.targetKcal,
      consumed: consumed,
      activities: [
        for (final a in activities) ActivityItem(kcal: a.kcal, source: a.source, externalId: a.externalId, id: a.id),
      ],
      creditPercent: profile.activityCreditPercent,
    );
  }

  final Profile profile;
  final List<WeightEntry> weights;
  final List<DiaryEntry> diary;
  final int waterMl;
  final List<ActivityEntry> activities;
  final List<MealSlot> slots;
  final List<TileConfig> layout;
  final EnergyResult targets;
  final WeightAnalysis analysis;
  final Nutrients consumed;
  late final DayBudget budget;

  double get currentKg => currentWeight(profile, analysis);
}

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final db = context.db;
    final day = todayDayKey();
    final stream =
        combineLatest([
              db.watchProfile(),
              db.watchWeights(),
              db.watchDiary(day),
              db.watchWaterMl(day),
              db.watchActivities(day),
              db.watchMealSlots(),
              db.watchSetting('dashboardLayout'),
            ])
            .where((v) => v[0] != null)
            .map(
              (v) => DashData(
                profile: v[0] as Profile,
                weights: v[1] as List<WeightEntry>,
                diary: v[2] as List<DiaryEntry>,
                waterMl: v[3] as int,
                activities: v[4] as List<ActivityEntry>,
                slots: v[5] as List<MealSlot>,
                layout: parseLayout(v[6] as String?),
              ),
            );

    return Scaffold(
      body: SafeArea(
        child: StreamBuilder<DashData>(
          stream: stream,
          builder: (context, snap) {
            if (snap.hasError) return Center(child: Text('Fehler: ${snap.error}'));
            final d = snap.data;
            if (d == null) return const Center(child: CircularProgressIndicator());
            return _DashboardBody(d);
          },
        ),
      ),
    );
  }
}

class _DashboardBody extends StatelessWidget {
  const _DashboardBody(this.d);
  final DashData d;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final now = DateTime.now();
    final greeting = now.hour < 11 ? 'Guten Morgen' : (now.hour < 18 ? 'Hallo' : 'Guten Abend');
    final name = d.profile.displayName;
    return LayoutBuilder(
      builder: (context, c) {
        final width = math.min(c.maxWidth, 1280.0);
        final cols = width >= 1100 ? 4 : (width >= 640 ? 3 : 2);
        const gap = 12.0;
        const pad = 16.0;
        final colW = (width - pad * 2 - gap * (cols - 1)) / cols;
        final tiles = d.layout.where((l) => l.visible).map((l) => l.tile).toList();
        return PageBody(
          child: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(pad, 12, 8, 8),
                sliver: SliverToBoxAdapter(
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              dateLong(now),
                              style: t.textTheme.labelLarge?.copyWith(color: t.colorScheme.onSurfaceVariant),
                            ),
                            Text(
                              name == null ? greeting : '$greeting, $name',
                              style: t.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        tooltip: 'Dashboard anpassen',
                        icon: const Icon(Icons.tune),
                        onPressed: () => showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          showDragHandle: true,
                          builder: (_) => DashboardCustomizeSheet(layout: d.layout),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(pad, 4, pad, 24),
                sliver: SliverToBoxAdapter(
                  child: tiles.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.all(32),
                          child: Text(
                            'Alle Kacheln sind ausgeblendet. Tippe oben auf „Anpassen“.',
                            textAlign: TextAlign.center,
                            style: t.textTheme.bodyLarge,
                          ),
                        )
                      : Wrap(
                          spacing: gap,
                          runSpacing: gap,
                          children: [
                            for (final tile in tiles)
                              SizedBox(
                                width: tile.wide && cols > 1 ? colW * 2 + gap : colW,
                                child: _tile(context, tile),
                              ),
                          ],
                        ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _tile(BuildContext context, DashTile tile) => switch (tile) {
    DashTile.calories => _CaloriesTile(d),
    DashTile.macros => _MacrosTile(d),
    DashTile.protein => _ProteinTile(d),
    DashTile.water => _WaterTile(d),
    DashTile.weight => _WeightTile(d),
    DashTile.goal => _GoalTile(d),
    DashTile.weightChart => _WeightChartTile(d),
    DashTile.activity => _ActivityTile(d),
    DashTile.meals => _MealsTile(d),
    DashTile.hints => _HintsTile(d),
  };
}

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
          );
          final stats = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StatValue(label: 'Gegessen', value: kcal(b.consumed.kcal)),
              const SizedBox(height: 10),
              StatValue(
                label: 'Tagesbudget',
                value: kcal(b.budgetKcal),
                sub: b.activityCreditKcal > 0
                    ? 'inkl. ${kcal(b.activityCreditKcal)} Aktivität'
                    : (d.targets.isCalorieOverridden ? 'eigenes Ziel' : 'berechnet'),
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

class _WeightTile extends StatelessWidget {
  const _WeightTile(this.d);
  final DashData d;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final cur = d.currentKg;
    final target = d.profile.targetWeightKg;
    final remaining = cur - target;
    final b = bmi(cur, d.profile.heightCm);
    final today = d.analysis.latest != null && dayKey(d.analysis.latest!.date) == todayDayKey();
    return SectionCard(
      title: 'Gewicht',
      icon: Icons.monitor_weight_outlined,
      onTap: () => HomeShellState.of(context)?.go(2),
      trailing: IconButton(
        tooltip: 'Gewicht eintragen',
        visualDensity: VisualDensity.compact,
        icon: Icon(today ? Icons.edit_outlined : Icons.add_circle_outline, size: 20),
        onPressed: () => showWeightEntrySheet(context),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: StatValue(label: 'Aktuell', value: kg(cur)),
              ),
              Expanded(
                child: StatValue(label: 'Ziel', value: kg(target)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: StatValue(
                  label: remaining > 0 ? 'Noch' : 'Bis Ziel',
                  value: remaining.abs() < 0.1 ? 'Erreicht' : kg(remaining.abs()),
                  valueColor: t.colorScheme.primary,
                ),
              ),
              Expanded(
                child: StatValue(label: 'BMI', value: n1(b), sub: bmiCategory(b)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _GoalTile extends StatelessWidget {
  const _GoalTile(this.d);
  final DashData d;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final p = d.profile;
    final progress = goalProgress(startKg: p.startWeightKg, currentKg: d.currentKg, targetKg: p.targetWeightKg);
    final rate = d.analysis.weeklyRateKg;
    final forecast = d.analysis.forecastDate ?? d.targets.projectedGoalDate;
    final fromTrend = d.analysis.forecastDate != null;
    return SectionCard(
      title: 'Zielfortschritt',
      icon: Icons.flag_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            '${(progress * 100).round()} %',
            style: t.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800, color: t.colorScheme.primary),
          ),
          Text('von ${kg(p.startWeightKg)} auf ${kg(p.targetWeightKg)}', style: t.textTheme.bodySmall),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 12,
              backgroundColor: t.colorScheme.surfaceContainerHighest,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            rate == null
                ? 'Tempo: erst nach ca. 2 Wochen Messungen verlässlich'
                : 'Tempo: ${rate <= 0 ? '−' : '+'}${n1(rate.abs())} kg pro Woche (Trend)',
            style: t.textTheme.bodySmall,
          ),
          if (forecast != null)
            Text(
              'Prognose: ${dateShort(forecast)}${fromTrend ? '' : ' (nach Plan)'}',
              style: t.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
            ),
          if (d.analysis.isPlateau)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                'Seit über zwei Wochen kaum Veränderung (Plateau).',
                style: t.textTheme.bodySmall?.copyWith(color: t.colorScheme.tertiary, fontWeight: FontWeight.w600),
              ),
            ),
        ],
      ),
    );
  }
}

class _WeightChartTile extends StatelessWidget {
  const _WeightChartTile(this.d);
  final DashData d;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'Gewichtskurve · 30 Tage',
      icon: Icons.show_chart,
      onTap: () => HomeShellState.of(context)?.go(2),
      child: SizedBox(
        height: 190,
        child: WeightChart(entries: d.weights, targetKg: d.profile.targetWeightKg, days: 30, compact: true),
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

/// Reorder, hide and add dashboard tiles.
class DashboardCustomizeSheet extends StatefulWidget {
  const DashboardCustomizeSheet({super.key, required this.layout});
  final List<TileConfig> layout;

  @override
  State<DashboardCustomizeSheet> createState() => _DashboardCustomizeSheetState();
}

class _DashboardCustomizeSheetState extends State<DashboardCustomizeSheet> {
  late List<TileConfig> _items = [...widget.layout];

  Future<void> _save() => context.db.setSetting('dashboardLayout', encodeLayout(_items));

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return SafeArea(
      child: SizedBox(
        height: MediaQuery.sizeOf(context).height * 0.75,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 12, 8),
              child: Row(
                children: [
                  Expanded(child: Text('Dashboard anpassen', style: t.textTheme.titleLarge)),
                  TextButton(
                    onPressed: () {
                      setState(() => _items = defaultLayout());
                      _save();
                    },
                    child: const Text('Standard'),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Kacheln ein- und ausblenden und per Ziehen sortieren.',
                style: t.textTheme.bodySmall?.copyWith(color: t.colorScheme.onSurfaceVariant),
              ),
            ),
            Expanded(
              child: ReorderableListView.builder(
                buildDefaultDragHandles: false,
                itemCount: _items.length,
                onReorderItem: (oldIndex, newIndex) {
                  setState(() {
                    final item = _items.removeAt(oldIndex);
                    _items.insert(newIndex, item);
                  });
                  _save();
                },
                itemBuilder: (context, i) {
                  final c = _items[i];
                  return ListTile(
                    key: ValueKey(c.tile),
                    leading: ReorderableDragStartListener(index: i, child: const Icon(Icons.drag_indicator)),
                    title: Text(c.tile.label),
                    subtitle: c.tile.wide ? const Text('breite Kachel') : null,
                    trailing: Switch(
                      value: c.visible,
                      onChanged: (v) {
                        setState(() => _items[i] = c.copyWith(visible: v));
                        _save();
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
