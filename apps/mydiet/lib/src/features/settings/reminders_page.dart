import 'dart:async';

import 'package:material_ui/material_ui.dart';

import '../../app.dart';
import '../../core/reminders.dart';
import '../../data/database.dart';
import '../../data/reminder_scheduler.dart';
import '../../ui/format.dart';
import '../../ui/widgets.dart';

const remindersKey = 'reminders';

/// The reminders for the current settings, meal times and supplements.
Stream<List<PlannedReminder>> watchPlannedReminders(AppDatabase db) =>
    combineLatest([db.watchSetting(remindersKey), db.watchMealSlots(), db.watchSupplements(activeOnly: true)]).map((v) {
      final settings = ReminderSettings.parse(v[0] as String?);
      final slots = v[1] as List<MealSlot>;
      final sups = v[2] as List<SupplementWithDoses>;
      return planReminders(
        settings,
        mealSlots: [for (final s in slots) (name: s.name, minute: s.minuteOfDay)],
        supplementSlots: [
          for (final s in sups)
            for (final slot in s.slots)
              if (slot.minute >= 0) (name: s.supplement.name, minute: slot.minute),
        ],
      );
    });

/// Keeps the scheduled notifications in line with the data. Runs while the app is open and
/// renews everything at start (needed on Windows, where toasts don't repeat).
StreamSubscription<void> startReminderSync(AppDatabase db) {
  String? last;
  return watchPlannedReminders(db).listen((list) async {
    final key = list.map((r) => '$r|${r.body}').join('\n');
    if (key == last) return;
    last = key;
    try {
      await reminderScheduler.apply(list);
    } catch (e) {
      debugPrint('Erinnerungen konnten nicht geplant werden: $e');
    }
  });
}

class RemindersPage extends StatelessWidget {
  const RemindersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final db = context.db;
    final t = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Erinnerungen')),
      body: StreamBuilder<List<Object?>>(
        stream: combineLatest([db.watchSetting(remindersKey), watchPlannedReminders(db)]),
        builder: (context, snap) {
          final v = snap.data;
          if (v == null) return const Center(child: CircularProgressIndicator());
          final s = ReminderSettings.parse(v[0] as String?);
          final planned = v[1] as List<PlannedReminder>;
          Future<void> save(ReminderSettings n) async {
            if (n.any && !s.any) {
              final ok = await reminderScheduler.requestPermission();
              if (!ok && context.mounted) {
                showMessage(
                  context,
                  'Benachrichtigungen sind ausgeschaltet. Bitte in den Systemeinstellungen erlauben.',
                );
              }
            }
            await db.setSetting(remindersKey, n.toJson());
          }

          int count(ReminderKind k) => planned.where((r) => r.kind == k).length;
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                children: [
                  if (!remindersSupported)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Text(
                        'Auf diesem Gerät sind keine Benachrichtigungen möglich.',
                        style: t.textTheme.bodySmall,
                      ),
                    ),
                  SectionCard(
                    title: 'Mahlzeiten',
                    icon: Icons.restaurant_menu_outlined,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('An Mahlzeiten erinnern'),
                          subtitle: Text(
                            s.meals
                                ? '${count(ReminderKind.meal)} Mahlzeiten mit Uhrzeit (Profil → Mahlzeiten)'
                                : 'Zu den Uhrzeiten deiner Mahlzeiten',
                          ),
                          value: s.meals,
                          onChanged: (x) => save(s.copyWith(meals: x)),
                        ),
                        if (s.meals)
                          DropdownButtonFormField<int>(
                            initialValue: const [0, 10, 15, 30, 60].contains(s.mealLeadMinutes) ? s.mealLeadMinutes : 0,
                            decoration: const InputDecoration(labelText: 'Zeitpunkt'),
                            items: [
                              for (final m in const [0, 10, 15, 30, 60])
                                DropdownMenuItem(value: m, child: Text(m == 0 ? 'Zur Mahlzeit' : '$m Minuten vorher')),
                            ],
                            onChanged: (m) => save(s.copyWith(mealLeadMinutes: m)),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  SectionCard(
                    title: 'Wasser',
                    icon: Icons.water_drop_outlined,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Ans Trinken erinnern'),
                          subtitle: Text(
                            s.water
                                ? '${count(ReminderKind.water)}× am Tag, ${timeOfDay(s.waterStart)}–${timeOfDay(s.waterEnd)}'
                                : 'Regelmäßig über den Tag',
                          ),
                          value: s.water,
                          onChanged: (x) => save(s.copyWith(water: x)),
                        ),
                        if (s.water) ...[
                          Row(
                            children: [
                              Expanded(
                                child: _TimeButton(
                                  label: 'Von',
                                  minute: s.waterStart,
                                  onPicked: (m) => save(s.copyWith(waterStart: m)),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: _TimeButton(
                                  label: 'Bis',
                                  minute: s.waterEnd,
                                  onPicked: (m) => save(s.copyWith(waterEnd: m)),
                                ),
                              ),
                            ],
                          ),
                          if (s.waterEnd <= s.waterStart)
                            Text('„Bis“ muss nach „Von“ liegen.', style: TextStyle(color: t.colorScheme.error)),
                          const SizedBox(height: 8),
                          DropdownButtonFormField<int>(
                            initialValue: const [60, 90, 120, 180].contains(s.waterEveryMinutes)
                                ? s.waterEveryMinutes
                                : 120,
                            decoration: const InputDecoration(labelText: 'Abstand'),
                            items: [
                              for (final m in const [60, 90, 120, 180])
                                DropdownMenuItem(value: m, child: Text('alle ${n1opt(m / 60)} Stunden')),
                            ],
                            onChanged: (m) => save(s.copyWith(waterEveryMinutes: m)),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  SectionCard(
                    title: 'Supplemente',
                    icon: Icons.medication_outlined,
                    child: SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('An Einnahmen erinnern'),
                      subtitle: Text(
                        s.supplements
                            ? '${count(ReminderKind.supplement)} Uhrzeiten aus deinen Supplementen'
                            : 'Zu den Uhrzeiten, die bei den Supplementen eingetragen sind',
                      ),
                      value: s.supplements,
                      onChanged: (x) => save(s.copyWith(supplements: x)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SectionCard(
                    title: 'Wiegen',
                    icon: Icons.monitor_weight_outlined,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Ans Wiegen erinnern'),
                          subtitle: const Text('Morgens, immer zur gleichen Zeit, ergibt die besten Trends'),
                          value: s.weigh,
                          onChanged: (x) => save(s.copyWith(weigh: x)),
                        ),
                        if (s.weigh) ...[
                          _TimeButton(
                            label: 'Uhrzeit',
                            minute: s.weighMinute,
                            onPicked: (m) => save(s.copyWith(weighMinute: m)),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 6,
                            children: [
                              for (var d = 1; d <= 7; d++)
                                FilterChip(
                                  label: Text(const ['Mo', 'Di', 'Mi', 'Do', 'Fr', 'Sa', 'So'][d - 1]),
                                  selected: s.weighDays.contains(d),
                                  onSelected: (on) {
                                    final days = {...s.weighDays};
                                    on ? days.add(d) : days.remove(d);
                                    if (days.isNotEmpty) save(s.copyWith(weighDays: days));
                                  },
                                ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Erinnerungen werden nur auf diesem Gerät geplant. Auf Android können sie wegen '
                    'Energiesparen einige Minuten später kommen.',
                    style: t.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _TimeButton extends StatelessWidget {
  const _TimeButton({required this.label, required this.minute, required this.onPicked});

  final String label;
  final int minute;
  final ValueChanged<int> onPicked;

  @override
  Widget build(BuildContext context) => OutlinedButton.icon(
    icon: const Icon(Icons.schedule),
    label: Text('$label ${timeOfDay(minute)}'),
    onPressed: () async {
      final t = await showTimePicker(
        context: context,
        initialTime: TimeOfDay(hour: minute ~/ 60, minute: minute % 60),
      );
      if (t != null) onPicked(t.hour * 60 + t.minute);
    },
  );
}
