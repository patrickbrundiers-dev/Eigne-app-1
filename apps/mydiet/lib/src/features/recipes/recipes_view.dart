import 'package:material_ui/material_ui.dart';

import '../../app.dart';
import '../../core/recipes.dart';
import '../../data/database.dart';
import '../../ui/format.dart';
import 'recipe_detail_page.dart';
import 'recipe_form_page.dart';
import 'recipe_import_page.dart';

/// List of recipes with search and favourites filter.
class RecipesView extends StatefulWidget {
  const RecipesView({super.key});

  @override
  State<RecipesView> createState() => _RecipesViewState();
}

class _RecipesViewState extends State<RecipesView> {
  final _q = TextEditingController();
  bool _favorites = false;

  @override
  void dispose() {
    _q.dispose();
    super.dispose();
  }

  Future<void> _open(BuildContext context, Widget page) async {
    final id = await Navigator.push<String>(context, MaterialPageRoute(builder: (_) => page));
    if (id != null && context.mounted) {
      await Navigator.push(context, MaterialPageRoute(builder: (_) => RecipeDetailPage(recipeId: id)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final db = context.db;
    final t = Theme.of(context);
    return Scaffold(
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton.small(
            heroTag: 'recipe-import',
            tooltip: 'Rezept von Webseite oder Text übernehmen',
            onPressed: () => _open(context, const RecipeImportPage()),
            child: const Icon(Icons.link),
          ),
          const SizedBox(height: 12),
          FloatingActionButton.extended(
            heroTag: 'recipe-new',
            onPressed: () => _open(context, const RecipeFormPage()),
            icon: const Icon(Icons.add),
            label: const Text('Rezept'),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: SearchBar(
              controller: _q,
              hintText: 'Rezepte suchen',
              leading: const Icon(Icons.search),
              elevation: const WidgetStatePropertyAll(0),
              onChanged: (_) => setState(() {}),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                ChoiceChip(
                  label: const Text('Alle'),
                  selected: !_favorites,
                  onSelected: (_) => setState(() => _favorites = false),
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text('Favoriten'),
                  selected: _favorites,
                  onSelected: (_) => setState(() => _favorites = true),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Recipe>>(
              stream: db.watchRecipes(query: _q.text, onlyFavorites: _favorites),
              builder: (context, snap) {
                final items = snap.data;
                if (items == null) return const Center(child: CircularProgressIndicator());
                if (items.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        _q.text.isEmpty && !_favorites
                            ? 'Noch keine Rezepte. Lege dein erstes Rezept an: Zutaten aus der Datenbank, '
                                  'Portionen festlegen, fertig. Die Nährwerte pro Portion rechnet die App.'
                            : 'Keine Treffer.',
                        textAlign: TextAlign.center,
                        style: t.textTheme.bodyLarge,
                      ),
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.only(top: 4, bottom: 96),
                  itemCount: items.length,
                  itemBuilder: (context, i) => _RecipeTile(recipe: items[i]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _RecipeTile extends StatelessWidget {
  const _RecipeTile({required this.recipe});
  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final db = context.db;
    return FutureBuilder<RecipeNutrition>(
      // keyed by updatedAt so an edit refreshes the values
      key: ValueKey('${recipe.id}-${recipe.updatedAt.millisecondsSinceEpoch}'),
      future: db.recipeNutritionOf(recipe),
      builder: (context, snap) {
        final n = snap.data;
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: t.colorScheme.secondaryContainer,
            child: Icon(Icons.menu_book, color: t.colorScheme.onSecondaryContainer, size: 20),
          ),
          title: Text(recipe.name),
          subtitle: Text(
            [
              if (n != null) '${kcal(n.perServing.kcal)} · P ${grams(n.perServing.protein)} pro Portion',
              '${n1opt(recipe.servings)} Port.',
              if (recipe.prepMinutes != null) '${recipe.prepMinutes} min',
            ].join(' · '),
          ),
          trailing: IconButton(
            tooltip: recipe.isFavorite ? 'Favorit entfernen' : 'Als Favorit markieren',
            icon: Icon(
              recipe.isFavorite ? Icons.star : Icons.star_border,
              color: recipe.isFavorite ? t.colorScheme.tertiary : null,
            ),
            onPressed: () => db.setRecipeFavorite(recipe.id, !recipe.isFavorite),
          ),
          onTap: () =>
              Navigator.push(context, MaterialPageRoute(builder: (_) => RecipeDetailPage(recipeId: recipe.id))),
        );
      },
    );
  }
}
