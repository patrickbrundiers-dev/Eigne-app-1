/// Local error log entries without personal or health data.
///
/// Error messages can contain values the user typed (weights, amounts, food names
/// in exceptions). Before anything is stored, [sanitizeErrorMessage] removes numbers
/// and quoted text, and only stack frames from the app's own code are kept. The log
/// never leaves the device unless the user copies it.
library;

class ErrorReport {
  const ErrorReport({required this.time, required this.type, required this.message, required this.frames});

  final DateTime time;

  /// Runtime type of the error, e.g. "StateError".
  final String type;

  /// Sanitised message.
  final String message;

  /// Up to [maxFrames] frames of the app's own code ("lib/src/...:123").
  final List<String> frames;

  Map<String, Object> toJson() => {'t': time.toUtc().toIso8601String(), 'type': type, 'msg': message, 'at': frames};

  static ErrorReport? fromJson(Object? j) {
    if (j is! Map) return null;
    final t = DateTime.tryParse('${j['t']}');
    if (t == null) return null;
    return ErrorReport(
      time: t.toLocal(),
      type: '${j['type'] ?? ''}',
      message: '${j['msg'] ?? ''}',
      frames: [for (final f in (j['at'] as List? ?? const [])) '$f'],
    );
  }

  /// Plain text for copying into a bug report.
  String toText() => ['${time.toIso8601String()} $type: $message', for (final f in frames) '  at $f'].join('\n');
}

const int maxMessageLength = 300;
const int maxFrames = 8;

/// Removes what could be user data from an error message: quoted text, numbers,
/// e-mail addresses and file paths; then shortens it.
String sanitizeErrorMessage(String message) {
  var s = message;
  s = s.replaceAll(RegExp(r'[\w.+-]+@[\w-]+\.[\w.]+'), '<E-Mail>');
  s = s.replaceAll(RegExp(r'"[^"]*"'), '"…"');
  s = s.replaceAll(RegExp(r"'[^']*'"), "'…'");
  s = s.replaceAll(RegExp('„[^“]*“'), '„…“');
  s = s.replaceAll(RegExp(r'([A-Za-z]:)?[\\/][^\s:]+([\\/][^\s:]+)+'), '<Pfad>');
  s = s.replaceAll(RegExp(r'\d+([.,]\d+)?'), '#');
  s = s.replaceAll(RegExp(r'\s+'), ' ').trim();
  if (s.length > maxMessageLength) s = '${s.substring(0, maxMessageLength)}…';
  return s;
}

/// Keeps only frames of the app's own package, as "file:line".
List<String> appFrames(String stack, {String package = 'mydiet_ai'}) {
  final out = <String>[];
  final re = RegExp('package:$package/([^\\s):]+):(\\d+)');
  for (final line in stack.split('\n')) {
    final m = re.firstMatch(line);
    if (m != null) out.add('${m[1]}:${m[2]}');
    if (out.length >= maxFrames) break;
  }
  return out;
}

ErrorReport reportFor(Object error, StackTrace? stack, {DateTime? now}) => ErrorReport(
  time: now ?? DateTime.now(),
  type: error.runtimeType.toString(),
  message: sanitizeErrorMessage(error.toString()),
  frames: stack == null ? const [] : appFrames(stack.toString()),
);
