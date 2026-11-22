import 'package:material_ui/material_ui.dart';

/// Sattly-Designsystem „Fitness & Performance“ (Design 2, freigegeben von Patrick am 22.11.2026).
///
/// Alle Farben, Abstände, Radien und Schriftrollen an einer Stelle. Seiten lesen Farben über
/// `context.tokens` (oder das daraus gebaute `ColorScheme`), nie als feste Werte.
/// Vorlage und Begründung: docs/design/REDESIGN.md, Vorschau docs/design/vorschau.html.
@immutable
class SattlyTokens extends ThemeExtension<SattlyTokens> {
  const SattlyTokens({
    required this.bg,
    required this.surface,
    required this.surface2,
    required this.ink,
    required this.muted,
    required this.line,
    required this.track,
    required this.primary,
    required this.onPrimary,
    required this.primarySoft,
    required this.primaryInk,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.fiber,
    required this.water,
    required this.good,
    required this.warn,
    required this.danger,
  });

  /// Seitenhintergrund.
  final Color bg;

  /// Karten, Leisten, Dialoge.
  final Color surface;

  /// Flächen in Karten: Chips, Eingabefelder, Segmente.
  final Color surface2;

  /// Text und Kennzahlen.
  final Color ink;

  /// Beschriftungen, Nebeninfos.
  final Color muted;

  /// Rahmen und Trennlinien.
  final Color line;

  /// Hintergrund von Balken und Ringen.
  final Color track;

  /// Akzent: Hauptaktionen, Kalorien-Fortschritt, aktive Navigation.
  final Color primary;
  final Color onPrimary;
  final Color primarySoft;
  final Color primaryInk;

  /// Makro- und Wasserfarben (in Balken, Ringen, Diagrammen).
  final Color protein, carbs, fat, fiber, water;

  /// Status: im Ziel, Hinweis, über dem Ziel / Fehler.
  final Color good, warn, danger;

  static const light = SattlyTokens(
    bg: Color(0xFFF1F3F5),
    surface: Color(0xFFFFFFFF),
    surface2: Color(0xFFE8ECEF),
    ink: Color(0xFF0F1418),
    muted: Color(0xFF5E6974),
    line: Color(0xFFE1E6EA),
    track: Color(0xFFE3E8EC),
    primary: Color(0xFF137C45),
    onPrimary: Color(0xFFFFFFFF),
    primarySoft: Color(0xFFDDF5E6),
    primaryInk: Color(0xFF0F6438),
    protein: Color(0xFF7C5CE0),
    carbs: Color(0xFFC77700),
    fat: Color(0xFFE5486C),
    fiber: Color(0xFF0F8F79),
    water: Color(0xFF1A8CBF),
    good: Color(0xFF137C45),
    warn: Color(0xFFC77700),
    danger: Color(0xFFD12F45),
  );

  static const dark = SattlyTokens(
    bg: Color(0xFF0C0F12),
    surface: Color(0xFF151A1F),
    surface2: Color(0xFF1E252C),
    ink: Color(0xFFF1F4F6),
    muted: Color(0xFF8A96A2),
    line: Color(0xFF232B33),
    track: Color(0xFF252E37),
    primary: Color(0xFFC6F05A),
    onPrimary: Color(0xFF0C0F12),
    primarySoft: Color(0xFF2A3517),
    primaryInk: Color(0xFFD8F58C),
    protein: Color(0xFFA78BFA),
    carbs: Color(0xFFFFB547),
    fat: Color(0xFFFF6B8A),
    fiber: Color(0xFF4ADE9F),
    water: Color(0xFF38BDF8),
    good: Color(0xFF8EDC6B),
    warn: Color(0xFFFFB547),
    danger: Color(0xFFFF6B6B),
  );

  static SattlyTokens of(Brightness b) => b == Brightness.dark ? dark : light;

  /// Ersetzt den Akzent durch eine andere Farbe (Einstellungen → Farbschema).
  SattlyTokens withAccent(Color seed, Brightness b) {
    final s = ColorScheme.fromSeed(seedColor: seed, brightness: b);
    return copyWith(
      primary: s.primary,
      onPrimary: s.onPrimary,
      primarySoft: s.primaryContainer,
      primaryInk: s.onPrimaryContainer,
    );
  }

  @override
  SattlyTokens copyWith({
    Color? bg,
    Color? surface,
    Color? surface2,
    Color? ink,
    Color? muted,
    Color? line,
    Color? track,
    Color? primary,
    Color? onPrimary,
    Color? primarySoft,
    Color? primaryInk,
    Color? protein,
    Color? carbs,
    Color? fat,
    Color? fiber,
    Color? water,
    Color? good,
    Color? warn,
    Color? danger,
  }) => SattlyTokens(
    bg: bg ?? this.bg,
    surface: surface ?? this.surface,
    surface2: surface2 ?? this.surface2,
    ink: ink ?? this.ink,
    muted: muted ?? this.muted,
    line: line ?? this.line,
    track: track ?? this.track,
    primary: primary ?? this.primary,
    onPrimary: onPrimary ?? this.onPrimary,
    primarySoft: primarySoft ?? this.primarySoft,
    primaryInk: primaryInk ?? this.primaryInk,
    protein: protein ?? this.protein,
    carbs: carbs ?? this.carbs,
    fat: fat ?? this.fat,
    fiber: fiber ?? this.fiber,
    water: water ?? this.water,
    good: good ?? this.good,
    warn: warn ?? this.warn,
    danger: danger ?? this.danger,
  );

  @override
  SattlyTokens lerp(SattlyTokens? other, double t) {
    if (other == null) return this;
    Color l(Color a, Color b) => Color.lerp(a, b, t)!;
    return SattlyTokens(
      bg: l(bg, other.bg),
      surface: l(surface, other.surface),
      surface2: l(surface2, other.surface2),
      ink: l(ink, other.ink),
      muted: l(muted, other.muted),
      line: l(line, other.line),
      track: l(track, other.track),
      primary: l(primary, other.primary),
      onPrimary: l(onPrimary, other.onPrimary),
      primarySoft: l(primarySoft, other.primarySoft),
      primaryInk: l(primaryInk, other.primaryInk),
      protein: l(protein, other.protein),
      carbs: l(carbs, other.carbs),
      fat: l(fat, other.fat),
      fiber: l(fiber, other.fiber),
      water: l(water, other.water),
      good: l(good, other.good),
      warn: l(warn, other.warn),
      danger: l(danger, other.danger),
    );
  }
}

/// Abstände (4er-Raster).
abstract final class SattlySpace {
  static const double xs = 4, s = 8, m = 12, l = 16, xl = 24, xxl = 32;
}

/// Rundungen: Karten, Bedienelemente, Plus-Taste.
abstract final class SattlyRadius {
  static const double card = 14, control = 10, fab = 16, pill = 999;
}

/// Schriftrollen: Barlow für Text, Barlow Condensed für Kennzahlen.
abstract final class SattlyFonts {
  static const body = 'Barlow';
  static const numbers = 'BarlowCondensed';
}

/// Mindestgröße für Tipp-Flächen (Material-Empfehlung 48, Apple 44).
const double minTouchTarget = 48;

extension SattlyTokensContext on BuildContext {
  SattlyTokens get tokens => Theme.of(this).extension<SattlyTokens>() ?? SattlyTokens.of(Theme.of(this).brightness);
}

/// Große Kennzahl in Barlow Condensed (z. B. „865“ kcal übrig).
TextStyle numberStyle(double size, {Color? color, FontWeight weight = FontWeight.w700}) => TextStyle(
  fontFamily: SattlyFonts.numbers,
  fontSize: size,
  fontWeight: weight,
  height: 1.05,
  color: color,
  fontFeatures: const [FontFeature.tabularFigures()],
);
