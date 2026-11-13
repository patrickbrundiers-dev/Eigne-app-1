import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 900),
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Text('Deine Dokumente. Sicher organisiert.',
                style: textTheme.headlineMedium),
            const SizedBox(height: 8),
            Text(
              'Dein persönliches Dokumentenarchiv – lokal nutzbar, '
              'mit optionaler Synchronisierung.',
              style: textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            const Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                SummaryCard(
                  icon: Icons.inbox_outlined,
                  title: 'Posteingang',
                  subtitle: 'Noch keine Dokumente',
                ),
                SummaryCard(
                  icon: Icons.folder_outlined,
                  title: 'Dokumente',
                  subtitle: 'Dein Archiv wird hier angezeigt',
                ),
                SummaryCard(
                  icon: Icons.event_note_outlined,
                  title: 'Fristen',
                  subtitle: 'Noch keine Erinnerungen',
                ),
              ],
            ),
            const SizedBox(height: 24),
            Align(
              alignment: Alignment.centerLeft,
              child: FilledButton.icon(
                // Import is enabled once encrypted local storage is approved (T5).
                onPressed: null,
                icon: const Icon(Icons.add),
                label: const Text('Dokument importieren'),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Hinweis: Dies ist ein UI-Prototyp. Import, Speicherung, '
              'Benutzerkonten und Synchronisierung folgen in den nächsten Arbeitspaketen.',
              style: textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

class SummaryCard extends StatelessWidget {
  const SummaryCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
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
              Text(title, style: textTheme.titleMedium),
              const SizedBox(height: 4),
              Text(subtitle, style: textTheme.bodySmall),
            ],
          ),
        ),
      ),
    );
  }
}
