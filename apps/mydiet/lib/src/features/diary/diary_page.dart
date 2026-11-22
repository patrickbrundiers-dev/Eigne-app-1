import 'package:material_ui/material_ui.dart';

import '../../app.dart';
import '../../core/protein_split.dart';
import '../../core/dates.dart';
import '../../core/nutrition.dart';
import '../../core/week_budget.dart';
import '../../data/database.dart';
import '../../data/display_prefs.dart';
import '../../data/targets.dart';
import '../../ui/design/components.dart';
import '../../ui/design/tokens.dart';
import '../../ui/format.dart';
import '../../ui/widgets.dart';
import '../home_shell.dart';
import 'amount_sheet.dart';
import 'diary_table.dart';
import 'food_picker_page.dart';

class DiaryPage extends StatefulWidget {
  const DiaryPage({super.key});

  @override
  State<DiaryPage> createState() => _DiaryPageState();
}

class _DiaryPageState extends State<DiaryPage> {
  DateTime _day = dateOnly(DateTime.now());

  void _shift(int days) => setState(() => _day = DateTime(_day.year, _day.month, _day.day + days));

  DateNav? _nav;
  HomeShellState? _shell;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_nav != null) return;
    _shell = HomeShellState.of(context);
    _nav = DateNav(
      isActive: () => mounted && _shell?.index == 1,
      shift: _shift,
      today: () => setState(() => _day = dateOnly(DateTime.now())),
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
    final key = dayKey(_day);
    final isToday = key == todayDayKey();
    final wide = MediaQuery.sizeOf(context).width >= 900;
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
        stream: combineLatest([
          db.watchProfile(),
          db.watchWeights(),
          db.watchMealSlots(),
          db.watchDiary(key),
          db.watchSetting(budgetModeKey),
          db.watchSetting(hideNumbersKey),
          db.watchDailyTotals(dayKey(mondayOf(_day)), dayKey(DateTime(_day.year, _day.month, _day.day - 1))),
          db.watchSetting(diaryTableColumnsKey),
        ]),
        builder: (context, snap) {
          final v = snap.data;
          if (v == null || v[0] == null) return const Center(child: CircularProgressIndicator());
          final p = v[0] as Profile;
          final targets = targetsFor(p, v[1] as List<WeightEntry>);
          final slots = v[2] as List<MealSlot>;
          final entries = v[3] as List<DiaryEntry>;
          final total = Nutrients.sum(entries.map((e) => e.nutrients));
          final hide = v[5] == 'true';
          final week = v[4] == 'week'
              ? weekBudget(
                  today: _day,
                  dailyTargetKcal: targets.targetKcal,
                  consumedByDay: {
                    for (final e in (v[6] as Map<String, Nutrients>).entries) parseDayKey(e.key): e.value.kcal,
                  },
                  floorKcal: p.sex == 'female' ? 1200 : 1500,
                )
              : null;
          final slotIds = slots.map((s) => s.id).toSet();
          final orphans = entries.where((e) => !slotIds.contains(e.mealSlotId)).toList();
          final shares = proteinPerMeal(targets.proteinG.toDouble(), [for (final s in slots) s.minuteOfDay != null]);
          final perMeal = {for (final (i, s) in slots.indexed) s.id: shares[i]};
          final columns = wide ? visibleDiaryColumns(parseDiaryColumns(v[7] as String?), hideNumbers: hide) : null;
          return PageBody(
            maxWidth: wide ? 1280 : 900,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
              children: [
                _DaySummary(
                  total: total,
                  targetKcal: week?.todayTargetKcal ?? targets.targetKcal,
                  isWeekBudget: week != null,
                  hideNumbers: hide,
                  proteinG: targets.proteinG,
                  carbsG: targets.carbsG,
                  fatG: targets.fatG,
                ),
                const SizedBox(height: 12),
                if (wide)
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: ActionChip(
                        avatar: const Icon(Icons.view_column_outlined, size: 18),
                        label: const Text('Spalten'),
                        tooltip: 'Spalten im Tagebuch wählen',
                        onPressed: () async {
                          final next = await chooseDiaryColumns(context, parseDiaryColumns(v[7] as String?));
                          if (next != null) await db.setSetting(diaryTableColumnsKey, encodeDiaryColumns(next));
                        },
                      ),
                    ),
                  ),
                for (final s in slots) ...[
                  _MealCard(
                    day: key,
                    slot: s,
                    slots: slots,
                    entries: entries.where((e) => e.mealSlotId == s.id).toList(),
                    hideNumbers: hide,
                    proteinTargetG: perMeal[s.id],
                    columns: columns,
                  ),
                  const SizedBox(height: 12),
                ],
                if (orphans.isNotEmpty)
                  _MealCard(day: key, slot: null, slots: slots, entries: orphans, hideNumbers: hide, columns: columns),
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
    this.isWeekBudget = false,
    this.hideNumbers = false,
  });

  final Nutrients total;
  final int targetKcal, proteinG, carbsG, fatG;
  final bool isWeekBudget;
  final bool hideNumbers;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final tk = context.tokens;
    final rest = targetKcal - total.kcal;
    final share = targetKcal <= 0 ? 0.0 : total.kcal / targetKcal;
    Widget mini(String l, double v, int target, Color c) => Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l.toUpperCase(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: SattlyFonts.numbers,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.8,
              color: tk.muted,
            ),
          ),
          if (!hideNumbers)
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text('${n0(v)} / $target g', maxLines: 1, style: numberStyle(17, color: tk.ink)),
            ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(SattlyRadius.pill),
            child: LinearProgressIndicator(
              value: target == 0 ? 0 : (v / target).clamp(0.0, 1.0),
              minHeight: 6,
              color: c,
              backgroundColor: c.withValues(alpha: 0.18),
            ),
          ),
        ],
      ),
    );
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(SattlySpace.l),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (hideNumbers)
              Text(gentleStatus(share), style: t.textTheme.titleMedium)
            else
              StatStrip(
                items: [
                  ('Gegessen', kcal(total.kcal), tk.primary),
                  (isWeekBudget ? 'Ziel (Woche)' : 'Ziel', kcal(targetKcal), tk.muted),
                  (rest < 0 ? 'Zu viel' : 'Übrig', kcal(rest.abs()), rest < 0 ? tk.danger : tk.good),
                ],
              ),
            const SizedBox(height: SattlySpace.m),
            Semantics(
              label: 'Tagesziel zu ${(share * 100).round()} Prozent erreicht',
              excludeSemantics: true,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(SattlyRadius.pill),
                child: LinearProgressIndicator(
                  value: share.clamp(0.0, 1.0),
                  minHeight: 8,
                  color: share > 1 ? tk.danger : tk.primary,
                  backgroundColor: tk.track,
                ),
              ),
            ),
            const SizedBox(height: SattlySpace.l),
            Row(
              children: [
                mini('Protein', total.protein, proteinG, MacroColors.protein(context)),
                const SizedBox(width: SattlySpace.m),
                mini('Kohlenhydrate', total.carbs, carbsG, MacroColors.carbs(context)),
                const SizedBox(width: SattlySpace.m),
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
  const _MealCard({
    required this.day,
    required this.slot,
    required this.slots,
    required this.entries,
    this.hideNumbers = false,
    this.proteinTargetG,
    this.columns,
  });
  final bool hideNumbers;

  /// Wide screens: show the entries as a table with these columns; null = list.
  final List<DiaryColumn>? columns;
  final String day;
  final MealSlot? slot;

  /// This meal's share of the daily protein target (core/protein_split.dart).
  final double? proteinTargetG;
  final List<MealSlot> slots;
  final List<DiaryEntry> entries;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final tk = context.tokens;
    final sum = Nutrients.sum(entries.map((e) => e.nutrients));
    final s = slot;
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(SattlySpace.l, SattlySpace.s, SattlySpace.xs, 0),
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
                          if (!hideNumbers) kcal(sum.kcal),
                          if (!hideNumbers)
                            proteinTargetG == null || proteinTargetG! <= 0
                                ? 'P ${grams(sum.protein)}'
                                : 'Protein ${n0(sum.protein)} / ${n0(proteinTargetG!)} g',
                          if (hideNumbers) '${entries.length} Einträge',
                        ].join(' · '),
                        style: t.textTheme.bodySmall?.copyWith(color: tk.muted, fontWeight: FontWeight.w600),
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
                      if (entries.isNotEmpty)
                        const PopupMenuItem(value: 'toDate', child: Text('Auf anderes Datum kopieren …')),
                      if (entries.isNotEmpty)
                        const PopupMenuItem(value: 'template', child: Text('Als Vorlage speichern …')),
                    ],
                  ),
                if (s != null)
                  IconButton(
                    tooltip: '${s.name} hinzufügen',
                    icon: Icon(Icons.add_box_rounded, color: tk.primary, size: 30),
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
          else if (columns != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: DiaryTable(
                entries: entries,
                columns: columns!,
                onEdit: (e) => _edit(context, e),
                onDelete: (e) => _delete(context, e),
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
                        leading: _FoodInitial(name: e.foodName),
                        title: Text(e.foodName, style: t.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
                        subtitle: _EntryLine(entry: e, hideNumbers: hideNumbers),
                        trailing: hideNumbers
                            ? null
                            : Text(kcal(e.nutrients.kcal), style: numberStyle(17, color: tk.ink)),
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

  Future<String?> _askTemplateName(BuildContext context, String initial) async {
    final c = TextEditingController(text: initial);
    final r = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Als Vorlage speichern'),
        content: TextField(
          controller: c,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Name',
            helperText: 'Gleicher Name ersetzt eine vorhandene Vorlage.',
          ),
          onSubmitted: (v) => Navigator.pop(ctx, v),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Abbrechen')),
          FilledButton(onPressed: () => Navigator.pop(ctx, c.text), child: const Text('Speichern')),
        ],
      ),
    );
    c.dispose();
    final t = r?.trim();
    return t == null || t.isEmpty ? null : t;
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
    } else if (v == 'template') {
      final name = await _askTemplateName(context, 'Mein ${s.name}');
      if (name == null || !context.mounted) return;
      try {
        await db.saveTemplateFromMeal(name: name, day: day, mealSlotId: s.id);
        if (context.mounted) {
          showMessage(context, 'Vorlage „$name“ gespeichert. Du findest sie beim Hinzufügen ganz oben.');
        }
      } catch (e) {
        if (context.mounted) showMessage(context, errorText(e));
      }
      return;
    } else if (v == 'toDate') {
      final from = parseDayKey(day);
      final picked = await showDatePicker(
        context: context,
        initialDate: DateTime(from.year, from.month, from.day + 1),
        firstDate: DateTime(from.year - 1),
        lastDate: DateTime(from.year + 1, 12, 31),
        helpText: '${s.name} kopieren nach',
      );
      if (picked == null || !context.mounted) return;
      final to = dayKey(picked);
      if (to == day) return;
      n = await db.copyMeal(fromDay: day, fromSlotId: s.id, toDay: to);
      if (context.mounted) showMessage(context, '$n Einträge nach ${dateShort(picked)} kopiert');
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

/// Platzhalter-Bild eines Eintrags: Anfangsbuchstabe auf ruhiger Fläche (Design 2).
class _FoodInitial extends StatelessWidget {
  const _FoodInitial({required this.name});
  final String name;

  @override
  Widget build(BuildContext context) {
    final tk = context.tokens;
    final letter = name.trim().isEmpty ? '?' : name.trim().characters.first.toUpperCase();
    return ExcludeSemantics(
      child: Container(
        width: 36,
        height: 36,
        alignment: Alignment.center,
        decoration: BoxDecoration(color: tk.surface2, borderRadius: BorderRadius.circular(SattlyRadius.control)),
        child: Text(letter, style: numberStyle(18, color: tk.muted)),
      ),
    );
  }
}

/// Zweite Zeile eines Eintrags: Menge, Marke und Makros mit Farbpunkt.
class _EntryLine extends StatelessWidget {
  const _EntryLine({required this.entry, required this.hideNumbers});
  final DiaryEntry entry;
  final bool hideNumbers;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final e = entry;
    final base = [amountWithUnit(e.amount, e.unit), if (e.brand != null) e.brand!].join(' · ');
    if (hideNumbers) return Text(base);
    InlineSpan macro(String l, double g, Color c) => TextSpan(
      children: [
        WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: Padding(
            padding: const EdgeInsets.only(left: 10, right: 4),
            child: Container(
              width: 7,
              height: 7,
              decoration: BoxDecoration(color: c, shape: BoxShape.circle),
            ),
          ),
        ),
        TextSpan(text: '$l ${grams(g)}'),
      ],
    );
    return Text.rich(
      TextSpan(
        style: t.textTheme.bodySmall?.copyWith(color: context.tokens.muted),
        children: [
          TextSpan(text: base),
          macro('P', e.nutrients.protein, MacroColors.protein(context)),
          macro('K', e.nutrients.carbs, MacroColors.carbs(context)),
          macro('F', e.nutrients.fat, MacroColors.fat(context)),
        ],
      ),
    );
  }
}
