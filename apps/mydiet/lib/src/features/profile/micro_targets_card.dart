import 'package:material_ui/material_ui.dart';

import '../../core/energy.dart' show ageOn;
import '../../core/micronutrients.dart';
import '../../core/supplements.dart' show nutrientById;
import '../../data/database.dart';
import '../../ui/format.dart';
import '../../ui/widgets.dart';
import '../micros/micros_view.dart' show MicrosPage;

/// Daily vitamin and mineral targets (D-A-CH reference values) for this person.
class MicroTargetsCard extends StatelessWidget {
  const MicroTargetsCard({super.key, required this.profile, this.today});
  final Profile profile;
  final DateTime? today;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final female = profile.sex == 'female';
    final age = ageOn(profile.birthDate, today ?? DateTime.now());
    final rows = [
      for (final e in dachTargets.entries)
        if (nutrientById(e.key) != null)
          (nutrientById(e.key)!, e.value.forPerson(female: female, age: age), e.value.note),
    ];
    return SectionCard(
      title: 'Vitamine und Mineralstoffe',
      icon: Icons.eco_outlined,
      trailing: TextButton(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MicrosPage())),
        child: const Text('Heute'),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Tagesziele nach D-A-CH-Referenzwerten für ${female ? 'Frauen' : 'Männer'}, $age Jahre. '
            'Richtwerte für Gesunde, keine Dosierungsempfehlung.',
            style: t.textTheme.bodySmall?.copyWith(color: t.colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 8),
          for (final (info, value, note) in rows)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(note == null ? info.name : '${info.name} ($note)', style: t.textTheme.bodyMedium),
                  ),
                  const SizedBox(width: 8),
                  Text('${n1opt(value)} ${info.unit}', style: const TextStyle(fontWeight: FontWeight.w600)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
