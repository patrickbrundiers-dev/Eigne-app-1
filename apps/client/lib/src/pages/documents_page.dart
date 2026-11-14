import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../api/models.dart';
import '../app_state.dart';
import 'login_page.dart';
import 'placeholder_page.dart';

class DocumentsPage extends StatefulWidget {
  const DocumentsPage({super.key});

  @override
  State<DocumentsPage> createState() => _DocumentsPageState();
}

class _DocumentsPageState extends State<DocumentsPage> {
  String? _spaceId;
  Future<List<DocumentInfo>>? _docs;
  int _loadedVersion = -1;
  String? _loadedSpace;

  void _reload(AppState state) {
    final client = state.client;
    if (client == null || _spaceId == null) {
      _docs = null;
      return;
    }
    _loadedVersion = state.documentsVersion;
    _loadedSpace = _spaceId;
    _docs = client.documents(_spaceId!);
  }

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    if (!state.isSignedIn) {
      return PlaceholderPage(
        icon: Icons.cloud_off_outlined,
        title: 'Nicht verbunden',
        message:
            'Melde dich bei deinem Paperless-Server an, um Dokumente zu sehen.',
        action: FilledButton(
          onPressed: () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => const LoginPage())),
          child: const Text('Anmelden'),
        ),
      );
    }
    if (state.spaces.isEmpty) {
      return const PlaceholderPage(
        icon: Icons.folder_off_outlined,
        title: 'Keine Bereiche',
        message: 'Für dein Konto ist noch kein Bereich freigegeben.',
      );
    }
    if (_spaceId == null || !state.spaces.any((s) => s.id == _spaceId)) {
      _spaceId = state.spaces.first.id;
    }
    if (_docs == null ||
        _loadedVersion != state.documentsVersion ||
        _loadedSpace != _spaceId) {
      _reload(state);
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: DropdownButtonFormField<String>(
            key: const Key('documents.space'),
            initialValue: _spaceId,
            decoration: const InputDecoration(labelText: 'Bereich'),
            items: [
              for (final s in state.spaces)
                DropdownMenuItem(value: s.id, child: Text(s.name)),
            ],
            onChanged: (id) => setState(() => _spaceId = id),
          ),
        ),
        Expanded(
          child: FutureBuilder<List<DocumentInfo>>(
            future: _docs,
            builder: (context, snap) {
              if (snap.connectionState != ConnectionState.done) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snap.hasError) {
                final e = snap.error;
                return PlaceholderPage(
                  icon: Icons.error_outline,
                  title: 'Laden fehlgeschlagen',
                  message: e is ApiException
                      ? e.userMessage
                      : e is ConnectionFailed
                          ? e.userMessage
                          : 'Unerwarteter Fehler.',
                );
              }
              final docs = snap.data!;
              if (docs.isEmpty) {
                return const PlaceholderPage(
                  icon: Icons.folder_outlined,
                  title: 'Noch keine Dokumente',
                  message: 'Importiere ein Dokument über die Übersicht.',
                );
              }
              return RefreshIndicator(
                onRefresh: () async => setState(() => _reload(state)),
                child: ListView.separated(
                  itemCount: docs.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, i) => _DocumentTile(doc: docs[i]),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

String _subtitle(DocumentInfo d) {
  final parts = <String>[
    '${d.createdAt.toLocal().day}.${d.createdAt.toLocal().month}.${d.createdAt.toLocal().year}',
    if (d.pageCount != null)
      '${d.pageCount} ${d.pageCount == 1 ? 'Seite' : 'Seiten'}',
    if (d.sizeBytes != null) '${(d.sizeBytes! / 1024).ceil()} KB',
  ];
  return parts.join(' · ');
}

class _DocumentTile extends StatelessWidget {
  const _DocumentTile({required this.doc});

  final DocumentInfo doc;

  @override
  Widget build(BuildContext context) {
    final isPdf = doc.mimeType == 'application/pdf';
    return ListTile(
      leading:
          Icon(isPdf ? Icons.picture_as_pdf_outlined : Icons.image_outlined),
      title: Text(doc.title),
      subtitle: Text(_subtitle(doc)),
      onTap: () => showDialog<void>(
        context: context,
        builder: (_) => _PreviewDialog(doc: doc),
      ),
    );
  }
}

class _PreviewDialog extends StatelessWidget {
  const _PreviewDialog({required this.doc});

  final DocumentInfo doc;

  @override
  Widget build(BuildContext context) {
    final client = AppScope.of(context).client;
    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 700, maxHeight: 900),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(doc.title),
              trailing: IconButton(
                tooltip: 'Schließen',
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            Flexible(
              child: FutureBuilder<Uint8List>(
                future: client?.preview(doc.id),
                builder: (context, snap) {
                  if (snap.hasData) {
                    return InteractiveViewer(child: Image.memory(snap.data!));
                  }
                  if (snap.hasError) {
                    return const Padding(
                      padding: EdgeInsets.all(24),
                      child: Text('Keine Vorschau verfügbar.'),
                    );
                  }
                  return const Padding(
                    padding: EdgeInsets.all(24),
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
