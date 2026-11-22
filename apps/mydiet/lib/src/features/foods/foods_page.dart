import 'package:material_ui/material_ui.dart';

import '../../app.dart';
import '../../data/database.dart';
import '../../ui/format.dart';
import '../home_shell.dart';
import 'food_form_page.dart';

class FoodsPage extends StatefulWidget {
  const FoodsPage({super.key});

  @override
  State<FoodsPage> createState() => _FoodsPageState();
}

class _FoodsPageState extends State<FoodsPage> {
  final _q = TextEditingController();
  int _filter = 0; // 0 all, 1 own, 2 favourites

  @override
  void dispose() {
    _q.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final db = context.db;
    final t = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Lebensmittel')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FoodFormPage())),
        icon: const Icon(Icons.add),
        label: const Text('Neu'),
      ),
      body: PageBody(
        maxWidth: 900,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: SearchBar(
                controller: _q,
                hintText: 'Suchen',
                leading: const Icon(Icons.search),
                elevation: const WidgetStatePropertyAll(0),
                onChanged: (_) => setState(() {}),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  for (final (i, l) in const [(0, 'Alle'), (1, 'Eigene'), (2, 'Favoriten')])
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(l),
                        selected: _filter == i,
                        onSelected: (_) => setState(() => _filter = i),
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              child: StreamBuilder<List<Food>>(
                stream: db.watchFoods(query: _q.text, onlyUser: _filter == 1, onlyFavorites: _filter == 2),
                builder: (context, snap) {
                  final items = snap.data;
                  if (items == null) return const Center(child: CircularProgressIndicator());
                  if (items.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text(
                          _filter == 1 ? 'Noch keine eigenen Lebensmittel.' : 'Keine Treffer.',
                          style: t.textTheme.bodyLarge,
                        ),
                      ),
                    );
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.only(bottom: 96, top: 4),
                    itemCount: items.length + 1,
                    itemBuilder: (context, i) {
                      if (i == items.length) {
                        return Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            '${items.length} Lebensmittel. Basiswerte (Buch-Symbol) sind gerundete Richtwerte '
                            'aus Nährwerttabellen; für genaue Werte eigene Produkte vom Etikett anlegen.',
                            style: t.textTheme.bodySmall?.copyWith(color: t.colorScheme.onSurfaceVariant),
                          ),
                        );
                      }
                      final f = items[i];
                      return ListTile(
                        title: Text(f.name),
                        subtitle: Text(
                          [
                            if (f.brand != null) f.brand!,
                            '${kcal(f.kcal)} · P ${grams(f.protein)} · K ${grams(f.carbs)} · F ${grams(f.fat)} / 100 ${f.unit}',
                          ].join(' · '),
                        ),
                        leading: Icon(
                          f.isUserFood ? Icons.person_outline : Icons.menu_book_outlined,
                          color: t.colorScheme.outline,
                        ),
                        trailing: IconButton(
                          tooltip: f.isFavorite ? 'Favorit entfernen' : 'Als Favorit markieren',
                          icon: Icon(
                            f.isFavorite ? Icons.star : Icons.star_border,
                            color: f.isFavorite ? t.colorScheme.tertiary : null,
                          ),
                          onPressed: () => db.setFavorite(f.id, !f.isFavorite),
                        ),
                        onTap: () => _open(context, f),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _open(BuildContext context, Food f) async {
    final db = context.db;
    final action = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (c) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ListTile(
              title: Text(f.name, style: Theme.of(c).textTheme.titleLarge),
              subtitle: Text(f.isUserFood ? 'Eigenes Lebensmittel' : 'Basisdatenbank (Richtwert)'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _NutrientTable(food: f),
            ),
            const SizedBox(height: 8),
            if (f.isUserFood) ...[
              ListTile(
                leading: const Icon(Icons.edit_outlined),
                title: const Text('Bearbeiten'),
                onTap: () => Navigator.pop(c, 'edit'),
              ),
              ListTile(
                leading: const Icon(Icons.delete_outline),
                title: const Text('Löschen'),
                onTap: () => Navigator.pop(c, 'delete'),
              ),
            ] else
              ListTile(
                leading: const Icon(Icons.copy_outlined),
                title: const Text('Als eigenes Lebensmittel kopieren'),
                subtitle: const Text('z. B. um Werte vom Etikett zu übernehmen'),
                onTap: () => Navigator.pop(c, 'copy'),
              ),
          ],
        ),
      ),
    );
    if (!context.mounted || action == null) return;
    switch (action) {
      case 'edit':
        await Navigator.push(context, MaterialPageRoute(builder: (_) => FoodFormPage(food: f)));
      case 'copy':
        await Navigator.push(context, MaterialPageRoute(builder: (_) => FoodFormPage(copyOf: f)));
      case 'delete':
        await db.deleteFood(f.id);
    }
  }
}

class _NutrientTable extends StatelessWidget {
  const _NutrientTable({required this.food});
  final Food food;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final rows = [
      ('Energie', kcal(food.kcal)),
      ('Eiweiß', grams(food.protein)),
      ('Kohlenhydrate', grams(food.carbs)),
      ('davon Zucker', grams(food.sugar)),
      ('Fett', grams(food.fat)),
      ('davon gesättigt', grams(food.saturatedFat)),
      ('Ballaststoffe', grams(food.fiber)),
      ('Salz', '${n1opt(food.salt)} g'),
      if (food.servingAmount != null)
        ('Portion', '${food.servingLabel ?? 'Portion'} = ${n1opt(food.servingAmount!)} ${food.unit}'),
    ];
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text('pro 100 ${food.unit}', style: t.textTheme.labelMedium),
        ),
        for (final r in rows)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Row(
              children: [
                Expanded(child: Text(r.$1)),
                Text(r.$2, style: const TextStyle(fontWeight: FontWeight.w600)),
              ],
            ),
          ),
      ],
    );
  }
}
