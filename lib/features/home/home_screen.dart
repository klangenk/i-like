import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quick_actions/quick_actions.dart';
import '../../core/database/app_database.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/rating_level.dart';
import '../../core/utils/image_store.dart';
import '../../core/utils/tag_l10n.dart';
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
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _initQuickActions());
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
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
      ShortcutItem(type: 'scan', localizedTitle: 'Scan Barcode', icon: 'ic_scanner'),
      ShortcutItem(type: 'manual', localizedTitle: 'Manual Entry', icon: 'ic_edit'),
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

  void _showCategory(String tag) {
    ref.read(selectedTagFilterProvider.notifier).state = tag;
    if (_scrollController.hasClients) _scrollController.jumpTo(0);
  }

  Widget _grid(List<Rating> ratings, EdgeInsets padding) {
    return SliverPadding(
      padding: padding,
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
              ref.read(ratingsDaoProvider).deleteRating(rating.id);
            },
          );
        }, childCount: ratings.length),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final query = ref.watch(searchQueryProvider);
    final searchExpanded = ref.watch(searchExpandedProvider);
    final levelFilter = ref.watch(levelFilterProvider);
    final tagFilter = ref.watch(selectedTagFilterProvider);
    final narrowed = levelFilter != null || tagFilter != null;
    final allRatings = ref.watch(ratingsProvider).valueOrNull ?? const [];
    final ratingsAsync = ref.watch(filteredRatingsProvider);
    final grouped = ref.watch(groupByTagProvider);
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
          controller: _scrollController,
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              sliver: SliverToBoxAdapter(
                child: Row(
                  children: [
                    Text(l10n.homeTitle, style: Theme.of(context).textTheme.headlineLarge),
                    const SizedBox(width: 8),
                    const Icon(Icons.favorite_rounded, color: AppColors.heart, size: 28),
                    const Spacer(),
                    RoundIconButton(
                      icon: searchExpanded ? Icons.close_rounded : Icons.search_rounded,
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
                    style: TextStyle(fontSize: 16, color: AppColors.muted(context)),
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
                    onChanged: (v) => ref.read(searchQueryProvider.notifier).state = v,
                  ),
                ),
              ),
            if (allRatings.isNotEmpty)
              const SliverPadding(
                padding: EdgeInsets.fromLTRB(20, 18, 20, 0),
                sliver: SliverToBoxAdapter(child: LevelFilter()),
              ),
            if (allRatings.isNotEmpty && tagFilter != null)
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                sliver: SliverToBoxAdapter(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: InputChip(
                      label: Text(localizedTagName(tagFilter, l10n)),
                      selected: true,
                      showCheckmark: false,
                      onPressed: () => showSortSheet(context, ref),
                      onDeleted: () => ref.read(selectedTagFilterProvider.notifier).state = null,
                      deleteButtonTooltipMessage: l10n.close,
                    ),
                  ),
                ),
              ),
            ...ratingsAsync.when(
              data: (ratings) {
                if (ratings.isEmpty) {
                  final filtering = query.isNotEmpty || narrowed;
                  return [
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: EmptyState(
                        icon: query.isNotEmpty
                            ? Icons.search_off_rounded
                            : Icons.favorite_border_rounded,
                        title: query.isNotEmpty
                            ? l10n.noResults
                            : narrowed
                            ? l10n.nothingInLevel
                            : l10n.noRatingsYet,
                        subtitle: query.isNotEmpty
                            ? l10n.tryDifferentSearch
                            : narrowed
                            ? l10n.nothingInLevelSubtitle
                            : l10n.onboardingSubtitle,
                        action: filtering
                            ? null
                            : FilledButton.icon(
                                style: FilledButton.styleFrom(
                                  backgroundColor: AppColors.raspberry,
                                  foregroundColor: Colors.white,
                                  minimumSize: const Size(0, 56),
                                  padding: const EdgeInsets.symmetric(horizontal: 28),
                                ),
                                icon: const Icon(Icons.add_rounded),
                                label: Text(l10n.getStarted),
                                onPressed: () => showQuickAddSheet(context),
                              ),
                      ),
                    ),
                  ];
                }
                // A filtered list is one category already; sections would only
                // repeat the other categories of the same items.
                if (!grouped || tagFilter != null) {
                  return [_grid(ratings, const EdgeInsets.fromLTRB(20, 18, 20, 112))];
                }
                final sections = groupByTag(ratings);
                return [
                  for (final (i, section) in sections.indexed) ...[
                    SliverPadding(
                      padding: EdgeInsets.fromLTRB(20, i == 0 ? 22 : 30, 20, 0),
                      sliver: SliverToBoxAdapter(
                        child: _SectionHeader(
                          title: section.tag == null
                              ? l10n.noCategory
                              : localizedTagName(section.tag!, l10n),
                          count: section.ratings.length,
                          onTap: section.tag == null ? null : () => _showCategory(section.tag!),
                        ),
                      ),
                    ),
                    _grid(
                      section.ratings,
                      EdgeInsets.fromLTRB(20, 14, 20, i == sections.length - 1 ? 112 : 0),
                    ),
                  ],
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
                  child: Center(child: Text(l10n.errorPrefix(error.toString()))),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Category name with its count, above each section of the grouped list.
class _SectionHeader extends StatelessWidget {
  final String title;
  final int count;
  final VoidCallback? onTap;

  const _SectionHeader({required this.title, required this.count, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      header: true,
      button: onTap != null,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Flexible(child: Text(title, style: Theme.of(context).textTheme.headlineSmall)),
                    const SizedBox(width: 8),
                    Text(
                      '$count',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.muted(context),
                      ),
                    ),
                  ],
                ),
              ),
              if (onTap != null)
                Icon(Icons.chevron_right_rounded, color: AppColors.muted(context)),
            ],
          ),
        ),
      ),
    );
  }
}
