import 'package:drift/drift.dart' show Value;
import 'package:material_ui/material_ui.dart';

import '../../app.dart';
import '../../core/dates.dart';
import '../../core/energy.dart';
import '../../data/database.dart';
import '../../ui/format.dart';
import '../../ui/widgets.dart';

const dietStyles = <String, String>{
  'balanced': 'Ausgewogen',
  'high_protein': 'High Protein',
  'low_carb': 'Low Carb',
  'keto': 'Ketogen',
  'vegetarian': 'Vegetarisch',
  'vegan': 'Vegan',
  'pescetarian': 'Pescetarisch',
};

const _defaultMealNames = [
  ['Mahlzeit'],
  ['Frühstück', 'Abendessen'],
  ['Frühstück', 'Mittagessen', 'Abendessen'],
  ['Frühstück', 'Mittagessen', 'Abendessen', 'Snacks'],
  ['Frühstück', 'Snack am Vormittag', 'Mittagessen', 'Abendessen', 'Snacks'],
  ['Frühstück', 'Snack am Vormittag', 'Mittagessen', 'Snack am Nachmittag', 'Abendessen', 'Spätmahlzeit'],
];
const _defaultMealTimes = [
  [12 * 60 + 30],
  [8 * 60, 18 * 60 + 30],
  [7 * 60 + 30, 12 * 60 + 30, 18 * 60 + 30],
  [7 * 60 + 30, 12 * 60 + 30, 18 * 60 + 30, null],
  [7 * 60, 10 * 60, 12 * 60 + 30, 18 * 60 + 30, null],
  [7 * 60, 10 * 60, 12 * 60 + 30, 15 * 60 + 30, 18 * 60 + 30, 21 * 60],
];

/// Profile form used for onboarding (profile == null) and for editing.
class ProfileForm extends StatefulWidget {
  const ProfileForm({super.key, this.profile, required this.onSaved});
  final Profile? profile;
  final VoidCallback onSaved;

  @override
  State<ProfileForm> createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  final _form = GlobalKey<FormState>();
  late final _name = TextEditingController(text: widget.profile?.displayName ?? '');
  late final _height = TextEditingController(text: numField(widget.profile?.heightCm));
  late final _weight = TextEditingController(text: numField(widget.profile?.startWeightKg));
  late final _target = TextEditingController(text: numField(widget.profile?.targetWeightKg));
  late final _bodyFat = TextEditingController(text: numField(widget.profile?.bodyFatPercent));
  late final _occupation = TextEditingController(text: widget.profile?.occupation ?? '');
  late final _sportMin = TextEditingController(text: '${widget.profile?.sportMinutesPerWeek ?? 0}');
  late final _sportNote = TextEditingController(text: widget.profile?.sportNote ?? '');
  late final _sleep = TextEditingController(text: numField(widget.profile?.sleepHours));
  late final _habits = TextEditingController(text: widget.profile?.eatingHabits ?? '');
  late final _kcalOverride = TextEditingController(text: widget.profile?.calorieOverride?.toString() ?? '');

  late Sex _sex = widget.profile?.sex == 'female' ? Sex.female : Sex.male;
  late DateTime? _birth = widget.profile?.birthDate;
  late DateTime? _targetDate = widget.profile?.targetDate;
  late JobActivity _job = JobActivity.values.firstWhere(
    (j) => j.name == widget.profile?.jobActivity,
    orElse: () => JobActivity.sitting,
  );
  late String? _diet = widget.profile?.dietStyle;
  late List<String> _allergies = widget.profile?.allergies ?? [];
  late List<String> _preferred = widget.profile?.preferredFoods ?? [];
  late List<String> _disliked = widget.profile?.dislikedFoods ?? [];
  int _mealCount = 4;
  bool _saving = false;

  bool get _isOnboarding => widget.profile == null;

  @override
  void dispose() {
    for (final c in [
      _name,
      _height,
      _weight,
      _target,
      _bodyFat,
      _occupation,
      _sportMin,
      _sportNote,
      _sleep,
      _habits,
      _kcalOverride,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _pickBirth() async {
    final now = DateTime.now();
    final d = await showDatePicker(
      context: context,
      initialDate: _birth ?? DateTime(now.year - 35, 1, 1),
      firstDate: DateTime(now.year - 100),
      lastDate: DateTime(now.year - 14, now.month, now.day),
      initialDatePickerMode: DatePickerMode.year,
      helpText: 'Geburtsdatum',
    );
    if (d != null) setState(() => _birth = d);
  }

  Future<void> _pickTargetDate() async {
    final now = DateTime.now();
    final d = await showDatePicker(
      context: context,
      initialDate: _targetDate ?? now.add(const Duration(days: 120)),
      firstDate: now.add(const Duration(days: 7)),
      lastDate: now.add(const Duration(days: 365 * 5)),
      helpText: 'Bis wann möchtest du dein Ziel erreichen?',
    );
    if (d != null) setState(() => _targetDate = d);
  }

  Future<void> _save() async {
    if (!_form.currentState!.validate()) return;
    if (_birth == null) {
      showMessage(context, 'Bitte das Geburtsdatum wählen.');
      return;
    }
    setState(() => _saving = true);
    final db = context.db;
    try {
      final weight = parseNum(_weight.text)!;
      await db.transaction(() async {
        await db.saveProfile(
          ProfilesCompanion(
            displayName: Value(_name.text.trim().isEmpty ? null : _name.text.trim()),
            sex: Value(_sex.name),
            birthDate: Value(_birth!),
            heightCm: Value(parseNum(_height.text)!),
            startWeightKg: Value(weight),
            targetWeightKg: Value(parseNum(_target.text)!),
            targetDate: Value(_targetDate),
            bodyFatPercent: Value(parseNum(_bodyFat.text)),
            occupation: Value(_occupation.text.trim().isEmpty ? null : _occupation.text.trim()),
            jobActivity: Value(_job.name),
            sportMinutesPerWeek: Value(parseNum(_sportMin.text)?.round() ?? 0),
            sportNote: Value(_sportNote.text.trim().isEmpty ? null : _sportNote.text.trim()),
            sleepHours: Value(parseNum(_sleep.text)),
            dietStyle: Value(_diet),
            eatingHabits: Value(_habits.text.trim().isEmpty ? null : _habits.text.trim()),
            allergiesJson: Value(encodeList(_allergies)),
            preferredFoodsJson: Value(encodeList(_preferred)),
            dislikedFoodsJson: Value(encodeList(_disliked)),
            calorieOverride: Value(parseNum(_kcalOverride.text)?.round()),
          ),
        );
        if (_isOnboarding) {
          await db.saveWeight(day: dayKey(DateTime.now()), weightKg: weight, bodyFatPercent: parseNum(_bodyFat.text));
          final names = _defaultMealNames[_mealCount - 1];
          final times = _defaultMealTimes[_mealCount - 1];
          await db.saveMealSlots([
            for (var i = 0; i < names.length; i++) (id: null, name: names[i], minuteOfDay: times[i]),
          ]);
        }
      });
      widget.onSaved();
    } catch (e) {
      if (mounted) showMessage(context, 'Speichern fehlgeschlagen: ${errorText(e)}');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final w = parseNum(_weight.text);
    final tw = parseNum(_target.text);
    final diff = (w != null && tw != null) ? w - tw : null;

    Widget group(String title, List<Widget> children) => Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: SectionCard(
        title: title,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (var i = 0; i < children.length; i++) ...[if (i > 0) const SizedBox(height: 12), children[i]],
          ],
        ),
      ),
    );

    Widget row(List<Widget> c) => Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < c.length; i++) ...[if (i > 0) const SizedBox(width: 12), Expanded(child: c[i])],
      ],
    );

    return Form(
      key: _form,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: [
          group('Über dich', [
            TextFormField(
              controller: _name,
              decoration: const InputDecoration(labelText: 'Name (optional)'),
            ),
            SegmentedButton<Sex>(
              segments: const [
                ButtonSegment(value: Sex.male, label: Text('Männlich'), icon: Icon(Icons.male)),
                ButtonSegment(value: Sex.female, label: Text('Weiblich'), icon: Icon(Icons.female)),
              ],
              selected: {_sex},
              onSelectionChanged: (s) => setState(() => _sex = s.first),
            ),
            OutlinedButton.icon(
              onPressed: _pickBirth,
              icon: const Icon(Icons.cake_outlined),
              label: Text(
                _birth == null
                    ? 'Geburtsdatum wählen'
                    : '${dateShort(_birth!)} · ${ageOn(_birth!, DateTime.now())} Jahre',
              ),
            ),
            row([
              NumberField(controller: _height, label: 'Größe', suffix: 'cm', validator: numRange(120, 230)),
              NumberField(
                controller: _bodyFat,
                label: 'Körperfett',
                suffix: '%',
                helper: 'optional',
                validator: numRange(3, 70, required: false),
              ),
            ]),
          ]),
          group('Dein Ziel', [
            row([
              NumberField(
                controller: _weight,
                label: _isOnboarding ? 'Gewicht' : 'Startgewicht',
                suffix: 'kg',
                validator: numRange(30, 350),
                onChanged: (_) => setState(() {}),
              ),
              NumberField(
                controller: _target,
                label: 'Zielgewicht',
                suffix: 'kg',
                validator: numRange(30, 350),
                onChanged: (_) => setState(() {}),
              ),
            ]),
            if (diff != null)
              Text(
                diff.abs() < 0.25
                    ? 'Ziel: Gewicht halten'
                    : diff > 0
                    ? 'Abnehmziel: ${kg(diff)}'
                    : 'Zunahmeziel: ${kg(-diff)}',
                style: t.textTheme.bodyMedium?.copyWith(color: t.colorScheme.primary, fontWeight: FontWeight.w600),
              ),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _pickTargetDate,
                    icon: const Icon(Icons.flag_outlined),
                    label: Text(
                      _targetDate == null
                          ? 'Zieldatum (optional)'
                          : 'Ziel bis ${dateShort(_targetDate!)}'
                                ' (${(_targetDate!.difference(DateTime.now()).inDays / 7).round()} Wochen)',
                    ),
                  ),
                ),
                if (_targetDate != null)
                  IconButton(
                    tooltip: 'Zieldatum entfernen',
                    onPressed: () => setState(() => _targetDate = null),
                    icon: const Icon(Icons.close),
                  ),
              ],
            ),
            Text(
              'Ohne Zieldatum rechnet die App mit einem moderaten Tempo von 0,5 % des Körpergewichts pro Woche. '
              'Mehr als 1 % pro Woche wird nie eingeplant.',
              style: t.textTheme.bodySmall?.copyWith(color: t.colorScheme.onSurfaceVariant),
            ),
            NumberField(
              controller: _kcalOverride,
              label: 'Eigenes Kalorienziel (optional)',
              suffix: 'kcal',
              helper: 'Leer lassen, um das berechnete Ziel zu verwenden',
              validator: numRange(800, 6000, required: false),
              decimals: false,
            ),
          ]),
          group('Alltag & Aktivität', [
            TextFormField(
              controller: _occupation,
              decoration: const InputDecoration(labelText: 'Beruf (optional)'),
            ),
            DropdownButtonFormField<JobActivity>(
              initialValue: _job,
              isExpanded: true,
              decoration: const InputDecoration(labelText: 'Körperliche Aktivität im Alltag'),
              items: [
                for (final j in JobActivity.values)
                  DropdownMenuItem(
                    value: j,
                    child: Text('${j.label} – ${j.example}', overflow: TextOverflow.ellipsis),
                  ),
              ],
              onChanged: (v) => setState(() => _job = v ?? _job),
            ),
            row([
              NumberField(
                controller: _sportMin,
                label: 'Sport pro Woche',
                suffix: 'min',
                validator: numRange(0, 3000),
                decimals: false,
              ),
              NumberField(
                controller: _sleep,
                label: 'Schlaf',
                suffix: 'h',
                helper: 'optional',
                validator: numRange(2, 14, required: false),
              ),
            ]),
            TextFormField(
              controller: _sportNote,
              decoration: const InputDecoration(
                labelText: 'Sportarten (optional)',
                hintText: 'z. B. Krafttraining, Radfahren',
              ),
            ),
          ]),
          group('Ernährung', [
            DropdownButtonFormField<String?>(
              initialValue: _diet,
              decoration: const InputDecoration(labelText: 'Ernährungsweise'),
              items: [
                const DropdownMenuItem(value: null, child: Text('Keine Angabe')),
                for (final e in dietStyles.entries) DropdownMenuItem(value: e.key, child: Text(e.value)),
              ],
              onChanged: (v) => setState(() => _diet = v),
            ),
            TextFormField(
              controller: _habits,
              minLines: 1,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Ernährungsgewohnheiten (optional)',
                hintText: 'z. B. mittags keine Zeit, abends warm',
              ),
            ),
            ChipListField(
              label: 'Unverträglichkeiten & Allergien',
              hint: 'z. B. Laktose, Nüsse',
              items: _allergies,
              onChanged: (v) => setState(() => _allergies = v),
            ),
            ChipListField(
              label: 'Bevorzugte Lebensmittel',
              items: _preferred,
              onChanged: (v) => setState(() => _preferred = v),
            ),
            ChipListField(
              label: 'Abgelehnte Lebensmittel',
              items: _disliked,
              onChanged: (v) => setState(() => _disliked = v),
            ),
            if (_isOnboarding) ...[
              Text('Mahlzeiten pro Tag', style: t.textTheme.labelLarge),
              SegmentedButton<int>(
                segments: [for (var i = 1; i <= 6; i++) ButtonSegment(value: i, label: Text('$i'))],
                selected: {_mealCount},
                onSelectionChanged: (s) => setState(() => _mealCount = s.first),
                showSelectedIcon: false,
              ),
              Text(
                _defaultMealNames[_mealCount - 1].join(' · '),
                style: t.textTheme.bodySmall?.copyWith(color: t.colorScheme.onSurfaceVariant),
              ),
              Text(
                'Namen und Uhrzeiten kannst du später unter Profil → Mahlzeiten ändern.',
                style: t.textTheme.bodySmall?.copyWith(color: t.colorScheme.onSurfaceVariant),
              ),
            ],
          ]),
          FilledButton.icon(
            onPressed: _saving ? null : _save,
            icon: const Icon(Icons.check),
            label: Text(_isOnboarding ? 'Profil anlegen und loslegen' : 'Speichern'),
            style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(52)),
          ),
        ],
      ),
    );
  }
}
