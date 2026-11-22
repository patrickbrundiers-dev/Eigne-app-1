import 'package:material_ui/material_ui.dart';

import '../../app.dart';
import '../../data/database.dart';
import '../../ui/format.dart';
import '../../ui/widgets.dart';

/// Shopping list: add items, check them off, remove checked ones.
class ShoppingView extends StatefulWidget {
  const ShoppingView({super.key});

  @override
  State<ShoppingView> createState() => _ShoppingViewState();
}

class _ShoppingViewState extends State<ShoppingView> {
  final _c = TextEditingController();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  Future<void> _add() async {
    final text = _c.text.trim();
    if (text.isEmpty) return;
    final p = ShoppingViewParser.parse(text);
    try {
      await context.db.addShoppingItem(label: p.label, amount: p.amount, unit: p.unit);
      _c.clear();
    } catch (e) {
      if (mounted) showMessage(context, errorText(e));
    }
  }

  @override
  Widget build(BuildContext context) {
    final db = context.db;
    final t = Theme.of(context);
    return StreamBuilder<List<ShoppingItem>>(
      stream: db.watchShopping(),
      builder: (context, snap) {
        final items = snap.data ?? const <ShoppingItem>[];
        final checked = items.where((i) => i.checked).length;
        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
          children: [
            TextField(
              controller: _c,
              decoration: InputDecoration(
                labelText: 'Hinzufügen',
                hintText: 'z. B. 500 g Hackfleisch oder Zimt',
                suffixIcon: IconButton(icon: const Icon(Icons.add), onPressed: _add, tooltip: 'Hinzufügen'),
              ),
              onSubmitted: (_) => _add(),
            ),
            const SizedBox(height: 8),
            if (snap.data != null && items.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Text(
                  'Die Einkaufsliste ist leer. Füge Dinge oben hinzu oder übernimm die Zutaten eines Rezepts.',
                  textAlign: TextAlign.center,
                  style: t.textTheme.bodyLarge,
                ),
              ),
            for (final i in items)
              Dismissible(
                key: ValueKey(i.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  color: t.colorScheme.errorContainer,
                  child: Icon(Icons.delete_outline, color: t.colorScheme.onErrorContainer),
                ),
                onDismissed: (_) async {
                  await db.deleteShoppingItem(i.id);
                  if (context.mounted) {
                    showMessage(
                      context,
                      '„${i.label}“ entfernt',
                      action: SnackBarAction(label: 'Rückgängig', onPressed: () => db.restoreShoppingItem(i.id)),
                    );
                  }
                },
                child: CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  controlAffinity: ListTileControlAffinity.leading,
                  value: i.checked,
                  onChanged: (v) => db.setShoppingChecked(i.id, v ?? false),
                  title: Text(
                    i.amount == null ? i.label : '${n1opt(i.amount!)} ${i.unit ?? ''} ${i.label}'.replaceAll('  ', ' '),
                    style: i.checked
                        ? TextStyle(decoration: TextDecoration.lineThrough, color: t.colorScheme.outline)
                        : null,
                  ),
                  subtitle: i.fromRecipes == null ? null : Text('für ${i.fromRecipes}'),
                ),
              ),
            if (checked > 0) ...[
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () async {
                  final n = await db.clearCheckedShopping();
                  if (context.mounted) showMessage(context, '$n erledigte Einträge entfernt');
                },
                icon: const Icon(Icons.done_all),
                label: Text('$checked erledigte entfernen'),
              ),
            ],
          ],
        );
      },
    );
  }
}

/// Parses a typed shopping line.
abstract final class ShoppingViewParser {
  /// "500 g Hackfleisch", "2 Paprika" or just "Zimt".
  static ({String label, double? amount, String? unit}) parse(String s) {
    final m = RegExp(r'^\s*(\d+(?:[.,]\d+)?)\s*([a-zA-ZäöüÄÖÜ]{1,8}\.?)?\s+(.+)$').firstMatch(s);
    if (m == null) return (label: s.trim(), amount: null, unit: null);
    final amount = parseNum(m.group(1));
    final unitOrWord = m.group(2);
    const units = {'g', 'kg', 'ml', 'l', 'stk', 'stk.', 'el', 'tl', 'pck', 'pck.', 'dose', 'bund', 'packung'};
    if (unitOrWord != null && units.contains(unitOrWord.toLowerCase())) {
      return (label: m.group(3)!.trim(), amount: amount, unit: unitOrWord);
    }
    final rest = [?unitOrWord, m.group(3)!].join(' ').trim();
    return (label: rest, amount: amount, unit: null);
  }
}
