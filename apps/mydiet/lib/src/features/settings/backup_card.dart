import 'dart:io';

import 'package:material_ui/material_ui.dart';

import '../../app.dart';
import '../../core/dates.dart';
import '../../data/backup.dart';
import '../../ui/format.dart';
import '../../ui/widgets.dart';

/// Lists the automatic backups and restores one.
class BackupCard extends StatefulWidget {
  const BackupCard({super.key});

  @override
  State<BackupCard> createState() => _BackupCardState();
}

class _BackupCardState extends State<BackupCard> {
  Future<(BackupService, List<File>)>? _future;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _future ??= _load();
  }

  Future<(BackupService, List<File>)> _load() async {
    final s = await BackupService.forApp(context.db);
    return (s, await s.list());
  }

  void _reload() => setState(() => _future = _load());

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return SectionCard(
      title: 'Sicherungen',
      icon: Icons.backup_outlined,
      child: FutureBuilder<(BackupService, List<File>)>(
        future: _future,
        builder: (context, snap) {
          if (snap.hasError) {
            return Text('Sicherungen nicht verfügbar: ${errorText(snap.error!)}', style: t.textTheme.bodySmall);
          }
          final d = snap.data;
          if (d == null) return const SizedBox(height: 40, child: Center(child: CircularProgressIndicator()));
          final (service, files) = d;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Die App sichert einmal täglich automatisch alle Daten auf diesem Gerät und behält die letzten '
                '${service.keep} Sicherungen. Vor jeder Wiederherstellung wird der aktuelle Stand zusätzlich gesichert.',
                style: t.textTheme.bodySmall?.copyWith(color: t.colorScheme.onSurfaceVariant),
              ),
              const SizedBox(height: 8),
              if (files.isEmpty) const Text('Noch keine Sicherung vorhanden.'),
              for (final f in files.take(5))
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                  leading: const Icon(Icons.history),
                  title: Text(dateShort(parseDayKey(BackupService.dayOf(f)))),
                  subtitle: Text(f.uri.pathSegments.last),
                  trailing: TextButton(onPressed: () => _restore(service, f), child: const Text('Wiederherstellen')),
                ),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: () async {
                    try {
                      await service.backupNow();
                      if (context.mounted) showMessage(context, 'Sicherung erstellt');
                    } catch (e) {
                      if (context.mounted) showMessage(context, 'Sicherung fehlgeschlagen: ${errorText(e)}');
                    }
                    _reload();
                  },
                  icon: const Icon(Icons.save_outlined),
                  label: const Text('Jetzt sichern'),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _restore(BackupService s, File f) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Sicherung wiederherstellen?'),
        content: Text(
          'Alle aktuellen Daten werden durch den Stand vom ${dateShort(parseDayKey(BackupService.dayOf(f)))} ersetzt. '
          'Der aktuelle Stand wird vorher gesichert.',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('Abbrechen')),
          FilledButton(onPressed: () => Navigator.pop(c, true), child: const Text('Wiederherstellen')),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    try {
      await s.restore(f);
      if (mounted) showMessage(context, 'Sicherung wiederhergestellt');
    } catch (e) {
      if (mounted) showMessage(context, 'Wiederherstellen fehlgeschlagen: ${errorText(e)}');
    }
    _reload();
  }
}
