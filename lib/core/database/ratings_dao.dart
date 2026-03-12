import 'package:drift/drift.dart';
import 'app_database.dart';

class RatingsDao {
  final AppDatabase db;

  RatingsDao(this.db);

  Future<List<Rating>> getAll() => (db.select(db.ratings)
        ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
      .get();

  Stream<List<Rating>> watchAll() => (db.select(db.ratings)
        ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
      .watch();

  Future<Rating> getById(int id) =>
      (db.select(db.ratings)..where((t) => t.id.equals(id))).getSingle();

  Stream<Rating> watchById(int id) =>
      (db.select(db.ratings)..where((t) => t.id.equals(id))).watchSingle();

  Future<int> insertRating(RatingsCompanion entry) =>
      db.into(db.ratings).insert(entry);

  Future<bool> updateRating(Rating entry) =>
      db.update(db.ratings).replace(entry);

  Future<int> deleteRating(int id) =>
      (db.delete(db.ratings)..where((t) => t.id.equals(id))).go();

  Future<List<Rating>> search(String query) {
    final pattern = '%$query%';
    return (db.select(db.ratings)
          ..where((t) =>
              t.title.like(pattern) |
              t.tags.like(pattern) |
              t.notes.like(pattern))
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .get();
  }

  Stream<List<Rating>> watchSearch(String query) {
    final pattern = '%$query%';
    return (db.select(db.ratings)
          ..where((t) =>
              t.title.like(pattern) |
              t.tags.like(pattern) |
              t.notes.like(pattern))
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .watch();
  }

  Future<List<String>> getAllTags() async {
    final ratings = await getAll();
    final tags = <String>{};
    for (final rating in ratings) {
      if (rating.tags.isNotEmpty) {
        tags.addAll(rating.tags.split(',').map((t) => t.trim()).where((t) => t.isNotEmpty));
      }
    }
    return tags.toList()..sort();
  }

  Future<Map<String, int>> tagStatistics() async {
    final ratings = await getAll();
    final stats = <String, int>{};
    for (final rating in ratings) {
      if (rating.tags.isNotEmpty) {
        for (final tag in rating.tags.split(',').map((t) => t.trim()).where((t) => t.isNotEmpty)) {
          stats[tag] = (stats[tag] ?? 0) + 1;
        }
      }
    }
    return stats;
  }

  Future<double> averageScore() async {
    final ratings = await getAll();
    if (ratings.isEmpty) return 0;
    final total = ratings.fold<double>(0, (sum, r) => sum + r.score);
    return total / ratings.length;
  }
}
