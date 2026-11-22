import 'package:material_ui/material_ui.dart';

import 'tokens.dart';

/// Baut das App-Theme aus den Design-Tokens. [accent] ersetzt den Akzent (Einstellungen → Farbschema);
/// ohne Angabe gilt der Sattly-Akzent (hell Grün, dunkel Limette).
///
/// Das Ergebnis wird zwischengespeichert: Ein bei jedem Neuaufbau neu erzeugtes Theme wäre nie gleich dem
/// vorigen (die WidgetState-Funktionen sind jedes Mal neu), und MaterialApp würde bei jedem Neuaufbau
/// 200 ms lang zwischen zwei gleichen Themes überblenden und dabei alle Seiten neu aufbauen.
ThemeData sattlyTheme(Brightness brightness, {Color? accent}) =>
    _cache.putIfAbsent((brightness, accent?.toARGB32()), () => _build(brightness, accent));

final _cache = <(Brightness, int?), ThemeData>{};

ThemeData _build(Brightness brightness, Color? accent) {
  var t = SattlyTokens.of(brightness);
  if (accent != null) t = t.withAccent(accent, brightness);

  final scheme = ColorScheme.fromSeed(seedColor: t.primary, brightness: brightness).copyWith(
    primary: t.primary,
    onPrimary: t.onPrimary,
    primaryContainer: t.primarySoft,
    onPrimaryContainer: t.primaryInk,
    surface: t.surface,
    onSurface: t.ink,
    onSurfaceVariant: t.muted,
    outline: t.muted,
    outlineVariant: t.line,
    surfaceContainerLowest: t.surface,
    surfaceContainerLow: t.surface,
    surfaceContainer: t.surface2,
    surfaceContainerHigh: t.surface2,
    surfaceContainerHighest: t.track,
    surfaceTint: Colors.transparent,
    error: t.danger,
  );

  final base = ThemeData(
    colorScheme: scheme,
    useMaterial3: true,
    brightness: brightness,
    fontFamily: SattlyFonts.body,
    extensions: [t],
  );
  final tt = base.textTheme;
  TextStyle? num(TextStyle? s) => s?.copyWith(fontFamily: SattlyFonts.numbers, fontWeight: FontWeight.w700);
  final textTheme = tt.copyWith(
    displayLarge: num(tt.displayLarge),
    displayMedium: num(tt.displayMedium),
    displaySmall: num(tt.displaySmall),
    headlineLarge: num(tt.headlineLarge),
    headlineMedium: num(tt.headlineMedium),
    headlineSmall: tt.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
    titleLarge: tt.titleLarge?.copyWith(fontWeight: FontWeight.w700),
    titleMedium: tt.titleMedium?.copyWith(fontWeight: FontWeight.w600),
    titleSmall: tt.titleSmall?.copyWith(fontWeight: FontWeight.w700, letterSpacing: 0.3),
    labelLarge: tt.labelLarge?.copyWith(fontWeight: FontWeight.w600),
    labelMedium: tt.labelMedium?.copyWith(fontWeight: FontWeight.w600, letterSpacing: 0.4),
    labelSmall: tt.labelSmall?.copyWith(fontWeight: FontWeight.w600, letterSpacing: 0.6),
  );

  const controlShape = RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(SattlyRadius.control)));
  const buttonSize = Size(64, minTouchTarget);

  return base.copyWith(
    textTheme: textTheme,
    scaffoldBackgroundColor: t.bg,
    canvasColor: t.bg,
    dividerColor: t.line,
    dividerTheme: DividerThemeData(color: t.line, space: 1, thickness: 1),
    cardTheme: CardThemeData(
      elevation: 0,
      margin: EdgeInsets.zero,
      color: t.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(SattlyRadius.card),
        side: BorderSide(color: t.line),
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      scrolledUnderElevation: 0,
      foregroundColor: t.ink,
      titleTextStyle: textTheme.titleLarge?.copyWith(color: t.ink, fontSize: 24),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: t.surface,
      surfaceTintColor: Colors.transparent,
      indicatorColor: t.primarySoft,
      indicatorShape: controlShape,
      labelTextStyle: WidgetStateProperty.resolveWith(
        (s) => TextStyle(
          fontFamily: SattlyFonts.body,
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: s.contains(WidgetState.selected) ? t.ink : t.muted,
        ),
      ),
      iconTheme: WidgetStateProperty.resolveWith(
        (s) => IconThemeData(color: s.contains(WidgetState.selected) ? t.primaryInk : t.muted),
      ),
    ),
    navigationRailTheme: NavigationRailThemeData(
      backgroundColor: t.surface,
      indicatorColor: t.primarySoft,
      indicatorShape: controlShape,
      selectedIconTheme: IconThemeData(color: t.primaryInk),
      unselectedIconTheme: IconThemeData(color: t.muted),
      selectedLabelTextStyle: TextStyle(
        fontFamily: SattlyFonts.body,
        fontWeight: FontWeight.w700,
        color: t.ink,
        fontSize: 12,
      ),
      unselectedLabelTextStyle: TextStyle(
        fontFamily: SattlyFonts.body,
        fontWeight: FontWeight.w600,
        color: t.muted,
        fontSize: 12,
      ),
    ),
    tabBarTheme: TabBarThemeData(
      labelColor: t.ink,
      unselectedLabelColor: t.muted,
      indicatorColor: t.primary,
      dividerColor: t.line,
      labelStyle: const TextStyle(fontFamily: SattlyFonts.body, fontWeight: FontWeight.w700, fontSize: 15),
      unselectedLabelStyle: const TextStyle(fontFamily: SattlyFonts.body, fontWeight: FontWeight.w600, fontSize: 15),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: buttonSize,
        shape: controlShape,
        textStyle: const TextStyle(fontFamily: SattlyFonts.body, fontWeight: FontWeight.w700, fontSize: 15),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(minimumSize: buttonSize, shape: controlShape, elevation: 0),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: buttonSize,
        shape: controlShape,
        side: BorderSide(color: t.line),
        foregroundColor: t.ink,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        shape: controlShape,
        textStyle: const TextStyle(fontFamily: SattlyFonts.body, fontWeight: FontWeight.w700),
      ),
    ),
    segmentedButtonTheme: SegmentedButtonThemeData(
      style: SegmentedButton.styleFrom(
        shape: controlShape,
        side: BorderSide(color: t.line),
        selectedBackgroundColor: t.primarySoft,
        selectedForegroundColor: t.primaryInk,
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: t.primary,
      foregroundColor: t.onPrimary,
      elevation: 0,
      highlightElevation: 0,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(SattlyRadius.fab))),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: t.surface2,
      side: BorderSide.none,
      shape: controlShape,
      labelStyle: TextStyle(fontFamily: SattlyFonts.body, color: t.ink, fontWeight: FontWeight.w600),
    ),
    inputDecorationTheme: InputDecorationTheme(
      isDense: true,
      filled: true,
      fillColor: t.surface2,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(SattlyRadius.control),
        borderSide: BorderSide(color: t.line),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(SattlyRadius.control),
        borderSide: BorderSide(color: t.line),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(SattlyRadius.control),
        borderSide: BorderSide(color: t.primary, width: 2),
      ),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: t.surface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(SattlyRadius.card)),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: t.surface,
      surfaceTintColor: Colors.transparent,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(SattlyRadius.card))),
    ),
    popupMenuTheme: PopupMenuThemeData(
      color: t.surface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(SattlyRadius.control),
        side: BorderSide(color: t.line),
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(SattlyRadius.control)),
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(color: t.primary, linearTrackColor: t.track),
    listTileTheme: ListTileThemeData(iconColor: t.muted, minVerticalPadding: 10),
    dataTableTheme: DataTableThemeData(
      headingTextStyle: TextStyle(
        fontFamily: SattlyFonts.numbers,
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.6,
        color: t.muted,
      ),
      dataTextStyle: TextStyle(fontFamily: SattlyFonts.body, fontSize: 15, color: t.ink),
      dividerThickness: 1,
    ),
  );
}
