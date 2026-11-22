part of 'dashboard_page.dart';

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
