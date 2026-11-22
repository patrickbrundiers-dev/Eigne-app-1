import 'package:material_ui/material_ui.dart';

import '../../app.dart';
import '../../data/health_source.dart';
import '../../data/health_sync.dart';
import '../../ui/format.dart';
import '../../ui/widgets.dart';

/// Settings → Health Connect: connect, import now, automatic import.
class HealthPage extends StatefulWidget {
  const HealthPage({super.key});

  @override
  State<HealthPage> createState() => _HealthPageState();
}

class _HealthPageState extends State<HealthPage> {
  late final HealthSource _source = healthSourceFactory();
  HealthAvailability? _availability;
  bool _permitted = false;
  bool _busy = false;
  String? _result;

  @override
  void initState() {
    super.initState();
    _check();
  }

  Future<void> _check() async {
    HealthAvailability a;
    var ok = false;
    try {
      a = await _source.availability();
      if (a == HealthAvailability.available) ok = await _source.hasPermissions();
    } catch (_) {
      a = HealthAvailability.unavailable;
    }
    if (mounted) {
      setState(() {
        _availability = a;
        _permitted = ok;
      });
    }
  }

  Future<void> _connect(HealthSettings s) async {
    final db = context.db;
    setState(() => _busy = true);
    try {
      final ok = await _source.requestPermissions();
      if (!ok) {
        if (mounted) {
          setState(() => _result = 'Keine Freigabe erteilt. Du kannst sie jederzeit in Health Connect ändern.');
        }
        return;
      }
      await db.setSetting(healthSettingsKey, s.copyWith(enabled: true).toJson());
      _permitted = true;
      await _import(days: 30);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _setWrite(HealthSettings s, bool on) async {
    final db = context.db;
    if (!on) {
      await db.setSetting(healthSettingsKey, s.copyWith(writeNutrition: false).toJson());
      return;
    }
    setState(() => _busy = true);
    try {
      final ok = await _source.hasWritePermission() || await _source.requestWritePermission();
      if (!ok) {
        if (mounted) setState(() => _result = 'Ohne Freigabe kann Sattly keine Mahlzeiten schreiben.');
        return;
      }
      await db.setSetting(healthSettingsKey, s.copyWith(writeNutrition: true).toJson());
      final n = await exportNutrition(db, _source);
      if (mounted) setState(() => _result = '$n Mahlzeiten der letzten 7 Tage nach Health Connect geschrieben.');
    } catch (e) {
      if (mounted) setState(() => _result = 'Schreiben nach Health Connect hat nicht geklappt ($e).');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _import({int days = 7}) async {
    final db = context.db;
    setState(() {
      _busy = true;
      _result = null;
    });
    try {
      final r = await importHealth(db, _source, days: days);
      if (mounted) {
        setState(
          () => _result =
              '${r.activities} Aktivitätseinträge${r.weights > 0 ? ' und ${r.weights} Gewichtswerte' : ''} '
              'aus den letzten $days Tagen übernommen.'
              '${r.mealsWritten != null ? ' ${r.mealsWritten} Mahlzeiten geschrieben.' : ''}',
        );
      }
    } catch (e) {
      if (mounted) setState(() => _result = 'Health Connect konnte nicht gelesen werden ($e).');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final db = context.db;
    final t = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Health Connect')),
      body: StreamBuilder<String?>(
        stream: db.watchSetting(healthSettingsKey),
        builder: (context, snap) {
          final s = HealthSettings.parse(snap.data);
          final a = _availability;
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                children: [
                  SectionCard(
                    title: 'Verbindung',
                    icon: Icons.favorite_outline,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Sattly liest aus Health Connect Schritte, aktive Kalorien, Trainings und Gewicht. Apps wie '
                          'Garmin Connect, Samsung Health oder Google Fit schreiben dorthin, so kommen ihre Werte ohne '
                          'eigenes Konto in die App. Die Daten bleiben auf dem Gerät.',
                          style: t.textTheme.bodySmall,
                        ),
                        const SizedBox(height: 12),
                        if (a == null)
                          const LinearProgressIndicator()
                        else if (a == HealthAvailability.unavailable)
                          const Text('Auf diesem Gerät ist Health Connect nicht verfügbar (nur Android 9 und neuer).')
                        else if (a == HealthAvailability.needsInstall)
                          FilledButton.icon(
                            onPressed: () async {
                              await _source.install();
                              await _check();
                            },
                            icon: const Icon(Icons.download_outlined),
                            label: const Text('Health Connect installieren'),
                          )
                        else if (!_permitted)
                          FilledButton.icon(
                            onPressed: _busy ? null : () => _connect(s),
                            icon: const Icon(Icons.link),
                            label: const Text('Verbinden und Freigaben erteilen'),
                          )
                        else ...[
                          Row(
                            children: [
                              Icon(Icons.check_circle, color: t.colorScheme.primary),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  s.lastImport == null
                                      ? 'Verbunden'
                                      : 'Verbunden · zuletzt übernommen ${dateTiny(s.lastImport!)} '
                                            '${timeOfDay(s.lastImport!.hour * 60 + s.lastImport!.minute)}',
                                ),
                              ),
                            ],
                          ),
                          SwitchListTile(
                            contentPadding: EdgeInsets.zero,
                            title: const Text('Beim Öffnen automatisch übernehmen'),
                            subtitle: const Text('höchstens alle 3 Stunden, die letzten 7 Tage'),
                            value: s.enabled,
                            onChanged: (v) => db.setSetting(healthSettingsKey, s.copyWith(enabled: v).toJson()),
                          ),
                          SwitchListTile(
                            contentPadding: EdgeInsets.zero,
                            title: const Text('Mahlzeiten nach Health Connect schreiben'),
                            subtitle: const Text(
                              'Kalorien und Nährwerte je Mahlzeit der letzten 7 Tage, für Apps, die Ernährung aus '
                              'Health Connect lesen',
                            ),
                            value: s.writeNutrition,
                            onChanged: _busy ? null : (v) => _setWrite(s, v),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: FilledButton.tonalIcon(
                              onPressed: _busy ? null : () => _import(),
                              icon: _busy
                                  ? const SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(strokeWidth: 2),
                                    )
                                  : const Icon(Icons.sync),
                              label: const Text('Jetzt übernehmen'),
                            ),
                          ),
                        ],
                        if (_result != null) ...[const SizedBox(height: 8), Text(_result!)],
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'So wird gezählt: jedes Training wird ein eigener Eintrag. Pro Tag gibt es einen Eintrag '
                    '„Alltag“ mit Schritten und den aktiven Kalorien, die nicht schon in einem Training stecken. '
                    'Erneutes Übernehmen aktualisiert diese Einträge statt sie doppelt anzulegen; selbst gelöschte '
                    'kommen nicht wieder. Ein Gewicht aus Health Connect wird nur für Tage ohne eigenen Eintrag '
                    'übernommen. Wie viel der Aktivität dein Tagesbudget erhöht, stellst du im Profil ein. '
                    'Geschriebene Mahlzeiten ersetzt Sattly bei jedem Abgleich, Einträge anderer Apps bleiben unberührt.',
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
