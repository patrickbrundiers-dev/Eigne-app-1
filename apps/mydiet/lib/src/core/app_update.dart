/// Online update: versions and GitHub release parsing. Pure Dart, unit tested.
library;

/// Release tags of this app look like `mydiet-v0.2.0` (or `sattly-v0.2.0` after the
/// rename). Older tags of the previous app (`v0.8.0`) are ignored.
const releaseTagPrefixes = ['mydiet-v', 'sattly-v'];

class AppVersion implements Comparable<AppVersion> {
  const AppVersion(this.major, this.minor, this.patch);

  final int major;
  final int minor;
  final int patch;

  /// Parses `0.2.0`, `0.2.0+5`, `v0.2.0` or `mydiet-v0.2.0`. Returns null otherwise.
  static AppVersion? tryParse(String s) {
    final m = RegExp(r'(\d+)\.(\d+)(?:\.(\d+))?').firstMatch(s.trim());
    if (m == null) return null;
    return AppVersion(int.parse(m[1]!), int.parse(m[2]!), int.parse(m[3] ?? '0'));
  }

  @override
  int compareTo(AppVersion o) {
    if (major != o.major) return major.compareTo(o.major);
    if (minor != o.minor) return minor.compareTo(o.minor);
    return patch.compareTo(o.patch);
  }

  bool operator >(AppVersion o) => compareTo(o) > 0;

  @override
  bool operator ==(Object other) => other is AppVersion && compareTo(other) == 0;

  @override
  int get hashCode => Object.hash(major, minor, patch);

  @override
  String toString() => '$major.$minor.$patch';
}

enum UpdatePlatform { android, windows, other }

class UpdateAsset {
  const UpdateAsset({required this.name, required this.url, required this.size, this.sha256});

  final String name;
  final Uri url;
  final int size;

  /// Hex SHA-256 from GitHub (`digest: sha256:…`), if GitHub provides it.
  final String? sha256;
}

class UpdateInfo {
  const UpdateInfo({
    required this.version,
    required this.tag,
    required this.notes,
    required this.page,
    required this.assets,
    this.publishedAt,
  });

  final AppVersion version;
  final String tag;
  final String notes;
  final Uri page;
  final List<UpdateAsset> assets;
  final DateTime? publishedAt;

  /// The file to install: the APK on Android, the setup on Windows.
  UpdateAsset? assetFor(UpdatePlatform p) {
    bool match(UpdateAsset a) => switch (p) {
      UpdatePlatform.android => a.name.toLowerCase().endsWith('.apk'),
      UpdatePlatform.windows => a.name.toLowerCase().endsWith('.exe') && a.name.toLowerCase().contains('setup'),
      UpdatePlatform.other => false,
    };
    return assets.where(match).firstOrNull;
  }
}

/// The newest published release of this app from `GET /repos/{owner}/{repo}/releases`.
/// Drafts and pre-releases are skipped.
UpdateInfo? latestRelease(List<dynamic> releases) {
  UpdateInfo? best;
  for (final r in releases) {
    if (r is! Map) continue;
    if (r['draft'] == true || r['prerelease'] == true) continue;
    final tag = r['tag_name'];
    if (tag is! String) continue;
    final prefix = releaseTagPrefixes.where(tag.startsWith).firstOrNull;
    if (prefix == null) continue;
    final v = AppVersion.tryParse(tag.substring(prefix.length));
    if (v == null) continue;
    if (best != null && !(v > best.version)) continue;
    final assets = <UpdateAsset>[];
    for (final a in (r['assets'] as List?) ?? const []) {
      if (a is! Map) continue;
      final url = Uri.tryParse('${a['browser_download_url']}');
      final name = a['name'];
      if (url == null || name is! String || url.scheme != 'https') continue;
      final digest = a['digest'];
      assets.add(
        UpdateAsset(
          name: name,
          url: url,
          size: (a['size'] as num?)?.toInt() ?? 0,
          sha256: digest is String && digest.startsWith('sha256:') ? digest.substring(7).toLowerCase() : null,
        ),
      );
    }
    best = UpdateInfo(
      version: v,
      tag: tag,
      notes: (r['body'] as String?)?.trim() ?? '',
      page: Uri.tryParse('${r['html_url']}') ?? Uri(),
      assets: assets,
      publishedAt: DateTime.tryParse('${r['published_at']}'),
    );
  }
  return best;
}

/// The release to offer, or null when the app is up to date or the user skipped it.
UpdateInfo? offeredUpdate(UpdateInfo? latest, AppVersion current, {String? skippedTag}) {
  if (latest == null || !(latest.version > current)) return null;
  if (skippedTag != null && skippedTag == latest.tag) return null;
  return latest;
}

/// Automatic checks run at most once a day.
bool autoCheckDue(DateTime? lastCheck, DateTime now) =>
    lastCheck == null || now.difference(lastCheck) >= const Duration(hours: 20) || now.isBefore(lastCheck);
