import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:material_ui/material_ui.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app.dart';
import '../../core/app_update.dart';
import '../../data/update_client.dart';
import '../../ui/widgets.dart';

/// Replaced in tests.
UpdateClient Function() updateClientFactory = UpdateClient.new;

@visibleForTesting
AppVersion? debugCurrentVersion;

Future<AppVersion> currentAppVersion() async {
  if (debugCurrentVersion != null) return debugCurrentVersion!;
  final info = await PackageInfo.fromPlatform();
  return AppVersion.tryParse(info.version) ?? const AppVersion(0, 0, 0);
}

UpdatePlatform get updatePlatform {
  if (kIsWeb) return UpdatePlatform.other;
  return switch (defaultTargetPlatform) {
    TargetPlatform.android => UpdatePlatform.android,
    TargetPlatform.windows => UpdatePlatform.windows,
    _ => UpdatePlatform.other,
  };
}

const _kAuto = 'updateAutoCheck';
const _kLast = 'updateLastCheck';
const _kSkip = 'updateSkippedTag';

/// Checks once a day after start (can be switched off). Errors stay silent.
Future<void> autoCheckForUpdate(BuildContext context) async {
  final db = context.db;
  try {
    if (await db.getSetting(_kAuto) == 'off') return;
    final now = DateTime.now();
    final last = DateTime.tryParse(await db.getSetting(_kLast) ?? '');
    if (!autoCheckDue(last, now)) return;
    final latest = await updateClientFactory().fetchLatest();
    await db.setSetting(_kLast, now.toIso8601String());
    final offer = offeredUpdate(latest, await currentAppVersion(), skippedTag: await db.getSetting(_kSkip));
    if (offer == null || !context.mounted) return;
    showMessage(
      context,
      'MyDiet AI ${offer.version} ist verfügbar.',
      action: SnackBarAction(label: 'Ansehen', onPressed: () => showUpdateDialog(context, offer)),
    );
  } catch (_) {
    // Offline or GitHub not reachable: try again next start.
  }
}

/// Settings section: current version, automatic check, manual check.
class UpdateCard extends StatefulWidget {
  const UpdateCard({super.key});

  @override
  State<UpdateCard> createState() => _UpdateCardState();
}

class _UpdateCardState extends State<UpdateCard> {
  AppVersion? _current;
  bool _checking = false;
  String? _status;

  @override
  void initState() {
    super.initState();
    currentAppVersion().then((v) {
      if (mounted) setState(() => _current = v);
    });
  }

  Future<void> _check() async {
    setState(() {
      _checking = true;
      _status = null;
    });
    final db = context.db;
    try {
      final latest = await updateClientFactory().fetchLatest();
      await db.setSetting(_kLast, DateTime.now().toIso8601String());
      final current = _current ?? await currentAppVersion();
      final offer = offeredUpdate(latest, current);
      if (!mounted) return;
      setState(() {
        _checking = false;
        _status = offer == null ? 'Du hast die neueste Version ($current).' : null;
      });
      if (offer != null) await showUpdateDialog(context, offer);
    } on UpdateException catch (e) {
      if (mounted) setState(() => _status = e.message);
    } finally {
      if (mounted) setState(() => _checking = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final db = context.db;
    final t = Theme.of(context);
    return SectionCard(
      title: 'Updates',
      icon: Icons.system_update_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Installierte Version: ${_current ?? '…'}', style: t.textTheme.bodyLarge),
          StreamBuilder<String?>(
            stream: db.watchSetting(_kAuto),
            builder: (context, snap) => SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Täglich automatisch prüfen'),
              subtitle: const Text('Fragt GitHub Releases nach einer neuen Version, ohne persönliche Daten.'),
              value: snap.data != 'off',
              onChanged: (v) => db.setSetting(_kAuto, v ? 'on' : 'off'),
            ),
          ),
          if (_status != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(_status!, style: t.textTheme.bodySmall),
            ),
          FilledButton.tonalIcon(
            onPressed: _checking ? null : _check,
            icon: _checking
                ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                : const Icon(Icons.refresh),
            label: const Text('Nach Updates suchen'),
          ),
        ],
      ),
    );
  }
}

Future<void> showUpdateDialog(BuildContext context, UpdateInfo info) async {
  final asset = info.assetFor(updatePlatform);
  final choice = await showDialog<String>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Version ${info.version} ist da'),
      content: SizedBox(
        width: 480,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (info.notes.isNotEmpty) Text(info.notes),
              const SizedBox(height: 12),
              Text(switch (updatePlatform) {
                UpdatePlatform.windows =>
                  'Das Setup wird geladen, geprüft und gestartet. Die App schließt sich dafür kurz; '
                      'deine Daten bleiben erhalten.',
                UpdatePlatform.android =>
                  'Die neue APK wird im Browser geladen. Danach antippen und „Aktualisieren“ wählen; '
                      'deine Daten bleiben erhalten.',
                UpdatePlatform.other => 'Die Download-Seite wird geöffnet.',
              }, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context, 'skip'), child: const Text('Überspringen')),
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Später')),
        FilledButton(onPressed: () => Navigator.pop(context, 'install'), child: const Text('Jetzt aktualisieren')),
      ],
    ),
  );
  if (!context.mounted) return;
  if (choice == 'skip') {
    await context.db.setSetting(_kSkip, info.tag);
    if (context.mounted) showMessage(context, 'Version ${info.version} wird nicht mehr angeboten.');
  } else if (choice == 'install') {
    await installUpdate(context, info, asset);
  }
}

Future<void> installUpdate(BuildContext context, UpdateInfo info, UpdateAsset? asset) async {
  if (asset == null || updatePlatform == UpdatePlatform.other) {
    await launchUrl(info.page, mode: LaunchMode.externalApplication);
    return;
  }
  if (updatePlatform == UpdatePlatform.android) {
    final ok = await launchUrl(asset.url, mode: LaunchMode.externalApplication);
    if (!ok && context.mounted) showMessage(context, 'Browser konnte nicht geöffnet werden.');
    return;
  }
  // Windows: download, verify, run the setup silently and quit; the setup restarts the app.
  final progress = ValueNotifier<double>(0);
  showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      title: const Text('Update wird geladen'),
      content: ValueListenableBuilder<double>(
        valueListenable: progress,
        builder: (_, v, _) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            LinearProgressIndicator(value: v > 0 ? v : null),
            const SizedBox(height: 8),
            Text('${(v * 100).round()} %'),
          ],
        ),
      ),
    ),
  );
  try {
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}${Platform.pathSeparator}${asset.name}');
    await updateClientFactory().download(asset, file, onProgress: (v) => progress.value = v);
    await Process.start(file.path, [
      '/SILENT',
      '/SUPPRESSMSGBOXES',
      '/NORESTART',
      '/CLOSEAPPLICATIONS',
    ], mode: ProcessStartMode.detached);
    exit(0);
  } catch (e) {
    if (context.mounted) {
      Navigator.of(context, rootNavigator: true).pop();
      showMessage(context, e is UpdateException ? e.message : 'Update fehlgeschlagen: ${errorText(e)}');
    }
  } finally {
    progress.dispose();
  }
}
