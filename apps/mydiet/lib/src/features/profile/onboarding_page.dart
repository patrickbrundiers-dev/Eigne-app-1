import 'package:material_ui/material_ui.dart';

import 'profile_form.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: t.colorScheme.primaryContainer,
                            child: Icon(Icons.eco, color: t.colorScheme.onPrimaryContainer),
                          ),
                          const SizedBox(width: 12),
                          Text('MyDiet AI', style: t.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Erzähl kurz etwas über dich. Daraus berechnet die App Grundumsatz, '
                        'Gesamtumsatz und deine Tagesziele. Alles bleibt auf diesem Gerät und '
                        'lässt sich jederzeit ändern.',
                        style: t.textTheme.bodyLarge?.copyWith(color: t.colorScheme.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
                // The profile stream switches to the dashboard once saved.
                Expanded(child: ProfileForm(onSaved: () {})),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
