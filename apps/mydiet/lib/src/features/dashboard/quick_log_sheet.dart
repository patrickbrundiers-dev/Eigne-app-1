import 'package:material_ui/material_ui.dart';

import '../../app.dart';
import '../../core/meal_time.dart';
import '../../data/database.dart';
import '../../data/targets.dart' show todayDayKey;
import '../diary/food_picker_page.dart';
import '../weight/weight_entry_sheet.dart';

/// The dashboard's "Eintragen": pick the meal (preselected by the time of day) and how to log.
/// Any entry is at most three taps away: Eintragen → way → food/amount.
Future<void> showQuickLogSheet(BuildContext context, {DateTime? now}) async {
  final slots = await context.db.watchMealSlots().first;
  if (slots.isEmpty || !context.mounted) return;
  final n = now ?? DateTime.now();
  final initial = currentMealIndex([for (final s in slots) s.minuteOfDay], n.hour * 60 + n.minute);
  final choice = await showModalBottomSheet<(PickerStart?, String)>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (_) => QuickLogSheet(slots: slots, initialSlot: initial),
  );
  if (choice == null || !context.mounted) return;
  final (start, slotId) = choice;
  if (start == null) {
    await showWeightEntrySheet(context);
    return;
  }
  await Navigator.push(
    context,
    MaterialPageRoute<void>(
      builder: (_) => FoodPickerPage(day: todayDayKey(), mealSlotId: slotId, slots: slots, start: start),
    ),
  );
}

class QuickLogSheet extends StatefulWidget {
  const QuickLogSheet({super.key, required this.slots, required this.initialSlot});
  final List<MealSlot> slots;
  final int initialSlot;

  @override
  State<QuickLogSheet> createState() => _QuickLogSheetState();
}

class _QuickLogSheetState extends State<QuickLogSheet> {
  late int _slot = widget.initialSlot.clamp(0, widget.slots.length - 1);

  void _go(PickerStart? start) => Navigator.pop(context, (start, widget.slots[_slot].id));

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Eintragen für', style: t.textTheme.titleMedium),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                for (var i = 0; i < widget.slots.length; i++)
                  ChoiceChip(
                    label: Text(widget.slots[i].name),
                    selected: _slot == i,
                    onSelected: (_) => setState(() => _slot = i),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            _Way(
              Icons.search,
              'Lebensmittel suchen',
              'Zuletzt, häufig, Favoriten, Vorlagen',
              () => _go(PickerStart.search),
            ),
            _Way(
              Icons.qr_code_scanner,
              'Barcode scannen',
              'Packung scannen oder Nummer eingeben',
              () => _go(PickerStart.scan),
            ),
            _Way(Icons.notes, 'Als Text eintragen', 'z. B. „200 g Reis, 2 Eier“', () => _go(PickerStart.text)),
            _Way(Icons.bolt, 'Nur Kalorien', 'Schnell-Eintrag ohne Lebensmittel', () => _go(PickerStart.quick)),
            const Divider(),
            _Way(Icons.monitor_weight_outlined, 'Gewicht eintragen', null, () => _go(null)),
          ],
        ),
      ),
    );
  }
}

class _Way extends StatelessWidget {
  const _Way(this.icon, this.title, this.subtitle, this.onTap);
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => ListTile(
    contentPadding: EdgeInsets.zero,
    leading: Icon(icon),
    title: Text(title),
    subtitle: subtitle == null ? null : Text(subtitle!),
    onTap: onTap,
  );
}
