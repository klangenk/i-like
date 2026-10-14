import 'package:drift/drift.dart';
import 'app_database.dart';

/// A list with how many of its entries are still open (not ticked off).
class ListSummary {
  final RatingList list;
  final int open;
  final int total;

  const ListSummary(this.list, {required this.open, required this.total});
}

/// A list entry with its linked rating, if it has one that still exists.
class ListItem {
  final ListEntry entry;
  final Rating? rating;

  const ListItem(this.entry, this.rating);
}

class ListsDao {
  final AppDatabase db;

  ListsDao(this.db);

  /// All lists, oldest first, with their entry counts.
  Stream<List<ListSummary>> watchLists() {
    final e = db.listEntries;
    final open = e.id.count(filter: e.checked.equals(false));
    final total = e.id.count();
    final query = db.select(db.ratingLists).join([
      leftOuterJoin(e, e.listId.equalsExp(db.ratingLists.id)),
    ])
      ..addColumns([open, total])
      ..groupBy([db.ratingLists.id])
      ..orderBy([OrderingTerm.asc(db.ratingLists.createdAt), OrderingTerm.asc(db.ratingLists.id)]);
    return query.watch().map((rows) => [
          for (final row in rows)
            ListSummary(
              row.readTable(db.ratingLists),
              open: row.read(open) ?? 0,
              total: row.read(total) ?? 0,
            ),
        ]);
  }

  /// Emits null once the list is deleted.
  Stream<RatingList?> watchList(int id) =>
      (db.select(db.ratingLists)..where((t) => t.id.equals(id))).watchSingleOrNull();

  /// Open entries first, then ticked-off ones, each in list order.
  Stream<List<ListItem>> watchItems(int listId) {
    final e = db.listEntries;
    final query = db.select(e).join([
      leftOuterJoin(db.ratings, db.ratings.id.equalsExp(e.ratingId)),
    ])
      ..where(e.listId.equals(listId))
      ..orderBy([OrderingTerm.asc(e.checked), OrderingTerm.asc(e.position), OrderingTerm.asc(e.id)]);
    return query.watch().map((rows) => [
          for (final row in rows) ListItem(row.readTable(e), row.readTableOrNull(db.ratings)),
        ]);
  }

  Future<int> createList(String name, {bool checkable = true}) => db
      .into(db.ratingLists)
      .insert(RatingListsCompanion.insert(name: name.trim(), checkable: Value(checkable)));

  Future<void> renameList(int id, String name) =>
      (db.update(db.ratingLists)..where((t) => t.id.equals(id)))
          .write(RatingListsCompanion(name: Value(name.trim())));

  Future<void> setCheckable(int id, bool checkable) =>
      (db.update(db.ratingLists)..where((t) => t.id.equals(id)))
          .write(RatingListsCompanion(checkable: Value(checkable)));

  /// Deletes the list; its entries go with it (foreign key cascade).
  Future<void> deleteList(int id) =>
      (db.delete(db.ratingLists)..where((t) => t.id.equals(id))).go();

  Future<int> addText(int listId, String label) async {
    return db.transaction(() async {
      return db.into(db.listEntries).insert(ListEntriesCompanion.insert(
            listId: listId,
            label: label.trim(),
            position: Value(await _nextPosition(listId)),
          ));
    });
  }

  /// Adds [rating] to the list. If it is already on it, the existing entry is
  /// opened again instead of adding a duplicate. Returns false in that case.
  Future<bool> addRating(int listId, Rating rating) async {
    return db.transaction(() async {
      final existing = await (db.select(db.listEntries)
            ..where((t) => t.listId.equals(listId) & t.ratingId.equals(rating.id)))
          .get();
      if (existing.isNotEmpty) {
        await setChecked(existing.first.id, false);
        return false;
      }
      await db.into(db.listEntries).insert(ListEntriesCompanion.insert(
            listId: listId,
            ratingId: Value(rating.id),
            label: rating.title,
            position: Value(await _nextPosition(listId)),
          ));
      return true;
    });
  }

  /// Takes [ratingId] off the list.
  Future<void> removeRating(int listId, int ratingId) => (db.delete(db.listEntries)
        ..where((t) => t.listId.equals(listId) & t.ratingId.equals(ratingId)))
      .go();

  /// Ids of the lists [ratingId] is on.
  Stream<Set<int>> watchListIdsFor(int ratingId) {
    final query = db.selectOnly(db.listEntries, distinct: true)
      ..addColumns([db.listEntries.listId])
      ..where(db.listEntries.ratingId.equals(ratingId));
    return query.watch().map((rows) => {for (final row in rows) row.read(db.listEntries.listId)!});
  }

  Future<void> setChecked(int entryId, bool checked) =>
      (db.update(db.listEntries)..where((t) => t.id.equals(entryId)))
          .write(ListEntriesCompanion(checked: Value(checked)));

  Future<void> deleteEntry(int entryId) =>
      (db.delete(db.listEntries)..where((t) => t.id.equals(entryId))).go();

  /// Puts a deleted entry back as it was (for undo).
  Future<void> restoreEntry(ListEntry entry) => db.into(db.listEntries).insert(entry);

  /// Removes every ticked-off entry from the list.
  Future<int> clearChecked(int listId) =>
      (db.delete(db.listEntries)
            ..where((t) => t.listId.equals(listId) & t.checked.equals(true)))
          .go();

  Future<int> _nextPosition(int listId) async {
    final max = db.listEntries.position.max();
    final row = await (db.selectOnly(db.listEntries)
          ..addColumns([max])
          ..where(db.listEntries.listId.equals(listId)))
        .getSingle();
    return (row.read(max) ?? -1) + 1;
  }
}
