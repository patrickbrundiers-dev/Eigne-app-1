import 'dart:math' as math;

import 'package:material_ui/material_ui.dart';

import '../../app.dart';
import '../../core/daily_hints.dart';
import '../../core/dates.dart';
import '../../core/dashboard_layout.dart';
import '../../core/day_budget.dart';
import '../../core/energy.dart';
import '../../core/nutrition.dart';
import '../../core/week_budget.dart';
import '../../core/weight_progress.dart';
import '../../core/weight_trend.dart';
import '../../data/database.dart';
import '../../data/display_prefs.dart';
import '../../data/targets.dart';
import '../../ui/format.dart';
import '../../ui/widgets.dart';
import '../fasting/fasting_card.dart';
import '../home_shell.dart';
import '../micros/micros_view.dart';
import '../report/weekly_report_page.dart';
import '../supplements/supplements_view.dart';
import '../weight/weight_chart.dart';
import '../weight/weight_entry_sheet.dart';
import 'activity_sheet.dart';

part 'customize_sheet.dart';
part 'tiles/day_tiles.dart';
part 'tiles/nutrition_tiles.dart';
part 'tiles/weight_tiles.dart';

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
    this.weekMode = false,
    this.hideNumbers = false,
    this.weekTotals = const {},
    DateTime? today,
  }) : targets = targetsFor(profile, weights),
       analysis = analyzeWeight(weightPoints(weights), targetKg: profile.targetWeightKg),
       consumed = Nutrients.sum(diary.map((e) => e.nutrients)) {
    week = weekMode
        ? weekBudget(
            today: today ?? DateTime.now(),
            dailyTargetKcal: targets.targetKcal,
            consumedByDay: {for (final e in weekTotals.entries) parseDayKey(e.key): e.value.kcal},
            floorKcal: profile.sex == 'female' ? 1200 : 1500,
          )
        : null;
    budget = dayBudget(
      targetKcal: week?.todayTargetKcal ?? targets.targetKcal,
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
  final bool weekMode;
  final bool hideNumbers;

  /// Diary totals from Monday until yesterday (week mode only).
  final Map<String, Nutrients> weekTotals;
  late final WeekBudget? week;
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
    final now = DateTime.now();
    final monday = mondayOf(now);
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final stream =
        combineLatest([
              db.watchProfile(),
              db.watchWeights(),
              db.watchDiary(day),
              db.watchWaterMl(day),
              db.watchActivities(day),
              db.watchMealSlots(),
              db.watchSetting('dashboardLayout'),
              db.watchSetting(budgetModeKey),
              db.watchSetting(hideNumbersKey),
              db.watchDailyTotals(dayKey(monday), dayKey(yesterday)),
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
                weekMode: v[7] == 'week',
                hideNumbers: v[8] == 'true',
                weekTotals: v[9] as Map<String, Nutrients>,
                today: now,
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
                      if (MediaQuery.sizeOf(context).width < 840)
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Tooltip(
                            message: 'Profil',
                            child: InkWell(
                              key: const Key('profile-avatar'),
                              customBorder: const CircleBorder(),
                              onTap: () => HomeShellState.of(context)?.go(4),
                              child: CircleAvatar(
                                radius: 22,
                                backgroundColor: t.colorScheme.primaryContainer,
                                foregroundColor: t.colorScheme.onPrimaryContainer,
                                child: Text(
                                  (name?.isNotEmpty ?? false) ? name!.characters.first.toUpperCase() : 'P',
                                  semanticsLabel: 'Profil',
                                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                                ),
                              ),
                            ),
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
    DashTile.supplements => const _SupplementsTile(),
    DashTile.fasting => const FastingCard(),
    DashTile.micros => const MicrosTile(),
    DashTile.weeklyReport => const WeeklyReportTile(),
  };
}
