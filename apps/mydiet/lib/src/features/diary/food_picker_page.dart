import 'package:material_ui/material_ui.dart';

import '../../app.dart';
import '../../data/database.dart';
import '../../ui/format.dart';
import '../../ui/widgets.dart';
import '../foods/food_form_page.dart';
import 'amount_sheet.dart';

/// Search, pick a food, enter the amount, log it.
class FoodPickerPage extends StatefulWidget {
  const FoodPickerPage({super.key, required this.day, required this.mealSlotId, required this.slots});
  final String day;
  final String mealSlotId;
  final List<MealSlot> slots;

  @override
  State<FoodPickerPage> createState() => _FoodPickerPageState();
}

class _FoodPickerPageState extends State<FoodPickerPage> {
  final _q = TextEditingController();
  List<Food> _results = [];
  List<Food> _recent = [];
  List<Food> _favorites = [];
  int _added = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadLists();
  }

  Future<void> _loadLists() async {
    final db = context.db;
    final recent = await db.recentFoods();
    final favs = await db.watchFoods(onlyFavorites: true).first;
    if (mounted) {
      setState(() {
        _recent = recent;
        _favorites = favs;
      });
    }
  }

  Future<void> _search(String q) async {
    final r = q.trim().isEmpty ? <Food>[] : await context.db.searchFoods(q);
    if (mounted && q == _q.text) setState(() => _results = r);
  }

  Future<void> _pick(Food f) async {
    final res = await showAmountSheet(
      context,
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
                  autoFocus: true,
                  hintText: 'Lebensmittel suchen, z. B. Skyr',
                  leading: const Icon(Icons.search),
                  trailing: [
                    if (searching)
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          _q.clear();
                          setState(() => _results = []);
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
                      if (_results.isEmpty)
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Text('Nichts gefunden für „${_q.text.trim()}“.', style: t.textTheme.bodyLarge),
                        ),
                      for (final f in _results) _FoodTile(food: f, onTap: () => _pick(f)),
                    ] else ...[
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
                      for (final f in _recent) _FoodTile(food: f, onTap: () => _pick(f)),
                    ],
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
          if (food.source == 'base')
            Tooltip(
              message: 'Richtwert aus der Basisdatenbank',
              child: Icon(Icons.menu_book_outlined, size: 16, color: t.colorScheme.outline),
            ),
          const SizedBox(width: 4),
          const Icon(Icons.add_circle_outline),
        ],
      ),
    );
  }
}
