import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quick_actions/quick_actions.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/rating_level.dart';
import '../../core/utils/image_store.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/round_icon_button.dart';
import '../add_rating/quick_add_sheet.dart';
import 'home_provider.dart';
import 'widgets/level_filter.dart';
import 'widgets/rating_card.dart';
import 'widgets/sort_sheet.dart';
import '../../shared/widgets/empty_state.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _initQuickActions());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _initQuickActions() {
    const actions = QuickActions();
    actions.initialize((shortcutType) {
      if (!mounted) return;
      if (shortcutType == 'scan') {
        context.push('/scanner').then((result) {
          if (result != null && result is String && mounted) {
            handleBarcode(context, result);
          }
        });
      } else if (shortcutType == 'manual') {
        context.push('/add');
      }
    });
    actions.setShortcutItems(const [
      ShortcutItem(
        type: 'scan',
        localizedTitle: 'Scan Barcode',
        icon: 'ic_scanner',
      ),
      ShortcutItem(
        type: 'manual',
        localizedTitle: 'Manual Entry',
        icon: 'ic_edit',
      ),
    ]);
  }

  void _toggleSearch() {
    final expanded = ref.read(searchExpandedProvider);
    if (expanded) {
      _searchController.clear();
      ref.read(searchQueryProvider.notifier).state = '';
    }
    ref.read(searchExpandedProvider.notifier).state = !expanded;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final query = ref.watch(searchQueryProvider);
    final searchExpanded = ref.watch(searchExpandedProvider);
    final levelFilter = ref.watch(levelFilterProvider);
    final allRatings = ref.watch(ratingsProvider).valueOrNull ?? const [];
    final ratingsAsync = ref.watch(filteredRatingsProvider);
    final loved = allRatings
        .where((r) => RatingLevel.fromScore(r.score) == RatingLevel.liebe)
        .length;

    return Scaffold(
      floatingActionButton: allRatings.isEmpty
          ? null
          : FloatingActionButton.extended(
              onPressed: () => showQuickAddSheet(context),
              icon: const Icon(Icons.add_rounded, size: 24),
              label: Text(l10n.rateAction),
            ),
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              sliver: SliverToBoxAdapter(
                child: Row(
                  children: [
                    Text(
                      l10n.homeTitle,
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.favorite_rounded,
                      color: AppColors.heart,
                      size: 28,
                    ),
                    const Spacer(),
                    RoundIconButton(
                      icon: searchExpanded
                          ? Icons.close_rounded
                          : Icons.search_rounded,
                      tooltip: searchExpanded ? l10n.close : l10n.search,
                      onPressed: _toggleSearch,
                    ),
                    const SizedBox(width: 8),
                    RoundIconButton(
                      icon: Icons.sort_rounded,
                      tooltip: l10n.sort,
                      onPressed: () => showSortSheet(context, ref),
                    ),
                    const SizedBox(width: 8),
                    RoundIconButton(
                      icon: Icons.tune_rounded,
                      tooltip: l10n.settingsTitle,
                      onPressed: () => context.push('/settings'),
                    ),
                  ],
                ),
              ),
            ),
            if (allRatings.isNotEmpty)
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                sliver: SliverToBoxAdapter(
                  child: Text(
                    loved > 0
                        ? l10n.homeSummary(allRatings.length, loved)
                        : l10n.homeSummaryShort(allRatings.length),
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.muted(context),
                    ),
                  ),
                ),
              ),
            if (searchExpanded)
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                sliver: SliverToBoxAdapter(
                  child: TextField(
                    controller: _searchController,
                    autofocus: true,
                    textInputAction: TextInputAction.search,
                    decoration: InputDecoration(
                      hintText: l10n.searchHint,
                      prefixIcon: const Icon(Icons.search_rounded),
                    ),
                    onChanged: (v) =>
                        ref.read(searchQueryProvider.notifier).state = v,
                  ),
                ),
              ),
            if (allRatings.isNotEmpty)
              const SliverPadding(
                padding: EdgeInsets.fromLTRB(20, 18, 20, 0),
                sliver: SliverToBoxAdapter(child: LevelFilter()),
              ),
            ...ratingsAsync.when(
              data: (ratings) {
                if (ratings.isEmpty) {
                  final filtering = query.isNotEmpty || levelFilter != null;
                  return [
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: EmptyState(
                        icon: query.isNotEmpty
                            ? Icons.search_off_rounded
                            : Icons.favorite_border_rounded,
                        title: query.isNotEmpty
                            ? l10n.noResults
                            : levelFilter != null
                            ? l10n.nothingInLevel
                            : l10n.noRatingsYet,
                        subtitle: query.isNotEmpty
                            ? l10n.tryDifferentSearch
                            : levelFilter != null
                            ? l10n.nothingInLevelSubtitle
                            : l10n.onboardingSubtitle,
                        action: filtering
                            ? null
                            : FilledButton.icon(
                                style: FilledButton.styleFrom(
                                  backgroundColor: AppColors.raspberry,
                                  foregroundColor: Colors.white,
                                  minimumSize: const Size(0, 56),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 28,
                                  ),
                                ),
                                icon: const Icon(Icons.add_rounded),
                                label: Text(l10n.getStarted),
                                onPressed: () => showQuickAddSheet(context),
                              ),
                      ),
                    ),
                  ];
                }
                return [
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 18, 20, 112),
                    sliver: SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 18,
                            crossAxisSpacing: 12,
                            mainAxisExtent: 262,
                          ),
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final rating = ratings[index];
                        return RatingCard(
                          rating: rating,
                          onDelete: () {
                            ImageStore.delete(rating.localImagePath);
                            ref
                                .read(ratingsDaoProvider)
                                .deleteRating(rating.id);
                          },
                        );
                      }, childCount: ratings.length),
                    ),
                  ),
                ];
              },
              loading: () => [
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(child: CircularProgressIndicator()),
                ),
              ],
              error: (error, _) => [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Text(l10n.errorPrefix(error.toString())),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
