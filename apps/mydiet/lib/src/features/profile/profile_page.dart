import 'package:drift/drift.dart' show Value;
import 'package:material_ui/material_ui.dart';

import '../../app.dart';
import '../../core/energy.dart';
import '../../data/database.dart';
import '../../data/targets.dart';
import '../../ui/design/components.dart';
import '../../ui/design/tokens.dart';
import '../../ui/format.dart';
import '../../ui/widgets.dart';
import 'micro_targets_card.dart';
import '../home_shell.dart';
import '../settings/settings_page.dart';
import 'meal_slots_page.dart';
import 'profile_form.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final db = context.db;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil & Ziele'),
        actions: [
          IconButton(
            tooltip: 'Einstellungen',
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsPage())),
          ),
        ],
      ),
      body: StreamBuilder<List<Object?>>(
        stream: combineLatest([db.watchProfile(), db.watchWeights(), db.watchMealSlots()]),
        builder: (context, snap) {
          final v = snap.data;
          if (v == null || v[0] == null) return const Center(child: CircularProgressIndicator());
          final p = v[0] as Profile;
          final weights = v[1] as List<WeightEntry>;
          final slots = v[2] as List<MealSlot>;
          final input = energyInputFor(p, weights);
          final r = calculateEnergy(input);
          final wide = MediaQuery.sizeOf(context).width >= 900;
          final left = [
            _summary(context, p, input),
            const SizedBox(height: 12),
            _TargetsCard(r: r),
            const SizedBox(height: 12),
            MicroTargetsCard(profile: p),
          ];
          final right = [
            _AdjustCard(profile: p, result: r),
            const SizedBox(height: 12),
            SectionCard(
              title: 'Mahlzeiten',
              icon: Icons.schedule,
              trailing: TextButton(
                onPressed: () =>
                    Navigator.push(context, MaterialPageRoute(builder: (_) => MealSlotsPage(slots: slots))),
                child: const Text('Bearbeiten'),
              ),
              child: Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  for (final s in slots)
                    Chip(label: Text(s.minuteOfDay == null ? s.name : '${s.name} · ${timeOfDay(s.minuteOfDay)}')),
                ],
              ),
            ),
          ];
          return PageBody(
            child: wide
                ? SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: left),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: right),
                        ),
                      ],
                    ),
                  )
                : ListView(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                    children: [...left, const SizedBox(height: 12), ...right],
                  ),
          );
        },
      ),
    );
  }

  Widget _summary(BuildContext context, Profile p, EnergyInput i) {
    final t = Theme.of(context);
    final facts = <String>[
      i.sex == Sex.male ? 'männlich' : 'weiblich',
      '${i.ageYears} Jahre',
      '${n0(i.heightCm)} cm',
      'aktuell ${kg(i.weightKg)}',
      'Ziel ${kg(p.targetWeightKg)}',
      if (p.targetDate != null) 'bis ${dateShort(p.targetDate!)}',
      i.jobActivity.label,
      '${p.sportMinutesPerWeek} min Sport/Woche',
      if (i.bodyFatPercent != null) '${n1(i.bodyFatPercent!)} % Körperfett',
      if (p.sleepHours != null) '${n1opt(p.sleepHours!)} h Schlaf',
      if (p.dietStyle != null) dietStyles[p.dietStyle] ?? p.dietStyle!,
    ];
    final tk = context.tokens;
    final name = p.displayName ?? 'Dein Profil';
    final initial = (p.displayName?.trim().isNotEmpty ?? false)
        ? p.displayName!.trim().characters.first.toUpperCase()
        : null;
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: tk.primarySoft,
                foregroundColor: tk.primaryInk,
                child: initial == null
                    ? const Icon(Icons.person_outline)
                    : Text(initial, style: numberStyle(26, color: tk.primaryInk)),
              ),
              const SizedBox(width: SattlySpace.m),
              Expanded(
                child: Text(name, maxLines: 2, overflow: TextOverflow.ellipsis, style: t.textTheme.titleLarge),
              ),
              TextButton.icon(
                icon: const Icon(Icons.edit_outlined, size: 18),
                label: const Text('Bearbeiten'),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (c) => Scaffold(
                      appBar: AppBar(title: const Text('Profil bearbeiten')),
                      body: ProfileForm(profile: p, onSaved: () => Navigator.pop(c)),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: SattlySpace.m),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              for (final f in facts)
                Chip(
                  label: Text(f),
                  visualDensity: VisualDensity.compact,
                  side: BorderSide.none,
                  backgroundColor: tk.surface2,
                ),
            ],
          ),
          if (p.allergies.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text('Unverträglichkeiten: ${p.allergies.join(', ')}', style: t.textTheme.bodySmall),
          ],
          if (p.preferredFoods.isNotEmpty) Text('Mag: ${p.preferredFoods.join(', ')}', style: t.textTheme.bodySmall),
          if (p.dislikedFoods.isNotEmpty)
            Text('Mag nicht: ${p.dislikedFoods.join(', ')}', style: t.textTheme.bodySmall),
        ],
      ),
    );
  }
}

class _TargetsCard extends StatelessWidget {
  const _TargetsCard({required this.r});
  final EnergyResult r;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final tk = context.tokens;
    Widget v(String l, String val, {String? sub}) => Expanded(
      child: StatValue(label: l, value: val, sub: sub),
    );
    return SectionCard(
      title: 'Deine Tagesziele',
      icon: Icons.calculate_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              v('Grundumsatz', kcal(r.bmr), sub: r.bmrMethod),
              v('Gesamtumsatz', kcal(r.tdee), sub: 'PAL ${r.pal.toStringAsFixed(2).replaceAll('.', ',')}'),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              v('Kalorienziel', kcal(r.targetKcal), sub: r.isCalorieOverridden ? 'eigenes Ziel' : 'berechnet'),
              v(
                'Erwartetes Tempo',
                '${r.weeklyChangeKg <= 0 ? '−' : '+'}${n1(r.weeklyChangeKg.abs())} kg/Woche',
                sub: r.projectedGoalDate == null ? null : 'Ziel ca. ${dateShort(r.projectedGoalDate!)}',
              ),
            ],
          ),
          const SizedBox(height: 12),
          StatStrip(
            items: [
              ('Protein', '${r.proteinG} g', tk.protein),
              ('Kohlenhydrate', '${r.carbsG} g', tk.carbs),
              ('Fett', '${r.fatG} g', tk.fat),
            ],
            notes: [r.isProteinOverridden ? 'eigenes Ziel' : null, null, null],
          ),
          const SizedBox(height: 12),
          StatStrip(
            items: [
              ('Ballaststoffe', '${r.fiberG} g', tk.fiber),
              ('Wasser', '${n1(r.waterMl / 1000)} l', tk.water),
              ('', '', Colors.transparent),
            ],
          ),
          for (final w in r.warnings)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.warning_amber_rounded, size: 18, color: t.colorScheme.error),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(w, style: t.textTheme.bodySmall?.copyWith(color: t.colorScheme.error)),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 4),
          Theme(
            data: t.copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              tilePadding: EdgeInsets.zero,
              title: const Text('Rechenweg anzeigen'),
              children: [
                for (final s in r.steps)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 5,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(s.label, style: t.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                              Text(
                                s.formula,
                                style: t.textTheme.bodySmall?.copyWith(color: t.colorScheme.onSurfaceVariant),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(s.value, style: t.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 8),
                  child: Text(
                    'Annahmen: 1 kg Körpergewicht ≈ 7.700 kcal. Sport ist über den Aktivitätsfaktor eingerechnet. '
                    'Gerechnet wird mit dem 7-Tage-Trendgewicht. Das sind Schätzwerte, keine medizinische Beratung.',
                    style: t.textTheme.bodySmall?.copyWith(color: t.colorScheme.onSurfaceVariant),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Manual overrides: calories, protein, macro split, fibre, water, activity credit.
class _AdjustCard extends StatefulWidget {
  const _AdjustCard({required this.profile, required this.result});
  final Profile profile;
  final EnergyResult result;

  @override
  State<_AdjustCard> createState() => _AdjustCardState();
}

class _AdjustCardState extends State<_AdjustCard> {
  final _form = GlobalKey<FormState>();
  late final _kcal = TextEditingController(text: widget.profile.calorieOverride?.toString() ?? '');
  late final _protein = TextEditingController(text: widget.profile.proteinOverrideG?.toString() ?? '');
  late final _ppk = TextEditingController(text: numField(widget.profile.proteinPerKg));
  late final _fatPct = TextEditingController(text: numField(widget.profile.fatPercent));
  late final _fiber = TextEditingController(text: numField(widget.profile.fiberTargetG));
  late final _carbCap = TextEditingController(text: numField(widget.profile.carbCapG));
  late final _water = TextEditingController(text: widget.profile.waterOverrideMl?.toString() ?? '');
  late int _credit = widget.profile.activityCreditPercent;
  bool _dirty = false;

  @override
  void dispose() {
    for (final c in [_kcal, _protein, _ppk, _fatPct, _fiber, _water, _carbCap]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    if (!_form.currentState!.validate()) return;
    await context.db.saveProfile(
      widget.profile
          .toCompanion(true)
          .copyWith(
            calorieOverride: Value(parseNum(_kcal.text)?.round()),
            proteinOverrideG: Value(parseNum(_protein.text)?.round()),
            proteinPerKg: Value(parseNum(_ppk.text) ?? 1.8),
            fatPercent: Value(parseNum(_fatPct.text) ?? 30),
            carbCapG: Value(parseNum(_carbCap.text)),
            fiberTargetG: Value(parseNum(_fiber.text) ?? 30),
            waterOverrideMl: Value(parseNum(_water.text)?.round()),
            activityCreditPercent: Value(_credit),
          ),
    );
    if (mounted) {
      setState(() => _dirty = false);
      showMessage(context, 'Ziele gespeichert');
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    void changed(_) => setState(() => _dirty = true);
    Widget pair(Widget a, Widget b) => Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: a),
        const SizedBox(width: 12),
        Expanded(child: b),
      ],
    );
    return SectionCard(
      title: 'Ziele anpassen',
      icon: Icons.tune,
      child: Form(
        key: _form,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Leere Felder verwenden den berechneten Wert.',
              style: t.textTheme.bodySmall?.copyWith(color: t.colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 12),
            Text('Makro-Vorlage', style: t.textTheme.labelLarge),
            const SizedBox(height: 6),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                for (final p in macroPresets)
                  Tooltip(
                    message: p.note ?? '',
                    child: ActionChip(
                      avatar: p.id == presetForDietStyle(widget.profile.dietStyle).id
                          ? const Icon(Icons.star_outline, size: 16)
                          : null,
                      label: Text(p.label),
                      onPressed: () => setState(() {
                        _ppk.text = numField(p.proteinPerKg);
                        _fatPct.text = numField(p.fatPercent);
                        _carbCap.text = numField(p.carbCapG);
                        _protein.clear();
                        _dirty = true;
                      }),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Füllt Protein pro kg, Fettanteil und Kohlenhydrat-Grenze aus; der Stern passt zu deiner Ernährungsweise. '
              'Danach ist alles frei änderbar.',
              style: t.textTheme.bodySmall?.copyWith(color: t.colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 12),
            pair(
              NumberField(
                controller: _kcal,
                label: 'Kalorienziel',
                suffix: 'kcal',
                helper: 'berechnet: ${n0(widget.result.calculatedTargetKcal)}',
                decimals: false,
                validator: numRange(800, 6000, required: false),
                onChanged: changed,
              ),
              NumberField(
                controller: _protein,
                label: 'Proteinziel',
                suffix: 'g',
                decimals: false,
                validator: numRange(20, 400, required: false),
                onChanged: changed,
              ),
            ),
            const SizedBox(height: 12),
            pair(
              NumberField(
                controller: _ppk,
                label: 'Protein pro kg',
                suffix: 'g/kg',
                validator: numRange(0.8, 3.0),
                onChanged: changed,
              ),
              NumberField(
                controller: _fatPct,
                label: 'Fettanteil',
                suffix: '%',
                validator: numRange(15, 60),
                onChanged: changed,
              ),
            ),
            const SizedBox(height: 12),
            pair(
              NumberField(
                controller: _carbCap,
                label: 'Kohlenhydrate höchstens',
                suffix: 'g',
                helper: 'leer = keine Grenze',
                validator: numRange(0, 800, required: false),
                onChanged: changed,
              ),
              NumberField(
                controller: _fiber,
                label: 'Ballaststoffe',
                suffix: 'g',
                validator: numRange(10, 80),
                onChanged: changed,
              ),
            ),
            const SizedBox(height: 12),
            pair(
              NumberField(
                controller: _water,
                label: 'Wasserziel',
                suffix: 'ml',
                decimals: false,
                helper: 'berechnet: ${n0(widget.result.waterMl)}',
                validator: numRange(500, 6000, required: false),
                onChanged: changed,
              ),
              const SizedBox.shrink(),
            ),
            const SizedBox(height: 16),
            Text('Aktivitätskalorien zum Budget addieren', style: t.textTheme.labelLarge),
            const SizedBox(height: 6),
            SegmentedButton<int>(
              showSelectedIcon: false,
              segments: const [
                ButtonSegment(value: 0, label: Text('0 %')),
                ButtonSegment(value: 25, label: Text('25 %')),
                ButtonSegment(value: 50, label: Text('50 %')),
                ButtonSegment(value: 100, label: Text('100 %')),
              ],
              selected: {_credit},
              onSelectionChanged: (s) => setState(() {
                _credit = s.first;
                _dirty = true;
              }),
            ),
            const SizedBox(height: 6),
            Text(
              'Empfohlen: 0 %. Dein geplanter Sport ist schon im Aktivitätsfaktor enthalten; zusätzliches '
              'Anrechnen würde ihn doppelt zählen. Nur für Aktivität jenseits deines üblichen Pensums höher stellen.',
              style: t.textTheme.bodySmall?.copyWith(color: t.colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 12),
            FilledButton(onPressed: _dirty ? _save : null, child: const Text('Ziele speichern')),
          ],
        ),
      ),
    );
  }
}
