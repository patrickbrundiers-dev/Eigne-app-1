import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/dates.dart';
import '../../core/weight_trend.dart';
import '../../data/database.dart';
import '../../data/targets.dart';
import '../../ui/design/tokens.dart';
import '../../ui/format.dart';

/// Weigh-ins as dots, the 7-day average as a line, the target as a dashed line.
class WeightChart extends StatelessWidget {
  const WeightChart({super.key, required this.entries, required this.targetKg, this.days, this.compact = false});

  final List<WeightEntry> entries;
  final double targetKg;

  /// Show only the last [days] days (null = all).
  final int? days;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final today = dateOnly(DateTime.now());
    final start = days == null ? null : DateTime(today.year, today.month, today.day - (days! - 1));
    final pts = sortPoints(weightPoints(entries)).where((p) => start == null || !p.date.isBefore(start)).toList();
    if (pts.isEmpty) {
      return Center(
        child: Text(
          'Noch keine Gewichtseinträge im Zeitraum.',
          style: t.textTheme.bodyMedium?.copyWith(color: t.colorScheme.onSurfaceVariant),
        ),
      );
    }
    final origin = start ?? pts.first.date;
    double x(DateTime d) => DateTime.utc(
      d.year,
      d.month,
      d.day,
    ).difference(DateTime.utc(origin.year, origin.month, origin.day)).inDays.toDouble();
    final all = sortPoints(weightPoints(entries));
    final trend = [for (final p in pts) FlSpot(x(p.date), trailingAverage(all, p.date) ?? p.kg)];
    final raw = [for (final p in pts) FlSpot(x(p.date), p.kg)];
    final ys = [...pts.map((p) => p.kg), targetKg];
    var minY = ys.reduce(math.min) - 1;
    var maxY = ys.reduce(math.max) + 1;
    if (maxY - minY < 4) {
      final mid = (maxY + minY) / 2;
      minY = mid - 2;
      maxY = mid + 2;
    }
    final maxX = start == null ? math.max(1.0, x(pts.last.date)) : (days! - 1).toDouble();
    final labelStyle = t.textTheme.labelSmall?.copyWith(color: t.colorScheme.onSurfaceVariant);
    final primary = t.colorScheme.primary;

    final first = trend.first.y, last = trend.last.y;
    final diff = last - first;
    final summary =
        'Gewichtskurve: ${pts.length} ${pts.length == 1 ? 'Messung' : 'Messungen'} von ${dateShort(pts.first.date)} bis ${dateShort(pts.last.date)}, '
        'Trend von ${kg(first)} auf ${kg(last)} (${diff <= 0 ? 'minus' : 'plus'} ${kg(diff.abs())}), Ziel ${kg(targetKg)}';
    return Semantics(
      label: summary,
      excludeSemantics: true,
      child: LineChart(
        LineChartData(
          minX: 0,
          maxX: maxX,
          minY: minY.floorToDouble(),
          maxY: maxY.ceilToDouble(),
          clipData: const FlClipData.all(),
          gridData: FlGridData(
            drawVerticalLine: false,
            getDrawingHorizontalLine: (_) =>
                FlLine(color: t.colorScheme.outlineVariant.withValues(alpha: 0.5), strokeWidth: 1),
          ),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 34,
                interval: ((maxY - minY) / 4).ceilToDouble().clamp(1, 50),
                getTitlesWidget: (v, meta) => _offGrid(v, meta)
                    ? const SizedBox.shrink()
                    : SideTitleWidget(
                        meta: meta,
                        child: Text(n0(v), style: labelStyle),
                      ),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 22,
                interval: math.max(1, (maxX / (compact ? 4 : 6)).roundToDouble()),
                getTitlesWidget: (v, meta) => _offGrid(v, meta)
                    ? const SizedBox.shrink()
                    : SideTitleWidget(
                        meta: meta,
                        child: Text(
                          dateTiny(DateTime(origin.year, origin.month, origin.day + v.round())),
                          style: labelStyle,
                        ),
                      ),
              ),
            ),
          ),
          extraLinesData: ExtraLinesData(
            horizontalLines: [
              HorizontalLine(
                y: targetKg,
                color: context.tokens.warn,
                strokeWidth: 1.5,
                dashArray: [6, 4],
                label: HorizontalLineLabel(
                  show: true,
                  alignment: Alignment.topRight,
                  style: labelStyle?.copyWith(color: context.tokens.warn, fontWeight: FontWeight.w700),
                  labelResolver: (_) => 'Ziel ${n1(targetKg)}',
                ),
              ),
            ],
          ),
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (_) => t.colorScheme.inverseSurface,
              getTooltipItems: (spots) => [
                for (final s in spots)
                  LineTooltipItem(
                    s.barIndex == 0
                        ? '${dateTiny(DateTime(origin.year, origin.month, origin.day + s.x.round()))}  ${kg(s.y)}'
                        : 'Trend ${kg(s.y)}',
                    TextStyle(color: t.colorScheme.onInverseSurface, fontSize: 12),
                  ),
              ],
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: raw,
              barWidth: 0,
              color: Colors.transparent,
              dotData: FlDotData(
                getDotPainter: (s, _, _, _) => FlDotCirclePainter(
                  radius: compact ? 2.5 : 3.5,
                  color: primary.withValues(alpha: 0.45),
                  strokeWidth: 0,
                ),
              ),
            ),
            LineChartBarData(
              spots: trend,
              isCurved: true,
              preventCurveOverShooting: true,
              barWidth: 3,
              color: primary,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [primary.withValues(alpha: 0.18), primary.withValues(alpha: 0)],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// fl_chart always labels min and max; hide them when they are not on the grid,
/// otherwise they collide with the neighbouring label.
bool _offGrid(double v, TitleMeta meta) {
  final i = meta.appliedInterval;
  if (i <= 0) return false;
  final steps = v / i;
  return (steps - steps.round()).abs() > 1e-6;
}
