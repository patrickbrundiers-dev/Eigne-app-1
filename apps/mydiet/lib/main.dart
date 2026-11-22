import 'package:intl/date_symbol_data_local.dart';
import 'package:material_ui/material_ui.dart';

import 'src/app.dart';
import 'src/data/backup.dart';
import 'src/data/database.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('de_DE');
  final db = AppDatabase();
  runApp(MyDietApp(db: db));
  // Daily local backup in the background; a failure never blocks the app.
  BackupService.forApp(db).then((b) => b.runIfDue()).catchError((Object e) {
    debugPrint('Backup fehlgeschlagen: $e');
    return null;
  });
}
