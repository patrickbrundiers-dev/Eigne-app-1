import 'package:intl/date_symbol_data_local.dart';
import 'package:material_ui/material_ui.dart';

import 'src/app.dart';
import 'src/data/app_database_open.dart';
import 'src/data/backup.dart';
import 'src/data/error_log.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('de_DE');
  // Local error log without personal data; never blocks the start.
  await ErrorLog.install().catchError((Object e) => debugPrint('Fehlerprotokoll nicht verfügbar: $e'));
  final OpenedDatabase opened;
  try {
    opened = await openAppDatabase();
  } catch (e) {
    // Only when the database is encrypted and its key cannot be read right now; nothing was changed.
    runApp(StartupErrorApp(error: e));
    return;
  }
  final db = opened.db;
  runApp(MyDietApp(db: db, protection: opened.protection, notice: opened.notice));
  // Daily local backup in the background; a failure never blocks the app.
  // Older plain backups are encrypted first (7.2b), then today's backup is written.
  BackupService.forApp(db)
      .then((b) async {
        await b.encryptLegacy();
        await b.runIfDue();
      })
      .catchError((Object e) {
        debugPrint('Backup fehlgeschlagen: $e');
        ErrorLog.instance?.record(e, StackTrace.current);
        return null;
      });
}
