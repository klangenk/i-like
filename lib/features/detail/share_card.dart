import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../core/database/app_database.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/rating_level.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/level_badge.dart';

/// Renders [rating] as an image card and opens the share sheet with it and
/// [text]. Falls back to sharing [text] alone if the card can't be rendered.
Future<void> shareRatingCard(BuildContext context, Rating rating, String text) async {
  final file = await _renderCard(context, rating);
  if (file == null) {
    await Share.share(text);
  } else {
    await Share.shareXFiles([XFile(file.path, mimeType: 'image/png')], text: text);
  }
}

Future<File?> _renderCard(BuildContext context, Rating rating) async {
  final overlay = Overlay.maybeOf(context, rootOverlay: true);
  if (overlay == null) return null;

  // Load the photo first, so the card isn't captured with an empty frame.
  ImageProvider? photo;
  if (rating.localImagePath.isNotEmpty && File(rating.localImagePath).existsSync()) {
    photo = FileImage(File(rating.localImagePath));
  } else if (rating.imageUrl.isNotEmpty) {
    photo = NetworkImage(rating.imageUrl);
  }
  if (photo != null) {
    var failed = false;
    await precacheImage(photo, context, onError: (_, _) => failed = true);
    if (failed) photo = null;
  }

  final key = GlobalKey();
  final entry = OverlayEntry(
    // Laid out and painted off screen, never visible.
    builder: (_) => Positioned(
      left: -4000,
      top: 0,
      child: RepaintBoundary(
        key: key,
        child: _ShareCard(rating: rating, photo: photo),
      ),
    ),
  );
  overlay.insert(entry);
  try {
    await WidgetsBinding.instance.endOfFrame;
    final boundary = key.currentContext?.findRenderObject() as RenderRepaintBoundary?;
    if (boundary == null) return null;
    final image = await boundary.toImage(pixelRatio: 3);
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    if (bytes == null) return null;
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/i-like-${rating.id}.png');
    await file.writeAsBytes(bytes.buffer.asUint8List());
    return file;
  } catch (_) {
    return null;
  } finally {
    entry.remove();
  }
}

/// 360×450 card: photo, level, title, creator and the app's name.
class _ShareCard extends StatelessWidget {
  final Rating rating;
  final ImageProvider? photo;

  const _ShareCard({required this.rating, required this.photo});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final level = RatingLevel.fromScore(rating.score);
    return Material(
      color: Colors.white,
      child: SizedBox(
        width: 360,
        height: 450,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(22),
                        child: photo != null
                            ? Image(image: photo!, fit: BoxFit.cover)
                            : ColoredBox(
                                color: level?.tint(context) ?? AppColors.mist,
                                child: Icon(
                                  Icons.favorite_rounded,
                                  size: 72,
                                  color: level?.dot ?? AppColors.heart,
                                ),
                              ),
                      ),
                    ),
                    Positioned(left: 12, bottom: 12, child: RatingBadge(rating: rating, large: true)),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Text(
                rating.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 23,
                  height: 1.15,
                  fontWeight: FontWeight.w900,
                  color: AppColors.ink,
                ),
              ),
              if (rating.creator.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  l10n.byCreator(rating.creator),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 15, color: AppColors.inkMuted),
                ),
              ],
              const SizedBox(height: 12),
              const Row(
                children: [
                  Text(
                    'I Like',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900, color: AppColors.ink),
                  ),
                  SizedBox(width: 4),
                  Icon(Icons.favorite_rounded, size: 17, color: AppColors.heart),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
