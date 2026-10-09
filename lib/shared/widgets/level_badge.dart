import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/rating_level.dart';
import '../../l10n/app_localizations.dart';

/// Pill showing a rating's word level, e.g. "● Gut".
class LevelBadge extends StatelessWidget {
  final RatingLevel level;
  final bool large;

  const LevelBadge({super.key, required this.level, this.large = false});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final dotSize = large ? 12.0 : 8.0;
    return Container(
      height: large ? 44 : 28,
      padding: EdgeInsets.only(left: large ? 14 : 9, right: large ? 18 : 11),
      decoration: BoxDecoration(
        color: level.tint(context),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (level == RatingLevel.liebe)
            Icon(Icons.favorite_rounded, size: dotSize + 6, color: level.dot)
          else
            Container(
              width: dotSize,
              height: dotSize,
              decoration: BoxDecoration(color: level.dot, shape: BoxShape.circle),
            ),
          SizedBox(width: large ? 8 : 6),
          Text(
            level.word(l10n),
            style: TextStyle(
              fontSize: large ? 20 : 13,
              fontWeight: large ? FontWeight.w900 : FontWeight.w800,
              color: level.strong(context),
            ),
          ),
        ],
      ),
    );
  }
}

/// Five-segment bar marking a level on the Nope → Liebe scale.
class LevelScale extends StatelessWidget {
  final RatingLevel level;

  const LevelScale({super.key, required this.level});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final empty = AppColors.divider(context);
    final muted = Theme.of(context).colorScheme.onSurfaceVariant;
    return Semantics(
      label: '${level.word(l10n)}, ${level.value} / 5',
      excludeSemantics: true,
      child: Column(
        children: [
          Row(
            children: [
              for (final l in RatingLevel.values) ...[
                Expanded(
                  child: Container(
                    height: 10,
                    decoration: BoxDecoration(
                      color: l.value <= level.value ? level.dot : empty,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
                if (l != RatingLevel.liebe) const SizedBox(width: 4),
              ],
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              for (final l in RatingLevel.values)
                Expanded(
                  child: Text(
                    l.word(l10n),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: l == level ? FontWeight.w800 : FontWeight.w600,
                      color: l == level ? level.strong(context) : muted,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
