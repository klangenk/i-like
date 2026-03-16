import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'app_database.g.dart';

class Ratings extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 1, max: 500)();
  RealColumn get score => real()();
  TextColumn get tags => text().withDefault(const Constant(''))();
  TextColumn get notes => text().withDefault(const Constant(''))();
  TextColumn get imageUrl =>
      text().named('image_url').withDefault(const Constant(''))();
  TextColumn get sourceUrl =>
      text().named('source_url').withDefault(const Constant(''))();
  TextColumn get barcode => text().withDefault(const Constant(''))();
  DateTimeColumn get createdAt =>
      dateTime().named('created_at').withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt =>
      dateTime().named('updated_at').withDefault(currentDateAndTime)();
}

@DriftDatabase(tables: [Ratings])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (m) async {
        await m.createAll();
      },
      onUpgrade: (m, from, to) async {
        // Add migration steps here when schemaVersion is bumped.
        // Example for a future version 2:
        // if (from < 2) {
        //   await m.addColumn(ratings, ratings.someNewColumn);
        // }
      },
      beforeOpen: (details) async {
        // Enable foreign keys (good practice even if not used yet)
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
