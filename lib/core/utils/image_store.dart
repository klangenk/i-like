import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

/// Downloads remote images to the app's documents directory so they remain
/// available even after the original URL goes stale or is deleted.
class ImageStore {
  /// Downloads [imageUrl] and saves it under
  /// `<documents>/rating_images/<timestamp>.<ext>`.
  ///
  /// Returns the local file path on success, or `null` if the download fails
  /// (network error, non-200 response, empty URL). Callers should store the
  /// returned path in the database and fall back to the remote [imageUrl] if
  /// the path is null or empty.
  static Future<String?> downloadAndStore(String imageUrl) async {
    if (imageUrl.isEmpty) return null;
    try {
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode != 200) return null;

      final dir = await getApplicationDocumentsDirectory();
      final imagesDir = Directory('${dir.path}/rating_images');
      await imagesDir.create(recursive: true);

      final contentType = response.headers['content-type'] ?? '';
      final ext = _extFromContentType(contentType, imageUrl);
      final filename = '${DateTime.now().millisecondsSinceEpoch}$ext';
      final file = File('${imagesDir.path}/$filename');
      await file.writeAsBytes(response.bodyBytes);

      return file.path;
    } catch (_) {
      return null;
    }
  }

  /// Deletes the local file at [localPath], if it exists. Safe to call with
  /// null or empty paths.
  static Future<void> delete(String? localPath) async {
    if (localPath == null || localPath.isEmpty) return;
    try {
      final file = File(localPath);
      if (await file.exists()) await file.delete();
    } catch (_) {}
  }

  static String _extFromContentType(String contentType, String url) {
    if (contentType.contains('png')) return '.png';
    if (contentType.contains('webp')) return '.webp';
    if (contentType.contains('gif')) return '.gif';
    // Fall back to extension in the URL
    final uri = Uri.tryParse(url);
    if (uri != null) {
      final path = uri.path.toLowerCase();
      for (final ext in ['.png', '.webp', '.gif', '.jpg', '.jpeg']) {
        if (path.endsWith(ext)) return ext;
      }
    }
    return '.jpg';
  }
}
