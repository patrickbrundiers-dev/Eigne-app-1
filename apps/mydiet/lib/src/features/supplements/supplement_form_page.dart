import 'package:material_ui/material_ui.dart';

import '../../app.dart';
import '../../core/micronutrients.dart';
import '../../core/supplements.dart';
import '../../data/database.dart';
import '../../ui/format.dart';
import '../../ui/widgets.dart';

/// Create or edit a supplement product with its ingredients per serving.
class SupplementFormPage extends StatefulWidget {
  const SupplementFormPage({super.key, this.existing});
  final SupplementWithDoses? existing;

  @override
  State<SupplementFormPage> createState() => _SupplementFormPageState();
}

class _SupplementFormPageState extends State<SupplementFormPage> {
  final _form = GlobalKey<FormState>();
  late final Supplement? _s = widget.existing?.supplement;
  late final _name = TextEditingController(text: _s?.name ?? '');
  late final _brand = TextEditingController(text: _s?.brand ?? '');
  late final _form_ = TextEditingController(text: _s?.form ?? '');
  late final _serving = TextEditingController(text: _s?.servingLabel ?? 'Kapsel');
  late final _maker = TextEditingController(text: _s?.manufacturerDose ?? '');
  late final _perDay = TextEditingController(text: numField(_s?.servingsPerDay ?? 1));
  late final _stock = TextEditingController(text: numField(_s?.stockServings));
  late final _note = TextEditingController(text: _s?.note ?? '');
  late List<int> _times = _s?.times ?? [];
  late bool _active = _s?.active ?? true;
  late final List<SupplementDose> _doses = [...?widget.existing?.doses];
  bool _saving = false;

  @override
  void dispose() {
    for (final c in [_name, _brand, _form_, _serving, _maker, _perDay, _stock, _note]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _addTime() async {
    final t = await showTimePicker(context: context, initialTime: const TimeOfDay(hour: 8, minute: 0));
    if (t == null) return;
    setState(() => _times = ({..._times, t.hour * 60 + t.minute}.toList()..sort()));
  }

  Future<void> _editDose([int? index]) async {
    final d = await showModalBottomSheet<SupplementDose>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => _DoseSheet(initial: index == null ? null : _doses[index]),
    );
    if (d == null) return;
    setState(() => index == null ? _doses.add(d) : _doses[index] = d);
  }

  Future<void> _save() async {
    if (!_form.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      final db = context.db;
      final first = (await db.watchSupplements().first).isEmpty;
      await db.saveSupplement(
        id: _s?.id,
        name: _name.text,
        brand: _brand.text,
        form: _form_.text,
        servingLabel: _serving.text,
        manufacturerDose: _maker.text,
        servingsPerDay: parseNum(_perDay.text) ?? 1,
        times: _times,
        active: _active,
        stockServings: parseNum(_stock.text),
        note: _note.text,
        doses: _doses,
      );
      if (first) await showSupplementTile(db);
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) showMessage(context, errorText(e));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  /// "Enthält ebenfalls Zink (Multi A), zusammen 38 mg pro Tag" for other active products.
  Widget _overlaps(BuildContext context) {
    final t = Theme.of(context);
    return StreamBuilder<List<SupplementWithDoses>>(
      stream: context.db.watchSupplements(activeOnly: true),
      builder: (context, snap) {
        final others = [
          for (final o in snap.data ?? const <SupplementWithDoses>[])
            if (o.supplement.id != _s?.id)
              SupplementUse(product: o.label, servings: o.supplement.servingsPerDay, doses: o.doses),
        ];
        return ValueListenableBuilder<TextEditingValue>(
          valueListenable: _perDay,
          builder: (context, _, _) {
            final list = supplementOverlaps(
              newDoses: _doses,
              newServingsPerDay: parseNum(_perDay.text) ?? 1,
              others: others,
            );
            if (list.isEmpty) return const SizedBox.shrink();
            final over = list.any((o) => o.overLimit);
            return Container(
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: over ? t.colorScheme.errorContainer : t.colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final o in list)
                    Text(
                      'Enthält ebenfalls ${o.info.name} (${o.others.join(', ')}): zusammen '
                      '${n1opt(o.combined)} ${o.info.unit} pro Tag'
                      '${o.overLimit ? ' – über der Höchstmenge von ${n1opt(o.info.ul!)} ${o.info.unit}' : ''}.',
                      style: TextStyle(
                        color: over ? t.colorScheme.onErrorContainer : t.colorScheme.onSecondaryContainer,
                      ),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(_s == null ? 'Neues Supplement' : 'Supplement bearbeiten'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilledButton(onPressed: _saving ? null : _save, child: const Text('Speichern')),
          ),
        ],
      ),
      body: Form(
        key: _form,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
              children: [
                TextFormField(
                  controller: _name,
                  decoration: const InputDecoration(labelText: 'Produkt', hintText: 'z. B. Vitamin D3 + K2'),
                  validator: (v) => (v ?? '').trim().isEmpty ? 'Bitte einen Namen eingeben' : null,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _brand,
                        decoration: const InputDecoration(labelText: 'Marke (optional)'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _form_,
                        decoration: const InputDecoration(labelText: 'Form', hintText: 'Kapsel, Pulver …'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Inhaltsstoffe pro Portion',
                        style: t.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                      ),
                    ),
                    TextButton.icon(onPressed: _editDose, icon: const Icon(Icons.add), label: const Text('Hinzufügen')),
                  ],
                ),
                TextFormField(
                  controller: _serving,
                  decoration: const InputDecoration(
                    labelText: 'Eine Portion ist',
                    hintText: 'z. B. 1 Kapsel, 2 Tabletten, 5 g',
                  ),
                ),
                const SizedBox(height: 4),
                if (_doses.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      'Trage die Werte vom Etikett ein, z. B. Vitamin D 20 µg.',
                      style: t.textTheme.bodyMedium?.copyWith(color: t.colorScheme.onSurfaceVariant),
                    ),
                  ),
                for (final (i, d) in _doses.indexed)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(d.displayName),
                    subtitle: _nrvText(d) == null ? null : Text(_nrvText(d)!),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('${n1opt(d.amount)} ${d.unit}', style: const TextStyle(fontWeight: FontWeight.w600)),
                        IconButton(
                          tooltip: 'Entfernen',
                          icon: const Icon(Icons.remove_circle_outline),
                          onPressed: () => setState(() => _doses.removeAt(i)),
                        ),
                      ],
                    ),
                    onTap: () => _editDose(i),
                  ),
                if (_doses.isNotEmpty) _overlaps(context),
                const SizedBox(height: 20),
                Text('Einnahme', style: t.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _maker,
                  decoration: const InputDecoration(
                    labelText: 'Verzehrempfehlung des Herstellers',
                    hintText: 'wie auf der Packung, z. B. 1 Kapsel täglich',
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: NumberField(
                        controller: _perDay,
                        label: 'Portionen pro Tag',
                        helper: 'deine Einnahme',
                        validator: numRange(0, 50),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: NumberField(
                        controller: _stock,
                        label: 'Vorrat (optional)',
                        suffix: 'Port.',
                        validator: numRange(0, 100000, required: false),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text('Uhrzeiten:', style: t.textTheme.bodyMedium),
                    for (final m in _times)
                      InputChip(
                        label: Text(timeOfDay(m)),
                        onDeleted: () => setState(() => _times = [..._times]..remove(m)),
                      ),
                    ActionChip(
                      avatar: const Icon(Icons.add, size: 18),
                      label: const Text('Uhrzeit'),
                      onPressed: _addTime,
                    ),
                  ],
                ),
                if (_times.length > 1)
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      'Die Portionen pro Tag werden gleichmäßig auf die Uhrzeiten verteilt.',
                      style: t.textTheme.bodySmall?.copyWith(color: t.colorScheme.onSurfaceVariant),
                    ),
                  ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Nehme ich aktuell'),
                  subtitle: const Text('Pausierte Produkte zählen nicht zur Tagessumme.'),
                  value: _active,
                  onChanged: (v) => setState(() => _active = v),
                ),
                TextFormField(
                  controller: _note,
                  decoration: const InputDecoration(labelText: 'Notiz (optional)'),
                  maxLines: 3,
                  minLines: 1,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String? _nrvText(SupplementDose d) {
    final info = nutrientById(d.nutrientId);
    if (info?.nrv == null) return null;
    final p = convertUnit(d.amount, from: d.unit, to: info!.unit) / info.nrv! * 100;
    return '${n0(p)} % des Referenzwerts (NRV)';
  }
}

class _DoseSheet extends StatefulWidget {
  const _DoseSheet({this.initial});
  final SupplementDose? initial;

  @override
  State<_DoseSheet> createState() => _DoseSheetState();
}

class _DoseSheetState extends State<_DoseSheet> {
  static const _custom = '__custom';
  late String _id = widget.initial == null
      ? 'vit_d'
      : (nutrientById(widget.initial!.nutrientId) == null ? _custom : widget.initial!.nutrientId);
  late final _amount = TextEditingController(text: numField(widget.initial?.amount));
  late final _customName = TextEditingController(text: _id == _custom ? widget.initial?.displayName ?? '' : '');
  late String _unit = widget.initial?.unit ?? nutrientById(_id)?.unit ?? 'mg';

  @override
  void dispose() {
    _amount.dispose();
    _customName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final info = nutrientById(_id);
    final units = _id == 'vit_d' ? const ['µg', 'mg', 'IE'] : const ['µg', 'mg', 'g'];
    if (!units.contains(_unit)) _unit = units.first;
    final a = parseNum(_amount.text);
    final valid = a != null && a > 0 && (_id != _custom || _customName.text.trim().isNotEmpty);
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 0, 20, MediaQuery.viewInsetsOf(context).bottom + 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DropdownButtonFormField<String>(
            initialValue: _id,
            isExpanded: true,
            decoration: const InputDecoration(labelText: 'Inhaltsstoff'),
            items: [
              for (final n in nutrientCatalog) DropdownMenuItem(value: n.id, child: Text(n.name)),
              const DropdownMenuItem(value: _custom, child: Text('Anderer Inhaltsstoff …')),
            ],
            onChanged: (v) => setState(() {
              _id = v ?? _id;
              _unit = nutrientById(_id)?.unit ?? _unit;
            }),
          ),
          if (_id == _custom) ...[
            const SizedBox(height: 12),
            TextField(
              controller: _customName,
              decoration: const InputDecoration(labelText: 'Name', hintText: 'z. B. Ashwagandha-Extrakt'),
              onChanged: (_) => setState(() {}),
            ),
          ],
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: TextField(
                  controller: _amount,
                  autofocus: true,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(labelText: 'Menge pro Portion'),
                  onChanged: (_) => setState(() {}),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: _unit,
                  decoration: const InputDecoration(labelText: 'Einheit'),
                  items: [for (final u in units) DropdownMenuItem(value: u, child: Text(u))],
                  onChanged: (v) => setState(() => _unit = v ?? _unit),
                ),
              ),
            ],
          ),
          if (_unit == 'IE' && a != null)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text('${n1opt(a)} IE = ${n1opt(vitaminDIuToUg(a))} µg (1 µg = 40 IE)'),
            ),
          if (info?.ul != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                'Tolerierbare Höchstmenge (EFSA, Erwachsene): ${n1opt(info!.ul!)} ${info.unit} pro Tag'
                '${info.ulScope == UpperLimitScope.supplementsOnly ? ' aus Nahrungsergänzung' : ' insgesamt'}'
                '${info.ulNote != null ? ' (${info.ulNote})' : ''}.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: !valid
                ? null
                : () {
                    final ie = _unit == 'IE';
                    Navigator.pop(
                      context,
                      SupplementDose(
                        nutrientId: _id == _custom ? 'custom:${_customName.text.trim()}' : _id,
                        name: _id == _custom ? _customName.text.trim() : null,
                        amount: ie ? vitaminDIuToUg(a) : a,
                        unit: ie ? 'µg' : _unit,
                      ),
                    );
                  },
            child: const Text('Übernehmen'),
          ),
        ],
      ),
    );
  }
}

/// Shows the dashboard tile for supplements (used when the first product is created).
Future<void> showSupplementTile(AppDatabase db) async {
  await db.setDashTileVisible('supplements', true);
}
