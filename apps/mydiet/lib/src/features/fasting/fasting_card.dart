import 'dart:async';

import 'package:material_ui/material_ui.dart';

import '../../app.dart';
import '../../core/fasting.dart';
import '../../data/database.dart';
import '../../ui/format.dart';
import '../../ui/widgets.dart';

/// Intermittent fasting: timer, start/stop, protocol and recent fasts.
class FastingCard extends StatefulWidget {
  const FastingCard({super.key});

  @override
  State<FastingCard> createState() => _FastingCardState();
}

class _FastingCardState extends State<FastingCard> {
  Timer? _tick;

  @override
  void initState() {
    super.initState();
    _tick = Timer.periodic(const Duration(seconds: 30), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _tick?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final db = context.db;
    final t = Theme.of(context);
    return SectionCard(
      title: 'Intervallfasten',
      icon: Icons.timer_outlined,
      child: StreamBuilder<List<Object?>>(
        stream: combineLatest([db.watchFasting(limit: 14), db.watchSetting('fastingProtocol')]),
        builder: (context, snap) {
          final v = snap.data;
          if (v == null) return const SizedBox(height: 60);
          final sessions = v[0] as List<FastingSession>;
          final protocol = protocolById(v[1] as String?);
          final open = sessions.where((s) => s.endAt == null).firstOrNull;
          final avg = averageFastHours([for (final s in sessions) (start: s.startAt, end: s.endAt)]);
          if (open == null) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Plan: ${protocol.label} · ${n0(protocol.fastHours)} h fasten',
                        style: t.textTheme.bodyLarge,
                      ),
                    ),
                    PopupMenuButton<String>(
                      tooltip: 'Fastenplan',
                      icon: const Icon(Icons.tune),
                      onSelected: (id) => db.setSetting('fastingProtocol', id),
                      itemBuilder: (_) => [
                        for (final p in fastingProtocols)
                          CheckedPopupMenuItem(value: p.id, checked: p.id == protocol.id, child: Text(p.label)),
                      ],
                    ),
                  ],
                ),
                if (avg != null)
                  Text(
                    'Ø ${n1opt(avg)} h in den letzten ${sessions.where((s) => s.endAt != null).length} Fastenzeiten',
                    style: t.textTheme.bodySmall,
                  ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: () => _start(context, protocol, DateTime.now()),
                        icon: const Icon(Icons.play_arrow),
                        label: const Text('Jetzt starten'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    OutlinedButton(
                      onPressed: () => _startEarlier(context, protocol),
                      child: const Text('Früher begonnen'),
                    ),
                  ],
                ),
              ],
            );
          }
          final st = FastingState(start: open.startAt, now: DateTime.now(), targetHours: open.targetHours);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          formatHm(st.elapsed),
                          style: t.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
                        ),
                        Text(
                          st.reached
                              ? 'Ziel von ${n1opt(open.targetHours)} h erreicht'
                              : 'noch ${formatHm(st.remaining)} · Ende ${timeOfDay(st.endsAt.hour * 60 + st.endsAt.minute)}',
                          style: t.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  FilledButton.tonal(onPressed: () => _end(context), child: const Text('Beenden')),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(value: st.progress, minHeight: 8),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _start(BuildContext context, FastingProtocol p, DateTime at) async {
    try {
      await context.db.startFast(targetHours: p.fastHours, at: at);
    } catch (e) {
      if (context.mounted) showMessage(context, errorText(e));
    }
  }

  Future<void> _startEarlier(BuildContext context, FastingProtocol p) async {
    final now = DateTime.now();
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: (now.hour + 22) % 24, minute: 0),
      helpText: 'Letzte Mahlzeit um',
    );
    if (time == null || !context.mounted) return;
    var start = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    if (start.isAfter(now)) start = DateTime(now.year, now.month, now.day - 1, time.hour, time.minute);
    await _start(context, p, start);
  }

  Future<void> _end(BuildContext context) async {
    try {
      await context.db.endFast();
    } catch (e) {
      if (context.mounted) showMessage(context, errorText(e));
    }
  }
}
