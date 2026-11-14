import 'package:flutter/material.dart';

import '../app_state.dart';
import 'login_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final user = state.user;
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: [
        const ListTile(title: Text('Server')),
        if (user == null)
          ListTile(
            leading: const Icon(Icons.cloud_off_outlined),
            title: const Text('Nicht verbunden'),
            subtitle: const Text(
                'Optional: mit deinem eigenen Server synchronisieren'),
            trailing: FilledButton(
              key: const Key('settings.login'),
              onPressed: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => const LoginPage())),
              child: const Text('Anmelden'),
            ),
          )
        else ...[
          ListTile(
            leading: const Icon(Icons.cloud_done_outlined),
            title: Text(user.displayName),
            subtitle: Text('${user.email}\n${state.lastServer ?? ''}'),
            isThreeLine: true,
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Abmelden'),
            key: const Key('settings.logout'),
            onTap: state.signOut,
          ),
        ],
        const Divider(),
        const ListTile(
          leading: Icon(Icons.family_restroom_outlined),
          title: Text('Familie und Bereiche'),
          subtitle: Text(
              'Verwaltung folgt. Bis dahin über paperless-admin am Server.'),
        ),
      ],
    );
  }
}
