import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path_provider/path_provider.dart';

import 'backup.dart' show backupKey;
import 'database.dart';
import 'db_encryption.dart';
import 'error_log.dart';

/// The key in the platform's secure storage (Android Keystore, Windows Credential Manager).
class SecureDbKeyStore implements DbKeyStore {
  static const _name = 'sattly_db_key_v1';
  final _storage = const FlutterSecureStorage();

  @override
  Future<String?> read() => _storage.read(key: _name);

  @override
  Future<void> write(String key) => _storage.write(key: _name, value: key);
}

/// Whether this run uses the encrypted database; shown in the settings.
enum DbProtection { encrypted, plain, unsupported }

class OpenedDatabase {
  const OpenedDatabase(this.db, this.protection, {this.notice});
  final AppDatabase db;
  final DbProtection protection;

  /// A message for the user after the start, e.g. when an unreadable database was set aside.
  final String? notice;
}

/// The same file drift used before encryption: `<Dokumente>/mydiet.sqlite`.
Future<File> appDatabaseFile() async {
  final dir = await getApplicationDocumentsDirectory();
  return File('${dir.path}${Platform.pathSeparator}mydiet.sqlite');
}

/// Opens the app's database, encrypted where possible. Never deletes data and never blocks
/// the start: if the key store or the conversion fails while the file is still unencrypted, the
/// app opens it unencrypted as before and tries again at the next start.
Future<OpenedDatabase> openAppDatabase({DbKeyStore? keys}) async {
  if (kIsWeb) return OpenedDatabase(AppDatabase(), DbProtection.unsupported);
  final file = await appDatabaseFile();
  try {
    final p = await prepareEncryptedDatabase(file, keys ?? SecureDbKeyStore());
    final db = AppDatabase(AppDatabase.openEncrypted(p.path, p.key));
    backupKey = p.key;
    final notice = p.result == DbPrepareResult.keyLost
        ? 'Die bisherige Datenbank ließ sich nicht entschlüsseln, zum Beispiel weil sie aus einer '
              'Gerätesicherung eines anderen Telefons stammt. Sie wurde nicht gelöscht, sondern beiseitegelegt. '
              'Sattly startet leer. Eigene Daten lassen sich unter Einstellungen → Daten aus einem Export '
              'wiederherstellen.'
        : null;
    return OpenedDatabase(db, DbProtection.encrypted, notice: notice);
  } catch (e, st) {
    ErrorLog.instance?.record(e, st);
    if (!await file.exists() || await isPlainSqlite(file)) {
      debugPrint('Verschlüsselung der Datenbank nicht möglich, öffne unverschlüsselt: ${e.runtimeType}');
      return OpenedDatabase(AppDatabase(AppDatabase.openPlain(file.path)), DbProtection.plain);
    }
    rethrow;
  }
}
