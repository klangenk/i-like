import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/rating_level.dart';
import '../../../l10n/app_localizations.dart';
import '../home_provider.dart';

void showSortSheet(BuildContext context, WidgetRef ref) {
  final l10n = AppLocalizations.of(context)!;
  final current = ref.read(sortOptionProvider);
  final ink = Theme.of(context).colorScheme.onSurface;

  final options = [
    (SortOption.newest, l10n.sortNewest, l10n.sortNewestHint, ink),
    (SortOption.oldest, l10n.sortOldest, l10n.sortOldestHint, const Color(0xFFB9B7C4)),
    (SortOption.highest, l10n.sortHighest, l10n.sortHighestHint, RatingLevel.liebe.dot),
    (SortOption.lowest, l10n.sortLowest, l10n.sortLowestHint, RatingLevel.nope.dot),
    (SortOption.az, l10n.sortAZ, l10n.sortAZHint, RatingLevel.okay.dot),
    (SortOption.za, l10n.sortZA, l10n.sortZAHint, RatingLevel.naja.dot),
  ];

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (ctx) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.sort, style: Theme.of(ctx).textTheme.headlineSmall),
            const SizedBox(height: 14),
            for (final (option, label, hint, dot) in options)
              _SortOptionTile(
                label: label,
                hint: hint,
                dot: dot,
                selected: option == current,
                onTap: () {
                  ref.read(sortOptionProvider.notifier).state = option;
                  Navigator.pop(ctx);
                },
              ),
          ],
        ),
      ),
    ),
  );
}

class _SortOptionTile extends StatelessWidget {
  final String label;
  final String hint;
  final Color dot;
  final bool selected;
  final VoidCallback onTap;

  const _SortOptionTile({
    required this.label,
    required this.hint,
    required this.dot,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      selected: selected,
      button: true,
      child: Material(
        color: selected ? AppColors.subtle(context) : Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 60),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              child: Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(color: dot, shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                        Text(hint, style: Theme.of(context).textTheme.bodySmall),
                      ],
                    ),
                  ),
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: selected ? AppColors.raspberry : Colors.transparent,
                      border: selected
                          ? null
                          : Border.all(color: AppColors.divider(context), width: 2),
                    ),
                    child: selected
                        ? const Icon(Icons.check_rounded, size: 16, color: Colors.white)
                        : null,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
