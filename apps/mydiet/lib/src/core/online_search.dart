/// When the food search also asks Open Food Facts while the user types (Aufgabe 3.7).
///
/// Pure Dart, unit tested. The app stays offline-first: the own database is always
/// searched first and shown immediately; Open Food Facts is asked only when the own
/// database has (almost) nothing, after a short typing pause, and only with the search
/// term. See AI_DECISIONS D-20.
library;

import 'nutrition.dart' show normalizeName;

/// At least this many letters or digits before anything is sent.
const liveSearchMinChars = 3;

/// Ask online only if the own database has fewer exact hits than this.
const liveSearchLocalBelow = 3;

/// Typing pause before a request: no request per keystroke.
const liveSearchDelay = Duration(milliseconds: 600);

/// Results per online request (one page, enough to pick from).
const liveSearchPageSize = 12;

/// Whether to ask Open Food Facts for [query] while typing.
///
/// [localHits] are the hits whose name contains all search words (not the typo-tolerant
/// extras, which almost always find "something"). Barcodes (only digits) are left to
/// the scanner, meal sentences ("200 g Reis, 1 Ei") to the text entry.
bool shouldSearchOnline({required String query, required int localHits, bool enabled = true}) {
  if (!enabled) return false;
  final key = liveSearchKey(query);
  if (key.replaceAll(' ', '').length < liveSearchMinChars) return false;
  if (RegExp(r'^\d+$').hasMatch(key.replaceAll(' ', ''))) return false;
  // "200 g Reis", "Reis, Hähnchen": a whole meal, not one product.
  if (RegExp(r'[,;+\n]').hasMatch(query) || RegExp(r'^\s*\d+([.,]\d+)?\s*[a-zA-Zäöü]').hasMatch(query)) {
    return false;
  }
  return localHits < liveSearchLocalBelow;
}

/// Normalised search term used as cache key ("Müsli " and "muesli" are the same request).
String liveSearchKey(String query) => normalizeName(query);

/// Online results without what the user already has: products whose barcode or
/// name+brand is in the own database, and duplicates within the online list.
List<T> withoutKnown<T>(
  Iterable<T> online, {
  required String Function(T) barcode,
  required String Function(T) nameKey,
  Set<String> localBarcodes = const {},
  Set<String> localNameKeys = const {},
}) {
  final seenCodes = {...localBarcodes};
  final seenNames = {...localNameKeys};
  final out = <T>[];
  for (final p in online) {
    final code = barcode(p).trim();
    final name = nameKey(p);
    if (code.isNotEmpty && !seenCodes.add(code)) continue;
    if (!seenNames.add(name)) continue;
    out.add(p);
  }
  return out;
}

/// Small most-recently-used cache, so going back and forth while typing does not
/// send the same request twice.
class RecentCache<V> {
  RecentCache({this.capacity = 30});
  final int capacity;
  final _map = <String, V>{};

  V? operator [](String key) {
    final v = _map.remove(key);
    if (v != null) _map[key] = v;
    return v;
  }

  void operator []=(String key, V value) {
    _map.remove(key);
    _map[key] = value;
    while (_map.length > capacity) {
      _map.remove(_map.keys.first);
    }
  }

  int get length => _map.length;

  void clear() => _map.clear();
}
