import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/database/app_database.dart';
import '../home/home_provider.dart';

final searchQueryProvider = StateProvider<String>((ref) => '');

final searchResultsProvider = StreamProvider<List<Rating>>((ref) {
  final query = ref.watch(searchQueryProvider);
  if (query.isEmpty) {
    return ref.watch(ratingsDaoProvider).watchAll();
  }
  return ref.watch(ratingsDaoProvider).watchSearch(query);
});

final statisticsProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final dao = ref.watch(ratingsDaoProvider);
  final ratings = await dao.getAll();
  final tagStats = await dao.tagStatistics();
  final avgScore = await dao.averageScore();

  return {
    'totalCount': ratings.length,
    'averageScore': avgScore,
    'tagStats': tagStats,
  };
});
