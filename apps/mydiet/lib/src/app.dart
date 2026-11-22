import 'branding.dart';

import 'package:material_ui/material_ui.dart';

import 'data/app_database_open.dart' show DbProtection;
import 'data/database.dart';
import 'features/lock/lock_gate.dart';
import 'features/home_shell.dart';
import 'features/profile/onboarding_page.dart';

/// Gives every widget access to the database.
class AppScope extends InheritedWidget {
  const AppScope({super.key, required this.db, this.protection = DbProtection.unsupported, required super.child});
  final AppDatabase db;

  /// Whether the database file is encrypted on this start (7.2).
  final DbProtection protection;

  static DbProtection protectionOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AppScope>()?.protection ?? DbProtection.unsupported;

  static AppDatabase of(BuildContext context) => context.dependOnInheritedWidgetOfExactType<AppScope>()!.db;

  @override
  bool updateShouldNotify(AppScope oldWidget) => db != oldWidget.db || protection != oldWidget.protection;
}

extension DbContext on BuildContext {
  AppDatabase get db => AppScope.of(this);
}

/// Colour schemes the user can choose from (Einstellungen → Farbschema).
const colorSchemes = <String, (String, Color)>{
  'green': ('Frisch (Grün)', Color(0xFF2E7D5B)),
  'teal': ('Petrol', Color(0xFF00796B)),
  'blue': ('Blau', Color(0xFF2F5DA8)),
  'violet': ('Violett', Color(0xFF6A4FB3)),
  'orange': ('Orange', Color(0xFFD9662B)),
  'rose': ('Rosé', Color(0xFFC2416B)),
};

ThemeData buildTheme(Color seed, Brightness brightness) {
  final scheme = ColorScheme.fromSeed(seedColor: seed, brightness: brightness);
  final base = ThemeData(colorScheme: scheme, useMaterial3: true, brightness: brightness, fontFamily: 'Inter');
  return base.copyWith(
    scaffoldBackgroundColor: brightness == Brightness.light ? scheme.surfaceContainerLowest : scheme.surface,
    cardTheme: CardThemeData(
      elevation: 0,
      margin: EdgeInsets.zero,
      color: brightness == Brightness.light ? scheme.surface : scheme.surfaceContainer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: scheme.outlineVariant.withValues(alpha: 0.6)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      isDense: true,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      scrolledUnderElevation: 0,
      titleTextStyle: base.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: brightness == Brightness.light ? scheme.surface : scheme.surfaceContainer,
      indicatorColor: scheme.primaryContainer,
    ),
  );
}

class MyDietApp extends StatelessWidget {
  const MyDietApp({super.key, required this.db, this.protection = DbProtection.unsupported, this.notice});
  final AppDatabase db;
  final DbProtection protection;

  /// Shown once after the start (e.g. an unreadable database was set aside).
  final String? notice;

  @override
  Widget build(BuildContext context) {
    return AppScope(
      db: db,
      protection: protection,
      child: StreamBuilder<String?>(
        stream: db.watchSetting('themeMode'),
        builder: (context, modeSnap) => StreamBuilder<String?>(
          stream: db.watchSetting('colorScheme'),
          builder: (context, colorSnap) {
            final seed = (colorSchemes[colorSnap.data] ?? colorSchemes['green']!).$2;
            final mode = switch (modeSnap.data) {
              'light' => ThemeMode.light,
              'dark' => ThemeMode.dark,
              _ => ThemeMode.system,
            };
            return MaterialApp(
              title: appName,
              debugShowCheckedModeBanner: false,
              theme: buildTheme(seed, Brightness.light),
              darkTheme: buildTheme(seed, Brightness.dark),
              themeMode: mode,
              locale: const Locale('de', 'DE'),
              supportedLocales: const [Locale('de', 'DE'), Locale('en')],
              localizationsDelegates: GlobalMaterialLocalizations.delegates,
              // Above the navigator, so the lock also covers pages and dialogs.
              builder: (context, child) => LockGate(child: child ?? const SizedBox()),
              home: notice == null
                  ? const _ProfileGate()
                  : _StartupNotice(message: notice!, child: const _ProfileGate()),
            );
          },
        ),
      ),
    );
  }
}

class _ProfileGate extends StatelessWidget {
  const _ProfileGate();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Profile?>(
      stream: context.db.watchProfile(),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting && !snap.hasData) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (snap.data == null) return const OnboardingPage();
        return const HomeShell();
      },
    );
  }
}

/// Shows [message] once in a dialog after the first frame.
class _StartupNotice extends StatefulWidget {
  const _StartupNotice({required this.message, required this.child});
  final String message;
  final Widget child;

  @override
  State<_StartupNotice> createState() => _StartupNoticeState();
}

class _StartupNoticeState extends State<_StartupNotice> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Datenbank neu angelegt'),
          content: Text(widget.message),
          actions: [FilledButton(onPressed: () => Navigator.pop(context), child: const Text('Verstanden'))],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

/// Shown instead of the app when the encrypted database exists but its key cannot be read.
/// Nothing was changed; the next start tries again.
class StartupErrorApp extends StatelessWidget {
  const StartupErrorApp({super.key, required this.error});
  final Object error;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appName,
      debugShowCheckedModeBanner: false,
      theme: buildTheme(colorSchemes['green']!.$2, Brightness.light),
      home: const Scaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.lock_outline, size: 48),
                SizedBox(height: 16),
                Text('Datenbank gerade nicht lesbar', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
                SizedBox(height: 12),
                Text(
                  'Sattly konnte den Schlüssel deiner verschlüsselten Daten nicht aus dem sicheren Speicher des '
                  'Geräts lesen. Es wurde nichts verändert oder gelöscht. Bitte schließe die App und starte sie '
                  'erneut, nach einem Neustart des Geräts klappt es meist wieder.',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
