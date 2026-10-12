import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/database/app_database.dart';
import '../../core/utils/date_label.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/level_badge.dart';
import '../../shared/widgets/rating_image.dart';

/// Shown when a scanned barcode is already rated: "You rated this Nope on
/// 3 March". Returns true if the user wants to rate it again anyway.
Future<bool> showKnownBarcodeSheet(BuildContext context, List<Rating> matches) async {
  final l10n = AppLocalizations.of(context)!;
  final again = await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    builder: (ctx) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.knownBarcodeTitle, style: Theme.of(ctx).textTheme.headlineSmall),
            const SizedBox(height: 14),
            for (final rating in matches.take(3))
              _KnownRating(
                rating: rating,
                onTap: () {
                  Navigator.pop(ctx, false);
                  context.push('/detail/${rating.id}');
                },
              ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(minimumSize: const Size(0, 52)),
                icon: const Icon(Icons.add_rounded),
                label: Text(l10n.rateAgain),
                onPressed: () => Navigator.pop(ctx, true),
              ),
            ),
          ],
        ),
      ),
    ),
  );
  return again ?? false;
}

class _KnownRating extends StatelessWidget {
  final Rating rating;
  final VoidCallback onTap;

  const _KnownRating({required this.rating, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: scheme.surfaceContainerHighest.withAlpha(120),
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              RatingImage(
                imageUrl: rating.imageUrl,
                localImagePath: rating.localImagePath,
                width: 64,
                height: 64,
                borderRadius: BorderRadius.circular(14),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      rating.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        RatingBadge(rating: rating),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            l10n.ratedOn(longDateLabel(context, rating.createdAt)),
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: scheme.onSurfaceVariant),
            ],
          ),
        ),
      ),
    );
  }
}
