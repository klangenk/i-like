import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/database/app_database.dart';
import '../../core/database/lists_dao.dart';
import '../home/home_provider.dart';

final listsDaoProvider = Provider<ListsDao>((ref) {
  return ListsDao(ref.watch(databaseProvider));
});

// All lists with their counts
final listsProvider = StreamProvider<List<ListSummary>>((ref) {
  return ref.watch(listsDaoProvider).watchLists();
});

final listProvider = StreamProvider.family<RatingList?, int>((ref, id) {
  return ref.watch(listsDaoProvider).watchList(id);
});

final listItemsProvider = StreamProvider.family<List<ListItem>, int>((ref, id) {
  return ref.watch(listsDaoProvider).watchItems(id);
});

// Lists a rating is on
final listIdsForRatingProvider = StreamProvider.family<Set<int>, int>((
  ref,
  ratingId,
) {
  return ref.watch(listsDaoProvider).watchListIdsFor(ratingId);
});

/// The list as plain text for sharing: open entries first, ticked-off ones
/// marked with ✓ on a checkable list.
String listAsText(RatingList list, List<ListItem> items) {
  final lines = [
    for (final item in items)
      list.checkable
          ? '${item.entry.checked ? '✓' : '•'} ${item.entry.label}'
          : '• ${item.entry.label}',
  ];
  return '${list.name}\n\n${lines.join('\n')}';
}
