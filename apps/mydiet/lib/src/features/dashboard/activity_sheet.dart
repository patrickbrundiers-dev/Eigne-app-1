import 'package:material_ui/material_ui.dart';

import '../../app.dart';
import '../../data/database.dart';
import '../../data/targets.dart';
import '../../ui/format.dart';
import '../../ui/widgets.dart';

Future<void> showActivitySheet(BuildContext context, {String? day}) => showModalBottomSheet(
  context: context,
  isScrollControlled: true,
  showDragHandle: true,
  builder: (_) => _ActivitySheet(day: day ?? todayDayKey()),
);

class _ActivitySheet extends StatefulWidget {
  const _ActivitySheet({required this.day});
  final String day;

  @override
  State<_ActivitySheet> createState() => _ActivitySheetState();
}

class _ActivitySheetState extends State<_ActivitySheet> {
  final _form = GlobalKey<FormState>();
  final _label = TextEditingController(text: 'Spaziergang');
  final _minutes = TextEditingController();
  final _kcal = TextEditingController();
  final _steps = TextEditingController();

  @override
  void dispose() {
    for (final c in [_label, _minutes, _kcal, _steps]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _add() async {
    if (!_form.currentState!.validate()) return;
    try {
      await context.db.addActivity(
        day: widget.day,
        label: _label.text,
        minutes: parseNum(_minutes.text)?.round() ?? 0,
        kcal: parseNum(_kcal.text) ?? 0,
        steps: parseNum(_steps.text)?.round(),
      );
      _minutes.clear();
      _kcal.clear();
      _steps.clear();
      if (mounted) FocusScope.of(context).unfocus();
    } catch (e) {
      if (mounted) showMessage(context, errorText(e));
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final db = context.db;
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 0, 20, MediaQuery.viewInsetsOf(context).bottom + 20),
      child: Form(
        key: _form,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Aktivität', style: t.textTheme.titleLarge),
            const SizedBox(height: 4),
            Text(
              'Manuell erfasst. Smartwatch-Daten (Health Connect, Garmin) folgen in Phase 4 und werden '
              'pro Quelle nur einmal gezählt.',
              style: t.textTheme.bodySmall?.copyWith(color: t.colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 12),
            StreamBuilder<List<ActivityEntry>>(
              stream: db.watchActivities(widget.day),
              builder: (context, snap) {
                final items = snap.data ?? const [];
                if (items.isEmpty) return const SizedBox.shrink();
                return Column(
                  children: [
                    for (final a in items)
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                        leading: const Icon(Icons.directions_run),
                        title: Text(a.label),
                        subtitle: Text(
                          [
                            if (a.minutes > 0) '${a.minutes} min',
                            if (a.kcal > 0) kcal(a.kcal),
                            if (a.steps != null) '${n0(a.steps!)} Schritte',
                          ].join(' · '),
                        ),
                        trailing: IconButton(
                          tooltip: 'Löschen',
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () => db.deleteActivity(a.id),
                        ),
                      ),
                    const Divider(),
                  ],
                );
              },
            ),
            TextFormField(
              controller: _label,
              decoration: const InputDecoration(labelText: 'Bezeichnung'),
              validator: (s) => (s ?? '').trim().isEmpty ? 'Bitte eingeben' : null,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: NumberField(
                    controller: _minutes,
                    label: 'Dauer',
                    suffix: 'min',
                    decimals: false,
                    validator: numRange(0, 1440, required: false),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: NumberField(
                    controller: _kcal,
                    label: 'Verbrauch',
                    suffix: 'kcal',
                    decimals: false,
                    validator: numRange(0, 10000, required: false),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            NumberField(
              controller: _steps,
              label: 'Schritte (optional)',
              decimals: false,
              validator: numRange(0, 200000, required: false),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(onPressed: _add, icon: const Icon(Icons.add), label: const Text('Hinzufügen')),
          ],
        ),
      ),
    );
  }
}
