import 'package:file_picker/file_picker.dart';

/// A file chosen by the user, readable as a stream (large files are not loaded into memory).
class PickedDocument {
  const PickedDocument(
      {required this.name, required this.length, required this.open});

  final String name;
  final int length;
  final Stream<List<int>> Function() open;
}

/// Lets tests replace the native file dialog.
abstract class DocumentPicker {
  Future<PickedDocument?> pick();
}

class NativeDocumentPicker implements DocumentPicker {
  const NativeDocumentPicker();

  /// Only a convenience filter: the server checks the real type by content.
  static const extensions = [
    'pdf',
    'png',
    'jpg',
    'jpeg',
    'tif',
    'tiff',
    'webp'
  ];

  @override
  Future<PickedDocument?> pick() async {
    final files = await FilePicker.pickFiles(
      dialogTitle: 'Dokument importieren',
      type: FileType.custom,
      allowedExtensions: extensions,
    );
    if (files.isEmpty) return null;
    final file = files.first;
    final xfile = file.xFile;
    return PickedDocument(
      name: file.name,
      length: await xfile.length(),
      open: xfile.openRead,
    );
  }
}
