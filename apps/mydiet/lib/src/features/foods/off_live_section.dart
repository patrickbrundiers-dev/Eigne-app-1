import 'dart:async';

import 'package:material_ui/material_ui.dart';

import '../../core/food_quality.dart';
import '../../core/nutrition.dart' show foodKey;
import '../../core/online_search.dart';
import '../../data/database.dart';
import '../../data/off_client.dart';
import '../../ui/format.dart';
import 'barcode.dart' show offClientFactory;

/// Asks Open Food Facts while the user types, when the own database has (almost)
/// nothing (Aufgabe 3.7, rules in core/online_search.dart). Only the search term is
/// sent, after a typing pause; answers for older terms are dropped. Without internet
/// the own search keeps working and only a short note is shown.
class OffLiveSearch extends ChangeNotifier {
  OffLiveSearch(this.db);
  final AppDatabase db;

  /// Raw answers per search term, shared by all search pages of this app run.
  static final _cache = RecentCache<List<OffProduct>>();

  /// For tests: forget earlier answers.
  @visibleForTesting
  static void clearCache() => _cache.clear();

  Timer? _timer;
  int _seq = 0;
  bool _disposed = false;

  /// Whether the online part is shown at all for the current term.
  bool active = false;
  bool loading = false;
  String? error;
  List<OffProduct> results = const [];

  /// Call after every local search with the term and the number of exact local hits.
  void update(String query, {required int localHits, required bool enabled}) {
    _timer?.cancel();
    final seq = ++_seq;
    if (!shouldSearchOnline(query: query, localHits: localHits, enabled: enabled)) {
      if (active || loading || error != null || results.isNotEmpty) {
        active = false;
        loading = false;
        error = null;
        results = const [];
        _notify();
      }
      return;
    }
    active = true;
    error = null;
    final key = liveSearchKey(query);
    final cached = _cache[key];
    if (cached != null) {
      unawaited(_show(cached, seq));
      return;
    }
    loading = true;
    results = const [];
    _notify();
    _timer = Timer(liveSearchDelay, () => _run(query.trim(), key, seq));
  }

  Future<void> _run(String query, String key, int seq) async {
    try {
      final raw = await offClientFactory().search(query, pageSize: liveSearchPageSize);
      _cache[key] = raw;
      await _show(raw, seq);
    } on OffException catch (e) {
      if (seq != _seq || _disposed) return;
      loading = false;
      error = e.message;
      _notify();
    }
  }

  Future<void> _show(List<OffProduct> raw, int seq) async {
    String nameKey(OffProduct p) => foodKey(p.name, p.brand);
    final known = await db.knownFoods(barcodes: raw.map((p) => p.barcode), keys: raw.map(nameKey));
    if (seq != _seq || _disposed) return;
    results = withoutKnown(
      raw,
      barcode: (p) => p.barcode,
      nameKey: nameKey,
      localBarcodes: known.barcodes,
      localNameKeys: known.keys,
    );
    loading = false;
    _notify();
  }

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    _timer?.cancel();
    super.dispose();
  }
}

/// The online part of the search list: header, progress, results or a short note.
class OffLiveSection extends StatelessWidget {
  const OffLiveSection({super.key, required this.search, required this.onTap});
  final OffLiveSearch search;
  final ValueChanged<OffProduct> onTap;

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: search,
    builder: (context, _) {
      if (!search.active) return const SizedBox.shrink();
      final t = Theme.of(context);
      final muted = t.textTheme.bodySmall?.copyWith(color: t.colorScheme.onSurfaceVariant);
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Online bei Open Food Facts',
                    style: t.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                  ),
                ),
                if (search.loading)
                  Semantics(
                    label: 'Suche läuft',
                    child: const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 2, 20, 4),
            child: Text('Nur der Suchbegriff wird gesendet. Werte vor dem Speichern prüfen.', style: muted),
          ),
          if (search.error != null)
            ListTile(
              leading: const Icon(Icons.cloud_off),
              title: const Text('Online-Suche gerade nicht möglich'),
              subtitle: Text('${search.error} Deine eigene Datenbank funktioniert weiter.'),
            )
          else if (!search.loading && search.results.isEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
              child: Text('Auch online nichts Passendes gefunden.', style: t.textTheme.bodyMedium),
            ),
          for (final p in search.results)
            ListTile(
              leading: const Icon(Icons.public),
              title: Text(p.name),
              subtitle: Text(
                [
                  ?p.brand,
                  '${kcal(p.per100.kcal)} / 100 ${p.unit}',
                  if (p.missing.isNotEmpty) 'fehlt: ${p.missing.join(', ')}',
                ].join(' · '),
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => onTap(p),
            ),
        ],
      );
    },
  );
}
