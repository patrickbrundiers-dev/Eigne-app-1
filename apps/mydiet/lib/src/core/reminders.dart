/// Reminders (Phase 2e): which local notifications to schedule. Pure Dart, unit tested.
/// Stored as JSON in the setting `reminders`; nothing leaves the device.
library;

import 'dart:convert';

class ReminderSettings {
  const ReminderSettings({
    this.meals = false,
    this.mealLeadMinutes = 0,
    this.water = false,
    this.waterStart = 9 * 60,
    this.waterEnd = 20 * 60,
    this.waterEveryMinutes = 120,
    this.supplements = false,
    this.weigh = false,
    this.weighMinute = 7 * 60,
    this.weighDays = const {1, 2, 3, 4, 5, 6, 7},
  });

  final bool meals;

  /// Minutes before the meal time (0–60).
  final int mealLeadMinutes;
  final bool water;
  final int waterStart;
  final int waterEnd;
  final int waterEveryMinutes;
  final bool supplements;
  final bool weigh;
  final int weighMinute;

  /// ISO weekdays, 1 = Monday.
  final Set<int> weighDays;

  bool get any => meals || water || supplements || weigh;

  ReminderSettings copyWith({
    bool? meals,
    int? mealLeadMinutes,
    bool? water,
    int? waterStart,
    int? waterEnd,
    int? waterEveryMinutes,
    bool? supplements,
    bool? weigh,
    int? weighMinute,
    Set<int>? weighDays,
  }) => ReminderSettings(
    meals: meals ?? this.meals,
    mealLeadMinutes: mealLeadMinutes ?? this.mealLeadMinutes,
    water: water ?? this.water,
    waterStart: waterStart ?? this.waterStart,
    waterEnd: waterEnd ?? this.waterEnd,
    waterEveryMinutes: waterEveryMinutes ?? this.waterEveryMinutes,
    supplements: supplements ?? this.supplements,
    weigh: weigh ?? this.weigh,
    weighMinute: weighMinute ?? this.weighMinute,
    weighDays: weighDays ?? this.weighDays,
  );

  String toJson() => jsonEncode({
    'meals': meals,
    'mealLead': mealLeadMinutes,
    'water': water,
    'waterStart': waterStart,
    'waterEnd': waterEnd,
    'waterEvery': waterEveryMinutes,
    'supplements': supplements,
    'weigh': weigh,
    'weighMinute': weighMinute,
    'weighDays': weighDays.toList()..sort(),
  });

  /// Invalid or missing values fall back to the defaults.
  static ReminderSettings parse(String? s) {
    const d = ReminderSettings();
    if (s == null || s.isEmpty) return d;
    Map<String, dynamic> m;
    try {
      final v = jsonDecode(s);
      if (v is! Map<String, dynamic>) return d;
      m = v;
    } on FormatException {
      return d;
    }
    bool b(String k, bool def) => m[k] is bool ? m[k] as bool : def;
    int i(String k, int def, int min, int max) {
      final v = m[k];
      return v is int && v >= min && v <= max ? v : def;
    }

    final days = m['weighDays'];
    final weighDays = days is List
        ? {
            for (final x in days)
              if (x is int && x >= 1 && x <= 7) x,
          }
        : d.weighDays;
    return ReminderSettings(
      meals: b('meals', d.meals),
      mealLeadMinutes: i('mealLead', d.mealLeadMinutes, 0, 60),
      water: b('water', d.water),
      waterStart: i('waterStart', d.waterStart, 0, 1439),
      waterEnd: i('waterEnd', d.waterEnd, 0, 1439),
      waterEveryMinutes: i('waterEvery', d.waterEveryMinutes, 30, 480),
      supplements: b('supplements', d.supplements),
      weigh: b('weigh', d.weigh),
      weighMinute: i('weighMinute', d.weighMinute, 0, 1439),
      weighDays: weighDays.isEmpty ? d.weighDays : weighDays,
    );
  }
}

enum ReminderKind { meal, water, supplement, weigh }

class PlannedReminder {
  const PlannedReminder({
    required this.id,
    required this.kind,
    required this.title,
    required this.body,
    required this.minute,
    this.weekday,
  });

  /// Stable id per kind and time, so rescheduling replaces instead of duplicating.
  final int id;
  final ReminderKind kind;
  final String title;
  final String body;

  /// Minute of the day, 0–1439.
  final int minute;

  /// ISO weekday for weekly reminders, null for daily ones.
  final int? weekday;

  @override
  String toString() => '$id $kind ${minute ~/ 60}:${minute % 60} $weekday $title';
}

String _hm(int m) => '${(m ~/ 60).toString().padLeft(2, '0')}:${(m % 60).toString().padLeft(2, '0')}';

/// All reminders to schedule. Meal slots without a time get none. Supplement intakes at the
/// same time are combined into one notification.
List<PlannedReminder> planReminders(
  ReminderSettings s, {
  List<({String name, int? minute})> mealSlots = const [],
  List<({String name, int minute})> supplementSlots = const [],
}) {
  final out = <PlannedReminder>[];
  if (s.meals) {
    final timed = [
      for (final m in mealSlots)
        if (m.minute != null) m,
    ];
    for (var i = 0; i < timed.length && i < 10; i++) {
      final m = timed[i];
      out.add(
        PlannedReminder(
          id: 1000 + i,
          kind: ReminderKind.meal,
          title: '${m.name} eintragen',
          body: s.mealLeadMinutes == 0
              ? 'Zeit für ${m.name}. Kurz ins Tagebuch eintragen?'
              : 'In ${s.mealLeadMinutes} Minuten: ${m.name} (${_hm(m.minute!)}).',
          minute: (m.minute! - s.mealLeadMinutes) % 1440,
        ),
      );
    }
  }
  if (s.water && s.waterEnd > s.waterStart) {
    var n = 0;
    for (var t = s.waterStart; t <= s.waterEnd && n < 24; t += s.waterEveryMinutes, n++) {
      out.add(
        PlannedReminder(
          id: 2000 + n,
          kind: ReminderKind.water,
          title: 'Wasser trinken',
          body: 'Ein Glas Wasser? Tippe, um es einzutragen.',
          minute: t,
        ),
      );
    }
  }
  if (s.supplements) {
    final byMinute = <int, List<String>>{};
    for (final x in supplementSlots) {
      if (x.minute < 0 || x.minute > 1439) continue;
      (byMinute[x.minute] ??= []).add(x.name);
    }
    final minutes = byMinute.keys.toList()..sort();
    for (final m in minutes) {
      final names = byMinute[m]!.toSet().toList()..sort();
      out.add(
        PlannedReminder(
          id: 3000 + m,
          kind: ReminderKind.supplement,
          title: 'Supplemente ${_hm(m)}',
          body: names.join(', '),
          minute: m,
        ),
      );
    }
  }
  if (s.weigh) {
    final days = s.weighDays.toList()..sort();
    final daily = days.length == 7;
    if (daily) {
      out.add(
        PlannedReminder(
          id: 4000,
          kind: ReminderKind.weigh,
          title: 'Wiegen',
          body: 'Am besten morgens nach dem Aufstehen, vor dem Frühstück.',
          minute: s.weighMinute,
        ),
      );
    } else {
      for (final d in days) {
        out.add(
          PlannedReminder(
            id: 4000 + d,
            kind: ReminderKind.weigh,
            title: 'Wiegen',
            body: 'Am besten morgens nach dem Aufstehen, vor dem Frühstück.',
            minute: s.weighMinute,
            weekday: d,
          ),
        );
      }
    }
  }
  return out;
}

/// The next time [r] fires after [now] (local time).
DateTime nextFire(PlannedReminder r, DateTime now) {
  var t = DateTime(now.year, now.month, now.day, r.minute ~/ 60, r.minute % 60);
  if (!t.isAfter(now)) t = DateTime(now.year, now.month, now.day + 1, r.minute ~/ 60, r.minute % 60);
  if (r.weekday != null) {
    while (t.weekday != r.weekday) {
      t = DateTime(t.year, t.month, t.day + 1, t.hour, t.minute);
    }
  }
  return t;
}
