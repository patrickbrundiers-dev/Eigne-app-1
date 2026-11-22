import 'package:material_ui/material_ui.dart';

import '../../app.dart';
import '../../data/database.dart';
import '../../ui/format.dart';
import '../../ui/widgets.dart';

/// Edit 1-6 meals: names, planned times, order. Removing a meal keeps its past entries.
class MealSlotsPage extends StatefulWidget {
  const MealSlotsPage({super.key, required this.slots});
  final List<MealSlot> slots;

  @override
  State<MealSlotsPage> createState() => _MealSlotsPageState();
}

class _Row {
  _Row(this.id, String name, this.minute) : name = TextEditingController(text: name);
  final String? id;
  final TextEditingController name;
  int? minute;
  final key = UniqueKey();
}

class _MealSlotsPageState extends State<MealSlotsPage> {
  late final List<_Row> _rows = [for (final s in widget.slots) _Row(s.id, s.name, s.minuteOfDay)];

  @override
  void dispose() {
    for (final r in _rows) {
      r.name.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    if (_rows.any((r) => r.name.text.trim().isEmpty)) {
      showMessage(context, 'Bitte jeder Mahlzeit einen Namen geben.');
      return;
    }
    try {
      await context.db.saveMealSlots([for (final r in _rows) (id: r.id, name: r.name.text, minuteOfDay: r.minute)]);
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) showMessage(context, errorText(e));
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mahlzeiten'),
        actions: [TextButton(onPressed: _save, child: const Text('Speichern'))],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: Text(
                  '1 bis 6 Mahlzeiten. Ohne Uhrzeit ist eine Mahlzeit flexibel (z. B. Snacks). '
                  'Wer mittags keine Zeit hat, entfernt das Mittagessen einfach. Einträge entfernter '
                  'Mahlzeiten bleiben erhalten.',
                  style: t.textTheme.bodySmall?.copyWith(color: t.colorScheme.onSurfaceVariant),
                ),
              ),
              Expanded(
                child: ReorderableListView(
                  buildDefaultDragHandles: false,
                  onReorderItem: (o, n) => setState(() {
                    _rows.insert(n, _rows.removeAt(o));
                  }),
                  children: [
                    for (var i = 0; i < _rows.length; i++)
                      Padding(
                        key: _rows[i].key,
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        child: Row(
                          children: [
                            ReorderableDragStartListener(
                              index: i,
                              child: const Padding(padding: EdgeInsets.all(8), child: Icon(Icons.drag_indicator)),
                            ),
                            Expanded(
                              child: TextField(
                                controller: _rows[i].name,
                                decoration: InputDecoration(labelText: 'Mahlzeit ${i + 1}'),
                              ),
                            ),
                            const SizedBox(width: 8),
                            OutlinedButton(
                              onPressed: () async {
                                final m = _rows[i].minute;
                                final picked = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay(hour: (m ?? 720) ~/ 60, minute: (m ?? 720) % 60),
                                );
                                if (picked != null) setState(() => _rows[i].minute = picked.hour * 60 + picked.minute);
                              },
                              child: Text(_rows[i].minute == null ? 'flexibel' : timeOfDay(_rows[i].minute)),
                            ),
                            if (_rows[i].minute != null)
                              IconButton(
                                tooltip: 'Uhrzeit entfernen',
                                onPressed: () => setState(() => _rows[i].minute = null),
                                icon: const Icon(Icons.schedule_outlined),
                              ),
                            IconButton(
                              tooltip: 'Entfernen',
                              onPressed: _rows.length <= 1 ? null : () => setState(() => _rows.removeAt(i)),
                              icon: const Icon(Icons.remove_circle_outline),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: OutlinedButton.icon(
                  onPressed: _rows.length >= 6 ? null : () => setState(() => _rows.add(_Row(null, '', null))),
                  icon: const Icon(Icons.add),
                  label: Text(_rows.length >= 6 ? 'Maximal 6 Mahlzeiten' : 'Mahlzeit hinzufügen'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
