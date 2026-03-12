import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/star_display.dart';
import '../../shared/widgets/tag_badge.dart';
import '../../shared/widgets/empty_state.dart';
import '../home/widgets/rating_card.dart';
import '../home/home_provider.dart';
import 'search_provider.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final query = ref.watch(searchQueryProvider);
    final resultsAsync = ref.watch(searchResultsProvider);
    final statsAsync = ref.watch(statisticsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.searchTitle),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: l10n.searchHint,
                prefixIcon: const Icon(Icons.search),
                suffixIcon: query.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          ref.read(searchQueryProvider.notifier).state = '';
                        },
                      )
                    : null,
              ),
              onChanged: (value) {
                ref.read(searchQueryProvider.notifier).state = value;
              },
            ),
          ),

          if (query.isEmpty)
            statsAsync.when(
              data: (stats) {
                final totalCount = stats['totalCount'] as int;
                if (totalCount == 0) return const SizedBox.shrink();
                final avgScore = stats['averageScore'] as double;
                final tagStats = stats['tagStats'] as Map<String, int>;

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.statistics,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              _StatItem(
                                label: l10n.totalRatings,
                                value: '$totalCount',
                              ),
                              const SizedBox(width: 24),
                              _StatItem(
                                label: l10n.averageScore,
                                value: avgScore.toStringAsFixed(1),
                                trailing: StarDisplay(
                                  score: avgScore,
                                  size: 14,
                                ),
                              ),
                            ],
                          ),
                          if (tagStats.isNotEmpty) ...[
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 6,
                              runSpacing: 6,
                              children: tagStats.entries.map((e) {
                                return TagBadge(tag: '${e.key} (${e.value})');
                              }).toList(),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                );
              },
              loading: () => const SizedBox.shrink(),
              error: (_, _) => const SizedBox.shrink(),
            ),

          const SizedBox(height: 8),

          Expanded(
            child: resultsAsync.when(
              data: (ratings) {
                if (ratings.isEmpty) {
                  return EmptyState(
                    icon: Icons.search_off,
                    title: query.isEmpty ? l10n.noRatingsYet : l10n.noResults,
                    subtitle: query.isEmpty ? l10n.tapToRate : l10n.tryDifferentSearch,
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.only(bottom: 80),
                  itemCount: ratings.length,
                  itemBuilder: (context, index) {
                    return RatingCard(
                      rating: ratings[index],
                      onDismissed: () {
                        ref
                            .read(ratingsDaoProvider)
                            .deleteRating(ratings[index].id);
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

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final Widget? trailing;

  const _StatItem({
    required this.label,
    required this.value,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 2),
        Row(
          children: [
            Text(
              value,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            if (trailing != null) ...[
              const SizedBox(width: 4),
              trailing!,
            ],
          ],
        ),
      ],
    );
  }
}
