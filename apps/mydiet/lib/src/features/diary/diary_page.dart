import 'package:material_ui/material_ui.dart';

import '../../app.dart';
import '../../core/dates.dart';
import '../../core/nutrition.dart';
import '../../data/database.dart';
import '../../data/targets.dart';
import '../../ui/format.dart';
import '../../ui/widgets.dart';
import '../home_shell.dart';
import 'amount_sheet.dart';
import 'food_picker_page.dart';

class DiaryPage extends StatefulWidget {
  const DiaryPage({super.key});

  @override
  State<DiaryPage> createState() => _DiaryPageState();
}

class _DiaryPageState extends State<DiaryPage> {
  DateTime _day = dateOnly(DateTime.now());

  void _shift(int days) => setState(() => _day = DateTime(_day.year, _day.month, _day.day + days));

  @override
  Widget build(BuildContext context) {
    final db = context.db;
    final key = dayKey(_day);
    final isToday = key == todayDayKey();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tagebuch'),
        actions: [
          IconButton(tooltip: 'Vorheriger Tag', onPressed: () => _shift(-1), icon: const Icon(Icons.chevron_left)),
          TextButton(
            onPressed: () async {
              final d = await showDatePicker(
                context: context,
                initialDate: _day,
                firstDate: DateTime(2000),
                lastDate: DateTime.now().add(const Duration(days: 30)),
              );
              if (d != null) setState(() => _day = d);
            },
            child: Text(isToday ? 'Heute' : weekdayShort(_day)),
          ),
          IconButton(tooltip: 'Nächster Tag', onPressed: () => _shift(1), icon: const Icon(Icons.chevron_right)),
          const SizedBox(width: 4),
        ],
      ),
      body: StreamBuilder<List<Object?>>(
        stream: combineLatest([db.watchProfile(), db.watchWeights(), db.watchMealSlots(), db.watchDiary(key)]),
        builder: (context, snap) {
          final v = snap.data;
          if (v == null || v[0] == null) return const Center(child: CircularProgressIndicator());
          final p = v[0] as Profile;
          final targets = targetsFor(p, v[1] as List<WeightEntry>);
          final slots = v[2] as List<MealSlot>;
          final entries = v[3] as List<DiaryEntry>;
          final total = Nutrients.sum(entries.map((e) => e.nutrients));
          final slotIds = slots.map((s) => s.id).toSet();
          final orphans = entries.where((e) => !slotIds.contains(e.mealSlotId)).toList();
          return PageBody(
            maxWidth: 900,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
              children: [
                _DaySummary(
                  total: total,
                  targetKcal: targets.targetKcal,
                  proteinG: targets.proteinG,
                  carbsG: targets.carbsG,
                  fatG: targets.fatG,
                ),
                const SizedBox(height: 12),
                for (final s in slots) ...[
                  _MealCard(
                    day: key,
                    slot: s,
                    slots: slots,
                    entries: entries.where((e) => e.mealSlotId == s.id).toList(),
                  ),
                  const SizedBox(height: 12),
                ],
                if (orphans.isNotEmpty) _MealCard(day: key, slot: null, slots: slots, entries: orphans),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _DaySummary extends StatelessWidget {
  const _DaySummary({
    required this.total,
    required this.targetKcal,
    required this.proteinG,
    required this.carbsG,
    required this.fatG,
  });

  final Nutrients total;
  final int targetKcal, proteinG, carbsG, fatG;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final rest = targetKcal - total.kcal;
    Widget mini(String l, double v, int target, Color c) => Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l, style: t.textTheme.labelSmall),
          Text('${n0(v)} / $target g', style: t.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: target == 0 ? 0 : (v / target).clamp(0.0, 1.0),
              minHeight: 5,
              color: c,
              backgroundColor: t.colorScheme.surfaceContainerHighest,
            ),
          ),
        ],
      ),
    );
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: StatValue(label: 'Gegessen', value: kcal(total.kcal)),
                ),
                Expanded(
                  child: StatValue(label: 'Ziel', value: kcal(targetKcal)),
                ),
                Expanded(
                  child: StatValue(
                    label: rest < 0 ? 'Zu viel' : 'Übrig',
                    value: kcal(rest.abs()),
                    valueColor: rest < 0 ? t.colorScheme.error : t.colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                mini('Protein', total.protein, proteinG, MacroColors.protein(context)),
                const SizedBox(width: 12),
                mini('Kohlenhydrate', total.carbs, carbsG, MacroColors.carbs(context)),
                const SizedBox(width: 12),
                mini('Fett', total.fat, fatG, MacroColors.fat(context)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MealCard extends StatelessWidget {
  const _MealCard({required this.day, required this.slot, required this.slots, required this.entries});
  final String day;
  final MealSlot? slot;
  final List<MealSlot> slots;
  final List<DiaryEntry> entries;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final sum = Nutrients.sum(entries.map((e) => e.nutrients));
    final s = slot;
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 4, 0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        s?.name ?? 'Weitere Einträge',
                        style: t.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      Text(
                        [
                          if (s?.minuteOfDay != null) timeOfDay(s!.minuteOfDay),
                          kcal(sum.kcal),
                          'P ${grams(sum.protein)}',
                        ].join(' · '),
                        style: t.textTheme.bodySmall?.copyWith(color: t.colorScheme.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
                if (s != null)
                  PopupMenuButton<String>(
                    tooltip: 'Mehr',
                    onSelected: (v) => _menu(context, v),
                    itemBuilder: (_) => [
                      const PopupMenuItem(value: 'yesterday', child: Text('Vom Vortag übernehmen')),
                      if (entries.isNotEmpty && day != todayDayKey())
                        const PopupMenuItem(value: 'toToday', child: Text('Nach heute kopieren')),
                    ],
                  ),
                if (s != null)
                  IconButton(
                    tooltip: '${s.name} hinzufügen',
                    icon: Icon(Icons.add_circle, color: t.colorScheme.primary, size: 30),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => FoodPickerPage(day: day, mealSlotId: s.id, slots: slots),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          if (entries.isEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 14),
              child: Text(
                'Noch nichts eingetragen.',
                style: t.textTheme.bodyMedium?.copyWith(color: t.colorScheme.onSurfaceVariant),
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Column(
                children: [
                  for (final e in entries)
                    Dismissible(
                      key: ValueKey(e.id),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        color: t.colorScheme.errorContainer,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        child: Icon(Icons.delete_outline, color: t.colorScheme.onErrorContainer),
                      ),
                      onDismissed: (_) => _delete(context, e),
                      child: ListTile(
                        dense: true,
                        title: Text(e.foodName, style: t.textTheme.bodyLarge),
                        subtitle: Text(
                          [
                            amountWithUnit(e.amount, e.unit),
                            if (e.brand != null) e.brand!,
                            'P ${grams(e.nutrients.protein)} · K ${grams(e.nutrients.carbs)} · F ${grams(e.nutrients.fat)}',
                          ].join(' · '),
                        ),
                        trailing: Text(kcal(e.nutrients.kcal), style: const TextStyle(fontWeight: FontWeight.w600)),
                        onTap: () => _edit(context, e),
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _delete(BuildContext context, DiaryEntry e) async {
    final db = context.db;
    await db.deleteDiaryEntry(e.id);
    if (!context.mounted) return;
    showMessage(
      context,
      '${e.foodName} entfernt',
      action: SnackBarAction(label: 'Rückgängig', onPressed: () => db.restoreDiaryEntry(e.id)),
    );
  }

  Future<void> _edit(BuildContext context, DiaryEntry e) async {
    final res = await showAmountSheet(
      context,
      name: e.foodName,
      brand: e.brand,
      unit: e.unit,
      per100: e.per100,
      initialAmount: e.amount,
      slots: slots,
      mealSlotId: slots.any((s) => s.id == e.mealSlotId) ? e.mealSlotId : (slots.firstOrNull?.id ?? e.mealSlotId),
      confirmLabel: 'Speichern',
    );
    if (res == null || !context.mounted) return;
    await context.db.updateDiaryEntry(e.id, amount: res.amount, mealSlotId: res.mealSlotId);
  }

  Future<void> _menu(BuildContext context, String v) async {
    final db = context.db;
    final s = slot!;
    int n;
    if (v == 'yesterday') {
      final prev = dayKey(DateTime(parseDayKey(day).year, parseDayKey(day).month, parseDayKey(day).day - 1));
      n = await db.copyMeal(fromDay: prev, fromSlotId: s.id, toDay: day);
      if (context.mounted) {
        showMessage(context, n == 0 ? 'Am Vortag war ${s.name} leer.' : '$n Einträge vom Vortag übernommen');
      }
    } else {
      n = await db.copyMeal(fromDay: day, fromSlotId: s.id, toDay: todayDayKey());
      if (context.mounted) {
        showMessage(
          context,
          '$n Einträge nach heute kopiert',
          action: SnackBarAction(label: 'Ansehen', onPressed: () => HomeShellState.of(context)?.go(1)),
        );
      }
    }
  }
}
