import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/utils/image_store.dart';
import '../../l10n/app_localizations.dart';

enum _PhotoAction { camera, gallery, remove }

/// Result of [pickRatingPhoto]: a new stored photo, an explicit removal,
/// or `null` when the user cancelled.
sealed class PhotoPick {
  const PhotoPick();
}

class PhotoPicked extends PhotoPick {
  final String localPath;
  const PhotoPicked(this.localPath);
}

class PhotoRemoved extends PhotoPick {
  const PhotoRemoved();
}

/// Lets the user take or choose a photo and copies it into app storage.
/// [canRemove] adds a "Remove photo" option when an image is already set.
Future<PhotoPick?> pickRatingPhoto(BuildContext context, {required bool canRemove}) async {
  final l10n = AppLocalizations.of(context)!;
  final messenger = ScaffoldMessenger.of(context);

  final action = await showModalBottomSheet<_PhotoAction>(
    context: context,
    builder: (ctx) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: Text(l10n.takePhoto),
              onTap: () => Navigator.pop(ctx, _PhotoAction.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: Text(l10n.chooseFromGallery),
              onTap: () => Navigator.pop(ctx, _PhotoAction.gallery),
            ),
            if (canRemove)
              ListTile(
                leading: Icon(Icons.delete_outline_rounded, color: Theme.of(ctx).colorScheme.error),
                title: Text(
                  l10n.removePhoto,
                  style: TextStyle(color: Theme.of(ctx).colorScheme.error),
                ),
                onTap: () => Navigator.pop(ctx, _PhotoAction.remove),
              ),
          ],
        ),
      ),
    ),
  );

  switch (action) {
    case null:
      return null;
    case _PhotoAction.remove:
      return const PhotoRemoved();
    case _PhotoAction.camera:
    case _PhotoAction.gallery:
      try {
        final file = await ImagePicker().pickImage(
          source: action == _PhotoAction.camera ? ImageSource.camera : ImageSource.gallery,
          maxWidth: 1600,
          maxHeight: 1600,
          imageQuality: 85,
        );
        if (file == null) return null;
        final stored = await ImageStore.storeLocalCopy(file.path);
        if (stored == null) throw Exception('copy failed');
        return PhotoPicked(stored);
      } catch (_) {
        messenger.showSnackBar(SnackBar(content: Text(l10n.photoError)));
        return null;
      }
  }
}
