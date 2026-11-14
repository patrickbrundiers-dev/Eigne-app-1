import 'package:flutter/material.dart';

import '../api/models.dart';
import '../app_state.dart';
import 'document_picker.dart';

/// Pick a file, choose the target space if there is more than one, upload, report.
Future<void> runImport(
  BuildContext context,
  AppState state,
  DocumentPicker picker,
) async {
  final messenger = ScaffoldMessenger.of(context);
  final client = state.client;
  final targets = state.writableSpaces;
  if (client == null || targets.isEmpty) return;

  final picked = await picker.pick();
  if (picked == null || !context.mounted) return;

  final space = targets.length == 1
      ? targets.first
      : await showDialog<SpaceInfo>(
          context: context,
          builder: (context) => SimpleDialog(
            title: const Text('In welchen Bereich?'),
            children: [
              for (final s in targets)
                SimpleDialogOption(
                  onPressed: () => Navigator.pop(context, s),
                  child: Text(s.name),
                ),
            ],
          ),
        );
  if (space == null) return;

  Future<void> queue() async {
    await state.queueUpload(picked, space);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
          content: Text('Kein Server erreichbar. „${picked.name}“ wird '
              'automatisch hochgeladen, sobald die Verbindung wieder da ist.')));
  }

  if (state.offline) return queue();

  messenger.showSnackBar(
    SnackBar(content: Text('„${picked.name}“ wird hochgeladen …')),
  );
  try {
    final doc = await client.upload(
      spaceId: space.id,
      filename: picked.name,
      length: picked.length,
      content: picked.open(),
    );
    state.documentsChanged();
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
          content: Text('„${doc.title}“ in ${space.name} gespeichert.')));
  } on ApiException catch (e) {
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(e.userMessage)));
  } on ConnectionFailed {
    await queue();
  }
}
