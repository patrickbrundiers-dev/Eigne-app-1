import 'dart:convert';

import 'package:material_ui/material_ui.dart';

/// Reads a stored column choice (JSON list of enum names). Unknown names are ignored, the order follows [all].
/// Missing or broken values give [defaults].
List<T> parseColumns<T extends Enum>(String? json, List<T> all, List<T> defaults) {
  if (json == null) return defaults;
  try {
    final names = {for (final e in jsonDecode(json) as List) e as String};
    return [
      for (final c in all)
        if (names.contains(c.name)) c,
    ];
  } catch (_) {
    return defaults;
  }
}

String encodeColumns<T extends Enum>(Iterable<T> cols) => jsonEncode([for (final c in cols) c.name]);

/// Dialog to choose the visible columns of a table. Returns the new choice (in the order of [all]) or null.
Future<List<T>?> chooseColumns<T extends Enum>(
  BuildContext context, {
  required List<T> all,
  required List<T> current,
  required String Function(T) label,
}) => showDialog<List<T>>(
  context: context,
  builder: (_) => _ColumnsDialog<T>(all: all, current: current, label: label),
);

class _ColumnsDialog<T extends Enum> extends StatefulWidget {
  const _ColumnsDialog({required this.all, required this.current, required this.label});
  final List<T> all;
  final List<T> current;
  final String Function(T) label;

  @override
  State<_ColumnsDialog<T>> createState() => _ColumnsDialogState<T>();
}

class _ColumnsDialogState<T extends Enum> extends State<_ColumnsDialog<T>> {
  late final Set<T> _on = widget.current.toSet();

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('Spalten wählen'),
    content: SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final c in widget.all)
            CheckboxListTile(
              dense: true,
              value: _on.contains(c),
              title: Text(widget.label(c)),
              onChanged: (v) => setState(() => v == true ? _on.add(c) : _on.remove(c)),
            ),
        ],
      ),
    ),
    actions: [
      TextButton(onPressed: () => Navigator.pop(context), child: const Text('Abbrechen')),
      FilledButton(
        onPressed: () => Navigator.pop(context, [
          for (final c in widget.all)
            if (_on.contains(c)) c,
        ]),
        child: const Text('Übernehmen'),
      ),
    ],
  );
}
