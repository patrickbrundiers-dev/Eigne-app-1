import 'package:material_ui/material_ui.dart';

import '../../app.dart';
import '../../core/food_quality.dart' show OffProduct;
import '../../data/database.dart';
import '../../data/display_prefs.dart';
import '../../data/food_search.dart';
import '../../ui/format.dart';
import 'barcode.dart';
import 'food_form_page.dart';
import 'off_live_section.dart';
import 'off_search_page.dart' show openOffProduct;

/// Searches the food database and returns the chosen food (used for recipe ingredients).
class FoodSearchPage extends StatefulWidget {
  const FoodSearchPage({super.key, this.title = 'Zutat wählen'});
  final String title;

  @override
  State<FoodSearchPage> createState() => _FoodSearchPageState();
}

class _FoodSearchPageState extends State<FoodSearchPage> {
  final _q = TextEditingController();
  List<Food> _results = [];
  List<Food> _favorites = [];
  OffLiveSearch? _live;
  bool _liveEnabled = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _live ??= OffLiveSearch(context.db);
    context.db.getSetting(offLiveSearchKey).then((v) => _liveEnabled = offLiveSearchEnabled(v));
    context.db.watchFoods(onlyFavorites: true).first.then((f) {
      if (mounted) setState(() => _favorites = f);
    });
  }

  Future<void> _search(String q) async {
    final r = q.trim().isEmpty ? FoodSearchResult.empty : await smartSearch(context.db, q);
    if (mounted && q == _q.text) {
      setState(() => _results = r.foods);
      _live?.update(q, localHits: r.exactHits, enabled: _liveEnabled);
    }
  }

  Future<void> _pickOnline(OffProduct p) async {
    final id = await openOffProduct(context, p);
    if (id == null || !mounted) return;
    final f = await context.db.getFood(id);
    if (f != null && mounted) Navigator.pop(context, f);
  }

  Future<void> _create() async {
    final id = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (_) => FoodFormPage(initialName: _q.text.trim())),
    );
    if (id == null || !mounted) return;
    final f = await context.db.getFood(id);
    if (f != null && mounted) Navigator.pop(context, f);
  }

  @override
  void dispose() {
    _live?.dispose();
    _q.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searching = _q.text.trim().isNotEmpty;
    final list = searching ? _results : _favorites;
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
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
                  hintText: 'Lebensmittel suchen',
                  leading: const Icon(Icons.search),
                  trailing: [
                    IconButton(
                      tooltip: 'Barcode scannen',
                      icon: const Icon(Icons.qr_code_scanner),
                      onPressed: () async {
                        final f = await scanFood(context);
                        if (f != null && context.mounted) Navigator.pop(context, f);
                      },
                    ),
                  ],
                  elevation: const WidgetStatePropertyAll(0),
                  onChanged: (v) {
                    setState(() {});
                    _search(v);
                  },
                ),
              ),
              Expanded(
                child: ListView(
                  children: [
                    if (!searching && _favorites.isNotEmpty)
                      const Padding(
                        padding: EdgeInsets.fromLTRB(20, 8, 20, 4),
                        child: Text('Favoriten', style: TextStyle(fontWeight: FontWeight.w700)),
                      ),
                    if (searching && _results.isEmpty)
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Text('Nichts gefunden für „${_q.text.trim()}“.'),
                      ),
                    for (final f in list)
                      ListTile(
                        title: Text(f.name),
                        subtitle: Text([if (f.brand != null) f.brand!, '${kcal(f.kcal)} / 100 ${f.unit}'].join(' · ')),
                        trailing: const Icon(Icons.add_circle_outline),
                        onTap: () => Navigator.pop(context, f),
                      ),
                    if (searching && _live != null) OffLiveSection(search: _live!, onTap: _pickOnline),
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
}
