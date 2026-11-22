import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../core/dates.dart';
import 'database.dart';

/// Automatic local backups: one JSON export per day in the app's private storage,
/// the newest [keep] are kept. A restore first saves the current state, so a
/// restore can itself be undone.
class BackupService {
  BackupService(this.db, this.dir, {this.keep = 14});

  final AppDatabase db;
  final Directory dir;
  final int keep;

  static const _prefix = 'mydiet-backup-';

  static Future<BackupService> forApp(AppDatabase db) async {
    final base = await getApplicationSupportDirectory();
    return BackupService(db, Directory('${base.path}${Platform.pathSeparator}backups'));
  }

  File _file(String name) => File('${dir.path}${Platform.pathSeparator}$name');

  /// Backups, newest first.
  Future<List<File>> list() async {
    if (!await dir.exists()) return [];
    final files = await dir
        .list()
        .where((e) => e is File && e.uri.pathSegments.last.startsWith(_prefix) && e.path.endsWith('.json'))
        .cast<File>()
        .toList();
    files.sort((a, b) => b.uri.pathSegments.last.compareTo(a.uri.pathSegments.last));
    return files;
  }

  /// Writes today's backup if it does not exist yet. Returns the new file or null.
  Future<File?> runIfDue({DateTime? now}) async {
    final day = dayKey(now ?? DateTime.now());
    final f = _file('$_prefix$day.json');
    if (await f.exists()) return null;
    final written = await _write(f);
    await _prune();
    return written;
  }

  /// Saves the current state (also when a backup of today exists).
  Future<File> backupNow({String suffix = 'manuell', DateTime? now}) async {
    final t = now ?? DateTime.now();
    final stamp =
        '${dayKey(t)}-${t.hour.toString().padLeft(2, '0')}${t.minute.toString().padLeft(2, '0')}'
        '${t.second.toString().padLeft(2, '0')}';
    final f = await _write(_file('$_prefix$stamp-$suffix.json'));
    await _prune();
    return f;
  }

  /// Replaces all data with [backup]; the current state is saved first.
  Future<void> restore(File backup) async {
    final json = await backup.readAsString();
    await backupNow(suffix: 'vor-wiederherstellung');
    await db.importJson(json);
  }

  Future<File> _write(File f) async {
    await dir.create(recursive: true);
    final json = await db.exportJson();
    // Write to a temp file first, so a crash never leaves a half-written backup.
    final tmp = File('${f.path}.tmp');
    await tmp.writeAsString(json, flush: true);
    return tmp.rename(f.path);
  }

  Future<void> _prune() async {
    final all = await list();
    for (final f in all.skip(keep)) {
      try {
        await f.delete();
      } on FileSystemException {
        // ignore: a locked file stays until the next run
      }
    }
  }

  /// Date part of a backup file name, e.g. "2026-03-01".
  static String dayOf(File f) => f.uri.pathSegments.last.substring(_prefix.length, _prefix.length + 10);
}
