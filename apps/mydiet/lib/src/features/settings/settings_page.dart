import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

import '../../app.dart';
import '../../core/dates.dart';
import '../../data/csv_export.dart';
import '../../data/display_prefs.dart';
import 'backup_card.dart';
import '../../ui/widgets.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final db = context.db;
    final t = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Einstellungen')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
            children: [
              SectionCard(
                title: 'Darstellung',
                icon: Icons.palette_outlined,
                child: StreamBuilder<List<Object?>>(
                  stream: combineLatest([db.watchSetting('themeMode'), db.watchSetting('colorScheme')]),
                  builder: (context, snap) {
                    final mode = (snap.data?[0] as String?) ?? 'system';
                    final color = (snap.data?[1] as String?) ?? 'green';
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SegmentedButton<String>(
                          segments: const [
                            ButtonSegment(value: 'system', label: Text('System'), icon: Icon(Icons.brightness_auto)),
                            ButtonSegment(value: 'light', label: Text('Hell'), icon: Icon(Icons.light_mode_outlined)),
                            ButtonSegment(value: 'dark', label: Text('Dunkel'), icon: Icon(Icons.dark_mode_outlined)),
                          ],
                          selected: {mode},
                          onSelectionChanged: (s) => db.setSetting('themeMode', s.first),
                        ),
                        const SizedBox(height: 16),
                        Text('Farbschema', style: t.textTheme.labelLarge),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: [
                            for (final e in colorSchemes.entries)
                              Tooltip(
                                message: e.value.$1,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(24),
                                  onTap: () => db.setSetting('colorScheme', e.key),
                                  child: CircleAvatar(
                                    radius: 22,
                                    backgroundColor: e.value.$2,
                                    child: color == e.key ? const Icon(Icons.check, color: Colors.white) : null,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
              SectionCard(
                title: 'Daten',
                icon: Icons.storage_outlined,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Alle Daten liegen in einer lokalen Datenbank im geschützten App-Speicher dieses Geräts. '
                      'Es wird nichts ins Internet übertragen. Die Synchronisierung zwischen Handy und PC '
                      'folgt in Phase 4. Bis dahin sichert die App täglich automatisch (siehe Sicherungen).',
                      style: t.textTheme.bodySmall?.copyWith(color: t.colorScheme.onSurfaceVariant),
                    ),
                    const SizedBox(height: 12),
                    FilledButton.tonalIcon(
                      onPressed: () => _export(context),
                      icon: const Icon(Icons.download_outlined),
                      label: const Text('Daten exportieren (JSON)'),
                    ),
                    const SizedBox(height: 8),
                    OutlinedButton.icon(
                      onPressed: () => _import(context),
                      icon: const Icon(Icons.upload_outlined),
                      label: const Text('Export importieren (ersetzt alle Daten)'),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        OutlinedButton.icon(
                          onPressed: () => _exportCsv(context, diary: true),
                          icon: const Icon(Icons.table_view_outlined),
                          label: const Text('Tagebuch als CSV'),
                        ),
                        OutlinedButton.icon(
                          onPressed: () => _exportCsv(context, diary: false),
                          icon: const Icon(Icons.table_view_outlined),
                          label: const Text('Gewicht als CSV'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              const BackupCard(),
              const SizedBox(height: 12),
              SectionCard(
                title: 'Ziel und Anzeige',
                icon: Icons.tune,
                child: StreamBuilder<List<Object?>>(
                  stream: combineLatest([db.watchSetting(budgetModeKey), db.watchSetting(hideNumbersKey)]),
                  builder: (context, snap) => Column(
                    children: [
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Wochenbudget statt Tagesziel'),
                        subtitle: const Text(
                          'Mehr oder weniger an einem Tag wird auf die restlichen Tage der Woche verteilt '
                          '(höchstens +20 %, nie unter dem Mindestwert).',
                        ),
                        value: snap.data?[0] == 'week',
                        onChanged: (v) => db.setSetting(budgetModeKey, v ? 'week' : 'day'),
                      ),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Zahlen ausblenden'),
                        subtitle: const Text(
                          'Dashboard und Tagebuch zeigen nur den Fortschritt, keine Kalorien und Gramm. '
                          'Die App rechnet im Hintergrund unverändert weiter.',
                        ),
                        value: snap.data?[1] == 'true',
                        onChanged: (v) => db.setSetting(hideNumbersKey, v ? 'true' : 'false'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SectionCard(
                title: 'Über MyDiet AI',
                icon: Icons.info_outline,
                child: Text(
                  'Version 0.1 · Phase 1 (Grundsystem).\n'
                  'Berechnungen sind Schätzwerte und ersetzen keine ärztliche oder ernährungsmedizinische Beratung.',
                  style: t.textTheme.bodySmall,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _export(BuildContext context) async {
    try {
      final json = await context.db.exportJson();
      final uri = await FilePicker.saveFile(
        fileName: 'mydiet-export-${dayKey(DateTime.now())}.json',
        bytes: Uint8List.fromList(utf8.encode(json)),
        mimeType: 'application/json',
        dialogTitle: 'Export speichern',
      );
      if (context.mounted && uri != null) showMessage(context, 'Export gespeichert');
    } catch (e) {
      if (context.mounted) showMessage(context, 'Export fehlgeschlagen: ${errorText(e)}');
    }
  }

  Future<void> _exportCsv(BuildContext context, {required bool diary}) async {
    final db = context.db;
    try {
      final String csv;
      if (diary) {
        final slots = await db.watchMealSlots().first;
        csv = diaryCsv(await db.allDiary(), {for (final s in slots) s.id: s.name});
      } else {
        csv = weightCsv(await db.allWeights());
      }
      final uri = await FilePicker.saveFile(
        fileName: 'mydiet-${diary ? 'tagebuch' : 'gewicht'}-${dayKey(DateTime.now())}.csv',
        bytes: Uint8List.fromList(utf8.encode(csv)),
        mimeType: 'text/csv',
        dialogTitle: 'CSV speichern',
      );
      if (context.mounted && uri != null) showMessage(context, 'CSV gespeichert');
    } catch (e) {
      if (context.mounted) showMessage(context, 'Export fehlgeschlagen: ${errorText(e)}');
    }
  }

  Future<void> _import(BuildContext context) async {
    final db = context.db;
    final files = await FilePicker.pickFiles(
      dialogTitle: 'MyDiet-Export wählen',
      type: FileType.custom,
      allowedExtensions: const ['json'],
    );
    if (files.isEmpty || !context.mounted) return;
    final ok = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Alle Daten ersetzen?'),
        content: const Text(
          'Profil, Lebensmittel, Tagebuch, Gewicht und Einstellungen werden durch den Inhalt der Datei ersetzt. '
          'Exportiere vorher, wenn du den aktuellen Stand behalten willst.',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('Abbrechen')),
          FilledButton(onPressed: () => Navigator.pop(c, true), child: const Text('Ersetzen')),
        ],
      ),
    );
    if (ok != true) return;
    try {
      final text = utf8.decode(await files.first.readAsBytes());
      final counts = await db.importJson(text);
      if (context.mounted) {
        showMessage(
          context,
          'Import fertig: ${counts['diary_entries'] ?? 0} Tagebucheinträge, ${counts['weight_entries'] ?? 0} Gewichte',
        );
      }
    } catch (e) {
      if (context.mounted) showMessage(context, 'Import fehlgeschlagen, nichts wurde geändert: ${errorText(e)}');
    }
  }
}
