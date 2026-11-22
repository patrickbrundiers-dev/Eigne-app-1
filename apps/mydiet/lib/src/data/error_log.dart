import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

import '../core/error_report.dart';

/// Keeps the last [keep] errors in a small JSON-lines file in the app's private storage.
/// Only sanitised reports are written (see core/error_report.dart).
class ErrorLog {
  ErrorLog(this.file, {this.keep = 50});

  final File file;
  final int keep;

  static ErrorLog? _instance;

  /// The app's log, or null before [install] ran (e.g. in tests).
  static ErrorLog? get instance => _instance;

  static Future<ErrorLog> forApp() async {
    final base = await getApplicationSupportDirectory();
    return ErrorLog(File('${base.path}${Platform.pathSeparator}fehlerprotokoll.jsonl'));
  }

  /// Catches framework and uncaught async errors and records them; the previous
  /// handlers still run (red screen in debug, console output).
  static Future<void> install() async {
    final log = await forApp();
    _instance = log;
    final previousFlutter = FlutterError.onError;
    FlutterError.onError = (details) {
      log.record(details.exception, details.stack);
      previousFlutter?.call(details);
    };
    final previousPlatform = PlatformDispatcher.instance.onError;
    PlatformDispatcher.instance.onError = (error, stack) {
      log.record(error, stack);
      return previousPlatform?.call(error, stack) ?? false;
    };
  }

  Future<void> _pending = Future.value();

  /// Adds a report. Never throws: logging must not cause new errors.
  Future<void> record(Object error, StackTrace? stack, {DateTime? now}) {
    final report = reportFor(error, stack, now: now);
    return _pending = _pending.then((_) async {
      try {
        final all = [...await read(), report];
        final kept = all.length > keep ? all.sublist(all.length - keep) : all;
        await file.parent.create(recursive: true);
        await file.writeAsString(kept.map((r) => jsonEncode(r.toJson())).join('\n'), flush: true);
      } catch (_) {
        // ignore
      }
    });
  }

  /// Oldest first.
  Future<List<ErrorReport>> read() async {
    try {
      if (!await file.exists()) return [];
      final lines = await file.readAsLines();
      return [
        for (final l in lines)
          if (l.trim().isNotEmpty) ?ErrorReport.fromJson(_tryDecode(l)),
      ];
    } catch (_) {
      return [];
    }
  }

  Future<void> clear() async {
    await _pending;
    if (await file.exists()) await file.delete();
  }
}

Object? _tryDecode(String s) {
  try {
    return jsonDecode(s);
  } catch (_) {
    return null;
  }
}
