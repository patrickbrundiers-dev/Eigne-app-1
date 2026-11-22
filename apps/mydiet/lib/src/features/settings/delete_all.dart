import 'package:material_ui/material_ui.dart';

import '../../app.dart';
import '../../data/backup.dart';
import '../../data/reminder_scheduler.dart';
import '../../ui/widgets.dart';

/// Word the user has to type before everything is erased.
const deleteConfirmWord = 'LÖSCHEN';

/// "Alle Daten löschen" (right to erasure): asks twice, then erases the database,
/// optionally all automatic backups, and cancels all reminders.
Future<void> confirmAndDeleteAll(BuildContext context, {BackupService? backups}) async {
  final choice = await showDialog<bool>(context: context, builder: (_) => const _DeleteAllDialog());
  if (choice == null || !context.mounted) return;
  final db = context.db;
  try {
    await db.deleteAllData();
    var removed = 0;
    if (choice) {
      final b = backups ?? await BackupService.forApp(db);
      removed = await b.deleteAll();
    }
    await reminderScheduler.apply(const []);
    if (context.mounted) {
      showMessage(
        context,
        choice
            ? 'Alle Daten und $removed ${removed == 1 ? 'Sicherung' : 'Sicherungen'} gelöscht'
            : 'Alle Daten gelöscht. Die automatischen Sicherungen sind noch da.',
      );
    }
  } catch (e) {
    if (context.mounted) showMessage(context, 'Löschen fehlgeschlagen, nichts wurde geändert: ${errorText(e)}');
  }
}

/// Returns null on cancel, otherwise whether backups are deleted too.
class _DeleteAllDialog extends StatefulWidget {
  const _DeleteAllDialog();

  @override
  State<_DeleteAllDialog> createState() => _DeleteAllDialogState();
}

class _DeleteAllDialogState extends State<_DeleteAllDialog> {
  final _word = TextEditingController();
  bool _backups = true;

  @override
  void dispose() {
    _word.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final ok = _word.text.trim().toUpperCase() == deleteConfirmWord;
    return AlertDialog(
      icon: Icon(Icons.delete_forever_outlined, color: t.colorScheme.error),
      title: const Text('Alle Daten löschen?'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Profil, Tagebuch, Gewicht, eigene Lebensmittel, Rezepte, Pläne, Supplemente, Fasten, '
              'Einstellungen und Erinnerungen werden endgültig von diesem Gerät gelöscht. '
              'Die App startet danach wie neu installiert.',
            ),
            const SizedBox(height: 8),
            Text(
              'Wenn du die Daten behalten willst, exportiere sie vorher (Daten exportieren).',
              style: t.textTheme.bodySmall?.copyWith(color: t.colorScheme.onSurfaceVariant),
            ),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              value: _backups,
              onChanged: (v) => setState(() => _backups = v ?? true),
              title: const Text('Automatische Sicherungen auch löschen'),
              subtitle: const Text('Sonst lassen sich die Daten aus einer Sicherung wiederherstellen.'),
            ),
            TextField(
              controller: _word,
              autocorrect: false,
              decoration: const InputDecoration(
                labelText: 'Zur Bestätigung „$deleteConfirmWord“ eingeben',
                border: OutlineInputBorder(),
              ),
              onChanged: (_) => setState(() {}),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Abbrechen')),
        FilledButton(
          style: FilledButton.styleFrom(backgroundColor: t.colorScheme.error, foregroundColor: t.colorScheme.onError),
          onPressed: ok ? () => Navigator.pop(context, _backups) : null,
          child: const Text('Endgültig löschen'),
        ),
      ],
    );
  }
}
