/// Data returned by the Paperless AI backend (`/api/v1`).
library;

class UserInfo {
  const UserInfo({
    required this.id,
    required this.email,
    required this.displayName,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) => UserInfo(
        id: json['id'] as String,
        email: json['email'] as String,
        displayName: json['display_name'] as String,
      );

  final String id;
  final String email;
  final String displayName;

  Map<String, dynamic> toJson() =>
      {'id': id, 'email': email, 'display_name': displayName};
}

class SpaceInfo {
  const SpaceInfo({
    required this.id,
    required this.name,
    required this.type,
    required this.permissions,
  });

  factory SpaceInfo.fromJson(Map<String, dynamic> json) => SpaceInfo(
        id: json['id'] as String,
        name: json['name'] as String,
        type: json['type'] as String,
        permissions: Set<String>.from(json['permissions'] as List),
      );

  final String id;
  final String name;
  final String type;
  final Set<String> permissions;

  bool get canWrite => permissions.contains('write');

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'type': type,
        'permissions': permissions.toList()..sort(),
      };
}

class DocumentInfo {
  const DocumentInfo({
    required this.id,
    required this.spaceId,
    required this.title,
    required this.createdAt,
    this.revision = 1,
    this.deleted = false,
    this.mimeType,
    this.sizeBytes,
    this.pageCount,
  });

  factory DocumentInfo.fromJson(Map<String, dynamic> json) => DocumentInfo(
        id: json['id'] as String,
        spaceId: json['space_id'] as String,
        title: json['title'] as String,
        createdAt: DateTime.parse(json['created_at'] as String),
        revision: (json['revision'] as int?) ?? 1,
        deleted: (json['deleted'] as bool?) ?? false,
        mimeType: json['mime_type'] as String?,
        sizeBytes: json['size_bytes'] as int?,
        pageCount: json['page_count'] as int?,
      );

  final String id;
  final String spaceId;
  final String title;
  final DateTime createdAt;
  final int revision;
  final bool deleted;
  final String? mimeType;
  final int? sizeBytes;
  final int? pageCount;

  Map<String, dynamic> toJson() => {
        'id': id,
        'space_id': spaceId,
        'title': title,
        'created_at': createdAt.toUtc().toIso8601String(),
        'revision': revision,
        'mime_type': mimeType,
        'size_bytes': sizeBytes,
        'page_count': pageCount,
      };
}

/// One page of the change feed (`GET /api/v1/sync`).
class SyncPage {
  const SyncPage({
    required this.cursor,
    required this.hasMore,
    required this.spaces,
    required this.documents,
  });

  factory SyncPage.fromJson(Map<String, dynamic> json) => SyncPage(
        cursor: json['cursor'] as String,
        hasMore: json['has_more'] as bool,
        spaces: [
          for (final s in json['spaces'] as List)
            SpaceInfo.fromJson(s as Map<String, dynamic>)
        ],
        documents: [
          for (final d in json['documents'] as List)
            DocumentInfo.fromJson(d as Map<String, dynamic>)
        ],
      );

  final String cursor;
  final bool hasMore;
  final List<SpaceInfo> spaces;
  final List<DocumentInfo> documents;
}

/// An error answer from the API. [code] is the backend's stable error code, if any.
class ApiException implements Exception {
  const ApiException(this.statusCode, {this.code, this.message});

  final int statusCode;
  final String? code;
  final String? message;

  bool get isUnauthorized => statusCode == 401;

  /// German message for the user. Never contains document content.
  String get userMessage {
    switch (code) {
      case 'unsupported_type':
        return 'Dieser Dateityp wird nicht unterstützt. Erlaubt sind PDF, PNG, JPEG, TIFF und WebP.';
      case 'too_large':
        return 'Die Datei ist zu groß.';
      case 'empty_file':
        return 'Die Datei ist leer.';
      case 'too_many_pages':
        return 'Das Dokument hat zu viele Seiten.';
      case 'encrypted_pdf':
        return 'Das PDF ist passwortgeschützt. Bitte das Passwort vorher entfernen.';
      case 'active_content':
        return 'Das PDF enthält ausführbaren Inhalt (z. B. JavaScript) und wurde abgelehnt.';
      case 'malformed':
        return 'Die Datei ist beschädigt oder konnte nicht gelesen werden.';
      case 'image_too_large':
        return 'Das Bild hat zu viele Pixel.';
      case 'duplicate':
        return 'Dieses Dokument ist in diesem Bereich schon vorhanden.';
    }
    switch (statusCode) {
      case 401:
        return 'Anmeldung fehlgeschlagen oder abgelaufen.';
      case 403:
        return 'Dafür fehlt dir die Berechtigung.';
      case 404:
        return 'Nicht gefunden.';
      case 503:
        return 'Der Server ist für Dokumente noch nicht eingerichtet.';
    }
    return 'Unerwarteter Fehler ($statusCode).';
  }

  @override
  String toString() => 'ApiException($statusCode, $code)';
}

/// The server could not be reached at all.
class ConnectionFailed implements Exception {
  const ConnectionFailed();

  String get userMessage =>
      'Server nicht erreichbar. Adresse und Netzwerk prüfen.';
}
