import 'dart:async';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../database/app_database.dart';

/// Optional backup through Android's Auto Backup, encrypted in the user's own
/// Google account. The backup rules (res/xml/*backup*) only include the folder
/// `files/ilike_backup/`, which this service fills while backup is on and
/// deletes when it is turned off – so nothing is backed up unless the user
/// asked for it. Android restores the folder when the app is set up on a new
/// phone; [restoreIfNeeded] then turns it back into the live database.
class BackupService {
  static const enabledKey = 'backup_enabled';
  static const _db = 'i_like.db';
  static const _images = 'rating_images';
  static const _docsPathFile = 'documents_path.txt';

  /// Android caps an app's Auto Backup at 25 MB; photos beyond this budget
  /// (oldest first) are left out so the backup as a whole still succeeds.
  static const _photoBudget = 20 * 1024 * 1024;

  static bool get supported => Platform.isAndroid;

  static bool isEnabled(SharedPreferences prefs) => prefs.getBool(enabledKey) ?? false;

  static Future<Directory> _backupDir() async =>
      Directory(p.join((await getApplicationSupportDirectory()).path, 'ilike_backup'));

  /// Call before the database opens. On a fresh install with a restored
  /// backup folder, copies the database and photos back into place. Returns
  /// the previous documents path if a restore happened (photo paths in the
  /// database still point there), else null.
  static Future<String?> restoreIfNeeded(SharedPreferences prefs) async {
    if (!supported) return null;
    final backup = await _backupDir();
    final copy = File(p.join(backup.path, _db));
    final docs = await getApplicationDocumentsDirectory();
    final live = File(p.join(docs.path, _db));
    if (!copy.existsSync() || live.existsSync()) return null;

    await copy.copy(live.path);
    final images = Directory(p.join(backup.path, _images));
    if (images.existsSync()) {
      final target = Directory(p.join(docs.path, _images))..createSync(recursive: true);
      for (final f in images.listSync().whereType<File>()) {
        await f.copy(p.join(target.path, p.basename(f.path)));
      }
    }
    // Shared preferences are not backed up, so remember the choice again.
    await prefs.setBool(enabledKey, true);
    final docsFile = File(p.join(backup.path, _docsPathFile));
    return docsFile.existsSync() ? docsFile.readAsStringSync().trim() : null;
  }

  /// After a restore: photo paths still name the old phone's folder.
  static Future<void> fixPhotoPaths(AppDatabase db, String oldDocsPath) async {
    final docs = (await getApplicationDocumentsDirectory()).path;
    if (oldDocsPath.isEmpty || oldDocsPath == docs) return;
    await db.customStatement(
      'UPDATE ratings SET local_image_path = replace(local_image_path, ?, ?)',
      [oldDocsPath, docs],
    );
  }

  /// Writes a consistent copy of the database and the newest photos into the
  /// backup folder, replacing the previous copy.
  static Future<void> snapshot(AppDatabase db) async {
    if (!supported) return;
    final backup = await _backupDir();
    final tmp = Directory('${backup.path}.tmp');
    if (tmp.existsSync()) tmp.deleteSync(recursive: true);
    tmp.createSync(recursive: true);

    await db.customStatement('VACUUM INTO ?', [p.join(tmp.path, _db)]);

    final docs = await getApplicationDocumentsDirectory();
    final images = Directory(p.join(docs.path, _images));
    if (images.existsSync()) {
      final files = images.listSync().whereType<File>().toList()
        ..sort((a, b) => b.lastModifiedSync().compareTo(a.lastModifiedSync()));
      final target = Directory(p.join(tmp.path, _images))..createSync();
      var total = 0;
      for (final f in files) {
        final size = f.lengthSync();
        if (total + size > _photoBudget) continue;
        total += size;
        await f.copy(p.join(target.path, p.basename(f.path)));
      }
    }
    File(p.join(tmp.path, _docsPathFile)).writeAsStringSync(docs.path);

    if (backup.existsSync()) backup.deleteSync(recursive: true);
    tmp.renameSync(backup.path);
  }

  /// Turns backup off: without the folder, the next Auto Backup run stores
  /// nothing of the app.
  static Future<void> clear() async {
    if (!supported) return;
    final backup = await _backupDir();
    if (backup.existsSync()) backup.deleteSync(recursive: true);
  }
}

/// Keeps the backup folder current while backup is on: snapshots a few
/// seconds after the ratings change, one at a time.
class BackupScheduler {
  final AppDatabase db;
  final SharedPreferences prefs;
  Timer? _timer;
  bool _running = false;

  BackupScheduler(this.db, this.prefs);

  void changed() {
    if (!BackupService.supported || !BackupService.isEnabled(prefs)) return;
    _timer?.cancel();
    _timer = Timer(const Duration(seconds: 5), _run);
  }

  Future<void> _run() async {
    if (_running) return changed();
    _running = true;
    try {
      if (BackupService.isEnabled(prefs)) await BackupService.snapshot(db);
    } catch (_) {
      // A failed snapshot keeps the previous one; the next change retries.
    } finally {
      _running = false;
    }
  }

  void dispose() => _timer?.cancel();
}
