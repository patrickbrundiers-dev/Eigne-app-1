part of '../dashboard_page.dart';

class _WeightTile extends StatelessWidget {
  const _WeightTile(this.d);
  final DashData d;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final cur = d.currentKg;
    final target = d.profile.targetWeightKg;
    final remaining = cur - target;
    final b = bmi(cur, d.profile.heightCm);
    final today = d.analysis.latest != null && dayKey(d.analysis.latest!.date) == todayDayKey();
    final month = trendWindow(weightPoints(d.weights));
    final rate = month.weeklyRateKg;
    return SectionCard(
      title: 'Gewicht',
      icon: Icons.monitor_weight_outlined,
      onTap: () => HomeShellState.of(context)?.go(2),
      trailing: IconButton(
        tooltip: 'Gewicht eintragen',
        visualDensity: VisualDensity.compact,
        icon: Icon(today ? Icons.edit_outlined : Icons.add_circle_outline, size: 20),
        onPressed: () => showWeightEntrySheet(context),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: StatValue(label: 'Aktuell', value: kg(cur)),
              ),
              Expanded(
                child: StatValue(label: 'Ziel', value: kg(target)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: StatValue(
                  label: remaining > 0 ? 'Noch' : 'Bis Ziel',
                  value: remaining.abs() < 0.1 ? 'Erreicht' : kg(remaining.abs()),
                  valueColor: t.colorScheme.primary,
                ),
              ),
              Expanded(
                child: StatValue(label: 'BMI', value: n1(b), sub: bmiCategory(b)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            rate == null
                ? '30 Tage: ${reliabilityText(month.reliability)}'
                : '30 Tage: ${rate <= 0 ? '−' : '+'}${n1(rate.abs())} kg/Woche · ${reliabilityText(month.reliability)}',
            style: t.textTheme.bodySmall?.copyWith(color: t.colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

class _GoalTile extends StatelessWidget {
  const _GoalTile(this.d);
  final DashData d;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final p = d.profile;
    final progress = goalProgress(startKg: p.startWeightKg, currentKg: d.currentKg, targetKg: p.targetWeightKg);
    final rate = d.analysis.weeklyRateKg;
    final forecast = d.analysis.forecastDate ?? d.targets.projectedGoalDate;
    final fromTrend = d.analysis.forecastDate != null;
    return SectionCard(
      title: 'Zielfortschritt',
      icon: Icons.flag_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            '${(progress * 100).round()} %',
            style: t.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800, color: t.colorScheme.primary),
          ),
          Text('von ${kg(p.startWeightKg)} auf ${kg(p.targetWeightKg)}', style: t.textTheme.bodySmall),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 12,
              backgroundColor: t.colorScheme.surfaceContainerHighest,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            rate == null
                ? 'Tempo: erst nach ca. 2 Wochen Messungen verlässlich'
                : 'Tempo: ${rate <= 0 ? '−' : '+'}${n1(rate.abs())} kg pro Woche (Trend)',
            style: t.textTheme.bodySmall,
          ),
          if (forecast != null)
            Text(
              'Prognose: ${dateShort(forecast)}${fromTrend ? '' : ' (nach Plan)'}',
              style: t.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
            ),
          if (d.analysis.isPlateau)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                'Seit über zwei Wochen kaum Veränderung (Plateau).',
                style: t.textTheme.bodySmall?.copyWith(color: t.colorScheme.tertiary, fontWeight: FontWeight.w600),
              ),
            ),
        ],
      ),
    );
  }
}

class _WeightChartTile extends StatelessWidget {
  const _WeightChartTile(this.d);
  final DashData d;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'Gewichtskurve · 30 Tage',
      icon: Icons.show_chart,
      onTap: () => HomeShellState.of(context)?.go(2),
      child: SizedBox(
        height: 190,
        child: WeightChart(entries: d.weights, targetKg: d.profile.targetWeightKg, days: 30, compact: true),
      ),
    );
  }
}
