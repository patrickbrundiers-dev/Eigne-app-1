import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

import '../../app.dart';
import '../../core/dates.dart';
import '../../core/nutrition.dart';
import '../../core/weight_trend.dart' show weekStart;
import '../../data/database.dart';
import '../../data/targets.dart';
import '../../ui/format.dart';
import '../../ui/widgets.dart';
import '../diary/amount_sheet.dart';
import '../foods/food_search_page.dart';
import '../home_shell.dart';

/// Columns for the week: one on phones, days side by side from about 550 px.
int planColumns(double width) => ((width + 12) / (260 + 12)).floor().clamp(1, 7);

/// Weekly meal plan: plan foods and recipes, fill automatically, copy, put into the
/// diary or on the shopping list.
class PlanView extends StatefulWidget {
  const PlanView({super.key});

  @override
  State<PlanView> createState() => _PlanViewState();
}

class _PlanViewState extends State<PlanView> {
  late DateTime _monday = weekStart(DateTime.now());

  List<String> get _days => [
    for (var i = 0; i < 7; i++) dayKey(DateTime(_monday.year, _monday.month, _monday.day + i)),
  ];

  void _shift(int weeks) => setState(() => _monday = DateTime(_monday.year, _monday.month, _monday.day + 7 * weeks));

  DateNav? _nav;
  HomeShellState? _shell;
  TabController? _tabs;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _tabs = DefaultTabController.maybeOf(context);
    if (_nav != null) return;
    _shell = HomeShellState.of(context);
    _nav = DateNav(
      // Active while the "Essen" tab shows the weekly plan.
      isActive: () => mounted && _shell?.index == 3 && (_tabs == null || _tabs!.index == 2),
      shift: _shift,
      today: () => setState(() => _monday = weekStart(DateTime.now())),
    );
    _shell?.addDateNav(_nav!);
  }

  @override
  void dispose() {
    if (_nav != null) _shell?.removeDateNav(_nav!);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final db = context.db;
    final t = Theme.of(context);
    final days = _days;
    return StreamBuilder<List<Object?>>(
      stream: combineLatest([
        db.watchPlan(days.first, days.last),
        db.watchMealSlots(),
        db.watchProfile(),
        db.watchWeights(),
      ]),
      builder: (context, snap) {
        final v = snap.data;
        if (v == null) return const Center(child: CircularProgressIndicator());
        final plan = v[0] as List<MealPlanEntry>;
        final slots = v[1] as List<MealSlot>;
        final profile = v[2] as Profile?;
        final target = profile == null ? null : targetsFor(profile, v[3] as List<WeightEntry>).targetKcal;
        final weekKcal = Nutrients.sum(plan.map((e) => e.nutrients)).kcal;
        Widget dayCard(String day) => _DayCard(
          day: day,
          weekDays: days,
          entries: plan.where((e) => e.dayKey == day).toList(),
          slots: slots,
          targetKcal: target,
        );
        return LayoutBuilder(
          builder: (context, box) {
            final cols = planColumns(box.maxWidth - 24);
            final cardWidth = (box.maxWidth - 24 - 12 * (cols - 1)) / cols;
            return ListView(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 32),
              children: [
                Row(
                  children: [
                    IconButton(
                      tooltip: 'Vorige Woche',
                      icon: const Icon(Icons.chevron_left),
                      onPressed: () => _shift(-1),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            '${dateTiny(_monday)} – ${dateTiny(parseDayKey(days.last))}',
                            style: t.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                          ),
                          Text(
                            plan.isEmpty
                                ? 'Noch nichts geplant'
                                : '${plan.length} Einträge · Ø ${kcal(weekKcal / 7)} pro Tag',
                            style: t.textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      tooltip: 'Nächste Woche',
                      icon: const Icon(Icons.chevron_right),
                      onPressed: () => _shift(1),
                    ),
                    PopupMenuButton<String>(
                      tooltip: 'Woche',
                      onSelected: (a) => _weekAction(context, a, days, plan, target),
                      itemBuilder: (_) => [
                        const PopupMenuItem(value: 'auto', child: Text('Mit Rezepten füllen …')),
                        if (plan.isNotEmpty) ...[
                          const PopupMenuItem(value: 'diary', child: Text('Ganze Woche ins Tagebuch')),
                          const PopupMenuItem(value: 'shopping', child: Text('Auf die Einkaufsliste')),
                          const PopupMenuItem(value: 'copy', child: Text('In die nächste Woche kopieren')),
                          const PopupMenuItem(value: 'clear', child: Text('Woche leeren')),
                        ],
                      ],
                    ),
                  ],
                ),
                if (cols == 1)
                  for (final day in days) dayCard(day)
                else
                  Wrap(
                    spacing: 12,
                    children: [for (final day in days) SizedBox(width: cardWidth, child: dayCard(day))],
                  ),
                if (cols > 1)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Text(
                      'Tipp: Einträge mit der Maus auf einen anderen Tag ziehen, mit gedrückter Strg-Taste kopieren. '
                      'Alt+← / → wechselt die Woche.',
                      style: t.textTheme.bodySmall,
                    ),
                  ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _weekAction(
    BuildContext context,
    String action,
    List<String> days,
    List<MealPlanEntry> plan,
    int? target,
  ) async {
    final db = context.db;
    try {
      switch (action) {
        case 'auto':
          final opts = await showModalBottomSheet<_AutoOptions>(
            context: context,
            isScrollControlled: true,
            showDragHandle: true,
            builder: (_) => _AutoSheet(defaultKcal: target ?? 2000),
          );
          if (opts == null) return;
          final n = await db.generatePlanFor(
            days: days,
            targetKcal: opts.kcal,
            tags: opts.tags,
            includeSnacks: opts.snacks,
          );
          if (context.mounted) {
            showMessage(
              context,
              n == 0
                  ? 'Keine passenden Rezepte oder alle Mahlzeiten schon geplant. Lege Rezepte unter „Rezepte“ an.'
                  : '$n Mahlzeiten geplant. Bereits geplante Mahlzeiten blieben unverändert.',
            );
          }
        case 'diary':
          final n = await db.planToDiary([for (final e in plan) e.id]);
          if (context.mounted) showMessage(context, '$n Einträge ins Tagebuch übernommen');
        case 'shopping':
          await db.planToShopping(days.first, days.last);
          if (context.mounted) showMessage(context, 'Zutaten der Woche auf der Einkaufsliste');
        case 'copy':
          final next = [
            for (final d in days) dayKey(DateTime(parseDayKey(d).year, parseDayKey(d).month, parseDayKey(d).day + 7)),
          ];
          final n = await db.copyPlanDays(days, next);
          if (context.mounted) showMessage(context, '$n Einträge in die nächste Woche kopiert');
        case 'clear':
          final ids = [for (final e in plan) e.id];
          await db.clearPlanDays(days.first, days.last);
          if (context.mounted) {
            showMessage(
              context,
              'Woche geleert',
              action: SnackBarAction(
                label: 'Rückgängig',
                onPressed: () async {
                  for (final id in ids) {
                    await db.restorePlanEntry(id);
                  }
                },
              ),
            );
          }
      }
    } catch (e) {
      if (context.mounted) showMessage(context, errorText(e));
    }
  }
}

class _DayCard extends StatelessWidget {
  const _DayCard({
    required this.day,
    required this.weekDays,
    required this.entries,
    required this.slots,
    required this.targetKcal,
  });
  final String day;
  final List<String> weekDays;
  final List<MealPlanEntry> entries;
  final List<MealSlot> slots;
  final int? targetKcal;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final db = context.db;
    final date = parseDayKey(day);
    final isToday = day == todayDayKey();
    final total = Nutrients.sum(entries.map((e) => e.nutrients));
    final slotIds = slots.map((s) => s.id).toSet();
    final groups = [
      for (final s in slots) (name: s.name, items: entries.where((e) => e.mealSlotId == s.id).toList()),
      (name: 'Weitere', items: entries.where((e) => !slotIds.contains(e.mealSlotId)).toList()),
    ].where((g) => g.items.isNotEmpty);
    return DragTarget<MealPlanEntry>(
      onWillAcceptWithDetails: (d) => d.data.dayKey != day,
      onAcceptWithDetails: (d) => _drop(context, d.data, copy: HardwareKeyboard.instance.isControlPressed),
      builder: (context, candidates, _) => Padding(
        padding: const EdgeInsets.only(top: 10),
        child: DecoratedBox(
          position: DecorationPosition.foreground,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: candidates.isEmpty ? null : Border.all(color: t.colorScheme.primary, width: 2),
          ),
          child: SectionCard(
            title: '${weekdayShort(date)}${isToday ? ' · heute' : ''}',
            icon: isToday ? Icons.today : Icons.calendar_today_outlined,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (entries.isNotEmpty)
                  Text(
                    targetKcal == null ? kcal(total.kcal) : '${n0(total.kcal)} / ${kcal(targetKcal!)}',
                    style: t.textTheme.labelMedium?.copyWith(
                      color: targetKcal != null && total.kcal > targetKcal! * 1.05 ? t.colorScheme.error : null,
                    ),
                  ),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  tooltip: 'Hinzufügen',
                  icon: const Icon(Icons.add),
                  onPressed: () => _add(context),
                ),
              ],
            ),
            child: entries.isEmpty
                ? Text('Nichts geplant.', style: t.textTheme.bodySmall)
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      for (final g in groups) ...[
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(g.name, style: t.textTheme.labelLarge),
                        ),
                        for (final e in g.items)
                          _draggable(
                            context,
                            e,
                            ListTile(
                              dense: true,
                              contentPadding: EdgeInsets.zero,
                              leading: Icon(
                                e.diaryEntryId != null
                                    ? Icons.check_circle
                                    : (e.recipeId != null ? Icons.menu_book : Icons.egg_alt_outlined),
                                size: 20,
                                color: e.diaryEntryId != null ? t.colorScheme.primary : t.colorScheme.outline,
                              ),
                              title: Text(e.name),
                              subtitle: Text(
                                '${amountWithUnit(e.amount, e.unit)} · ${kcal(e.nutrients.kcal)} · P ${grams(e.nutrients.protein)}',
                              ),
                              trailing: PopupMenuButton<String>(
                                onSelected: (a) => _entryAction(context, a, e),
                                itemBuilder: (_) => [
                                  const PopupMenuItem(value: 'diary', child: Text('Ins Tagebuch')),
                                  const PopupMenuItem(value: 'edit', child: Text('Menge oder Mahlzeit ändern')),
                                  if (e.diaryEntryId == null)
                                    const PopupMenuItem(value: 'move', child: Text('Auf anderen Tag verschieben …')),
                                  const PopupMenuItem(value: 'copy', child: Text('Auf anderen Tag kopieren …')),
                                  const PopupMenuItem(value: 'delete', child: Text('Entfernen')),
                                ],
                              ),
                            ),
                          ),
                      ],
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton.icon(
                          onPressed: () async {
                            final n = await db.planToDiary([for (final e in entries) e.id]);
                            if (context.mounted) showMessage(context, '$n Einträge ins Tagebuch übernommen');
                          },
                          icon: const Icon(Icons.playlist_add_check),
                          label: const Text('Tag ins Tagebuch'),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  /// Entries already in the diary stay put (they belong to that day); everything else can be dragged.
  Widget _draggable(BuildContext context, MealPlanEntry e, Widget child) {
    if (e.diaryEntryId != null) return child;
    final t = Theme.of(context);
    final feedback = Material(
      elevation: 6,
      borderRadius: BorderRadius.circular(12),
      color: t.colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Text(e.name, style: t.textTheme.bodyLarge?.copyWith(color: t.colorScheme.onPrimaryContainer)),
      ),
    );
    final dragging = Opacity(opacity: 0.4, child: child);
    final desktop = switch (t.platform) {
      TargetPlatform.windows || TargetPlatform.linux || TargetPlatform.macOS => true,
      _ => false,
    };
    // Mouse: drag right away. Touch: long press, so scrolling still works.
    return desktop
        ? Draggable<MealPlanEntry>(data: e, feedback: feedback, childWhenDragging: dragging, child: child)
        : LongPressDraggable<MealPlanEntry>(data: e, feedback: feedback, childWhenDragging: dragging, child: child);
  }

  Future<void> _drop(BuildContext context, MealPlanEntry e, {required bool copy, String? to}) async {
    final db = context.db;
    final target = to ?? day;
    if (!copy && e.dayKey == target) return;
    final label = weekdayShort(parseDayKey(target));
    try {
      if (copy) {
        final id = await db.copyPlanEntry(e.id, day: target);
        if (context.mounted) {
          showMessage(
            context,
            '${e.name} auf $label kopiert',
            action: SnackBarAction(label: 'Rückgängig', onPressed: () => db.deletePlanEntry(id)),
          );
        }
      } else {
        await db.updatePlanEntry(e.id, day: target);
        if (context.mounted) {
          showMessage(
            context,
            '${e.name} auf $label verschoben',
            action: SnackBarAction(
              label: 'Rückgängig',
              onPressed: () => db.updatePlanEntry(e.id, day: e.dayKey),
            ),
          );
        }
      }
    } catch (err) {
      if (context.mounted) showMessage(context, errorText(err));
    }
  }

  Future<String?> _pickDay(BuildContext context, String title) => showDialog<String>(
    context: context,
    builder: (c) => SimpleDialog(
      title: Text(title),
      children: [
        for (final d in weekDays)
          SimpleDialogOption(
            onPressed: d == day ? null : () => Navigator.pop(c, d),
            child: Text(
              '${weekdayShort(parseDayKey(d))}${d == day ? ' (dieser Tag)' : ''}',
              style: d == day ? TextStyle(color: Theme.of(c).disabledColor) : null,
            ),
          ),
      ],
    ),
  );

  Future<void> _entryAction(BuildContext context, String a, MealPlanEntry e) async {
    final db = context.db;
    try {
      switch (a) {
        case 'diary':
          final n = await db.planToDiary([e.id]);
          if (context.mounted) showMessage(context, n == 0 ? 'Steht schon im Tagebuch' : '${e.name} eingetragen');
        case 'edit':
          final res = await showAmountSheet(
            context,
            name: e.name,
            unit: e.unit,
            per100: e.per100,
            initialAmount: e.amount,
            slots: slots,
            mealSlotId: e.mealSlotId,
            confirmLabel: 'Speichern',
          );
          if (res != null) await db.updatePlanEntry(e.id, amount: res.amount, mealSlotId: res.mealSlotId);
        case 'move' || 'copy':
          final to = await _pickDay(context, a == 'move' ? '${e.name} verschieben auf' : '${e.name} kopieren auf');
          if (to != null && context.mounted) await _drop(context, e, copy: a == 'copy', to: to);
        case 'delete':
          await db.deletePlanEntry(e.id);
          if (context.mounted) {
            showMessage(
              context,
              '${e.name} entfernt',
              action: SnackBarAction(label: 'Rückgängig', onPressed: () => db.restorePlanEntry(e.id)),
            );
          }
      }
    } catch (err) {
      if (context.mounted) showMessage(context, errorText(err));
    }
  }

  Future<void> _add(BuildContext context) async {
    final db = context.db;
    if (slots.isEmpty) return;
    final kind = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (c) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.menu_book),
              title: const Text('Rezept'),
              onTap: () => Navigator.pop(c, 'recipe'),
            ),
            ListTile(
              leading: const Icon(Icons.egg_alt_outlined),
              title: const Text('Lebensmittel'),
              onTap: () => Navigator.pop(c, 'food'),
            ),
          ],
        ),
      ),
    );
    if (kind == null || !context.mounted) return;
    try {
      if (kind == 'food') {
        final f = await Navigator.push<Food>(
          context,
          MaterialPageRoute(builder: (_) => const FoodSearchPage(title: 'Lebensmittel planen')),
        );
        if (f == null || !context.mounted) return;
        final res = await showAmountSheet(
          context,
          name: f.name,
          brand: f.brand,
          unit: f.unit,
          per100: f.per100,
          servingAmount: f.servingAmount,
          servingLabel: f.servingLabel,
          slots: slots,
          mealSlotId: slots.first.id,
          confirmLabel: 'Planen',
        );
        if (res == null) return;
        await db.planFood(day: day, mealSlotId: res.mealSlotId, food: f, amount: res.amount);
      } else {
        final recipes = await db.watchRecipes().first;
        if (!context.mounted) return;
        if (recipes.isEmpty) {
          showMessage(context, 'Noch keine Rezepte. Lege sie unter „Rezepte“ an.');
          return;
        }
        final r = await showModalBottomSheet<Recipe>(
          context: context,
          showDragHandle: true,
          isScrollControlled: true,
          builder: (c) => DraggableScrollableSheet(
            expand: false,
            builder: (c, sc) => ListView(
              controller: sc,
              children: [
                for (final r in recipes)
                  ListTile(
                    leading: Icon(r.isFavorite ? Icons.star : Icons.menu_book),
                    title: Text(r.name),
                    subtitle: r.tags.isEmpty ? null : Text(r.tags.join(', ')),
                    onTap: () => Navigator.pop(c, r),
                  ),
              ],
            ),
          ),
        );
        if (r == null || !context.mounted) return;
        final n = await db.recipeNutritionOf(r);
        if (!context.mounted) return;
        final res = await showAmountSheet(
          context,
          name: r.name,
          unit: 'g',
          per100: n.per100,
          servingAmount: n.servingWeight,
          servingLabel: 'Portion',
          initialAmount: n.servingWeight,
          slots: slots,
          mealSlotId: slots.first.id,
          confirmLabel: 'Planen',
        );
        if (res == null) return;
        await db.planRecipe(day: day, mealSlotId: res.mealSlotId, recipe: r, grams: res.amount);
      }
    } catch (e) {
      if (context.mounted) showMessage(context, errorText(e));
    }
  }
}

typedef _AutoOptions = ({double kcal, Set<String> tags, bool snacks});

class _AutoSheet extends StatefulWidget {
  const _AutoSheet({required this.defaultKcal});
  final int defaultKcal;

  @override
  State<_AutoSheet> createState() => _AutoSheetState();
}

class _AutoSheetState extends State<_AutoSheet> {
  late final _kcal = TextEditingController(text: '${widget.defaultKcal}');
  final _tags = <String>{};
  bool _snacks = false;
  List<String> _allTags = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.db.watchRecipes().first.then((rs) {
      final all = <String, String>{};
      for (final r in rs) {
        for (final t in r.tags) {
          all.putIfAbsent(t.toLowerCase(), () => t);
        }
      }
      if (mounted) setState(() => _allTags = all.values.toList()..sort());
    });
  }

  @override
  void dispose() {
    _kcal.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final k = parseNum(_kcal.text);
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 0, 20, MediaQuery.viewInsetsOf(context).bottom + 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Woche mit Rezepten füllen', style: t.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          Text(
            'Leere Mahlzeiten werden mit deinen Rezepten gefüllt; die Portionsgröße richtet sich nach dem '
            'Kalorienziel. Bereits Geplantes bleibt unverändert, alles ist danach änderbar.',
            style: t.textTheme.bodySmall,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _kcal,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Kalorien pro Tag', suffixText: 'kcal'),
            onChanged: (_) => setState(() {}),
          ),
          if (_allTags.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text('Nur Rezepte mit', style: t.textTheme.labelLarge),
            const SizedBox(height: 6),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                for (final tag in _allTags)
                  FilterChip(
                    label: Text(tag),
                    selected: _tags.contains(tag),
                    onSelected: (v) => setState(() => v ? _tags.add(tag) : _tags.remove(tag)),
                  ),
              ],
            ),
          ],
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Auch Snacks planen'),
            value: _snacks,
            onChanged: (v) => setState(() => _snacks = v),
          ),
          const SizedBox(height: 8),
          FilledButton(
            onPressed: k == null || k < 800 || k > 6000
                ? null
                : () => Navigator.pop<_AutoOptions>(context, (kcal: k, tags: _tags, snacks: _snacks)),
            child: const Text('Füllen'),
          ),
        ],
      ),
    );
  }
}
