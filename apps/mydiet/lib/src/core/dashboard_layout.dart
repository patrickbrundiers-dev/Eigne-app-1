import 'dart:convert';

/// Dashboard tiles. [wide] tiles span two columns.
enum DashTile {
  calories('Kalorien heute', wide: true),
  macros('Makronährstoffe', wide: true),
  weight('Gewicht'),
  goal('Zielfortschritt'),
  water('Wasser'),
  activity('Aktivität'),
  weightChart('Gewichtskurve', wide: true),
  hints('Tageshinweise', wide: true),
  protein('Protein'),
  meals('Mahlzeiten heute'),
  supplements('Supplemente heute', wide: true),
  fasting('Intervallfasten', wide: true),
  micros('Vitamine und Mineralstoffe', wide: true);

  const DashTile(this.label, {this.wide = false});
  final String label;
  final bool wide;
}

class TileConfig {
  const TileConfig(this.tile, this.visible);
  final DashTile tile;
  final bool visible;

  TileConfig copyWith({bool? visible}) => TileConfig(tile, visible ?? this.visible);
}

const _defaultHidden = {DashTile.protein, DashTile.meals, DashTile.supplements, DashTile.fasting, DashTile.micros};

List<TileConfig> defaultLayout() => [for (final t in DashTile.values) TileConfig(t, !_defaultHidden.contains(t))];

/// Reads a stored layout. Unknown tiles are dropped, tiles added in a newer app
/// version are appended (hidden), so a stored layout never loses or duplicates tiles.
List<TileConfig> parseLayout(String? json) {
  if (json == null || json.isEmpty) return defaultLayout();
  try {
    final list = jsonDecode(json) as List;
    final out = <TileConfig>[];
    final seen = <DashTile>{};
    for (final e in list) {
      final m = e as Map;
      final tile = DashTile.values.where((t) => t.name == m['id']).firstOrNull;
      if (tile == null || !seen.add(tile)) continue;
      out.add(TileConfig(tile, m['visible'] == true));
    }
    for (final t in DashTile.values) {
      if (!seen.contains(t)) out.add(TileConfig(t, false));
    }
    return out;
  } catch (_) {
    return defaultLayout();
  }
}

String encodeLayout(List<TileConfig> layout) => jsonEncode([
  for (final c in layout) {'id': c.tile.name, 'visible': c.visible},
]);

/// Returns [json] with the tile [id] made visible (or hidden). Unknown ids leave it unchanged.
String setTileVisible(String? json, String id, bool visible) {
  final layout = parseLayout(json);
  return encodeLayout([for (final c in layout) c.tile.name == id ? c.copyWith(visible: visible) : c]);
}
