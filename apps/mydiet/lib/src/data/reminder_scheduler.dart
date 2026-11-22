import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import '../core/reminders.dart';

/// Schedules local notifications. Nothing is sent over the network.
abstract class ReminderScheduler {
  /// Asks for the notification permission where the system needs it (Android 13+).
  Future<bool> requestPermission();

  /// Replaces all scheduled reminders with [reminders].
  Future<void> apply(List<PlannedReminder> reminders);
}

/// Used in tests and on platforms without notifications.
class NoopReminderScheduler implements ReminderScheduler {
  final applied = <List<PlannedReminder>>[];

  @override
  Future<bool> requestPermission() async => true;

  @override
  Future<void> apply(List<PlannedReminder> reminders) async => applied.add(reminders);
}

class LocalReminderScheduler implements ReminderScheduler {
  final _plugin = FlutterLocalNotificationsPlugin();
  bool _ready = false;

  static const _windowsDays = 7;

  Future<void> _init() async {
    if (_ready) return;
    tzdata.initializeTimeZones();
    try {
      final info = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(info.identifier));
    } catch (_) {
      tz.setLocalLocation(tz.getLocation('Europe/Berlin'));
    }
    await _plugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        windows: WindowsInitializationSettings(
          appName: 'Sattly',
          appUserModelId: 'Sattly.Sattly.App',
          guid: '6f7b2c1e-3d4a-4b8e-9c21-5a0d7e9f4b13',
        ),
      ),
    );
    _ready = true;
  }

  @override
  Future<bool> requestPermission() async {
    await _init();
    if (defaultTargetPlatform == TargetPlatform.android) {
      final android = _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
      return await android?.requestNotificationsPermission() ?? true;
    }
    return true;
  }

  NotificationDetails _details(ReminderKind kind) {
    final (id, name) = switch (kind) {
      ReminderKind.meal => ('meals', 'Mahlzeiten'),
      ReminderKind.water => ('water', 'Wasser'),
      ReminderKind.supplement => ('supplements', 'Supplemente'),
      ReminderKind.weigh => ('weigh', 'Wiegen'),
    };
    return NotificationDetails(
      android: AndroidNotificationDetails(id, name, channelDescription: 'Erinnerungen: $name'),
      windows: const WindowsNotificationDetails(),
    );
  }

  @override
  Future<void> apply(List<PlannedReminder> reminders) async {
    await _init();
    await _plugin.cancelAll();
    final now = tz.TZDateTime.now(tz.local);
    final windows = defaultTargetPlatform == TargetPlatform.windows;
    for (final r in reminders) {
      final first = nextFire(r, now);
      if (windows) {
        // Windows does not repeat scheduled toasts: plan the next 7 days, renewed at every start.
        for (var d = 0; d < _windowsDays; d++) {
          final at = DateTime(first.year, first.month, first.day + d, first.hour, first.minute);
          if (r.weekday != null && at.weekday != r.weekday) continue;
          await _plugin.zonedSchedule(
            id: r.id * 10 + d,
            scheduledDate: tz.TZDateTime.from(at, tz.local),
            notificationDetails: _details(r.kind),
            androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
            title: r.title,
            body: r.body,
          );
        }
        continue;
      }
      await _plugin.zonedSchedule(
        id: r.id,
        scheduledDate: tz.TZDateTime(tz.local, first.year, first.month, first.day, first.hour, first.minute),
        notificationDetails: _details(r.kind),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        title: r.title,
        body: r.body,
        matchDateTimeComponents: r.weekday == null ? DateTimeComponents.time : DateTimeComponents.dayOfWeekAndTime,
      );
    }
  }
}

bool get remindersSupported =>
    !kIsWeb && (defaultTargetPlatform == TargetPlatform.android || defaultTargetPlatform == TargetPlatform.windows);

/// Replaced in tests.
ReminderScheduler reminderScheduler = remindersSupported ? LocalReminderScheduler() : NoopReminderScheduler();
