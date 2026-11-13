import 'package:flutter/material.dart';

void main() {
  runApp(const PaperlessAiApp());
}

class PaperlessAiApp extends StatelessWidget {
  const PaperlessAiApp({super.key});

  @override
  Widget build(BuildContext context) {
    const seed = Color(0xFF315C8C);
    return MaterialApp(
      title: 'Paperless AI',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: seed, brightness: Brightness.light),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: seed, brightness: Brightness.dark),
        useMaterial3: true,
      ),
      home: const DashboardPage(),
    );
  }
}

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Paperless AI'),
        actions: [
          IconButton(
            tooltip: 'Einstellungen',
            onPressed: () {},
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Text('Deine Dokumente. Sicher organisiert.',
                  style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 8),
              Text(
                'Dein persönliches Dokumentenarchiv – lokal nutzbar, '
                'mit optionaler Synchronisierung.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 24),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: const [
                  _SummaryCard(
                    icon: Icons.inbox_outlined,
                    title: 'Posteingang',
                    subtitle: 'Noch keine Dokumente',
                  ),
                  _SummaryCard(
                    icon: Icons.folder_outlined,
                    title: 'Dokumente',
                    subtitle: 'Dein Archiv wird hier angezeigt',
                  ),
                  _SummaryCard(
                    icon: Icons.event_note_outlined,
                    title: 'Fristen',
                    subtitle: 'Noch keine Erinnerungen',
                  ),
                ],
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add),
                label: const Text('Dokument importieren'),
              ),
              const SizedBox(height: 8),
              Text(
                'Hinweis: Dies ist ein UI-Prototyp. Import, Speicherung, '
                'Benutzerkonten und Synchronisierung folgen in den nächsten Arbeitspaketen.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 260,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 28),
              const SizedBox(height: 14),
              Text(title, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 4),
              Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
      ),
    );
  }
}
