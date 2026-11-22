import 'package:material_ui/material_ui.dart';

import '../../app.dart';
import '../../core/meal_text.dart';
import '../../core/nutrition.dart';
import '../../core/recipe_import.dart';
import '../../data/database.dart';
import '../../data/meal_text_match.dart';
import '../../data/recipe_import_client.dart';
import '../../ui/format.dart';
import '../../ui/widgets.dart';
import '../diary/amount_sheet.dart';
import '../diary/text_entry_page.dart' show foodNameFromLine;
import '../foods/food_form_page.dart';
import '../foods/food_search_page.dart';

/// Recipe from a web address (schema.org data) or a pasted ingredient list. Every ingredient is
/// matched to the user's own foods; uncertain lines must be confirmed. Nutrition values come only
/// from those foods, never from the page. Returns the new recipe id.
class RecipeImportPage extends StatefulWidget {
  const RecipeImportPage({super.key});

  @override
  State<RecipeImportPage> createState() => _RecipeImportPageState();
}

class _RecipeImportPageState extends State<RecipeImportPage> {
  final _input = TextEditingController();
  final _name = TextEditingController();
  final _servings = TextEditingController();
  final _cooked = TextEditingController();
  ImportedRecipe? _recipe;
  List<IngredientMatch> _lines = [];
  final _selected = <int>{};
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _input.dispose();
    _name.dispose();
    _servings.dispose();
    _cooked.dispose();
    super.dispose();
  }

  bool get _isAddress {
    final s = _input.text.trim();
    return !s.contains('\n') && RegExp(r'^(https?://|www\.)', caseSensitive: false).hasMatch(s);
  }

  Future<void> _load() async {
    final text = _input.text.trim();
    if (text.isEmpty) return;
    final db = context.db;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final r = _isAddress
          ? await recipePageClientFactory().load(Uri.parse(text.startsWith('www.') ? 'https://$text' : text))
          : recipeFromPastedText(text);
      if (r.ingredients.isEmpty) throw RecipeImportException('Keine Zutaten erkannt. Bitte eine Zutat pro Zeile.');
      final lines = await matchIngredients(db, r.ingredients);
      if (!mounted) return;
      setState(() {
        _recipe = r;
        _lines = lines;
        _name.text = r.name;
        _servings.text = r.servings == null ? '' : n1opt(r.servings!);
        _selected
          ..clear()
          ..addAll([
            for (var i = 0; i < lines.length; i++)
              if (lines[i].match?.isCertain ?? false) i,
          ]);
      });
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _changeFood(int i, Food f) async {
    final m = _lines[i].match!;
    final amount = await resolveFor(context.db, m.line, f);
    if (!mounted) return;
    setState(() {
      m.food = f;
      m.amount = amount;
      m.quality = MatchQuality.good;
      if (amount.amount != null) _selected.add(i);
    });
  }

  Future<void> _pickFood(int i) async {
    final f = await Navigator.push<Food>(
      context,
      MaterialPageRoute(builder: (_) => const FoodSearchPage(title: 'Zutat zuordnen')),
    );
    if (f != null && mounted) await _changeFood(i, f);
  }

  Future<void> _createFood(int i) async {
    final m = _lines[i].match!;
    final id = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (_) => FoodFormPage(initialName: foodNameFromLine(m.line.raw))),
    );
    if (id == null || !mounted) return;
    final f = await context.db.getFood(id);
    if (f != null) await _changeFood(i, f);
  }

  Future<void> _editAmount(int i) async {
    final m = _lines[i].match!;
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
      slots: const [],
      mealSlotId: '',
      confirmLabel: 'Übernehmen',
    );
    if (res == null || !mounted) return;
    setState(() {
      m.amount = ResolvedAmount(res.amount);
      _selected.add(i);
    });
  }

  List<TextMatch> get _usable => [
    for (final i in _selected.toList()..sort())
      if (_lines[i].match case final m? when m.food != null && m.amount.amount != null) m,
  ];

  Future<void> _save() async {
    final db = context.db;
    final servings = parseNum(_servings.text);
    final cooked = parseNum(_cooked.text);
    final items = [for (final m in _usable) IngredientInput.fromFood(m.food!, m.amount.amount!)];
    try {
      if (servings == null) throw ArgumentError('Bitte die Anzahl Portionen eingeben.');
      final r = _recipe!;
      final source = r.source == null ? null : 'Quelle: ${r.source}';
      final id = await db.saveRecipe(
        name: _name.text,
        servings: servings,
        cookedWeightG: cooked,
        prepMinutes: r.totalMinutes,
        instructions: [?r.instructions, ?source].join('\n\n'),
        tags: r.tags,
        items: items,
      );
      if (mounted) Navigator.pop(context, id);
    } catch (e) {
      if (mounted) showMessage(context, errorText(e));
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final r = _recipe;
    final usable = _usable;
    final total = Nutrients.sum([for (final m in usable) m.food!.per100.forAmount(m.amount.amount!)]);
    final open = [
      for (var i = 0; i < _lines.length; i++)
        if (!_lines[i].negligible && !(_selected.contains(i) && (_lines[i].match?.food != null))) i,
    ].length;
    final servings = parseNum(_servings.text);
    return Scaffold(
      appBar: AppBar(title: const Text('Rezept übernehmen')),
      bottomNavigationBar: r == null
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                child: FilledButton.icon(
                  onPressed: usable.isEmpty ? null : _save,
                  icon: const Icon(Icons.save_outlined),
                  label: Text('Rezept mit ${usable.length} Zutaten speichern'),
                ),
              ),
            ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
            children: [
              TextField(
                controller: _input,
                minLines: 1,
                maxLines: 6,
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                  labelText: 'Webadresse oder Zutatenliste',
                  hintText: 'https://… oder eine Zutat pro Zeile',
                  prefixIcon: Icon(Icons.link),
                ),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 8),
              Text(
                _isAddress
                    ? 'Die Seite wird geladen; übernommen werden Name, Portionen, Zutaten und Zubereitung. '
                          'Nährwerte rechnet die App aus deinen Lebensmitteln.'
                    : 'Ohne Webadresse wird der Text als Zutatenliste gelesen (offline).',
                style: t.textTheme.bodySmall,
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: FilledButton.tonalIcon(
                  onPressed: _busy || _input.text.trim().isEmpty ? null : _load,
                  icon: _busy
                      ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                      : const Icon(Icons.download_outlined),
                  label: Text(_isAddress ? 'Laden' : 'Zutaten erkennen'),
                ),
              ),
              if (_error != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(_error!, style: TextStyle(color: t.colorScheme.error)),
                ),
              if (r != null) ...[
                const SizedBox(height: 16),
                TextField(
                  controller: _name,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _servings,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: InputDecoration(
                          labelText: 'Portionen',
                          errorText: servings == null ? 'bitte eingeben' : null,
                        ),
                        onChanged: (_) => setState(() {}),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: _cooked,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: const InputDecoration(
                          labelText: 'Gewicht nach dem Kochen',
                          suffixText: 'g',
                          helperText: 'optional, für Werte je 100 g',
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SectionCard(
                  title: 'Zutaten',
                  icon: Icons.checklist,
                  trailing: Text(
                    servings == null ? kcal(total.kcal) : '${kcal(total.kcal / servings)} / Portion',
                    style: t.textTheme.labelMedium,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        open == 0
                            ? 'Alle Zutaten zugeordnet.'
                            : '$open Zutaten noch offen: bitte prüfen, zuordnen oder abwählen. '
                                  'Nur angehakte Zutaten werden übernommen.',
                        style: t.textTheme.bodySmall,
                      ),
                      for (var i = 0; i < _lines.length; i++) _line(context, i),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _line(BuildContext context, int i) {
    final t = Theme.of(context);
    final l = _lines[i];
    final m = l.match;
    if (m == null) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            const SizedBox(width: 48),
            Expanded(
              child: Text(
                '„${l.raw}“ · ohne Nährwerte',
                style: t.textTheme.bodySmall?.copyWith(color: t.colorScheme.onSurfaceVariant),
              ),
            ),
          ],
        ),
      );
    }
    final f = m.food;
    final a = m.amount.amount;
    final notes = [
      if (f != null && m.quality == MatchQuality.uncertain) 'unsichere Zuordnung, bitte prüfen',
      ?m.amount.note,
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Checkbox(
            value: _selected.contains(i),
            onChanged: f == null || a == null
                ? null
                : (v) => setState(() => v == true ? _selected.add(i) : _selected.remove(i)),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('„${l.raw}“', style: t.textTheme.labelMedium?.copyWith(color: t.colorScheme.onSurfaceVariant)),
                InkWell(
                  onTap: () => _pickFood(i),
                  child: Text(
                    f == null
                        ? 'Nicht gefunden – tippen zum Zuordnen'
                        : (f.brand == null ? f.name : '${f.name} · ${f.brand}'),
                    style: t.textTheme.titleMedium?.copyWith(
                      color: f == null ? t.colorScheme.error : null,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                for (final n in notes)
                  Row(
                    children: [
                      Icon(Icons.info_outline, size: 14, color: t.colorScheme.tertiary),
                      const SizedBox(width: 4),
                      Expanded(child: Text(n, style: t.textTheme.bodySmall)),
                    ],
                  ),
                if (f == null)
                  TextButton.icon(
                    onPressed: () => _createFood(i),
                    icon: const Icon(Icons.add),
                    label: const Text('Lebensmittel anlegen'),
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
                    if (a != null) Text(kcal(f.per100.forAmount(a).kcal), style: t.textTheme.bodySmall),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
