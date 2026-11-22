import 'dart:convert';

import 'package:material_ui/material_ui.dart';

import '../../data/database.dart';
import '../../ui/format.dart';

/// Columns of the food table on wide screens (PC). Values per 100 g/ml.
enum FoodColumn {
  brand('Marke'),
  kcal('kcal'),
  protein('Eiweiß'),
  carbs('Kohlenh.'),
  sugar('Zucker'),
  fat('Fett'),
  saturatedFat('ges. Fett'),
  fiber('Ballastst.'),
  salt('Salz'),
  source('Quelle');

  const FoodColumn(this.label);
  final String label;

  bool get numeric => this != brand && this != source;

  /// Sort value (numbers) or text.
  Comparable<Object> value(Food f) => switch (this) {
    brand => (f.brand ?? '').toLowerCase(),
    kcal => f.kcal,
    protein => f.protein,
    carbs => f.carbs,
    sugar => f.sugar,
    fat => f.fat,
    saturatedFat => f.saturatedFat,
    fiber => f.fiber,
    salt => f.salt,
    source => f.sourceKind.label,
  };

  String text(Food f) => switch (this) {
    brand => f.brand ?? '',
    kcal => n0(f.kcal),
    salt => n1opt(f.salt),
    source => f.sourceKind.label,
    _ => n1opt(value(f) as double),
  };
}

const foodTableColumnsKey = 'foodTableColumns';
const defaultFoodColumns = [FoodColumn.brand, FoodColumn.kcal, FoodColumn.protein, FoodColumn.carbs, FoodColumn.fat];

/// Reads the stored column choice; unknown names are ignored, order follows [FoodColumn].
List<FoodColumn> parseFoodColumns(String? json) {
  if (json == null) return defaultFoodColumns;
  try {
    final names = {for (final e in jsonDecode(json) as List) e as String};
    return [
      for (final c in FoodColumn.values)
        if (names.contains(c.name)) c,
    ];
  } catch (_) {
    return defaultFoodColumns;
  }
}

String encodeFoodColumns(Iterable<FoodColumn> cols) => jsonEncode([for (final c in cols) c.name]);

/// Sorts [items] by [column] (null = name).
List<Food> sortFoods(List<Food> items, FoodColumn? column, {bool ascending = true}) {
  final out = [...items];
  int cmp(Food a, Food b) {
    final r = column == null
        ? a.name.toLowerCase().compareTo(b.name.toLowerCase())
        : column.value(a).compareTo(column.value(b));
    return ascending ? r : -r;
  }

  out.sort(cmp);
  return out;
}

class FoodTable extends StatefulWidget {
  const FoodTable({
    super.key,
    required this.items,
    required this.columns,
    required this.onOpen,
    required this.onFavorite,
  });

  final List<Food> items;
  final List<FoodColumn> columns;
  final void Function(Food) onOpen;
  final void Function(Food) onFavorite;

  @override
  State<FoodTable> createState() => _FoodTableState();
}

class _FoodTableState extends State<FoodTable> {
  /// -1 = name, otherwise index in [FoodTable.columns].
  int _sort = -1;
  bool _asc = true;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final cols = widget.columns;
    final sortCol = _sort < 0 || _sort >= cols.length ? null : cols[_sort];
    final rows = sortFoods(widget.items, sortCol, ascending: _asc);
    void sortBy(int i, bool asc) => setState(() {
      _sort = i;
      _asc = asc;
    });
    return DataTable(
      sortColumnIndex: (sortCol == null ? 0 : _sort + 1),
      sortAscending: _asc,
      showCheckboxColumn: false,
      columnSpacing: 20,
      columns: [
        DataColumn(label: const Text('Name'), onSort: (_, asc) => sortBy(-1, asc)),
        for (final (i, c) in cols.indexed)
          DataColumn(label: Text(c.label), numeric: c.numeric, onSort: (_, asc) => sortBy(i, asc)),
        const DataColumn(label: Text('')),
      ],
      rows: [
        for (final f in rows)
          DataRow(
            onSelectChanged: (_) => widget.onOpen(f),
            cells: [
              DataCell(ConstrainedBox(constraints: const BoxConstraints(maxWidth: 320), child: Text(f.name))),
              for (final c in cols) DataCell(Text(c.text(f))),
              DataCell(
                IconButton(
                  tooltip: f.isFavorite ? 'Favorit entfernen' : 'Als Favorit markieren',
                  icon: Icon(
                    f.isFavorite ? Icons.star : Icons.star_border,
                    color: f.isFavorite ? t.colorScheme.tertiary : null,
                  ),
                  onPressed: () => widget.onFavorite(f),
                ),
              ),
            ],
          ),
      ],
    );
  }
}

/// Dialog to choose the visible columns. Returns the new choice or null.
Future<List<FoodColumn>?> chooseFoodColumns(BuildContext context, List<FoodColumn> current) =>
    showDialog<List<FoodColumn>>(
      context: context,
      builder: (_) => _ColumnsDialog(current: current),
    );

class _ColumnsDialog extends StatefulWidget {
  const _ColumnsDialog({required this.current});
  final List<FoodColumn> current;

  @override
  State<_ColumnsDialog> createState() => _ColumnsDialogState();
}

class _ColumnsDialogState extends State<_ColumnsDialog> {
  late final Set<FoodColumn> _on = widget.current.toSet();

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('Spalten wählen'),
    content: SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final c in FoodColumn.values)
            CheckboxListTile(
              dense: true,
              value: _on.contains(c),
              title: Text(c.label),
              onChanged: (v) => setState(() => v == true ? _on.add(c) : _on.remove(c)),
            ),
        ],
      ),
    ),
    actions: [
      TextButton(onPressed: () => Navigator.pop(context), child: const Text('Abbrechen')),
      FilledButton(
        onPressed: () => Navigator.pop(context, [
          for (final c in FoodColumn.values)
            if (_on.contains(c)) c,
        ]),
        child: const Text('Übernehmen'),
      ),
    ],
  );
}
