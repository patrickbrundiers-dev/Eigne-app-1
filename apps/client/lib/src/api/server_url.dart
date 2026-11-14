/// Normalises and validates the server address the user typed.
///
/// TLS is required (docs/SECURITY.md). Plain HTTP is accepted only for the local machine
/// and the Android emulator's alias for it, which is what local development needs.
library;

const _loopbackHosts = {'localhost', '127.0.0.1', '::1', '[::1]', '10.0.2.2'};

class InvalidServerUrl implements Exception {
  const InvalidServerUrl(this.message);
  final String message;
}

Uri normalizeServerUrl(String input) {
  var text = input.trim();
  if (text.isEmpty) {
    throw const InvalidServerUrl('Bitte eine Serveradresse eingeben.');
  }
  if (!text.contains('://')) text = 'https://$text';
  final uri = Uri.tryParse(text);
  if (uri == null || uri.host.isEmpty) {
    throw const InvalidServerUrl('Die Serveradresse ist ungültig.');
  }
  if (uri.scheme != 'https' && uri.scheme != 'http') {
    throw const InvalidServerUrl('Nur https:// Adressen sind erlaubt.');
  }
  if (uri.scheme == 'http' && !_loopbackHosts.contains(uri.host)) {
    throw const InvalidServerUrl(
        'Unverschlüsseltes http:// ist nur für localhost erlaubt. Bitte https:// verwenden.');
  }
  if (uri.userInfo.isNotEmpty) {
    throw const InvalidServerUrl('Zugangsdaten gehören nicht in die Adresse.');
  }
  // Drop query/fragment and trailing slashes.
  final path = uri.path.replaceAll(RegExp(r'/+$'), '');
  return Uri(
      scheme: uri.scheme,
      host: uri.host,
      port: uri.hasPort ? uri.port : null,
      path: path);
}
