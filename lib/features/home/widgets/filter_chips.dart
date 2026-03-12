import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/utils/tag_l10n.dart';
import '../../../l10n/app_localizations.dart';
import '../home_provider.dart';
import '../../../core/theme/app_colors.dart';

class FilterChips extends ConsumerWidget {
  const FilterChips({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tagsAsync = ref.watch(allTagsProvider);
    final selectedTag = ref.watch(selectedTagFilterProvider);
    final minStars = ref.watch(minStarFilterProvider);

    return tagsAsync.when(
      data: (tags) {
        if (tags.isEmpty) return const SizedBox.shrink();
        return SizedBox(
          height: 48,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              // Star filter chip
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.star,
                        size: 16,
                        color: minStars > 0
                            ? Colors.white
                            : AppColors.accent,
                      ),
                      const SizedBox(width: 4),
                      Text(minStars > 0 ? '${minStars.toInt()}+' : AppLocalizations.of(context)!.stars),
                    ],
                  ),
                  selected: minStars > 0,
                  selectedColor: AppColors.accent,
                  onSelected: (_) {
                    final current = ref.read(minStarFilterProvider);
                    final next = current >= 4 ? 0.0 : current + 1;
                    ref.read(minStarFilterProvider.notifier).state = next;
                  },
                ),
              ),
              // Tag filter chips
              ...tags.map((tag) {
                final isSelected = selectedTag == tag;
                final color = AppColors.tagColor(tag);
                final l10n = AppLocalizations.of(context)!;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(localizedTagName(tag, l10n)),
                    selected: isSelected,
                    selectedColor: color.withAlpha(180),
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : null,
                    ),
                    onSelected: (selected) {
                      ref.read(selectedTagFilterProvider.notifier).state =
                          selected ? tag : null;
                    },
                  ),
                );
              }),
            ],
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
    );
  }
}
