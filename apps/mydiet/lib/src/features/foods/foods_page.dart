import 'package:material_ui/material_ui.dart';

import '../../app.dart';
import '../../data/database.dart';
import '../../ui/format.dart';
import '../home_shell.dart';
import 'barcode.dart';
import 'food_form_page.dart';
import 'food_table.dart';

class FoodsPage extends StatefulWidget {
  const FoodsPage({super.key, this.embedded = false});

  /// Inside the "Essen" tabs: no own app bar.
  final bool embedded;

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
    final wide = MediaQuery.sizeOf(context).width >= 900;
    return Scaffold(
      appBar: widget.embedded ? null : AppBar(title: const Text('Lebensmittel')),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'food-new',
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FoodFormPage())),
        icon: const Icon(Icons.add),
        label: const Text('Neu'),
      ),
      body: PageBody(
        maxWidth: wide ? 1280 : 900,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(16, widget.embedded ? 8 : 0, 16, 8),
              child: SearchBar(
                controller: _q,
                hintText: 'Suchen',
                leading: const Icon(Icons.search),
                trailing: [
                  IconButton(
                    tooltip: 'Barcode scannen',
                    icon: const Icon(Icons.qr_code_scanner),
                    onPressed: () async {
                      final f = await scanFood(context);
                      if (f != null && context.mounted) await _open(context, f);
                    },
                  ),
                ],
                elevation: const WidgetStatePropertyAll(0),
                onChanged: (_) => setState(() {}),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Wrap(
                spacing: 8,
                runSpacing: 4,
                children: [
                  if (wide)
                    ActionChip(
                      avatar: const Icon(Icons.view_column_outlined, size: 18),
                      label: const Text('Spalten'),
                      tooltip: 'Spalten wählen',
                      onPressed: () async {
                        final cur = parseFoodColumns(await db.getSetting(foodTableColumnsKey));
                        if (!context.mounted) return;
                        final next = await chooseFoodColumns(context, cur);
                        if (next != null) await db.setSetting(foodTableColumnsKey, encodeFoodColumns(next));
                      },
                    ),
                  for (final (i, l) in const [(0, 'Alle'), (1, 'Eigene'), (2, 'Favoriten')])
                    Padding(
                      padding: EdgeInsets.zero,
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
                  if (wide) {
                    return StreamBuilder<String?>(
                      stream: db.watchSetting(foodTableColumnsKey),
                      builder: (context, colSnap) => SingleChildScrollView(
                        padding: const EdgeInsets.only(bottom: 96, top: 4),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: FoodTable(
                            items: items,
                            columns: parseFoodColumns(colSnap.data),
                            onOpen: (f) => _open(context, f),
                            onFavorite: (f) => db.setFavorite(f.id, !f.isFavorite),
                          ),
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
                            '${items.length} Lebensmittel. Symbole: Buch = Richtwert aus Nährwerttabellen, '
                            'Person = eigene Eingabe vom Etikett, Barcode = Open Food Facts (Warnzeichen: bitte prüfen), '
                            'Funken = Schätzung.',
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
                        leading: FoodSourceIcon(food: f),
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
              subtitle: Text('${f.sourceKind.label} · ${f.quality.label}'),
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

/// Icon for the source and quality of a food (ARBEITSPLAN W2).
class FoodSourceIcon extends StatelessWidget {
  const FoodSourceIcon({super.key, required this.food, this.size = 24});
  final Food food;
  final double size;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final q = food.quality;
    final (icon, color) = switch (food.sourceKind) {
      FoodSource.base => (Icons.menu_book_outlined, t.colorScheme.outline),
      FoodSource.user => (Icons.person_outline, t.colorScheme.outline),
      FoodSource.off => (
        q == FoodQuality.complete ? Icons.qr_code_2 : Icons.warning_amber_rounded,
        q == FoodQuality.complete ? t.colorScheme.outline : t.colorScheme.tertiary,
      ),
      FoodSource.ai => (Icons.auto_awesome_outlined, t.colorScheme.tertiary),
    };
    return Tooltip(
      message: '${food.sourceKind.label} · ${q.label}',
      child: Icon(icon, color: color, size: size),
    );
  }
}
