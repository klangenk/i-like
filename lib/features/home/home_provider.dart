import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/database/app_database.dart';
import '../../core/database/ratings_dao.dart';
import '../../core/theme/rating_level.dart';
import '../settings/settings_provider.dart';

enum SortOption { newest, oldest, highest, lowest, az, za }

// Database provider - initialized in main.dart
final databaseProvider = Provider<AppDatabase>((ref) {
  throw UnimplementedError('Database must be overridden in ProviderScope');
});

// DAO provider
final ratingsDaoProvider = Provider<RatingsDao>((ref) {
  return RatingsDao(ref.watch(databaseProvider));
});

// All ratings stream
final ratingsProvider = StreamProvider<List<Rating>>((ref) {
  return ref.watch(ratingsDaoProvider).watchAll();
});

// Search query
final searchQueryProvider = StateProvider<String>((ref) => '');

// Whether the search field is expanded
final searchExpandedProvider = StateProvider<bool>((ref) => false);

// Selected tag filter
/// A [StateController] that saves every change, so view settings survive
/// restarts. Used like a StateProvider: `ref.read(p.notifier).state = x`.
class PersistedController<T> extends StateController<T> {
  final void Function(T value) _save;

  PersistedController(super.initial, this._save);

  @override
  set state(T value) {
    super.state = value;
    _save(value);
  }
}

// Category filter, remembered across restarts like sort order and grouping
final selectedTagFilterProvider = StateNotifierProvider<PersistedController<String?>, String?>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return PersistedController(
    prefs.getString(_tagFilterKey),
    (tag) => tag == null ? prefs.remove(_tagFilterKey) : prefs.setString(_tagFilterKey, tag),
  );
});

const _tagFilterKey = 'view_tag_filter';
const _sortKey = 'view_sort';
const _groupKey = 'view_group_by_tag';

// Only the "to try" list: saved things without a level yet
final toTryOnlyProvider = StateProvider<bool>((ref) => false);

/// Saved to try later, not rated yet.
bool isToTry(Rating r) => RatingLevel.fromScore(r.score) == null;

// Word-level filter (null = all levels)
final levelFilterProvider = StateProvider<RatingLevel?>((ref) => null);

// The one-time tip that links can be shared into the app
const _shareTipKey = 'share_tip_dismissed';

final shareTipDismissedProvider = StateProvider<bool>((ref) {
  return ref.watch(sharedPreferencesProvider).getBool(_shareTipKey) ?? false;
});

void dismissShareTip(WidgetRef ref) {
  ref.read(sharedPreferencesProvider).setBool(_shareTipKey, true);
  ref.read(shareTipDismissedProvider.notifier).state = true;
}

// Sort option
final sortOptionProvider = StateNotifierProvider<PersistedController<SortOption>, SortOption>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  final saved = prefs.getString(_sortKey);
  return PersistedController(
    SortOption.values.firstWhere((o) => o.name == saved, orElse: () => SortOption.newest),
    (sort) => prefs.setString(_sortKey, sort.name),
  );
});

// Show the list in one section per category
final groupByTagProvider = StateNotifierProvider<PersistedController<bool>, bool>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return PersistedController(
    prefs.getBool(_groupKey) ?? false,
    (grouped) => prefs.setBool(_groupKey, grouped),
  );
});

/// Splits already sorted ratings into one section per category; a rating
/// with several categories appears in each of them, like in the filter.
/// `url` only says where a rating came from, so it never forms a section of
/// its own; ratings without a category end up in a last section (tag null).
/// Biggest sections come first, the order inside a section is kept.
List<({String? tag, List<Rating> ratings})> groupByTag(List<Rating> ratings) {
  final groups = <String?, List<Rating>>{};
  for (final r in ratings) {
    final tags = r.tags
        .split(',')
        .map((t) => t.trim())
        .where((t) => t.isNotEmpty && t != 'url')
        .toSet();
    for (final tag in tags.isEmpty ? <String?>{null} : tags) {
      groups.putIfAbsent(tag, () => []).add(r);
    }
  }
  final sections =
      [
        for (final e in groups.entries)
          if (e.key != null) (tag: e.key, ratings: e.value),
      ]..sort((a, b) {
        final bySize = b.ratings.length.compareTo(a.ratings.length);
        return bySize != 0 ? bySize : a.tag!.toLowerCase().compareTo(b.tag!.toLowerCase());
      });
  final untagged = groups[null];
  if (untagged != null) sections.add((tag: null, ratings: untagged));
  return sections;
}

// Filtered and sorted ratings
final filteredRatingsProvider = Provider<AsyncValue<List<Rating>>>((ref) {
  final ratingsAsync = ref.watch(ratingsProvider);
  final query = ref.watch(searchQueryProvider).trim().toLowerCase();
  final selectedTag = ref.watch(selectedTagFilterProvider);
  final level = ref.watch(levelFilterProvider);
  final toTryOnly = ref.watch(toTryOnlyProvider);
  final sort = ref.watch(sortOptionProvider);

  return ratingsAsync.whenData((ratings) {
    var filtered = ratings.toList();

    if (query.isNotEmpty) {
      filtered = filtered
          .where(
            (r) =>
                r.title.toLowerCase().contains(query) ||
                r.creator.toLowerCase().contains(query) ||
                r.tags.toLowerCase().contains(query) ||
                r.notes.toLowerCase().contains(query),
          )
          .toList();
    }

    if (selectedTag != null) {
      filtered = filtered.where((r) {
        final tags = r.tags.split(',').map((t) => t.trim()).toList();
        return tags.contains(selectedTag);
      }).toList();
    }

    // Once the last thing to try is rated, its chip is gone: show everything
    if (toTryOnly && ratings.any(isToTry)) filtered = filtered.where(isToTry).toList();

    // Things to try have no level yet, so a level filter would hide them all
    if (level != null && !(toTryOnly && ratings.any(isToTry))) {
      filtered = filtered.where((r) => RatingLevel.fromScore(r.score) == level).toList();
    }

    switch (sort) {
      case SortOption.newest:
        filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      case SortOption.oldest:
        filtered.sort((a, b) => a.createdAt.compareTo(b.createdAt));
      // Things still to try have no level: last in both directions
      case SortOption.highest:
        filtered.sort((a, b) => _toTryLast(a, b) ?? b.score.compareTo(a.score));
      case SortOption.lowest:
        filtered.sort((a, b) => _toTryLast(a, b) ?? a.score.compareTo(b.score));
      case SortOption.az:
        filtered.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
      case SortOption.za:
        filtered.sort((a, b) => b.title.toLowerCase().compareTo(a.title.toLowerCase()));
    }

    return filtered;
  });
});

// How many ratings use each tag
final tagUsageProvider = Provider<Map<String, int>>((ref) {
  final ratings = ref.watch(ratingsProvider).valueOrNull ?? const <Rating>[];
  final counts = <String, int>{};
  for (final rating in ratings) {
    for (final tag in rating.tags.split(',').map((t) => t.trim()).where((t) => t.isNotEmpty)) {
      counts[tag] = (counts[tag] ?? 0) + 1;
    }
  }
  return counts;
});

int? _toTryLast(Rating a, Rating b) {
  if (isToTry(a) == isToTry(b)) return null;
  return isToTry(a) ? 1 : -1;
}

// All unique tags from ratings
final allTagsProvider = Provider<AsyncValue<List<String>>>((ref) {
  final ratingsAsync = ref.watch(ratingsProvider);
  return ratingsAsync.whenData((ratings) {
    final tags = <String>{};
    for (final rating in ratings) {
      if (rating.tags.isNotEmpty) {
        tags.addAll(rating.tags.split(',').map((t) => t.trim()).where((t) => t.isNotEmpty));
      }
    }
    return tags.toList()..sort();
  });
});
