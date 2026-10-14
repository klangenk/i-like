import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'app_database.g.dart';

/// SQLite table for all user ratings.
///
/// Column naming: Dart uses camelCase getters; the underlying SQLite columns
/// use snake_case (see [named] calls below).
class Ratings extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 1, max: 500)();
  RealColumn get score => real()();
  /// Comma-separated tag list, e.g. `"movie, sci-fi"`. Empty string = no tags.
  TextColumn get tags => text().withDefault(const Constant(''))();
  TextColumn get notes => text().withDefault(const Constant(''))();
  TextColumn get imageUrl =>
      text().named('image_url').withDefault(const Constant(''))();
  TextColumn get sourceUrl =>
      text().named('source_url').withDefault(const Constant(''))();
  TextColumn get barcode => text().withDefault(const Constant(''))();
  /// Path to the locally downloaded copy of [imageUrl]. Empty if not yet
  /// downloaded or if the download failed. Display code should prefer this
  /// over [imageUrl] so the image remains available even after the remote URL
  /// goes stale.
  TextColumn get localImagePath =>
      text().named('local_image_path').withDefault(const Constant(''))();
  /// Author, manufacturer, brand or designer – whoever made the item.
  TextColumn get creator => text().withDefault(const Constant(''))();
  /// Release or publication year as entered/fetched, e.g. "1995". Empty if unknown.
  TextColumn get year => text().withDefault(const Constant(''))();
  DateTimeColumn get createdAt =>
      dateTime().named('created_at').withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt =>
      dateTime().named('updated_at').withDefault(currentDateAndTime)();
}

/// User-made lists such as a shopping list or gift ideas. Lists say what the
/// user wants to do with things; tags on [Ratings] say what they are.
@DataClassName('RatingList')
class RatingLists extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  /// Whether entries are ticked off (shopping) or just collected (gift ideas).
  BoolColumn get checkable => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt =>
      dateTime().named('created_at').withDefault(currentDateAndTime)();
}

/// One line on a [RatingLists] list: free text, or a link to a rating.
class ListEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get listId => integer()
      .named('list_id')
      .references(RatingLists, #id, onDelete: KeyAction.cascade)();
  /// The linked rating, if any. Set to null when the rating is deleted; the
  /// entry then lives on with its [label].
  IntColumn get ratingId => integer()
      .named('rating_id')
      .nullable()
      .references(Ratings, #id, onDelete: KeyAction.setNull)();
  /// What the entry says. For a linked rating, its title when it was added.
  TextColumn get label => text().withLength(min: 1, max: 500)();
  BoolColumn get checked => boolean().withDefault(const Constant(false))();
  /// Order within the list, ascending. New entries go to the end.
  IntColumn get position => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt =>
      dateTime().named('created_at').withDefault(currentDateAndTime)();
}

/// Main Drift database. [Ratings] holds everything the user rated;
/// [RatingLists] and [ListEntries] hold their lists.
///
/// ## Adding a new column (example)
/// 1. Add the column to [Ratings].
/// 2. Bump [schemaVersion] by 1.
/// 3. Add an `if (from < <new version>)` block in [migration] → `onUpgrade`:
///    ```dart
///    if (from < 2) {
///      await m.addColumn(ratings, ratings.yourNewColumn);
///    }
///    ```
///    Drift calls [onCreate] for fresh installs and [onUpgrade] for existing
///    users, so both paths are covered automatically.
///
/// ## Adding a new table (example)
/// 1. Define the table class and add it to the `@DriftDatabase(tables: […])`.
/// 2. Bump [schemaVersion].
/// 3. In `onUpgrade`: `await m.createTable(yourNewTable);`
@DriftDatabase(tables: [Ratings, RatingLists, ListEntries])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  /// Constructor used in tests to inject an in-memory database.
  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      /// Called once when the database file is first created (fresh install).
      onCreate: (m) async {
        await m.createAll();
      },
      /// Called when the on-device [schemaVersion] is lower than the current
      /// one. [from] is the old version, [to] is the new version.
      onUpgrade: (m, from, to) async {
        if (from < 2) {
          await m.addColumn(ratings, ratings.localImagePath);
        }
        if (from < 3) {
          await m.addColumn(ratings, ratings.creator);
          await m.addColumn(ratings, ratings.year);
        }
        if (from < 4) {
          await m.createTable(ratingLists);
          await m.createTable(listEntries);
        }
      },
      /// Runs before the database is used on every app start.
      beforeOpen: (details) async {
        // Enable foreign-key constraints. SQLite disables them by default;
        // keeping them on is a safe baseline even if no FKs are defined yet.
        await customStatement('PRAGMA foreign_keys = ON');
      },
    );
  }

  static LazyDatabase _openConnection() {
    return LazyDatabase(() async {
      final dbFolder = await getApplicationDocumentsDirectory();
      final file = File(p.join(dbFolder.path, 'i_like.db'));
      return NativeDatabase.createInBackground(file);
    });
  }
}
