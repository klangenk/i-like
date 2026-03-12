import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/database/app_database.dart';
import '../../core/database/ratings_dao.dart';

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

// Selected tag filter
final selectedTagFilterProvider = StateProvider<String?>((ref) => null);

// Minimum star filter
final minStarFilterProvider = StateProvider<double>((ref) => 0);

// Filtered ratings
final filteredRatingsProvider = Provider<AsyncValue<List<Rating>>>((ref) {
  final ratingsAsync = ref.watch(ratingsProvider);
  final selectedTag = ref.watch(selectedTagFilterProvider);
  final minStars = ref.watch(minStarFilterProvider);

  return ratingsAsync.whenData((ratings) {
    var filtered = ratings;

    if (selectedTag != null) {
      filtered = filtered.where((r) {
        final tags = r.tags.split(',').map((t) => t.trim()).toList();
        return tags.contains(selectedTag);
      }).toList();
    }

    if (minStars > 0) {
      filtered = filtered.where((r) => r.score >= minStars).toList();
    }

    return filtered;
  });
});

// All unique tags from ratings
final allTagsProvider = Provider<AsyncValue<List<String>>>((ref) {
  final ratingsAsync = ref.watch(ratingsProvider);
  return ratingsAsync.whenData((ratings) {
    final tags = <String>{};
    for (final rating in ratings) {
      if (rating.tags.isNotEmpty) {
        tags.addAll(
          rating.tags.split(',').map((t) => t.trim()).where((t) => t.isNotEmpty),
        );
      }
    }
    return tags.toList()..sort();
  });
});
