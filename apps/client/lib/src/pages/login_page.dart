import 'package:flutter/material.dart';

import '../api/models.dart';
import '../api/server_url.dart';
import '../app_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _form = GlobalKey<FormState>();
  final _server = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _busy = false;
  String? _error;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final last = AppScope.of(context).lastServer;
    if (_server.text.isEmpty && last != null) _server.text = last;
  }

  @override
  void dispose() {
    _server.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_form.currentState!.validate()) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    final state = AppScope.of(context);
    final navigator = Navigator.of(context);
    try {
      await state.signIn(
        server: _server.text,
        email: _email.text,
        password: _password.text,
      );
      _password.clear();
      if (navigator.canPop()) navigator.pop();
    } on InvalidServerUrl catch (e) {
      setState(() => _error = e.message);
    } on ApiException catch (e) {
      setState(() => _error = e.isUnauthorized
          ? 'E-Mail oder Passwort ist falsch.'
          : e.userMessage);
    } on ConnectionFailed catch (e) {
      setState(() => _error = e.userMessage);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mit Server verbinden')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Form(
            key: _form,
            child: ListView(
              padding: const EdgeInsets.all(24),
              shrinkWrap: true,
              children: [
                TextFormField(
                  key: const Key('login.server'),
                  controller: _server,
                  decoration: const InputDecoration(
                    labelText: 'Server',
                    hintText: 'https://paperless.example.org',
                  ),
                  keyboardType: TextInputType.url,
                  autocorrect: false,
                  validator: (v) {
                    try {
                      normalizeServerUrl(v ?? '');
                      return null;
                    } on InvalidServerUrl catch (e) {
                      return e.message;
                    }
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  key: const Key('login.email'),
                  controller: _email,
                  decoration: const InputDecoration(labelText: 'E-Mail'),
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  autofillHints: const [AutofillHints.email],
                  validator: (v) =>
                      (v ?? '').contains('@') ? null : 'Bitte E-Mail eingeben.',
                ),
                const SizedBox(height: 12),
                TextFormField(
                  key: const Key('login.password'),
                  controller: _password,
                  decoration: const InputDecoration(labelText: 'Passwort'),
                  obscureText: true,
                  autofillHints: const [AutofillHints.password],
                  validator: (v) =>
                      (v ?? '').isEmpty ? 'Bitte Passwort eingeben.' : null,
                  onFieldSubmitted: (_) => _submit(),
                ),
                const SizedBox(height: 20),
                if (_error != null) ...[
                  Text(
                    _error!,
                    key: const Key('login.error'),
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.error),
                  ),
                  const SizedBox(height: 12),
                ],
                FilledButton(
                  key: const Key('login.submit'),
                  onPressed: _busy ? null : _submit,
                  child: _busy
                      ? const SizedBox.square(
                          dimension: 18,
                          child: CircularProgressIndicator(strokeWidth: 2))
                      : const Text('Anmelden'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
