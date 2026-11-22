import 'package:material_ui/material_ui.dart';

import '../../app.dart';
import '../../core/recipes.dart';
import '../../data/database.dart';
import '../../ui/format.dart';
import '../../ui/widgets.dart';
import '../diary/amount_sheet.dart';
import '../foods/food_search_page.dart';

/// Create or edit a recipe: ingredients, servings, optional cooked weight.
class RecipeFormPage extends StatefulWidget {
  const RecipeFormPage({super.key, this.recipe, this.items = const []});
  final Recipe? recipe;
  final List<RecipeItem> items;

  @override
  State<RecipeFormPage> createState() => _RecipeFormPageState();
}

class _RecipeFormPageState extends State<RecipeFormPage> {
  final _form = GlobalKey<FormState>();
  late final _name = TextEditingController(text: widget.recipe?.name ?? '');
  late final _servings = TextEditingController(text: numField(widget.recipe?.servings ?? 2));
  late final _cooked = TextEditingController(text: numField(widget.recipe?.cookedWeightG));
  late final _prep = TextEditingController(text: widget.recipe?.prepMinutes?.toString() ?? '');
  late final _steps = TextEditingController(text: widget.recipe?.instructions ?? '');
  late List<String> _tags = widget.recipe?.tags ?? [];
  late final List<IngredientInput> _items = [for (final i in widget.items) IngredientInput.fromItem(i)];
  bool _saving = false;

  @override
  void dispose() {
    for (final c in [_name, _servings, _cooked, _prep, _steps]) {
      c.dispose();
    }
    super.dispose();
  }

  RecipeNutrition? get _nutrition {
    final s = parseNum(_servings.text);
    if (s == null || !(s > 0)) return null;
    final cooked = parseNum(_cooked.text);
    return recipeNutrition([for (final i in _items) i.ingredient], servings: s, cookedWeight: cooked);
  }

  Future<double?> _askAmount(IngredientInput i, {double? initial, Food? food}) async {
    final res = await showAmountSheet(
      context,
      name: i.name,
      brand: i.brand,
      unit: i.unit,
      per100: i.per100,
      servingAmount: food?.servingAmount,
      servingLabel: food?.servingLabel,
      initialAmount: initial,
      slots: const [],
      mealSlotId: '',
      confirmLabel: 'Übernehmen',
    );
    return res?.amount;
  }

  Future<void> _addIngredient() async {
    final f = await Navigator.push<Food>(context, MaterialPageRoute(builder: (_) => const FoodSearchPage()));
    if (f == null || !mounted) return;
    final draft = IngredientInput.fromFood(f, 100);
    final a = await _askAmount(draft, food: f);
    if (a == null) return;
    setState(() => _items.add(draft.withAmount(a)));
  }

  Future<void> _editIngredient(int index) async {
    final i = _items[index];
    final a = await _askAmount(i, initial: i.amount);
    if (a == null) return;
    setState(() => _items[index] = i.withAmount(a));
  }

  Future<void> _save() async {
    if (!_form.currentState!.validate()) return;
    if (_items.isEmpty) {
      showMessage(context, 'Bitte mindestens eine Zutat hinzufügen.');
      return;
    }
    setState(() => _saving = true);
    try {
      final id = await context.db.saveRecipe(
        id: widget.recipe?.id,
        name: _name.text,
        servings: parseNum(_servings.text)!,
        cookedWeightG: parseNum(_cooked.text),
        prepMinutes: int.tryParse(_prep.text.trim()),
        instructions: _steps.text,
        tags: _tags,
        items: _items,
      );
      if (mounted) Navigator.pop(context, id);
    } catch (e) {
      if (mounted) showMessage(context, errorText(e));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final n = _nutrition;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.recipe == null ? 'Neues Rezept' : 'Rezept bearbeiten'),
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
                  decoration: const InputDecoration(labelText: 'Name'),
                  textCapitalization: TextCapitalization.sentences,
                  validator: (v) => (v ?? '').trim().isEmpty ? 'Bitte einen Namen eingeben' : null,
                ),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: NumberField(
                        controller: _servings,
                        label: 'Portionen',
                        validator: numRange(0.5, 100),
                        onChanged: (_) => setState(() {}),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: NumberField(
                        controller: _prep,
                        label: 'Zubereitung',
                        suffix: 'min',
                        decimals: false,
                        validator: numRange(0, 1440, required: false),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                NumberField(
                  controller: _cooked,
                  label: 'Gewicht nach dem Kochen (optional)',
                  suffix: 'g',
                  helper: 'Gewogenes Endgewicht. Dann stimmen auch Angaben in Gramm, z. B. 250 g Eintopf.',
                  validator: numRange(1, 50000, required: false),
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Text('Zutaten', style: t.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                    ),
                    TextButton.icon(onPressed: _addIngredient, icon: const Icon(Icons.add), label: const Text('Zutat')),
                  ],
                ),
                if (_items.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      'Noch keine Zutaten. Füge Lebensmittel aus deiner Datenbank hinzu.',
                      style: t.textTheme.bodyMedium?.copyWith(color: t.colorScheme.onSurfaceVariant),
                    ),
                  ),
                for (final (idx, i) in _items.indexed)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(i.brand == null ? i.name : '${i.name} (${i.brand})'),
                    subtitle: Text('${amountWithUnit(i.amount, i.unit)} · ${kcal(i.ingredient.nutrients.kcal)}'),
                    onTap: () => _editIngredient(idx),
                    trailing: IconButton(
                      tooltip: 'Entfernen',
                      icon: const Icon(Icons.remove_circle_outline),
                      onPressed: () => setState(() => _items.removeAt(idx)),
                    ),
                  ),
                if (n != null && _items.isNotEmpty) ...[const SizedBox(height: 8), RecipeNutritionSummary(n: n)],
                const SizedBox(height: 20),
                ChipListField(
                  label: 'Stichworte',
                  hint: 'z. B. schnell, Meal Prep, vegetarisch',
                  items: _tags,
                  onChanged: (v) => setState(() => _tags = v),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _steps,
                  decoration: const InputDecoration(labelText: 'Zubereitung (optional)', alignLabelWithHint: true),
                  minLines: 3,
                  maxLines: 12,
                  textCapitalization: TextCapitalization.sentences,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Values per serving and how they were calculated.
class RecipeNutritionSummary extends StatelessWidget {
  const RecipeNutritionSummary({super.key, required this.n});
  final RecipeNutrition n;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final p = n.perServing;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: t.colorScheme.surfaceContainerHigh, borderRadius: BorderRadius.circular(14)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Pro Portion', style: t.textTheme.labelLarge),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: StatValue(label: 'Kalorien', value: kcal(p.kcal)),
              ),
              Expanded(
                child: StatValue(label: 'Protein', value: grams(p.protein)),
              ),
              Expanded(
                child: StatValue(label: 'Kohlenh.', value: grams(p.carbs)),
              ),
              Expanded(
                child: StatValue(label: 'Fett', value: grams(p.fat)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Gesamt ${kcal(n.total.kcal)} ÷ ${n1opt(n.servings)} Portionen. '
            '1 Portion ≈ ${n0(n.servingWeight)} g '
            '(${n.usesCookedWeight ? 'Endgewicht ${n0(n.finalWeight)} g' : 'Summe der Zutaten ${n0(n.rawWeight)} g'}).',
            style: t.textTheme.bodySmall?.copyWith(color: t.colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}
