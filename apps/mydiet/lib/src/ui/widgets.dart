import 'dart:async';
import 'dart:math' as math;

import 'package:material_ui/material_ui.dart';

import 'design/tokens.dart';
import 'format.dart';

/// Card with a title row, used for dashboard tiles and page sections.
class SectionCard extends StatelessWidget {
  const SectionCard({
    super.key,
    this.title,
    this.icon,
    this.trailing,
    required this.child,
    this.padding = const EdgeInsets.fromLTRB(16, 14, 16, 16),
    this.onTap,
  });

  final String? title;
  final IconData? icon;
  final Widget? trailing;
  final Widget child;
  final EdgeInsets padding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: padding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (title != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: [
                      if (icon != null) ...[
                        Icon(icon, size: 18, color: t.colorScheme.primary),
                        const SizedBox(width: 8),
                      ],
                      Expanded(
                        child: Text(
                          title!,
                          style: t.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: t.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                      ?trailing,
                    ],
                  ),
                ),
              child,
            ],
          ),
        ),
      ),
    );
  }
}

/// Circular progress ring with a centre label.
class RingGauge extends StatelessWidget {
  const RingGauge({
    super.key,
    required this.progress,
    required this.size,
    required this.color,
    this.stroke = 12,
    this.child,
    this.semanticLabel,
  });

  final double progress;
  final double size;
  final Color color;
  final double stroke;
  final Widget? child;

  /// What a screen reader announces instead of the ring and its inner text.
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final bg = Theme.of(context).colorScheme.surfaceContainerHighest;
    final pct = progress.isFinite ? (progress * 100).round() : 0;
    return Semantics(
      label: semanticLabel,
      value: '$pct Prozent',
      excludeSemantics: semanticLabel != null,
      child: SizedBox(
        width: size,
        height: size,
        child: CustomPaint(
          painter: _RingPainter(progress, color, bg, stroke, Theme.of(context).colorScheme.error),
          child: Center(child: child),
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter(this.progress, this.color, this.bg, this.stroke, this.over);
  final double progress;
  final Color color, bg, over;
  final double stroke;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset(stroke / 2, stroke / 2) & Size(size.width - stroke, size.height - stroke);
    final p = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(rect, 0, 2 * math.pi, false, p..color = bg);
    final v = progress.isFinite ? progress : 0.0;
    if (v > 0) {
      canvas.drawArc(rect, -math.pi / 2, 2 * math.pi * math.min(v, 1), false, p..color = v > 1.0 ? over : color);
    }
  }

  @override
  bool shouldRepaint(_RingPainter old) => old.progress != progress || old.color != color || old.bg != bg;
}

/// "Protein  85 / 145 g" with a progress bar.
class MacroBar extends StatelessWidget {
  const MacroBar({
    super.key,
    required this.label,
    required this.value,
    required this.target,
    required this.color,
    this.unit = 'g',
  });

  final String label;
  final double value;
  final double target;
  final Color color;
  final String unit;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final p = target <= 0 ? 0.0 : value / target;
    return Semantics(
      label: '$label: ${n0(value)} von ${n0(target)} $unit',
      excludeSemantics: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis, style: t.textTheme.bodyMedium),
              ),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: n0(value),
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    TextSpan(
                      text: ' / ${n0(target)} $unit',
                      style: TextStyle(color: t.colorScheme.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: p.clamp(0.0, 1.0),
              minHeight: 8,
              color: p > 1.1 ? t.colorScheme.error : color,
              backgroundColor: t.colorScheme.surfaceContainerHighest,
            ),
          ),
        ],
      ),
    );
  }
}

/// Label above a large value, optional sub line.
class StatValue extends StatelessWidget {
  const StatValue({super.key, required this.label, required this.value, this.sub, this.valueColor});
  final String label;
  final String value;
  final String? sub;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: t.textTheme.labelMedium?.copyWith(color: t.colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 2),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(value, maxLines: 1, style: numberStyle(26, color: valueColor ?? t.colorScheme.onSurface)),
          ),
          if (sub != null) Text(sub!, style: t.textTheme.bodySmall?.copyWith(color: t.colorScheme.onSurfaceVariant)),
        ],
      ),
    );
  }
}

/// Makro- und Wasserfarben aus dem Designsystem (`ui/design/tokens.dart`).
class MacroColors {
  static Color protein(BuildContext c) => c.tokens.protein;
  static Color carbs(BuildContext c) => c.tokens.carbs;
  static Color fat(BuildContext c) => c.tokens.fat;
  static Color fiber(BuildContext c) => c.tokens.fiber;
  static Color water(BuildContext c) => c.tokens.water;
}

void showMessage(BuildContext context, String text, {SnackBarAction? action}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(text), action: action, behavior: SnackBarBehavior.floating));
}

String errorText(Object e) {
  if (e is ArgumentError) return '${e.message}';
  if (e is FormatException) return e.message;
  return e.toString();
}

/// Combines the latest values of several streams into a list.
Stream<List<Object?>> combineLatest(List<Stream<Object?>> streams) {
  late StreamController<List<Object?>> c;
  final values = List<Object?>.filled(streams.length, null);
  final has = List<bool>.filled(streams.length, false);
  final subs = <StreamSubscription<Object?>>[];
  c = StreamController<List<Object?>>(
    onListen: () {
      for (var i = 0; i < streams.length; i++) {
        subs.add(
          streams[i].listen((v) {
            values[i] = v;
            has[i] = true;
            if (has.every((h) => h)) c.add(List.unmodifiable(values));
          }, onError: c.addError),
        );
      }
    },
    onCancel: () async {
      for (final s in subs) {
        await s.cancel();
      }
    },
  );
  return c.stream;
}

/// Small numeric text field with German decimal input.
class NumberField extends StatelessWidget {
  const NumberField({
    super.key,
    required this.controller,
    required this.label,
    this.suffix,
    this.helper,
    this.validator,
    this.onChanged,
    this.autofocus = false,
    this.decimals = true,
  });

  final TextEditingController controller;
  final String label;
  final String? suffix;
  final String? helper;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final bool autofocus;
  final bool decimals;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      autofocus: autofocus,
      keyboardType: TextInputType.numberWithOptions(decimal: decimals),
      decoration: InputDecoration(labelText: label, suffixText: suffix, helperText: helper),
      validator: validator,
      onChanged: onChanged,
    );
  }
}

/// Validator factory for optional/required numeric ranges.
String? Function(String?) numRange(double min, double max, {bool required = true}) => (s) {
  final v = parseNum(s);
  if (v == null) return (s ?? '').trim().isEmpty && !required ? null : 'Bitte eine Zahl eingeben';
  if (v < min || v > max) return 'Erlaubt: ${n1opt(min)}–${n1opt(max)}';
  return null;
};

/// Editable list of short text items shown as chips (allergies, preferences).
class ChipListField extends StatefulWidget {
  const ChipListField({super.key, required this.label, required this.items, required this.onChanged, this.hint});
  final String label;
  final String? hint;
  final List<String> items;
  final ValueChanged<List<String>> onChanged;

  @override
  State<ChipListField> createState() => _ChipListFieldState();
}

class _ChipListFieldState extends State<ChipListField> {
  final _c = TextEditingController();

  void _add() {
    final parts = _c.text.split(RegExp(r'[,;]')).map((e) => e.trim()).where((e) => e.isNotEmpty);
    final next = [...widget.items];
    for (final p in parts) {
      if (!next.any((e) => e.toLowerCase() == p.toLowerCase())) next.add(p);
    }
    _c.clear();
    widget.onChanged(next);
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _c,
          decoration: InputDecoration(
            labelText: widget.label,
            hintText: widget.hint,
            suffixIcon: IconButton(icon: const Icon(Icons.add), onPressed: _add, tooltip: 'Hinzufügen'),
          ),
          onSubmitted: (_) => _add(),
        ),
        if (widget.items.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                for (final i in widget.items)
                  InputChip(label: Text(i), onDeleted: () => widget.onChanged([...widget.items]..remove(i))),
              ],
            ),
          ),
      ],
    );
  }
}
