import 'package:material_ui/material_ui.dart';

import '../../core/nutrition.dart';
import '../../data/database.dart';
import '../../ui/format.dart';
import '../../ui/widgets.dart';

/// Result of the amount sheet: amount and (optionally changed) meal.
typedef AmountResult = ({double amount, String mealSlotId});

/// Asks for an amount in g/ml and shows the resulting nutrients with the calculation.
Future<AmountResult?> showAmountSheet(
  BuildContext context, {
  required String name,
  String? brand,
  required String unit,
  required Nutrients per100,
  double? servingAmount,
  String? servingLabel,
  double? initialAmount,

  /// The amount the user usually logs (learned portion); shown as the first chip.
  double? usualAmount,
  required List<MealSlot> slots,
  required String mealSlotId,
  String confirmLabel = 'Hinzufügen',
}) => showModalBottomSheet<AmountResult>(
  context: context,
  isScrollControlled: true,
  showDragHandle: true,
  builder: (_) => _AmountSheet(
    name: name,
    brand: brand,
    unit: unit,
    per100: per100,
    servingAmount: servingAmount,
    servingLabel: servingLabel,
    initialAmount: initialAmount,
    usualAmount: usualAmount,
    slots: slots,
    mealSlotId: mealSlotId,
    confirmLabel: confirmLabel,
  ),
);

class _AmountSheet extends StatefulWidget {
  const _AmountSheet({
    required this.name,
    this.brand,
    required this.unit,
    required this.per100,
    this.servingAmount,
    this.servingLabel,
    this.initialAmount,
    this.usualAmount,
    required this.slots,
    required this.mealSlotId,
    required this.confirmLabel,
  });

  final String name;
  final String? brand;
  final String unit;
  final Nutrients per100;
  final double? servingAmount;
  final String? servingLabel;
  final double? initialAmount;
  final double? usualAmount;
  final List<MealSlot> slots;
  final String mealSlotId;
  final String confirmLabel;

  @override
  State<_AmountSheet> createState() => _AmountSheetState();
}

class _AmountSheetState extends State<_AmountSheet> {
  late final _c = TextEditingController(
    text: numField(widget.initialAmount ?? widget.usualAmount ?? widget.servingAmount ?? 100),
  );
  late String _slot = widget.mealSlotId;

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  double? get _amount {
    final v = parseNum(_c.text);
    return (v != null && v > 0 && v <= 5000) ? v : null;
  }

  void _set(double v) => setState(() => _c.text = numField(v));

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final a = _amount;
    final n = a == null ? null : widget.per100.forAmount(a);
    final u = widget.unit;
    final chips = <(String, double)>[
      if (widget.usualAmount != null) ('Wie üblich (${n1opt(widget.usualAmount!)} $u)', widget.usualAmount!),
      if (widget.servingAmount != null)
        ('1 ${widget.servingLabel ?? 'Portion'} (${n1opt(widget.servingAmount!)} $u)', widget.servingAmount!),
      for (final v in const [50.0, 100.0, 150.0, 200.0, 250.0]) ('${n0(v)} $u', v),
    ];
    final slotValid = widget.slots.any((s) => s.id == _slot);
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 0, 20, MediaQuery.viewInsetsOf(context).bottom + 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(widget.name, style: t.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
          if (widget.brand != null) Text(widget.brand!, style: t.textTheme.bodyMedium),
          const SizedBox(height: 4),
          Text(
            '${kcal(widget.per100.kcal)} pro 100 $u',
            style: t.textTheme.bodySmall?.copyWith(color: t.colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _c,
                  autofocus: true,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    labelText: 'Menge',
                    suffixText: u,
                    errorText: a == null ? 'Menge zwischen 0 und 5000 $u' : null,
                  ),
                  onChanged: (_) => setState(() {}),
                  onSubmitted: (_) => _confirm(),
                ),
              ),
              if (widget.slots.length > 1 && slotValid) ...[
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: _slot,
                    isExpanded: true,
                    decoration: const InputDecoration(labelText: 'Mahlzeit'),
                    items: [for (final s in widget.slots) DropdownMenuItem(value: s.id, child: Text(s.name))],
                    onChanged: (v) => setState(() => _slot = v ?? _slot),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [for (final c in chips) ActionChip(label: Text(c.$1), onPressed: () => _set(c.$2))],
          ),
          const SizedBox(height: 16),
          if (n != null)
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: t.colorScheme.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: StatValue(label: 'Kalorien', value: kcal(n.kcal)),
                      ),
                      Expanded(
                        child: StatValue(label: 'Protein', value: grams(n.protein)),
                      ),
                      Expanded(
                        child: StatValue(label: 'Kohlenh.', value: grams(n.carbs)),
                      ),
                      Expanded(
                        child: StatValue(label: 'Fett', value: grams(n.fat)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Rechenweg: ${n1opt(widget.per100.kcal)} kcal × ${n1opt(a!)} $u ÷ 100 = ${n1opt(n.kcal)} kcal'
                    ' · Ballaststoffe ${grams(n.fiber)}',
                    style: t.textTheme.bodySmall?.copyWith(color: t.colorScheme.onSurfaceVariant),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 16),
          FilledButton(onPressed: a == null ? null : _confirm, child: Text(widget.confirmLabel)),
        ],
      ),
    );
  }

  void _confirm() {
    final a = _amount;
    if (a == null) return;
    Navigator.pop<AmountResult>(context, (amount: a, mealSlotId: _slot));
  }
}
