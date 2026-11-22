import 'package:material_ui/material_ui.dart';

import '../../app.dart';
import '../../ui/format.dart';
import '../../ui/widgets.dart';

/// Bottom sheet for a quick entry: a label and calories, macros optional.
/// Returns true when an entry was saved.
Future<bool> showQuickEntrySheet(
  BuildContext context, {
  required String day,
  required String mealSlotId,
  String initialLabel = '',
}) async {
  final r = await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => _QuickEntrySheet(day: day, mealSlotId: mealSlotId, initialLabel: initialLabel),
  );
  return r ?? false;
}

class _QuickEntrySheet extends StatefulWidget {
  const _QuickEntrySheet({required this.day, required this.mealSlotId, required this.initialLabel});
  final String day;
  final String mealSlotId;
  final String initialLabel;

  @override
  State<_QuickEntrySheet> createState() => _QuickEntrySheetState();
}

class _QuickEntrySheetState extends State<_QuickEntrySheet> {
  final _form = GlobalKey<FormState>();
  late final _label = TextEditingController(text: widget.initialLabel);
  final _kcal = TextEditingController();
  final _p = TextEditingController();
  final _c = TextEditingController();
  final _f = TextEditingController();

  @override
  void dispose() {
    for (final c in [_label, _kcal, _p, _c, _f]) {
      c.dispose();
    }
    super.dispose();
  }

  String? _macro(String? v) {
    if (v == null || v.trim().isEmpty) return null;
    final n = parseNum(v);
    if (n == null || n < 0 || n > 1000) return '0–1000 g';
    return null;
  }

  Future<void> _save() async {
    if (!_form.currentState!.validate()) return;
    try {
      await context.db.logQuickEntry(
        day: widget.day,
        mealSlotId: widget.mealSlotId,
        label: _label.text,
        kcal: parseNum(_kcal.text)!,
        protein: parseNum(_p.text) ?? 0,
        carbs: parseNum(_c.text) ?? 0,
        fat: parseNum(_f.text) ?? 0,
      );
      if (!mounted) return;
      showMessage(context, 'Schnelleintrag gespeichert (${kcal(parseNum(_kcal.text)!)})');
      Navigator.pop(context, true);
    } catch (e) {
      if (mounted) showMessage(context, errorText(e));
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    Widget macro(String label, TextEditingController c) => Expanded(
      child: TextFormField(
        controller: c,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(labelText: label, suffixText: 'g'),
        validator: _macro,
      ),
    );
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 0, 20, 20 + MediaQuery.viewInsetsOf(context).bottom),
      child: Form(
        key: _form,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Schnelleintrag', style: t.textTheme.titleLarge),
            const SizedBox(height: 4),
            Text(
              'Für Mahlzeiten ohne genaue Angaben. Der Eintrag wird als Schätzung gekennzeichnet.',
              style: t.textTheme.bodySmall?.copyWith(color: t.colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _label,
              decoration: const InputDecoration(
                labelText: 'Bezeichnung (optional)',
                hintText: 'z. B. Pizza beim Italiener',
              ),
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 8),
            TextFormField(
              key: const ValueKey('quick-kcal'),
              controller: _kcal,
              autofocus: true,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: 'Kalorien', suffixText: 'kcal'),
              validator: (v) {
                final n = parseNum(v);
                if (n == null || n <= 0 || n > 10000) return 'Bitte 1–10000 kcal eingeben';
                return null;
              },
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                macro('Protein', _p),
                const SizedBox(width: 8),
                macro('Kohlenh.', _c),
                const SizedBox(width: 8),
                macro('Fett', _f),
              ],
            ),
            const SizedBox(height: 16),
            FilledButton(onPressed: _save, child: const Text('Eintragen')),
          ],
        ),
      ),
    );
  }
}
