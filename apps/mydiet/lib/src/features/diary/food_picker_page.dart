import 'package:material_ui/material_ui.dart';

import '../../app.dart';
import '../../data/database.dart';
import '../../core/food_quality.dart' show OffProduct;
import '../../core/habits.dart';
import '../../data/display_prefs.dart';
import '../../data/food_search.dart';
import '../../data/habits_data.dart';
import '../../data/meal_text_match.dart' show usualLoggedAmount;
import '../../ui/format.dart';
import '../../ui/widgets.dart';
import '../../core/recipes.dart';
import '../foods/barcode.dart';
import '../foods/food_form_page.dart';
import '../foods/off_live_section.dart';
import '../foods/off_search_page.dart';
import '../foods/foods_page.dart' show FoodSourceIcon;
import 'amount_sheet.dart';
import 'quick_entry_sheet.dart';
import 'text_entry_page.dart';

/// Search, pick a food, enter the amount, log it.
/// What the picker does right after opening (shortcuts from the dashboard's "Eintragen").
enum PickerStart { search, scan, text, quick }

class FoodPickerPage extends StatefulWidget {
  const FoodPickerPage({
    super.key,
    required this.day,
    required this.mealSlotId,
    required this.slots,
    this.start = PickerStart.search,
  });
  final String day;
  final String mealSlotId;
  final List<MealSlot> slots;
  final PickerStart start;

  @override
  State<FoodPickerPage> createState() => _FoodPickerPageState();
}

class _FoodPickerPageState extends State<FoodPickerPage> {
  final _q = TextEditingController();
  List<Food> _results = [];
  List<Food> _recent = [];
  List<Food> _suggested = [];
  List<MealTemplate> _templates = [];
  List<Food> _favorites = [];
  List<Recipe> _recipeResults = [];
  List<Recipe> _favRecipes = [];
  List<HabitSuggestion> _habits = [];
  int _added = 0;
  OffLiveSearch? _live;
  bool _liveEnabled = true;

  @override
  void initState() {
    super.initState();
    if (widget.start != PickerStart.search) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        switch (widget.start) {
          case PickerStart.scan:
            _scan();
          case PickerStart.text:
            _textEntry();
          case PickerStart.quick:
            _quick();
          case PickerStart.search:
            break;
        }
      });
    }
  }

  Future<void> _scan() async {
    final f = await scanFood(context);
    if (f != null && mounted) await _pick(f);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _live ??= OffLiveSearch(context.db);
    context.db.getSetting(offLiveSearchKey).then((v) => _liveEnabled = offLiveSearchEnabled(v));
    _loadLists();
  }

  Future<void> _loadLists() async {
    final db = context.db;
    final recent = await db.recentFoods();
    final suggested = await db.suggestedFoods(mealSlotId: widget.mealSlotId);
    final templates = await db.watchTemplates().first;
    final favs = await db.watchFoods(onlyFavorites: true).first;
    final favRecipes = await db.watchRecipes(onlyFavorites: true).first;
    final habits = await habitSuggestions(db, slotId: widget.mealSlotId);
    if (mounted) {
      setState(() {
        _habits = habits;
        _recent = recent;
        _suggested = suggested;
        // Templates saved from this meal first, the rest after (stable otherwise).
        _templates = [
          ...templates.where((t) => t.mealSlotId == widget.mealSlotId),
          ...templates.where((t) => t.mealSlotId != widget.mealSlotId),
        ];
        _favorites = favs;
        _favRecipes = favRecipes;
      });
    }
  }

  Future<void> _saveHabit(HabitSuggestion h) async {
    final slotName = widget.slots.where((s) => s.id == h.slotId).firstOrNull?.name ?? 'Mahlzeit';
    final c = TextEditingController(text: 'Mein $slotName');
    final name = await showDialog<String>(
      context: context,
      builder: (d) => AlertDialog(
        title: const Text('Als Vorlage speichern'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(h.title),
            const SizedBox(height: 12),
            TextField(
              controller: c,
              autofocus: true,
              decoration: const InputDecoration(labelText: 'Name der Vorlage'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(d), child: const Text('Abbrechen')),
          FilledButton(onPressed: () => Navigator.pop(d, c.text), child: const Text('Speichern')),
        ],
      ),
    );
    c.dispose();
    if (name == null || name.trim().isEmpty || !mounted) return;
    try {
      await saveHabitAsTemplate(context.db, h, name: name);
      if (mounted) showMessage(context, 'Vorlage „${name.trim()}“ gespeichert');
    } catch (e) {
      if (mounted) showMessage(context, errorText(e));
    }
    _loadLists();
  }

  Future<void> _dismissHabit(HabitSuggestion h) async {
    await dismissHabit(context.db, h);
    _loadLists();
  }

  Future<void> _search(String q) async {
    final db = context.db;
    final r = q.trim().isEmpty ? FoodSearchResult.empty : await smartSearch(db, q);
    final rr = q.trim().isEmpty ? <Recipe>[] : await db.searchRecipes(q, limit: 5);
    if (mounted && q == _q.text) {
      setState(() {
        _results = r.foods;
        _recipeResults = rr;
      });
      _live?.update(q, localHits: r.exactHits + rr.length, enabled: _liveEnabled);
    }
  }

  /// An Open Food Facts hit from the live search: check and save it, then log it.
  Future<void> _pickOnline(OffProduct p) async {
    final id = await openOffProduct(context, p);
    if (id == null || !mounted) return;
    final f = await context.db.getFood(id);
    if (f != null && mounted) await _pick(f);
    if (mounted) _search(_q.text);
  }

  Future<void> _pickRecipe(Recipe r) async {
    final db = context.db;
    final RecipeNutrition n = await db.recipeNutritionOf(r);
    if (!mounted) return;
    final res = await showAmountSheet(
      context,
      name: r.name,
      unit: 'g',
      per100: n.per100,
      servingAmount: n.servingWeight,
      servingLabel: 'Portion',
      slots: widget.slots,
      mealSlotId: widget.mealSlotId,
    );
    if (res == null || !mounted) return;
    try {
      await db.logRecipe(day: widget.day, mealSlotId: res.mealSlotId, recipe: r, grams: res.amount);
      setState(() => _added++);
      if (mounted) showMessage(context, '${r.name} (${amountWithUnit(res.amount, 'g')}) eingetragen');
    } catch (e) {
      if (mounted) showMessage(context, errorText(e));
    }
  }

  Future<void> _pick(Food f) async {
    final usual = await usualLoggedAmount(context.db, f.id);
    if (!mounted) return;
    final res = await showAmountSheet(
      context,
      usualAmount: usual,
      name: f.name,
      brand: f.brand,
      unit: f.unit,
      per100: f.per100,
      servingAmount: f.servingAmount,
      servingLabel: f.servingLabel,
      slots: widget.slots,
      mealSlotId: widget.mealSlotId,
    );
    if (res == null || !mounted) return;
    try {
      await context.db.logFood(day: widget.day, mealSlotId: res.mealSlotId, food: f, amount: res.amount);
      setState(() => _added++);
      if (mounted) {
        showMessage(context, '${f.name} (${amountWithUnit(res.amount, f.unit)}) eingetragen');
      }
      _loadLists();
    } catch (e) {
      if (mounted) showMessage(context, errorText(e));
    }
  }

  Future<void> _logTemplate(MealTemplate tpl) async {
    try {
      final n = await context.db.logTemplate(templateId: tpl.id, day: widget.day, mealSlotId: widget.mealSlotId);
      if (!mounted) return;
      setState(() => _added += n);
      showMessage(context, '${tpl.name}: $n ${n == 1 ? 'Eintrag' : 'Einträge'} eingetragen');
      _loadLists();
    } catch (e) {
      if (mounted) showMessage(context, errorText(e));
    }
  }

  Future<void> _deleteTemplate(MealTemplate tpl) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Vorlage löschen?'),
        content: Text('„${tpl.name}“ wird gelöscht. Bereits eingetragene Mahlzeiten bleiben erhalten.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('Abbrechen')),
          FilledButton(onPressed: () => Navigator.pop(c, true), child: const Text('Löschen')),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    await context.db.deleteTemplate(tpl.id);
    _loadLists();
  }

  Future<void> _quick() async {
    final ok = await showQuickEntrySheet(
      context,
      day: widget.day,
      mealSlotId: widget.mealSlotId,
      initialLabel: _q.text.trim(),
    );
    if (ok && mounted) setState(() => _added++);
  }

  Future<void> _textEntry() async {
    final n = await Navigator.push<int>(
      context,
      MaterialPageRoute(
        builder: (_) => TextEntryPage(
          day: widget.day,
          mealSlotId: widget.mealSlotId,
          slots: widget.slots,
          initialText: looksLikeMealText(_q.text) ? _q.text : '',
        ),
      ),
    );
    if (n == null || n == 0 || !mounted) return;
    setState(() => _added += n);
    showMessage(context, '$n ${n == 1 ? 'Eintrag' : 'Einträge'} eingetragen');
    _loadLists();
  }

  Future<void> _offSearch() async {
    final id = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (_) => OffSearchPage(initialQuery: _q.text.trim())),
    );
    if (id == null || !mounted) return;
    final f = await context.db.getFood(id);
    if (f != null && mounted) await _pick(f);
  }

  Future<void> _create() async {
    final id = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (_) => FoodFormPage(initialName: _q.text.trim())),
    );
    if (id == null || !mounted) return;
    final f = await context.db.getFood(id);
    if (f != null) await _pick(f);
  }

  @override
  void dispose() {
    _live?.dispose();
    _q.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final slotName = widget.slots.where((s) => s.id == widget.mealSlotId).firstOrNull?.name ?? 'Eintrag';
    final searching = _q.text.trim().isNotEmpty;
    return Scaffold(
      appBar: AppBar(
        title: Text('$slotName hinzufügen'),
        actions: [
          if (_added > 0)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilledButton.tonal(onPressed: () => Navigator.pop(context), child: Text('Fertig ($_added)')),
            ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
                child: SearchBar(
                  controller: _q,
                  autoFocus: widget.start == PickerStart.search,
                  hintText: 'Lebensmittel oder Rezept suchen',
                  leading: const Icon(Icons.search),
                  trailing: [
                    IconButton(tooltip: 'Als Text eintragen', icon: const Icon(Icons.notes), onPressed: _textEntry),
                    IconButton(tooltip: 'Barcode scannen', icon: const Icon(Icons.qr_code_scanner), onPressed: _scan),
                    if (searching)
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          _q.clear();
                          setState(() => _results = []);
                          _live?.update('', localHits: 0, enabled: _liveEnabled);
                        },
                      ),
                  ],
                  onChanged: (v) {
                    setState(() {});
                    _search(v);
                  },
                  elevation: const WidgetStatePropertyAll(0),
                ),
              ),
              Expanded(
                child: ListView(
                  children: [
                    if (searching) ...[
                      if (looksLikeMealText(_q.text))
                        ListTile(
                          leading: const Icon(Icons.auto_fix_high),
                          title: const Text('Ganze Mahlzeit erkennen'),
                          subtitle: Text('„${_q.text.trim()}“ als Text eintragen'),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: _textEntry,
                        ),
                      for (final r in _recipeResults) _RecipeTile(recipe: r, onTap: () => _pickRecipe(r)),
                      if (_results.isEmpty && _recipeResults.isEmpty)
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Text('Nichts gefunden für „${_q.text.trim()}“.', style: t.textTheme.bodyLarge),
                        ),
                      for (final f in _results) _FoodTile(food: f, onTap: () => _pick(f)),
                      if (_live != null) OffLiveSection(search: _live!, onTap: _pickOnline),
                      ListTile(
                        leading: const Icon(Icons.travel_explore),
                        title: const Text('Bei Open Food Facts suchen'),
                        subtitle: const Text('Sendet nur den Suchbegriff'),
                        onTap: _offSearch,
                      ),
                    ] else ...[
                      for (final h in _habits)
                        Card(
                          margin: const EdgeInsets.fromLTRB(16, 4, 16, 8),
                          child: ListTile(
                            leading: const Icon(Icons.repeat),
                            title: Text('Wiederkehrend: ${h.title}'),
                            subtitle: Text('${h.reason}. Als Vorlage speichern, dann mit einem Tipp eintragen.'),
                            isThreeLine: true,
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  tooltip: 'Nicht mehr vorschlagen',
                                  icon: const Icon(Icons.close),
                                  onPressed: () => _dismissHabit(h),
                                ),
                                IconButton(
                                  tooltip: 'Als Vorlage speichern',
                                  icon: const Icon(Icons.bookmark_add_outlined),
                                  onPressed: () => _saveHabit(h),
                                ),
                              ],
                            ),
                          ),
                        ),
                      if (_templates.isNotEmpty) ...[
                        _header(context, 'Vorlagen'),
                        for (final tpl in _templates)
                          ListTile(
                            leading: const Icon(Icons.bookmark_outline),
                            title: Text(tpl.name),
                            subtitle: const Text('Antippen trägt alles ein · lange drücken zum Löschen'),
                            trailing: const Icon(Icons.add_circle_outline),
                            onTap: () => _logTemplate(tpl),
                            onLongPress: () => _deleteTemplate(tpl),
                          ),
                      ],
                      if (_suggested.isNotEmpty) ...[
                        _header(context, 'Oft zum $slotName'),
                        for (final f in _suggested) _FoodTile(food: f, onTap: () => _pick(f)),
                      ],
                      if (_favRecipes.isNotEmpty) ...[
                        _header(context, 'Lieblingsrezepte'),
                        for (final r in _favRecipes) _RecipeTile(recipe: r, onTap: () => _pickRecipe(r)),
                      ],
                      if (_favorites.isNotEmpty) ...[
                        _header(context, 'Favoriten'),
                        for (final f in _favorites) _FoodTile(food: f, onTap: () => _pick(f)),
                      ],
                      _header(context, 'Zuletzt verwendet'),
                      if (_recent.isEmpty)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                          child: Text(
                            'Noch nichts. Suche oben nach einem Lebensmittel.',
                            style: t.textTheme.bodyMedium?.copyWith(color: t.colorScheme.onSurfaceVariant),
                          ),
                        ),
                      for (final f in _recent.where((f) => !_suggested.any((x) => x.id == f.id)))
                        _FoodTile(food: f, onTap: () => _pick(f)),
                    ],
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                      child: OutlinedButton.icon(
                        onPressed: _quick,
                        icon: const Icon(Icons.bolt),
                        label: const Text('Schnelleintrag: nur Kalorien (z. B. Restaurant)'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: OutlinedButton.icon(
                        onPressed: _create,
                        icon: const Icon(Icons.add),
                        label: Text(
                          searching
                              ? '„${_q.text.trim()}“ als neues Lebensmittel anlegen'
                              : 'Neues Lebensmittel anlegen',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header(BuildContext context, String s) => Padding(
    padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
    child: Text(s, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
  );
}

class _FoodTile extends StatelessWidget {
  const _FoodTile({required this.food, required this.onTap});
  final Food food;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return ListTile(
      onTap: onTap,
      title: Text(food.name),
      subtitle: Text(
        [
          if (food.brand != null) food.brand!,
          '${kcal(food.kcal)} · P ${grams(food.protein)} / 100 ${food.unit}',
        ].join(' · '),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (food.isFavorite) Icon(Icons.star, size: 18, color: t.colorScheme.tertiary),
          FoodSourceIcon(food: food, size: 16),
          const SizedBox(width: 4),
          const Icon(Icons.add_circle_outline),
        ],
      ),
    );
  }
}

class _RecipeTile extends StatelessWidget {
  const _RecipeTile({required this.recipe, required this.onTap});
  final Recipe recipe;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => ListTile(
    onTap: onTap,
    leading: const Icon(Icons.menu_book),
    title: Text(recipe.name),
    subtitle: Text('Rezept · ${n1opt(recipe.servings)} Portionen'),
    trailing: const Icon(Icons.add_circle_outline),
  );
}
