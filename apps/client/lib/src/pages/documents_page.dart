import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../api/models.dart';
import '../app_state.dart';
import '../sync/sync_engine.dart';
import 'login_page.dart';
import 'placeholder_page.dart';

class DocumentsPage extends StatefulWidget {
  const DocumentsPage({super.key});

  @override
  State<DocumentsPage> createState() => _DocumentsPageState();
}

class _DocumentsPageState extends State<DocumentsPage> {
  String? _spaceId;

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
    final docs = state.sync.documentsIn(_spaceId!);
    final pending = state.sync.pendingIn(_spaceId!);
    final neverSynced = state.sync.lastSyncedAt == null;

    Widget list;
    if (docs.isEmpty && pending.isEmpty) {
      list = neverSynced && state.syncing
          ? const Center(child: CircularProgressIndicator())
          : const PlaceholderPage(
              icon: Icons.folder_outlined,
              title: 'Noch keine Dokumente',
              message: 'Importiere ein Dokument über die Übersicht.',
            );
    } else {
      list = ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: pending.length + docs.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, i) => i < pending.length
            ? _PendingTile(item: pending[i])
            : _DocumentTile(doc: docs[i - pending.length]),
      );
    }

    return Column(
      children: [
        if (state.offline)
          const MaterialBanner(
            key: Key('documents.offline'),
            leading: Icon(Icons.cloud_off_outlined),
            content: Text('Offline: Du siehst den zuletzt synchronisierten '
                'Stand. Neue Dokumente werden hochgeladen, sobald der Server '
                'wieder erreichbar ist.'),
            actions: [SizedBox.shrink()],
          ),
        if (state.syncError != null)
          MaterialBanner(
            leading: const Icon(Icons.sync_problem_outlined),
            content: Text('Abgleich fehlgeschlagen: ${state.syncError}'),
            actions: const [SizedBox.shrink()],
          ),
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
          child: RefreshIndicator(
            onRefresh: state.syncNow,
            child: list,
          ),
        ),
      ],
    );
  }
}

class _PendingTile extends StatelessWidget {
  const _PendingTile({required this.item});

  final PendingUpload item;

  @override
  Widget build(BuildContext context) {
    final failed = item.error != null;
    return ListTile(
      key: Key('documents.pending.${item.id}'),
      leading: Icon(failed ? Icons.error_outline : Icons.cloud_upload_outlined),
      title: Text(item.filename),
      subtitle: Text(failed ? item.error! : 'Wartet auf Upload'),
      trailing: failed
          ? IconButton(
              tooltip: 'Verwerfen',
              icon: const Icon(Icons.delete_outline),
              onPressed: () => AppScope.of(context).discardUpload(item.id),
            )
          : null,
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
