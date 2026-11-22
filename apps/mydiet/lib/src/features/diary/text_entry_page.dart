import 'package:material_ui/material_ui.dart';

import '../../app.dart';
import '../../core/meal_text.dart';
import '../../core/nutrition.dart';
import '../../data/database.dart';
import '../../data/meal_text_match.dart';
import '../../ui/format.dart';
import '../../ui/widgets.dart';
import '../foods/food_form_page.dart';
import 'amount_sheet.dart';

/// "Als Text eintragen": type a whole meal in everyday words, check the recognised
/// lines, then log the confirmed ones. Works offline; only the user's own foods are used.
class TextEntryPage extends StatefulWidget {
  const TextEntryPage({
    super.key,
    required this.day,
    required this.mealSlotId,
    required this.slots,
    this.initialText = '',
  });

  final String day;
  final String mealSlotId;
  final List<MealSlot> slots;
  final String initialText;

  @override
  State<TextEntryPage> createState() => _TextEntryPageState();
}

class _TextEntryPageState extends State<TextEntryPage> {
  late final _text = TextEditingController(text: widget.initialText);
  List<TextMatch> _matches = [];
  final Set<int> _selected = {};
  bool _busy = false;
  bool _recognised = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_recognised && widget.initialText.trim().isNotEmpty) {
      _recognised = true;
      _recognise();
    }
  }

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  Future<void> _recognise() async {
    setState(() => _busy = true);
    final m = await matchMealText(context.db, _text.text);
    if (!mounted) return;
    setState(() {
      _busy = false;
      _matches = m;
      _selected
        ..clear()
        ..addAll([
          for (var i = 0; i < m.length; i++)
            if (m[i].isCertain) i,
        ]);
    });
  }

  Nutrients _nutrientsOf(TextMatch m) {
    final f = m.food;
    final a = m.amount.amount;
    if (f == null || a == null) return Nutrients.zero;
    return f.per100.forAmount(a);
  }

  Future<void> _changeFood(int i, Food f) async {
    final m = _matches[i];
    final amount = await resolveFor(context.db, m.line, f);
    if (!mounted) return;
    setState(() {
      m.food = f;
      m.amount = amount;
      // The user picked it themselves, so the match itself is confirmed.
      m.quality = MatchQuality.good;
      if (amount.amount != null) _selected.add(i);
    });
  }

  Future<void> _editAmount(int i) async {
    final m = _matches[i];
    final f = m.food;
    if (f == null) return;
    final res = await showAmountSheet(
      context,
      name: f.name,
      brand: f.brand,
      unit: f.unit,
      per100: f.per100,
      servingAmount: f.servingAmount,
      servingLabel: f.servingLabel,
      initialAmount: m.amount.amount,
      slots: widget.slots,
      mealSlotId: widget.mealSlotId,
      confirmLabel: 'Übernehmen',
    );
    if (res == null || !mounted) return;
    setState(() {
      m.amount = ResolvedAmount(res.amount);
      _selected.add(i);
    });
  }

  Future<void> _createFood(int i) async {
    final m = _matches[i];
    final id = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (_) => FoodFormPage(initialName: foodNameFromLine(m.line.raw))),
    );
    if (id == null || !mounted) return;
    final f = await context.db.getFood(id);
    if (f != null) await _changeFood(i, f);
  }

  Future<void> _logSelected() async {
    final db = context.db;
    final items = [
      for (final i in _selected.toList()..sort())
        if (_matches[i].food != null && _matches[i].amount.amount != null) _matches[i],
    ];
    if (items.isEmpty) return;
    try {
      for (final m in items) {
        await db.logFood(day: widget.day, mealSlotId: widget.mealSlotId, food: m.food!, amount: m.amount.amount!);
      }
      if (!mounted) return;
      Navigator.pop(context, items.length);
    } catch (e) {
      if (mounted) showMessage(context, errorText(e));
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final total = Nutrients.sum([for (final i in _selected) _nutrientsOf(_matches[i])]);
    final open = _matches.length - _selected.length;
    return Scaffold(
      appBar: AppBar(title: const Text('Als Text eintragen')),
      bottomNavigationBar: _matches.isEmpty
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _selected.isEmpty
                            ? 'Nichts ausgewählt'
                            : '${kcal(total.kcal)} · P ${grams(total.protein)}'
                                  '${open > 0 ? '\n$open ${open == 1 ? 'Zeile' : 'Zeilen'} nicht bestätigt' : ''}',
                        style: t.textTheme.bodyMedium,
                      ),
                    ),
                    FilledButton.icon(
                      onPressed: _selected.isEmpty ? null : _logSelected,
                      icon: const Icon(Icons.check),
                      label: Text('${_selected.length} eintragen'),
                    ),
                  ],
                ),
              ),
            ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
            children: [
              TextField(
                controller: _text,
                autofocus: widget.initialText.isEmpty,
                minLines: 2,
                maxLines: 5,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(
                  labelText: 'Was hast du gegessen?',
                  hintText: 'z. B. 200 g Hähnchen, 2 Eier, 1 Banane, 1 EL Olivenöl',
                  border: OutlineInputBorder(),
                ),
                onChanged: (_) => setState(() {}),
                onSubmitted: (_) => _recognise(),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Wird auf dem Gerät erkannt, nur mit deinen Lebensmitteln. '
                      'Unsichere Zeilen sind markiert und erst nach deinem Häkchen dabei.',
                      style: t.textTheme.bodySmall?.copyWith(color: t.colorScheme.onSurfaceVariant),
                    ),
                  ),
                  const SizedBox(width: 8),
                  FilledButton.tonalIcon(
                    onPressed: _busy || _text.text.trim().isEmpty ? null : _recognise,
                    icon: const Icon(Icons.auto_fix_high),
                    label: const Text('Erkennen'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (_busy) const LinearProgressIndicator(),
              for (var i = 0; i < _matches.length; i++) _line(context, i),
            ],
          ),
        ),
      ),
    );
  }

  Widget _line(BuildContext context, int i) {
    final t = Theme.of(context);
    final m = _matches[i];
    final f = m.food;
    final a = m.amount.amount;
    final unsure = !m.isCertain;
    final notes = [
      if (m.quality == MatchQuality.uncertain) 'Treffer unsicher, bitte prüfen',
      if (m.amount.note != null) m.amount.note!,
    ];
    final selectable = f != null && a != null;
    return Card(
      color: unsure && !_selected.contains(i) ? t.colorScheme.tertiaryContainer.withValues(alpha: 0.5) : null,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(4, 8, 12, 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Checkbox(
              value: _selected.contains(i),
              onChanged: selectable ? (v) => setState(() => v == true ? _selected.add(i) : _selected.remove(i)) : null,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '„${m.line.raw}“',
                    style: t.textTheme.labelMedium?.copyWith(color: t.colorScheme.onSurfaceVariant),
                  ),
                  const SizedBox(height: 2),
                  if (f == null)
                    Text('Nicht gefunden', style: t.textTheme.titleMedium?.copyWith(color: t.colorScheme.error))
                  else if (m.candidates.length > 1)
                    DropdownButton<String>(
                      value: f.id,
                      isExpanded: true,
                      isDense: true,
                      underline: const SizedBox(),
                      items: [
                        for (final c in m.candidates)
                          DropdownMenuItem(
                            value: c.id,
                            child: Text(
                              c.brand == null ? c.name : '${c.name} · ${c.brand}',
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                      ],
                      onChanged: (id) {
                        final c = m.candidates.firstWhere((c) => c.id == id);
                        _changeFood(i, c);
                      },
                    )
                  else
                    Text(f.name, style: t.textTheme.titleMedium),
                  for (final n in notes)
                    Row(
                      children: [
                        Icon(Icons.info_outline, size: 14, color: t.colorScheme.tertiary),
                        const SizedBox(width: 4),
                        Expanded(child: Text(n, style: t.textTheme.bodySmall)),
                      ],
                    ),
                  if (f == null)
                    Wrap(
                      spacing: 8,
                      children: [
                        TextButton.icon(
                          onPressed: () => _createFood(i),
                          icon: const Icon(Icons.add),
                          label: const Text('Lebensmittel anlegen'),
                        ),
                      ],
                    ),
                ],
              ),
            ),
            if (f != null)
              InkWell(
                onTap: () => _editAmount(i),
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        a == null ? 'Menge?' : amountWithUnit(a, f.unit),
                        style: t.textTheme.titleSmall?.copyWith(
                          color: a == null ? t.colorScheme.error : null,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      if (a != null) Text(kcal(_nutrientsOf(m).kcal), style: t.textTheme.bodySmall),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Name for a new food from a typed line: the leading amount and unit are dropped
/// ("200 g Drachenfrucht" -> "Drachenfrucht").
String foodNameFromLine(String raw) => raw
    .replaceFirst(
      RegExp(
        r'^\s*[\d.,/½¼¾]*\s*(g|gr|gramm|kg|ml|l|cl|el|tl|stück|stk|scheiben?|becher|glas|tassen?|portionen?)?\.?\s+',
        caseSensitive: false,
      ),
      '',
    )
    .trim();

/// True when a search text looks like a whole meal rather than one food name:
/// several parts, or an amount with a unit.
bool looksLikeMealText(String text) {
  final t = text.trim();
  if (t.isEmpty) return false;
  if (RegExp(r'[,;\n+]|\s+und\s+', caseSensitive: false).hasMatch(t)) return true;
  return RegExp(r'\d').hasMatch(t) && RegExp(r'[a-zA-ZäöüÄÖÜ]{2,}').hasMatch(t);
}
