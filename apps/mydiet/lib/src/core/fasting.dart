/// Intermittent fasting: protocols and timer state. Pure Dart, unit tested.
library;

class FastingProtocol {
  const FastingProtocol(this.id, this.label, this.fastHours);
  final String id;
  final String label;
  final double fastHours;

  double get eatingHours => 24 - fastHours;
}

const fastingProtocols = <FastingProtocol>[
  FastingProtocol('14_10', '14:10', 14),
  FastingProtocol('16_8', '16:8', 16),
  FastingProtocol('18_6', '18:6', 18),
  FastingProtocol('20_4', '20:4', 20),
  FastingProtocol('omad', 'Eine Mahlzeit (23:1)', 23),
  FastingProtocol('36', '36 Stunden', 36),
];

FastingProtocol protocolById(String? id) =>
    fastingProtocols.where((p) => p.id == id).firstOrNull ?? fastingProtocols[1];

class FastingState {
  const FastingState({required this.start, required this.now, required this.targetHours});
  final DateTime start;
  final DateTime now;
  final double targetHours;

  Duration get elapsed => now.isBefore(start) ? Duration.zero : now.difference(start);
  Duration get target => Duration(minutes: (targetHours * 60).round());
  Duration get remaining => elapsed >= target ? Duration.zero : target - elapsed;
  double get progress => target.inSeconds == 0 ? 1 : (elapsed.inSeconds / target.inSeconds).clamp(0, 1).toDouble();
  bool get reached => elapsed >= target;
  DateTime get endsAt => start.add(target);
}

/// Hours and minutes, e.g. "15:42 h".
String formatHm(Duration d) {
  final h = d.inMinutes ~/ 60;
  final m = d.inMinutes % 60;
  return '$h:${m.toString().padLeft(2, '0')} h';
}

/// Average length of finished fasts in hours, or null.
double? averageFastHours(Iterable<({DateTime start, DateTime? end})> sessions) {
  final done = [
    for (final s in sessions)
      if (s.end != null && s.end!.isAfter(s.start)) s.end!.difference(s.start).inMinutes / 60,
  ];
  if (done.isEmpty) return null;
  return done.reduce((a, b) => a + b) / done.length;
}
