import 'package:material_ui/material_ui.dart';

import '../../app.dart';
import '../../core/dates.dart';
import '../../data/database.dart';
import '../../ui/format.dart';
import '../../ui/widgets.dart';

Future<void> showWeightEntrySheet(BuildContext context, {WeightEntry? entry}) => showModalBottomSheet(
  context: context,
  isScrollControlled: true,
  showDragHandle: true,
  builder: (_) => _WeightEntrySheet(entry: entry),
);

class _WeightEntrySheet extends StatefulWidget {
  const _WeightEntrySheet({this.entry});
  final WeightEntry? entry;

  @override
  State<_WeightEntrySheet> createState() => _WeightEntrySheetState();
}

class _WeightEntrySheetState extends State<_WeightEntrySheet> {
  final _form = GlobalKey<FormState>();
  late DateTime _day = widget.entry == null ? dateOnly(DateTime.now()) : parseDayKey(widget.entry!.dayKey);
  late final _kg = TextEditingController(text: numField(widget.entry?.weightKg));
  late final _bf = TextEditingController(text: numField(widget.entry?.bodyFatPercent));
  late final _waist = TextEditingController(text: numField(widget.entry?.waistCm));
  late final _note = TextEditingController(text: widget.entry?.note ?? '');
  bool _prefilled = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_prefilled && widget.entry == null) {
      _prefilled = true;
      _loadForDay();
    }
  }

  /// If the chosen day already has an entry, show it so saving replaces it knowingly.
  Future<void> _loadForDay() async {
    final all = await context.db.allWeights();
    final e = all.where((w) => w.dayKey == dayKey(_day)).firstOrNull;
    if (!mounted) return;
    setState(() {
      if (e != null) {
        _kg.text = numField(e.weightKg);
        _bf.text = numField(e.bodyFatPercent);
        _waist.text = numField(e.waistCm);
        _note.text = e.note ?? '';
      } else if (_kg.text.isEmpty && all.isNotEmpty) {
        _kg.text = numField(all.last.weightKg);
      }
    });
  }

  @override
  void dispose() {
    for (final c in [_kg, _bf, _waist, _note]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    if (!_form.currentState!.validate()) return;
    try {
      await context.db.saveWeight(
        day: dayKey(_day),
        weightKg: parseNum(_kg.text)!,
        bodyFatPercent: parseNum(_bf.text),
        waistCm: parseNum(_waist.text),
        note: _note.text,
      );
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) showMessage(context, errorText(e));
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 0, 20, MediaQuery.viewInsetsOf(context).bottom + 20),
      child: Form(
        key: _form,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Gewicht eintragen', style: t.textTheme.titleLarge),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              icon: const Icon(Icons.calendar_today_outlined),
              label: Text(dateLong(_day)),
              onPressed: widget.entry != null
                  ? null
                  : () async {
                      final d = await showDatePicker(
                        context: context,
                        initialDate: _day,
                        firstDate: DateTime(2000),
                        lastDate: DateTime.now(),
                      );
                      if (d != null) {
                        setState(() => _day = d);
                        await _loadForDay();
                      }
                    },
            ),
            const SizedBox(height: 12),
            NumberField(controller: _kg, label: 'Gewicht', suffix: 'kg', autofocus: true, validator: numRange(25, 400)),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: NumberField(
                    controller: _bf,
                    label: 'Körperfett',
                    suffix: '%',
                    validator: numRange(3, 70, required: false),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: NumberField(
                    controller: _waist,
                    label: 'Bauchumfang',
                    suffix: 'cm',
                    validator: numRange(30, 250, required: false),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _note,
              decoration: const InputDecoration(labelText: 'Notiz (optional)'),
            ),
            const SizedBox(height: 8),
            Text(
              'Pro Tag gibt es einen Eintrag; ein neuer Wert ersetzt den alten.',
              style: t.textTheme.bodySmall?.copyWith(color: t.colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 16),
            FilledButton(onPressed: _save, child: const Text('Speichern')),
            if (widget.entry != null)
              TextButton.icon(
                onPressed: () async {
                  await context.db.deleteWeight(widget.entry!.id);
                  if (context.mounted) Navigator.pop(context);
                },
                icon: const Icon(Icons.delete_outline),
                label: const Text('Eintrag löschen'),
              ),
          ],
        ),
      ),
    );
  }
}
