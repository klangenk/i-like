import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/tag_l10n.dart';
import '../../l10n/app_localizations.dart';

class TagBadge extends StatelessWidget {
  final String tag;
  final VoidCallback? onTap;
  final bool selected;

  const TagBadge({
    super.key,
    required this.tag,
    this.onTap,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    // Use the raw key for color lookup, localized name for display
    final baseTag = _extractBaseTag(tag);
    final color = AppColors.tagColor(baseTag);
    final l10n = AppLocalizations.of(context)!;
    final displayName = _localizeFullTag(tag, l10n);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: selected ? color : color.withAlpha(30),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: color.withAlpha(selected ? 255 : 80),
            width: 1,
          ),
        ),
        child: Text(
          displayName,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: selected
                ? Colors.white
                : Theme.of(context).brightness == Brightness.dark
                    ? color.withAlpha(220)
                    : color.withAlpha(200),
          ),
        ),
      ),
    );
  }

  /// Extract the base tag key from strings like "book (3)" -> "book"
  String _extractBaseTag(String tag) {
    final match = RegExp(r'^(\w+)\s*\(').firstMatch(tag);
    return match != null ? match.group(1)! : tag;
  }

  /// Localize a tag, preserving suffixes like " (3)" from statistics
  String _localizeFullTag(String tag, AppLocalizations l10n) {
    final match = RegExp(r'^(\w+)(\s*\(.+\))$').firstMatch(tag);
    if (match != null) {
      final key = match.group(1)!;
      final suffix = match.group(2)!;
      return '${localizedTagName(key, l10n)}$suffix';
    }
    return localizedTagName(tag, l10n);
  }
}
