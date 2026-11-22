import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/error_report.dart';
import '../../data/error_log.dart';
import '../../ui/format.dart';
import '../../ui/widgets.dart';
import '../home_shell.dart' show PageBody;

/// Shows the local error log. Nothing is sent anywhere; the user can copy it into a bug report.
class ErrorLogPage extends StatefulWidget {
  const ErrorLogPage({super.key, this.log});

  /// For tests; defaults to the app's log.
  final ErrorLog? log;

  @override
  State<ErrorLogPage> createState() => _ErrorLogPageState();
}

class _ErrorLogPageState extends State<ErrorLogPage> {
  late Future<List<ErrorReport>> _reports = _load();

  ErrorLog? get _log => widget.log ?? ErrorLog.instance;

  Future<List<ErrorReport>> _load() async => (await _log?.read() ?? const <ErrorReport>[]).reversed.toList();

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Fehlerprotokoll')),
      body: FutureBuilder<List<ErrorReport>>(
        future: _reports,
        builder: (context, snap) {
          final list = snap.data;
          if (list == null) return const Center(child: CircularProgressIndicator());
          return PageBody(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(
                  'Hier stehen technische Fehler der App, nur auf diesem Gerät. Zahlen, Texte in Anführungszeichen '
                  'und Dateipfade werden vor dem Speichern entfernt, damit keine Gesundheitsdaten im Protokoll landen. '
                  'Nichts wird automatisch gesendet.',
                  style: t.textTheme.bodySmall?.copyWith(color: t.colorScheme.onSurfaceVariant),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  children: [
                    FilledButton.tonalIcon(
                      onPressed: list.isEmpty
                          ? null
                          : () async {
                              await Clipboard.setData(ClipboardData(text: list.map((r) => r.toText()).join('\n\n')));
                              if (context.mounted) showMessage(context, 'Protokoll kopiert');
                            },
                      icon: const Icon(Icons.copy),
                      label: const Text('Kopieren'),
                    ),
                    OutlinedButton.icon(
                      onPressed: list.isEmpty
                          ? null
                          : () async {
                              await _log?.clear();
                              setState(() => _reports = _load());
                            },
                      icon: const Icon(Icons.delete_outline),
                      label: const Text('Leeren'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (list.isEmpty)
                  const Card(
                    child: ListTile(leading: Icon(Icons.check_circle_outline), title: Text('Keine Fehler.')),
                  )
                else
                  for (final r in list)
                    Card(
                      child: ListTile(
                        title: Text(r.type),
                        subtitle: Text(
                          [
                            '${dateShort(r.time)}, ${timeOfDay(r.time.hour * 60 + r.time.minute)}',
                            r.message,
                            if (r.frames.isNotEmpty) r.frames.first,
                          ].join('\n'),
                        ),
                        isThreeLine: true,
                      ),
                    ),
              ],
            ),
          );
        },
      ),
    );
  }
}
