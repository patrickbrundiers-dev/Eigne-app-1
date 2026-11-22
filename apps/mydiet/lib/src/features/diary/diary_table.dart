import 'package:material_ui/material_ui.dart';

import '../../data/database.dart';
import '../../ui/format.dart';
import '../../ui/table_columns.dart';

/// Columns of the diary table on wide screens (PC). Values for the eaten amount.
enum DiaryColumn {
  amount('Menge'),
  brand('Marke'),
  kcal('kcal'),
  protein('Eiweiß'),
  carbs('Kohlenh.'),
  sugar('Zucker'),
  fat('Fett'),
  saturatedFat('ges. Fett'),
  fiber('Ballastst.'),
  salt('Salz');

  const DiaryColumn(this.label);
  final String label;

  /// Columns that show nutrient numbers (hidden with „Zahlen ausblenden“).
  bool get numeric => this != amount && this != brand;

  String text(DiaryEntry e) {
    final n = e.nutrients;
    return switch (this) {
      amount => amountWithUnit(e.amount, e.unit),
      brand => e.brand ?? '',
      kcal => n0(n.kcal),
      protein => n1opt(n.protein),
      carbs => n1opt(n.carbs),
      sugar => n1opt(n.sugar),
      fat => n1opt(n.fat),
      saturatedFat => n1opt(n.saturatedFat),
      fiber => n1opt(n.fiber),
      salt => n1opt(n.salt),
    };
  }
}

const diaryTableColumnsKey = 'diaryTableColumns';
const defaultDiaryColumns = [
  DiaryColumn.amount,
  DiaryColumn.kcal,
  DiaryColumn.protein,
  DiaryColumn.carbs,
  DiaryColumn.fat,
];

List<DiaryColumn> parseDiaryColumns(String? json) => parseColumns(json, DiaryColumn.values, defaultDiaryColumns);

String encodeDiaryColumns(Iterable<DiaryColumn> cols) => encodeColumns(cols);

Future<List<DiaryColumn>?> chooseDiaryColumns(BuildContext context, List<DiaryColumn> current) =>
    chooseColumns(context, all: DiaryColumn.values, current: current, label: (c) => c.label);

/// Visible columns: with hidden numbers only amount and brand remain.
List<DiaryColumn> visibleDiaryColumns(List<DiaryColumn> chosen, {required bool hideNumbers}) => [
  for (final c in chosen)
    if (!hideNumbers || !c.numeric) c,
];

/// The entries of one meal as a table. Order stays as in the diary.
class DiaryTable extends StatelessWidget {
  const DiaryTable({
    super.key,
    required this.entries,
    required this.columns,
    required this.onEdit,
    required this.onDelete,
  });

  final List<DiaryEntry> entries;
  final List<DiaryColumn> columns;
  final void Function(DiaryEntry) onEdit;
  final void Function(DiaryEntry) onDelete;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: DataTable(
      showCheckboxColumn: false,
      columnSpacing: 20,
      headingRowHeight: 36,
      dataRowMinHeight: 36,
      dataRowMaxHeight: 44,
      columns: [
        const DataColumn(label: Text('Lebensmittel')),
        for (final c in columns) DataColumn(label: Text(c.label), numeric: c.numeric),
        const DataColumn(label: Text('')),
      ],
      rows: [
        for (final e in entries)
          DataRow(
            onSelectChanged: (_) => onEdit(e),
            cells: [
              DataCell(ConstrainedBox(constraints: const BoxConstraints(maxWidth: 320), child: Text(e.foodName))),
              for (final c in columns) DataCell(Text(c.text(e))),
              DataCell(
                IconButton(
                  tooltip: '${e.foodName} entfernen',
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () => onDelete(e),
                ),
              ),
            ],
          ),
      ],
    ),
  );
}
