import 'package:material_ui/material_ui.dart';

import '../../app.dart';
import '../../core/nutrition.dart';
import '../../data/database.dart';
import '../../ui/format.dart';
import '../../ui/widgets.dart';

/// Create or edit a food. Returns the food id on save.
class FoodFormPage extends StatefulWidget {
  const FoodFormPage({super.key, this.food, this.initialName, this.copyOf});

  /// Edit this user food.
  final Food? food;

  /// Create a new user food prefilled from this one (e.g. a base food).
  final Food? copyOf;
  final String? initialName;

  @override
  State<FoodFormPage> createState() => _FoodFormPageState();
}

class _FoodFormPageState extends State<FoodFormPage> {
  final _form = GlobalKey<FormState>();
  Food? get _src => widget.food ?? widget.copyOf;
  late final _name = TextEditingController(
    text: widget.food?.name ?? (widget.copyOf != null ? '${widget.copyOf!.name} (eigen)' : widget.initialName ?? ''),
  );
  late final _brand = TextEditingController(text: _src?.brand ?? '');
  late final _barcode = TextEditingController(text: widget.food?.barcode ?? '');
  late final _category = TextEditingController(text: _src?.category ?? '');
  late final _kcal = TextEditingController(text: numField(_src?.kcal));
  late final _protein = TextEditingController(text: numField(_src?.protein));
  late final _carbs = TextEditingController(text: numField(_src?.carbs));
  late final _sugar = TextEditingController(text: numField(_src?.sugar));
  late final _fat = TextEditingController(text: numField(_src?.fat));
  late final _sat = TextEditingController(text: numField(_src?.saturatedFat));
  late final _fiber = TextEditingController(text: numField(_src?.fiber));
  late final _salt = TextEditingController(text: numField(_src?.salt));
  late final _serving = TextEditingController(text: numField(_src?.servingAmount));
  late final _servingLabel = TextEditingController(text: _src?.servingLabel ?? '');
  late String _unit = _src?.unit ?? 'g';
  String? _error;
  Food? _duplicate;

  List<TextEditingController> get _all => [
    _name,
    _brand,
    _barcode,
    _category,
    _kcal,
    _protein,
    _carbs,
    _sugar,
    _fat,
    _sat,
    _fiber,
    _salt,
    _serving,
    _servingLabel,
  ];

  @override
  void dispose() {
    for (final c in _all) {
      c.dispose();
    }
    super.dispose();
  }

  Nutrients get _n => Nutrients(
    kcal: parseNum(_kcal.text) ?? 0,
    protein: parseNum(_protein.text) ?? 0,
    carbs: parseNum(_carbs.text) ?? 0,
    sugar: parseNum(_sugar.text) ?? 0,
    fat: parseNum(_fat.text) ?? 0,
    saturatedFat: parseNum(_sat.text) ?? 0,
    fiber: parseNum(_fiber.text) ?? 0,
    salt: parseNum(_salt.text) ?? 0,
  );

  Future<void> _save() async {
    setState(() {
      _error = null;
      _duplicate = null;
    });
    if (!_form.currentState!.validate()) return;
    try {
      final id = await context.db.saveFood(
        id: widget.food?.id,
        name: _name.text,
        brand: _brand.text,
        barcode: _barcode.text,
        category: _category.text.trim().isEmpty ? null : _category.text.trim(),
        unit: _unit,
        per100: _n,
        servingAmount: parseNum(_serving.text),
        servingLabel: _servingLabel.text,
      );
      if (mounted) Navigator.pop(context, id);
    } on DuplicateFoodException catch (e) {
      setState(() {
        _error = e.message;
        _duplicate = e.existing;
      });
    } on InvalidFoodException catch (e) {
      setState(() => _error = e.errors.join('\n'));
    } catch (e) {
      setState(() => _error = errorText(e));
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final check = checkPer100(_n);
    final u = _unit;
    Widget nf(TextEditingController c, String label, {String suffix = 'g', bool required = false}) => NumberField(
      controller: c,
      label: label,
      suffix: suffix,
      validator: numRange(0, suffix == 'kcal' ? 900 : 100, required: required),
      onChanged: (_) => setState(() {}),
    );
    Widget pair(Widget a, Widget b) => Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: a),
        const SizedBox(width: 12),
        Expanded(child: b),
      ],
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.food == null ? 'Neues Lebensmittel' : 'Lebensmittel bearbeiten'),
        actions: [TextButton(onPressed: _save, child: const Text('Speichern'))],
      ),
      body: Form(
        key: _form,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
              children: [
                SectionCard(
                  title: 'Produkt',
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _name,
                        decoration: const InputDecoration(labelText: 'Name'),
                        validator: (s) => (s ?? '').trim().isEmpty ? 'Bitte einen Namen eingeben' : null,
                      ),
                      const SizedBox(height: 12),
                      pair(
                        TextFormField(
                          controller: _brand,
                          decoration: const InputDecoration(labelText: 'Marke / Hersteller'),
                        ),
                        TextFormField(
                          controller: _category,
                          decoration: const InputDecoration(labelText: 'Kategorie'),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _barcode,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Barcode (EAN, optional)',
                          helperText: 'Scanner folgt in Phase 2',
                        ),
                        validator: (s) {
                          final v = (s ?? '').replaceAll(RegExp(r'\s'), '');
                          if (v.isEmpty) return null;
                          return RegExp(r'^\d{8,14}$').hasMatch(v) ? null : '8 bis 14 Ziffern';
                        },
                      ),
                      const SizedBox(height: 12),
                      SegmentedButton<String>(
                        segments: const [
                          ButtonSegment(value: 'g', label: Text('fest (pro 100 g)')),
                          ButtonSegment(value: 'ml', label: Text('flüssig (pro 100 ml)')),
                        ],
                        selected: {_unit},
                        onSelectionChanged: (s) => setState(() => _unit = s.first),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                SectionCard(
                  title: 'Nährwerte pro 100 $u',
                  child: Column(
                    children: [
                      pair(
                        nf(_kcal, 'Energie', suffix: 'kcal', required: true),
                        nf(_protein, 'Eiweiß', required: true),
                      ),
                      const SizedBox(height: 12),
                      pair(nf(_carbs, 'Kohlenhydrate', required: true), nf(_sugar, 'davon Zucker')),
                      const SizedBox(height: 12),
                      pair(nf(_fat, 'Fett', required: true), nf(_sat, 'davon gesättigt')),
                      const SizedBox(height: 12),
                      pair(nf(_fiber, 'Ballaststoffe'), nf(_salt, 'Salz')),
                      const SizedBox(height: 12),
                      for (final e in check.errors) _note(context, e, error: true),
                      for (final w in check.warnings) _note(context, w),
                      if (check.ok && check.warnings.isEmpty && _n.kcal > 0)
                        _note(context, 'Plausibel: aus den Makros ergeben sich ${n0(_n.atwaterKcal)} kcal.', ok: true),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                SectionCard(
                  title: 'Portion (optional)',
                  child: pair(
                    NumberField(
                      controller: _serving,
                      label: 'Portionsgröße',
                      suffix: u,
                      validator: numRange(0.1, 5000, required: false),
                    ),
                    TextFormField(
                      controller: _servingLabel,
                      decoration: const InputDecoration(labelText: 'Bezeichnung', hintText: 'z. B. Scheibe, Becher'),
                    ),
                  ),
                ),
                if (_error != null) ...[
                  const SizedBox(height: 12),
                  Card(
                    color: t.colorScheme.errorContainer,
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_error!, style: TextStyle(color: t.colorScheme.onErrorContainer)),
                          if (_duplicate != null)
                            TextButton(
                              onPressed: () => Navigator.pop(context, _duplicate!.id),
                              child: const Text('Vorhandenes Lebensmittel verwenden'),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: _save,
                  style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(48)),
                  child: const Text('Speichern'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _note(BuildContext context, String s, {bool error = false, bool ok = false}) {
    final t = Theme.of(context);
    final color = error ? t.colorScheme.error : (ok ? t.colorScheme.primary : t.colorScheme.tertiary);
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            error ? Icons.error_outline : (ok ? Icons.check_circle_outline : Icons.warning_amber_rounded),
            size: 18,
            color: color,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(s, style: t.textTheme.bodySmall?.copyWith(color: color)),
          ),
        ],
      ),
    );
  }
}
