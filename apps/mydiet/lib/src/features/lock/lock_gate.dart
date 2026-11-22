import 'dart:async';

import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

import '../../branding.dart';
import '../../core/app_lock.dart';
import '../../data/app_lock_store.dart';

/// Shows the lock screen over the whole app (above the navigator) when the app lock is on:
/// at start and after the app was in the background longer than the chosen time.
class LockGate extends StatefulWidget {
  const LockGate({super.key, required this.child});
  final Widget child;

  /// Lets the settings page tell the gate that the configuration changed.
  static final changes = StreamController<void>.broadcast();

  @override
  State<LockGate> createState() => _LockGateState();
}

class _LockGateState extends State<LockGate> with WidgetsBindingObserver {
  final LockStore _store = lockStoreFactory();
  LockConfig? _config;
  bool _locked = true;
  DateTime? _backgroundSince;
  bool _authenticating = false;
  StreamSubscription<void>? _changes;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _load(initial: true);
    _changes = LockGate.changes.stream.listen((_) => _load());
  }

  Future<void> _load({bool initial = false}) async {
    LockConfig c;
    try {
      c = await _store.read();
    } catch (_) {
      c = const LockConfig();
    }
    if (!mounted) return;
    setState(() {
      _config = c;
      if (initial) _locked = c.enabled;
      if (!c.enabled) _locked = false;
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _changes?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final c = _config;
    if (c == null || !c.enabled || _authenticating) return;
    switch (state) {
      case AppLifecycleState.paused || AppLifecycleState.hidden:
        _backgroundSince ??= DateTime.now();
      case AppLifecycleState.resumed:
        final lock = shouldLockOnResume(
          backgroundSince: _backgroundSince,
          now: DateTime.now(),
          lockAfterSeconds: c.lockAfterSeconds,
        );
        _backgroundSince = null;
        if (lock) setState(() => _locked = true);
      default:
        break;
    }
  }

  Future<bool> _biometric() async {
    _authenticating = true;
    try {
      return await biometricsFactory().authenticate();
    } finally {
      // The system prompt pauses and resumes the app; ignore that.
      Future<void>.delayed(const Duration(milliseconds: 500), () => _authenticating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = _config;
    if (c == null) return const ColoredBox(color: Colors.black12); // a moment while reading the file
    return Stack(
      children: [
        // The app stays mounted (state is kept) but is hidden and unreachable while locked.
        Offstage(
          offstage: _locked,
          child: ExcludeFocus(
            excluding: _locked,
            child: TickerMode(enabled: !_locked, child: widget.child),
          ),
        ),
        if (_locked)
          LockScreen(
            config: c,
            onConfig: (n) async {
              setState(() => _config = n);
              await _store.write(n);
            },
            onUnlocked: () => setState(() => _locked = false),
            biometric: c.biometrics ? _biometric : null,
          ),
      ],
    );
  }
}

/// PIN pad (works with touch and keyboard), optional fingerprint button.
class LockScreen extends StatefulWidget {
  const LockScreen({super.key, required this.config, required this.onConfig, required this.onUnlocked, this.biometric});
  final LockConfig config;
  final Future<void> Function(LockConfig) onConfig;
  final VoidCallback onUnlocked;
  final Future<bool> Function()? biometric;

  @override
  State<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  String _pin = '';
  String? _message;
  bool _checking = false;
  bool _forgot = false;
  Timer? _tick;
  final _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    _tick = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted && widget.config.blockedUntil != null) setState(() {});
    });
    if (widget.biometric != null) WidgetsBinding.instance.addPostFrameCallback((_) => _useBiometric());
  }

  @override
  void dispose() {
    _tick?.cancel();
    _focus.dispose();
    super.dispose();
  }

  Duration get _wait {
    final u = widget.config.blockedUntil;
    if (u == null) return Duration.zero;
    final d = u.difference(DateTime.now());
    return d.isNegative ? Duration.zero : d;
  }

  Future<void> _useBiometric() async {
    final b = widget.biometric;
    if (b == null) return;
    if (await b() && mounted) widget.onUnlocked();
  }

  void _digit(String d) {
    if (_checking || _pin.length >= pinMaxLength || _wait > Duration.zero) return;
    setState(() {
      _pin += d;
      _message = null;
    });
  }

  void _back() {
    if (_pin.isEmpty) return;
    setState(() => _pin = _pin.substring(0, _pin.length - 1));
  }

  Future<void> _submit() async {
    if (_checking || _pin.length < pinMinLength) return;
    setState(() => _checking = true);
    final r = tryPin(widget.config, _pin, DateTime.now());
    await widget.onConfig(r.config);
    if (!mounted) return;
    if (r.unlocked) {
      widget.onUnlocked();
      return;
    }
    setState(() {
      _checking = false;
      _pin = '';
      _message = r.wait > Duration.zero ? null : 'Falsche PIN';
    });
  }

  KeyEventResult _key(FocusNode _, KeyEvent e) {
    if (e is! KeyDownEvent) return KeyEventResult.ignored;
    final c = e.character;
    if (c != null && RegExp(r'^\d$').hasMatch(c)) {
      _digit(c);
      return KeyEventResult.handled;
    }
    if (e.logicalKey == LogicalKeyboardKey.backspace) {
      _back();
      return KeyEventResult.handled;
    }
    if (e.logicalKey == LogicalKeyboardKey.enter || e.logicalKey == LogicalKeyboardKey.numpadEnter) {
      _submit();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final wait = _wait;
    Widget key(String label, {VoidCallback? onTap, IconData? icon, String? semantics}) => Padding(
      padding: const EdgeInsets.all(6),
      child: SizedBox(
        width: 72,
        height: 60,
        child: Semantics(
          label: semantics,
          button: true,
          child: FilledButton.tonal(
            onPressed: onTap,
            style: FilledButton.styleFrom(padding: EdgeInsets.zero),
            child: icon != null ? Icon(icon) : Text(label, style: t.textTheme.headlineSmall),
          ),
        ),
      ),
    );
    return Material(
      color: t.colorScheme.surface,
      child: Focus(
        focusNode: _focus,
        autofocus: true,
        onKeyEvent: _key,
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.lock_outline, size: 40, color: t.colorScheme.primary),
                  const SizedBox(height: 8),
                  Text('$appName ist gesperrt', style: t.textTheme.titleLarge),
                  const SizedBox(height: 16),
                  Semantics(
                    label: '${_pin.length} Ziffern eingegeben',
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        for (var i = 0; i < (_pin.length < pinMinLength ? pinMinLength : _pin.length); i++)
                          Padding(
                            padding: const EdgeInsets.all(6),
                            child: Icon(
                              i < _pin.length ? Icons.circle : Icons.circle_outlined,
                              size: 14,
                              color: t.colorScheme.primary,
                            ),
                          ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 24,
                    child: Text(
                      wait > Duration.zero
                          ? 'Zu viele Versuche. Noch ${wait.inSeconds + 1} s warten.'
                          : (_message ?? ''),
                      style: t.textTheme.bodyMedium?.copyWith(color: t.colorScheme.error),
                    ),
                  ),
                  for (final row in const [
                    ['1', '2', '3'],
                    ['4', '5', '6'],
                    ['7', '8', '9'],
                  ])
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [for (final d in row) key(d, onTap: () => _digit(d))],
                    ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      key('', icon: Icons.backspace_outlined, onTap: _back, semantics: 'Löschen'),
                      key('0', onTap: () => _digit('0')),
                      key(
                        '',
                        icon: Icons.check,
                        onTap: _pin.length >= pinMinLength ? _submit : null,
                        semantics: 'Entsperren',
                      ),
                    ],
                  ),
                  if (widget.biometric != null) ...[
                    const SizedBox(height: 8),
                    TextButton.icon(
                      onPressed: _useBiometric,
                      icon: const Icon(Icons.fingerprint),
                      label: const Text('Mit Fingerabdruck entsperren'),
                    ),
                  ],
                  TextButton(onPressed: () => setState(() => _forgot = !_forgot), child: const Text('PIN vergessen?')),
                  if (_forgot)
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 360),
                      child: Text(
                        'Die PIN ist nur verschlüsselt gespeichert und lässt sich nicht wiederherstellen. Ohne PIN '
                        'kommst du nur wieder hinein, wenn du die App-Daten löschst (Android: Einstellungen → Apps → '
                        '$appName → Speicher → Daten löschen; Windows: App deinstallieren). Dabei gehen die Daten auf '
                        'diesem Gerät verloren; ein eigener Export bleibt erhalten.',
                        style: t.textTheme.bodySmall,
                        textAlign: TextAlign.center,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
