import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../l10n/app_localizations.dart';
import 'home_provider.dart';
import 'widgets/rating_card.dart';
import 'widgets/filter_chips.dart';
import '../../shared/widgets/empty_state.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final ratingsAsync = ref.watch(filteredRatingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.homeTitle),
        actions: [
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
                    subtitle: l10n.tapToRate,
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
