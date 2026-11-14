import 'package:flutter/material.dart';

import 'shell/app_shell.dart';

/// Seed colour for both themes. Light/dark follows the operating system.
const Color kSeedColor = Color(0xFF315C8C);

ThemeData buildTheme(Brightness brightness) => ThemeData(
      colorScheme:
          ColorScheme.fromSeed(seedColor: kSeedColor, brightness: brightness),
      useMaterial3: true,
    );

class PaperlessAiApp extends StatelessWidget {
  const PaperlessAiApp({super.key});

  @override
  Widget build(BuildContext context) {
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
