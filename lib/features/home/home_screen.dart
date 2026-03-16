import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../l10n/app_localizations.dart';
import '../add_rating/quick_add_sheet.dart';
import 'home_provider.dart';
import 'widgets/rating_card.dart';
import 'widgets/filter_chips.dart';
import '../../shared/widgets/empty_state.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  void _showSortMenu(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final current = ref.read(sortOptionProvider);

    final options = [
      (SortOption.newest, l10n.sortNewest, Icons.arrow_downward),
      (SortOption.oldest, l10n.sortOldest, Icons.arrow_upward),
      (SortOption.highest, l10n.sortHighest, Icons.star),
      (SortOption.lowest, l10n.sortLowest, Icons.star_border),
      (SortOption.az, l10n.sortAZ, Icons.sort_by_alpha),
      (SortOption.za, l10n.sortZA, Icons.sort_by_alpha),
    ];

    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: options.map((o) {
            final (option, label, icon) = o;
            return ListTile(
              leading: Icon(icon),
              title: Text(label),
              trailing: current == option ? const Icon(Icons.check) : null,
              onTap: () {
                ref.read(sortOptionProvider.notifier).state = option;
                Navigator.pop(ctx);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final ratingsAsync = ref.watch(filteredRatingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.homeTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: () => _showSortMenu(context, ref),
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: Column(
        children: [
          const FilterChips(),
          Expanded(
            child: ratingsAsync.when(
              data: (ratings) {
                if (ratings.isEmpty) {
                  return EmptyState(
                    title: l10n.noRatingsYet,
                    subtitle: l10n.onboardingSubtitle,
                    action: FilledButton.icon(
                      icon: const Icon(Icons.add),
                      label: Text(l10n.getStarted),
                      onPressed: () => showQuickAddSheet(context),
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.only(top: 8, bottom: 80),
                  itemCount: ratings.length,
                  itemBuilder: (context, index) {
                    final rating = ratings[index];
                    return RatingCard(
                      rating: rating,
                      onDismissed: () {
                        ref.read(ratingsDaoProvider).deleteRating(rating.id);
                      },
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(child: Text(l10n.errorPrefix(error.toString()))),
            ),
          ),
        ],
      ),
    );
  }
}
