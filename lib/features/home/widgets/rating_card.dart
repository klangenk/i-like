import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../core/database/app_database.dart';
import '../../../core/theme/rating_level.dart';
import '../../../core/utils/date_label.dart';
import '../../../core/utils/tag_l10n.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/level_badge.dart';
import '../../../shared/widgets/rating_image.dart';

/// Grid tile: photo with the word level on it, title and "category · date".
/// Long-press offers delete.
class RatingCard extends StatelessWidget {
  final Rating rating;
  final VoidCallback? onDelete;

  const RatingCard({
    super.key,
    required this.rating,
    this.onDelete,
  });

  Future<void> _confirmDelete(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    HapticFeedback.mediumImpact();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.deleteRating),
        content: Text(l10n.deleteItemConfirm(rating.title)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            style: TextButton.styleFrom(foregroundColor: Theme.of(ctx).colorScheme.onSurface),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: Theme.of(ctx).colorScheme.error),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
    if (confirmed == true) onDelete?.call();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final level = RatingLevel.fromScore(rating.score);
    final firstTag = rating.tags
        .split(',')
        .map((t) => t.trim())
        .firstWhere((t) => t.isNotEmpty, orElse: () => '');
    final meta = [
      if (firstTag.isNotEmpty) localizedTagName(firstTag, l10n),
      shortDateLabel(context, rating.createdAt),
    ].join(' · ');

    final radius = BorderRadius.circular(20);
    // Neutral so the coloured level badge stands out on it.
    final placeholderColor = Theme.of(context).colorScheme.surfaceContainerHighest;
    final placeholderIcon = Theme.of(context).colorScheme.onSurfaceVariant;

    return InkWell(
      borderRadius: radius,
      onTap: () => context.push('/detail/${rating.id}'),
      onLongPress: onDelete == null ? null : () => _confirmDelete(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                RatingImage(
                  imageUrl: rating.imageUrl,
                  localImagePath: rating.localImagePath,
                  fit: BoxFit.cover,
                  borderRadius: radius,
                  placeholder: Container(
                    color: placeholderColor,
                    alignment: Alignment.center,
                    child: Icon(Icons.image_outlined, size: 36, color: placeholderIcon),
                  ),
                ),
                if (level != null)
                  Positioned(left: 8, bottom: 8, child: LevelBadge(level: level)),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            rating.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, height: 1.2),
          ),
          const SizedBox(height: 2),
          Text(
            meta,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
