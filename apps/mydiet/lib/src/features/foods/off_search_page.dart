import 'package:material_ui/material_ui.dart';

import '../../app.dart';
import '../../core/food_quality.dart';
import '../../data/off_client.dart';
import '../../ui/format.dart';
import 'barcode.dart' show offClientFactory;
import 'food_form_page.dart';

/// Text search at Open Food Facts. Runs only when the user presses "Suchen"; only the
/// search term is sent. A result opens the food form to check and save it, nothing is
/// saved unseen. Pops with the id of the saved food.
class OffSearchPage extends StatefulWidget {
  const OffSearchPage({super.key, this.initialQuery = ''});
  final String initialQuery;

  @override
  State<OffSearchPage> createState() => _OffSearchPageState();
}

class _OffSearchPageState extends State<OffSearchPage> {
  late final _q = TextEditingController(text: widget.initialQuery);
  List<OffProduct>? _results;
  String? _error;
  bool _busy = false;

  @override
  void dispose() {
    _q.dispose();
    super.dispose();
  }

  Future<void> _search() async {
    final q = _q.text.trim();
    if (q.isEmpty || _busy) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final r = await offClientFactory().search(q);
      if (mounted) setState(() => _results = r);
    } on OffException catch (e) {
      if (mounted) setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _open(OffProduct p) async {
    final db = context.db;
    final code = p.barcode.trim();
    if (code.isNotEmpty) {
      final local = await db.findFoodByBarcode(code);
      if (local != null) {
        if (mounted) Navigator.pop(context, local.id);
        return;
      }
    }
    if (!mounted) return;
    final id = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (_) => FoodFormPage(prefill: p, initialBarcode: code.isEmpty ? null : code),
      ),
    );
    if (id != null && mounted) Navigator.pop(context, id);
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final muted = t.textTheme.bodySmall?.copyWith(color: t.colorScheme.onSurfaceVariant);
    final r = _results;
    return Scaffold(
      appBar: AppBar(title: const Text('Open Food Facts durchsuchen')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _q,
                      autofocus: widget.initialQuery.isEmpty,
                      textInputAction: TextInputAction.search,
                      decoration: const InputDecoration(labelText: 'Produkt oder Marke'),
                      onSubmitted: (_) => _search(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  FilledButton.icon(
                    onPressed: _busy ? null : _search,
                    icon: const Icon(Icons.travel_explore),
                    label: const Text('Suchen'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Nur dein Suchbegriff wird an Open Food Facts gesendet (offene Datenbank, ODbL). '
                'Werte bitte mit dem Etikett vergleichen, bevor du speicherst.',
                style: muted,
              ),
              const SizedBox(height: 12),
              if (_busy) const Center(child: CircularProgressIndicator()),
              if (_error != null) Text(_error!, style: TextStyle(color: t.colorScheme.error)),
              if (r != null && r.isEmpty && !_busy) Text('Nichts gefunden für „${_q.text.trim()}“.'),
              if (r != null)
                for (final p in r)
                  Card(
                    child: ListTile(
                      title: Text(p.name),
                      subtitle: Text(
                        [
                          ?p.brand,
                          '${kcal(p.per100.kcal)} pro 100 ${p.unit}',
                          if (p.missing.isNotEmpty) 'fehlt: ${p.missing.join(', ')}',
                        ].join(' · '),
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => _open(p),
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
