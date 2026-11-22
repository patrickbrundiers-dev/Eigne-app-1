import 'branding.dart';

import 'package:material_ui/material_ui.dart';

import 'data/database.dart';
import 'features/lock/lock_gate.dart';
import 'features/home_shell.dart';
import 'features/profile/onboarding_page.dart';
import 'ui/design/theme.dart';

/// Gives every widget access to the database.
class AppScope extends InheritedWidget {
  const AppScope({super.key, required this.db, required super.child});
  final AppDatabase db;

  static AppDatabase of(BuildContext context) => context.dependOnInheritedWidgetOfExactType<AppScope>()!.db;

  @override
  bool updateShouldNotify(AppScope oldWidget) => db != oldWidget.db;
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

/// App-Theme aus dem Sattly-Designsystem (`ui/design/`). Das Farbschema „Frisch (Grün)“ nutzt den
/// Sattly-Akzent (hell Grün, dunkel Limette); die anderen Schemata ersetzen nur die Akzentfarbe.
ThemeData buildTheme(Color seed, Brightness brightness) =>
    sattlyTheme(brightness, accent: seed == colorSchemes['green']!.$2 ? null : seed);

class MyDietApp extends StatelessWidget {
  const MyDietApp({super.key, required this.db});
  final AppDatabase db;

  @override
  Widget build(BuildContext context) {
    return AppScope(
      db: db,
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
              home: const _ProfileGate(),
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
