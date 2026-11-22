import 'package:material_ui/material_ui.dart';

import '../../app.dart';
import '../../core/recipes.dart';
import '../../data/database.dart';
import '../../ui/format.dart';
import '../../ui/widgets.dart';
import '../diary/amount_sheet.dart';
import 'recipe_form_page.dart';

/// Shows a recipe and lets the user log it, put it on the shopping list, edit or delete it.
class RecipeDetailPage extends StatelessWidget {
  const RecipeDetailPage({super.key, required this.recipeId});
  final String recipeId;

  @override
  Widget build(BuildContext context) {
    final db = context.db;
    return StreamBuilder<List<Object?>>(
      stream: combineLatest([db.watchRecipe(recipeId), db.watchRecipeItems(recipeId)]),
      builder: (context, snap) {
        final r = snap.data?[0] as Recipe?;
        final items = (snap.data?[1] as List<RecipeItem>?) ?? const [];
        if (snap.data == null) return const Scaffold(body: Center(child: CircularProgressIndicator()));
        if (r == null || r.deletedAt != null) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(child: Text('Dieses Rezept gibt es nicht mehr.')),
          );
        }
        final n = recipeNutrition(
          [for (final i in items) Ingredient(per100: i.per100, amount: i.amount, unit: i.unit)],
          servings: r.servings,
          cookedWeight: r.cookedWeightG,
        );
        return _RecipeView(recipe: r, items: items, n: n);
      },
    );
  }
}

class _RecipeView extends StatelessWidget {
  const _RecipeView({required this.recipe, required this.items, required this.n});
  final Recipe recipe;
  final List<RecipeItem> items;
  final RecipeNutrition n;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final db = context.db;
    final r = recipe;
    return Scaffold(
      appBar: AppBar(
        title: Text(r.name),
        actions: [
          IconButton(
            tooltip: r.isFavorite ? 'Favorit entfernen' : 'Als Favorit markieren',
            icon: Icon(r.isFavorite ? Icons.star : Icons.star_border),
            onPressed: () => db.setRecipeFavorite(r.id, !r.isFavorite),
          ),
          IconButton(
            tooltip: 'Bearbeiten',
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => RecipeFormPage(recipe: r, items: items),
              ),
            ),
          ),
          IconButton(tooltip: 'Löschen', icon: const Icon(Icons.delete_outline), onPressed: () => _delete(context)),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
            children: [
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  Chip(label: Text('${n1opt(r.servings)} Portionen')),
                  if (r.prepMinutes != null) Chip(label: Text('${r.prepMinutes} min')),
                  for (final tag in r.tags) Chip(label: Text(tag)),
                ],
              ),
              const SizedBox(height: 12),
              RecipeNutritionSummary(n: n),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: items.isEmpty ? null : () => _log(context),
                      icon: const Icon(Icons.restaurant),
                      label: const Text('Heute eintragen'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: items.isEmpty ? null : () => _shopping(context),
                      icon: const Icon(Icons.shopping_cart_outlined),
                      label: const Text('Einkaufsliste'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text('Zutaten', style: t.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
              for (final i in items)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                  title: Text(i.brand == null ? i.foodName : '${i.foodName} (${i.brand})'),
                  trailing: Text(amountWithUnit(i.amount, i.unit)),
                  subtitle: Text('${kcal(i.nutrients.kcal)} · P ${grams(i.nutrients.protein)}'),
                ),
              if (r.instructions != null) ...[
                const SizedBox(height: 16),
                Text('Zubereitung', style: t.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 6),
                Text(r.instructions!, style: t.textTheme.bodyLarge),
              ],
              const SizedBox(height: 16),
              Text(
                'Nährwerte pro 100 g: ${kcal(n.per100.kcal)}, Protein ${grams(n.per100.protein)}, '
                'Kohlenhydrate ${grams(n.per100.carbs)}, Fett ${grams(n.per100.fat)}, '
                'Ballaststoffe ${grams(n.per100.fiber)}. Gesamt: ${kcal(n.total.kcal)}, Protein ${grams(n.total.protein)}.',
                style: t.textTheme.bodySmall?.copyWith(color: t.colorScheme.onSurfaceVariant),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _log(BuildContext context) async {
    final db = context.db;
    final slots = await db.watchMealSlots().first;
    if (!context.mounted || slots.isEmpty) return;
    final res = await showAmountSheet(
      context,
      name: recipe.name,
      unit: 'g',
      per100: n.per100,
      servingAmount: n.servingWeight,
      servingLabel: 'Portion',
      slots: slots,
      mealSlotId: slotForNow(slots).id,
    );
    if (res == null || !context.mounted) return;
    try {
      await db.logRecipe(day: todayKey(), mealSlotId: res.mealSlotId, recipe: recipe, grams: res.amount);
      if (context.mounted) {
        final portions = n.servingWeight > 0 ? res.amount / n.servingWeight : 0;
        showMessage(context, '${recipe.name} (${n1opt(portions)} Portionen) eingetragen');
      }
    } catch (e) {
      if (context.mounted) showMessage(context, errorText(e));
    }
  }

  Future<void> _shopping(BuildContext context) async {
    final c = TextEditingController(text: numField(recipe.servings));
    final servings = await showDialog<double>(
      context: context,
      builder: (d) => AlertDialog(
        title: const Text('Auf die Einkaufsliste'),
        content: TextField(
          controller: c,
          autofocus: true,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(labelText: 'Für wie viele Portionen?'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(d), child: const Text('Abbrechen')),
          FilledButton(
            onPressed: () {
              final v = parseNum(c.text);
              if (v != null && v > 0 && v <= 100) Navigator.pop(d, v);
            },
            child: const Text('Hinzufügen'),
          ),
        ],
      ),
    );
    c.dispose();
    if (servings == null || !context.mounted) return;
    final count = await context.db.addRecipeToShopping(recipe.id, servings: servings);
    if (context.mounted) showMessage(context, '$count Zutaten für ${n1opt(servings)} Portionen auf der Einkaufsliste');
  }

  Future<void> _delete(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (d) => AlertDialog(
        title: Text('„${recipe.name}“ löschen?'),
        content: const Text('Bereits eingetragene Mahlzeiten bleiben unverändert im Tagebuch.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(d, false), child: const Text('Abbrechen')),
          FilledButton(onPressed: () => Navigator.pop(d, true), child: const Text('Löschen')),
        ],
      ),
    );
    if (ok != true || !context.mounted) return;
    await context.db.deleteRecipe(recipe.id);
    if (context.mounted) Navigator.pop(context);
  }
}

/// The meal whose time is the latest one not after now; the first meal otherwise.
MealSlot slotForNow(List<MealSlot> slots, [DateTime? now]) {
  final n = now ?? DateTime.now();
  final minute = n.hour * 60 + n.minute;
  MealSlot? best;
  for (final s in slots) {
    final m = s.minuteOfDay;
    if (m != null && m <= minute && (best == null || m >= best.minuteOfDay!)) best = s;
  }
  return best ?? slots.first;
}
