import 'package:material_ui/material_ui.dart';

import '../../core/app_lock.dart';
import '../../data/app_lock_store.dart';
import '../../ui/widgets.dart';
import 'lock_gate.dart';

/// Settings → App-Sperre: PIN, fingerprint, when to lock.
class AppLockPage extends StatefulWidget {
  const AppLockPage({super.key});

  @override
  State<AppLockPage> createState() => _AppLockPageState();
}

class _AppLockPageState extends State<AppLockPage> {
  final LockStore _store = lockStoreFactory();
  final Biometrics _bio = biometricsFactory();
  LockConfig? _config;
  bool _bioAvailable = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final c = await _store.read();
    final b = await _bio.available();
    if (mounted) {
      setState(() {
        _config = c;
        _bioAvailable = b;
      });
    }
  }

  Future<void> _save(LockConfig c) async {
    await _store.write(c);
    LockGate.changes.add(null);
    if (mounted) setState(() => _config = c);
  }

  Future<void> _setPin() async {
    final pin = await showDialog<String>(context: context, builder: (_) => const _NewPinDialog());
    if (pin == null || !mounted) return;
    await _save(_config!.copyWith(pin: PinHash.create(pin), failed: 0, clearBlocked: true));
    if (mounted) showMessage(context, 'App-Sperre ist an.');
  }

  Future<void> _turnOff() async {
    final c = _config!;
    final pin = await showDialog<String>(
      context: context,
      builder: (_) => const _PinDialog(title: 'Aktuelle PIN eingeben'),
    );
    if (pin == null || !mounted) return;
    final r = tryPin(c, pin, DateTime.now());
    await _save(r.unlocked ? r.config.copyWith(clearPin: true, biometrics: false) : r.config);
    if (mounted) showMessage(context, r.unlocked ? 'App-Sperre ist aus.' : 'Falsche PIN.');
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final c = _config;
    return Scaffold(
      appBar: AppBar(title: const Text('App-Sperre')),
      body: c == null
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 720),
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                  children: [
                    SwitchListTile(
                      title: const Text('App mit PIN sperren'),
                      subtitle: Text(c.enabled ? 'An' : 'Aus'),
                      value: c.enabled,
                      onChanged: (v) => v ? _setPin() : _turnOff(),
                    ),
                    if (c.enabled) ...[
                      ListTile(
                        leading: const Icon(Icons.pin_outlined),
                        title: const Text('PIN ändern'),
                        onTap: _setPin,
                      ),
                      SwitchListTile(
                        secondary: const Icon(Icons.fingerprint),
                        title: const Text('Mit Fingerabdruck entsperren'),
                        subtitle: Text(
                          _bioAvailable
                              ? 'Gesichtserkennung oder Windows Hello, wenn das Gerät es anbietet'
                              : 'Auf diesem Gerät nicht verfügbar',
                        ),
                        value: c.biometrics && _bioAvailable,
                        onChanged: _bioAvailable
                            ? (v) async {
                                if (v && !await _bio.authenticate()) return;
                                await _save(c.copyWith(biometrics: v));
                              }
                            : null,
                      ),
                      ListTile(
                        leading: const Icon(Icons.timer_outlined),
                        title: const Text('Sperren, wenn die App im Hintergrund war'),
                        trailing: DropdownButton<int>(
                          value: c.lockAfterSeconds,
                          items: [
                            for (final e in lockAfterChoices.entries)
                              DropdownMenuItem(value: e.key, child: Text(e.value)),
                          ],
                          onChanged: (v) => v == null ? null : _save(c.copyWith(lockAfterSeconds: v)),
                        ),
                      ),
                    ],
                    const SizedBox(height: 12),
                    Text(
                      'Die PIN wird nur als verschlüsselter Prüfwert auf diesem Gerät gespeichert, nicht in Sicherungen '
                      'oder Exporten. Nach vier falschen Versuchen wartet die App, mit jedem weiteren länger. Die Daten '
                      'selbst liegen weiter im geschützten App-Speicher und werden nicht zusätzlich verschlüsselt.',
                      style: t.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

class _PinDialog extends StatefulWidget {
  const _PinDialog({required this.title});
  final String title;

  @override
  State<_PinDialog> createState() => _PinDialogState();
}

class _PinDialogState extends State<_PinDialog> {
  final _c = TextEditingController();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(widget.title),
    content: TextField(
      controller: _c,
      autofocus: true,
      obscureText: true,
      keyboardType: TextInputType.number,
      maxLength: pinMaxLength,
      decoration: const InputDecoration(labelText: 'PIN'),
      onSubmitted: (v) => Navigator.pop(context, v),
    ),
    actions: [
      TextButton(onPressed: () => Navigator.pop(context), child: const Text('Abbrechen')),
      FilledButton(onPressed: () => Navigator.pop(context, _c.text), child: const Text('OK')),
    ],
  );
}

class _NewPinDialog extends StatefulWidget {
  const _NewPinDialog();

  @override
  State<_NewPinDialog> createState() => _NewPinDialogState();
}

class _NewPinDialogState extends State<_NewPinDialog> {
  final _a = TextEditingController();
  final _b = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _a.dispose();
    _b.dispose();
    super.dispose();
  }

  void _ok() {
    final p = pinProblem(_a.text);
    if (p != null) return setState(() => _error = p);
    if (_a.text != _b.text) return setState(() => _error = 'Die beiden PINs stimmen nicht überein');
    Navigator.pop(context, _a.text);
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('Neue PIN'),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: _a,
          autofocus: true,
          obscureText: true,
          keyboardType: TextInputType.number,
          maxLength: pinMaxLength,
          decoration: const InputDecoration(labelText: 'PIN (4–8 Ziffern)'),
        ),
        TextField(
          controller: _b,
          obscureText: true,
          keyboardType: TextInputType.number,
          maxLength: pinMaxLength,
          decoration: InputDecoration(labelText: 'PIN wiederholen', errorText: _error),
          onSubmitted: (_) => _ok(),
        ),
      ],
    ),
    actions: [
      TextButton(onPressed: () => Navigator.pop(context), child: const Text('Abbrechen')),
      FilledButton(onPressed: _ok, child: const Text('Speichern')),
    ],
  );
}
