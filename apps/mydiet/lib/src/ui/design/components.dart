import 'dart:math' as math;

import 'package:material_ui/material_ui.dart';

import 'tokens.dart';

/// Ein Ring in [ConcentricRings]: Anteil (0 … 1, darüber = übererfüllt) und Farbe.
class RingValue {
  const RingValue(this.progress, this.color);
  final double progress;
  final Color color;
}

/// Konzentrische Fortschrittsringe (Design 2), außen zuerst. Der Hintergrund jedes Rings ist seine
/// eigene Farbe in schwacher Deckkraft, damit jeder Ring auch bei 0 % erkennbar bleibt.
class ConcentricRings extends StatelessWidget {
  const ConcentricRings({
    super.key,
    required this.rings,
    required this.size,
    this.stroke = 13,
    this.gap = 4,
    required this.semanticLabel,
  });

  final List<RingValue> rings;
  final double size;
  final double stroke;
  final double gap;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) => Semantics(
    label: semanticLabel,
    excludeSemantics: true,
    child: SizedBox.square(
      dimension: size,
      child: CustomPaint(painter: _RingsPainter(rings, stroke, gap, context.tokens.danger)),
    ),
  );
}

class _RingsPainter extends CustomPainter {
  _RingsPainter(this.rings, this.stroke, this.gap, this.over);
  final List<RingValue> rings;
  final double stroke, gap;
  final Color over;

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;
    for (var i = 0; i < rings.length; i++) {
      final inset = stroke / 2 + i * (stroke + gap);
      final rect = Rect.fromLTWH(inset, inset, size.width - 2 * inset, size.height - 2 * inset);
      if (rect.width <= 0) break;
      final r = rings[i];
      canvas.drawArc(rect, 0, 2 * math.pi, false, p..color = r.color.withValues(alpha: 0.18));
      final v = r.progress.isFinite ? r.progress : 0.0;
      if (v > 0) {
        // Kalorien über dem Ziel (äußerer Ring) in Warnfarbe, andere Ringe dürfen „voll“ sein.
        final color = i == 0 && v > 1.0 ? over : r.color;
        canvas.drawArc(rect, -math.pi / 2, 2 * math.pi * math.min(v, 1), false, p..color = color);
      }
    }
  }

  @override
  bool shouldRepaint(_RingsPainter old) =>
      old.rings.length != rings.length ||
      [for (var i = 0; i < rings.length; i++) old.rings[i].progress != rings[i].progress].any((x) => x);
}

/// Kennzahl mit farbiger Kante links (Design 2): Beschriftung klein und groß geschrieben, Zahl groß.
class StatStrip extends StatelessWidget {
  const StatStrip({super.key, required this.items, this.notes});

  /// (Beschriftung, Wert, Kantenfarbe)
  final List<(String, String, Color)> items;

  /// Optionale Zeile unter dem Wert, je Eintrag (z. B. „Prognose aus Trend“).
  final List<String?>? notes;

  @override
  Widget build(BuildContext context) {
    final tk = context.tokens;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final (i, (label, value, color)) in items.indexed)
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(right: SattlySpace.s),
              padding: const EdgeInsets.only(left: SattlySpace.s + 2),
              decoration: BoxDecoration(
                border: Border(left: BorderSide(color: color, width: 3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label.toUpperCase(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: SattlyFonts.numbers,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.8,
                      color: tk.muted,
                    ),
                  ),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(value, maxLines: 1, style: numberStyle(24, color: tk.ink)),
                  ),
                  if (notes?.elementAtOrNull(i) case final note?)
                    Text(note, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: tk.muted)),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

/// Kleine Legende: Farbpunkt, Name, Prozent.
class LegendRow extends StatelessWidget {
  const LegendRow({super.key, required this.color, required this.label, required this.value});
  final Color color;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 9,
          height: 9,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Flexible(
          child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis, style: t.textTheme.bodyMedium),
        ),
        const SizedBox(width: 4),
        Text(value, style: t.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700)),
      ],
    );
  }
}
