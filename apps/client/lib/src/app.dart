import 'package:flutter/material.dart';

import 'app_state.dart';
import 'auth/token_store.dart';
import 'shell/app_shell.dart';

/// Seed colour for both themes. Light/dark follows the operating system.
const Color kSeedColor = Color(0xFF315C8C);

ThemeData buildTheme(Brightness brightness) => ThemeData(
      colorScheme:
          ColorScheme.fromSeed(seedColor: kSeedColor, brightness: brightness),
      useMaterial3: true,
    );

class PaperlessAiApp extends StatefulWidget {
  const PaperlessAiApp({super.key, this.state});

  /// Injected in tests; the real app creates one with secure token storage.
  final AppState? state;

  @override
  State<PaperlessAiApp> createState() => _PaperlessAiAppState();
}

class _PaperlessAiAppState extends State<PaperlessAiApp> {
  late final AppState _state =
      widget.state ?? AppState(tokenStore: SecureTokenStore());

  @override
  void initState() {
    super.initState();
    if (widget.state == null) _state.restore();
  }

  @override
  Widget build(BuildContext context) {
    return AppScope(state: _state, child: _materialApp());
  }

  Widget _materialApp() {
    return MaterialApp(
      title: 'Paperless AI',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: buildTheme(Brightness.light),
      darkTheme: buildTheme(Brightness.dark),
      home: const AppShell(),
    );
  }
}
