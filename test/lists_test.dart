import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:i_like/core/database/app_database.dart';
import 'package:i_like/core/database/lists_dao.dart';
import 'package:i_like/core/theme/app_theme.dart';
import 'package:i_like/features/home/home_provider.dart';
import 'package:i_like/features/home/home_screen.dart';
import 'package:i_like/features/lists/list_screen.dart';
import 'package:i_like/features/lists/lists_provider.dart';
import 'package:i_like/features/lists/lists_screen.dart';
import 'package:i_like/features/settings/settings_provider.dart';
import 'package:i_like/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'store_shots_test.dart' show loadFonts;

AppDatabase memoryDb() => AppDatabase.forTesting(NativeDatabase.memory());

Future<Rating> addRating(AppDatabase db, String title, double score) async {
  final id = await db.into(db.ratings).insert(
        RatingsCompanion.insert(title: title, score: score),
      );
  return (db.select(db.ratings)..where((t) => t.id.equals(id))).getSingle();
}

Widget app(AppDatabase db, Widget home, {SharedPreferences? prefs}) => ProviderScope(
      overrides: [
        databaseProvider.overrideWithValue(db),
        if (prefs != null) sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: MaterialApp(
        theme: AppTheme.light,
        locale: const Locale('de'),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: home,
      ),
    );

void main() {
  group('ListsDao', () {
    late AppDatabase db;
    late ListsDao dao;

    setUp(() {
      db = memoryDb();
      dao = ListsDao(db);
    });
    tearDown(() => db.close());

    test('counts open and total entries per list', () async {
      final shopping = await dao.createList('Einkauf');
      final gifts = await dao.createList('Geschenke', checkable: false);
      final milk = await dao.addText(shopping, 'Milch');
      await dao.addText(shopping, 'Brot');
      await dao.setChecked(milk, true);

      final lists = await dao.watchLists().first;
      expect(lists.map((l) => l.list.name), ['Einkauf', 'Geschenke']);
      expect((lists[0].open, lists[0].total), (1, 2));
      expect((lists[1].open, lists[1].total), (0, 0));
      expect(lists[1].list.checkable, isFalse);
      expect(gifts, isNot(shopping));
    });

    test('keeps open entries in order and ticked-off ones last', () async {
      final list = await dao.createList('Einkauf');
      final a = await dao.addText(list, 'Milch');
      await dao.addText(list, 'Brot');
      await dao.addText(list, 'Käse');
      await dao.setChecked(a, true);

      final items = await dao.watchItems(list).first;
      expect(items.map((i) => i.entry.label), ['Brot', 'Käse', 'Milch']);

      expect(await dao.clearChecked(list), 1);
      expect((await dao.watchItems(list).first).map((i) => i.entry.label), ['Brot', 'Käse']);
    });

    test('links ratings, reopens instead of duplicating, survives deleting the rating', () async {
      final list = await dao.createList('Nochmal kaufen');
      final yogurt = await addRating(db, 'Joghurt Kirsche', 5);

      expect(await dao.addRating(list, yogurt), isTrue);
      var items = await dao.watchItems(list).first;
      expect(items.single.rating?.title, 'Joghurt Kirsche');

      await dao.setChecked(items.single.entry.id, true);
      expect(await dao.addRating(list, yogurt), isFalse);
      items = await dao.watchItems(list).first;
      expect(items, hasLength(1));
      expect(items.single.entry.checked, isFalse);

      await (db.delete(db.ratings)..where((t) => t.id.equals(yogurt.id))).go();
      items = await dao.watchItems(list).first;
      expect(items.single.rating, isNull);
      expect(items.single.entry.ratingId, isNull);
      expect(items.single.entry.label, 'Joghurt Kirsche');
    });

    test('knows which lists a rating is on and takes it off again', () async {
      final shopping = await dao.createList('Einkauf');
      final gifts = await dao.createList('Geschenke', checkable: false);
      final game = await addRating(db, 'Würfelglück', 5);
      await dao.addRating(shopping, game);
      await dao.addRating(gifts, game);
      expect(await dao.watchListIdsFor(game.id).first, {shopping, gifts});

      await dao.removeRating(shopping, game.id);
      expect(await dao.watchListIdsFor(game.id).first, {gifts});
    });

    test('deleting a list deletes its entries; undo restores an entry', () async {
      final list = await dao.createList('Urlaub');
      final id = await dao.addText(list, 'Strandbar');
      final entry = (await dao.watchItems(list).first).single.entry;

      await dao.deleteEntry(id);
      expect(await dao.watchItems(list).first, isEmpty);
      await dao.restoreEntry(entry);
      expect((await dao.watchItems(list).first).single.entry, entry);

      await dao.deleteList(list);
      expect(await db.select(db.listEntries).get(), isEmpty);
      expect(await dao.watchList(list).first, isNull);
    });

    test('shares as text', () async {
      final list = await dao.createList('Einkauf');
      final milk = await dao.addText(list, 'Milch');
      await dao.addText(list, 'Brot');
      await dao.setChecked(milk, true);
      final text = listAsText((await dao.watchList(list).first)!, await dao.watchItems(list).first);
      expect(text, 'Einkauf\n\n• Brot\n✓ Milch');
    });
  });

  test('upgrading a version 3 database adds the list tables and keeps ratings', () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory(setup: (raw) {
      raw.execute('''
        CREATE TABLE ratings (
          id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT NOT NULL, score REAL NOT NULL,
          tags TEXT NOT NULL DEFAULT '', notes TEXT NOT NULL DEFAULT '',
          image_url TEXT NOT NULL DEFAULT '', source_url TEXT NOT NULL DEFAULT '',
          barcode TEXT NOT NULL DEFAULT '', local_image_path TEXT NOT NULL DEFAULT '',
          creator TEXT NOT NULL DEFAULT '', year TEXT NOT NULL DEFAULT '',
          created_at INTEGER NOT NULL DEFAULT (CAST(strftime('%s', CURRENT_TIMESTAMP) AS INTEGER)),
          updated_at INTEGER NOT NULL DEFAULT (CAST(strftime('%s', CURRENT_TIMESTAMP) AS INTEGER)))''');
      raw.execute("INSERT INTO ratings (title, score) VALUES ('Alter Kaffee', 4)");
      raw.execute('PRAGMA user_version = 3');
    }));
    addTearDown(db.close);

    final coffee = (await db.select(db.ratings).get()).single;
    expect(coffee.title, 'Alter Kaffee');
    final dao = ListsDao(db);
    final list = await dao.createList('Einkauf');
    await dao.addRating(list, coffee);
    expect((await dao.watchItems(list).first).single.rating?.title, 'Alter Kaffee');
  });

  group('screens', () {
    late AppDatabase db;

    setUp(() => db = memoryDb());
    tearDown(() async {
      await db.close();
    });

    testWidgets('starts a shopping list from the empty state and adds entries', (tester) async {
      await tester.runAsync(() async {
        await addRating(db, 'Joghurt Kirsche', 5);
        await addRating(db, 'Hafermilch Barista', 4);
      });
      await tester.pumpWidget(app(db, const ListsScreen()));
      await tester.pumpAndSettle();
      expect(find.text('Noch keine Listen'), findsOneWidget);

      await tester.runAsync(() => ListsDao(db).createList('Einkaufsliste'));
      await tester.pumpAndSettle();
      expect(find.text('Einkaufsliste'), findsOneWidget);
      expect(find.text('Leer'), findsOneWidget);

      final id = (await tester.runAsync(() => db.select(db.ratingLists).get()))!.single.id;
      await tester.pumpWidget(app(db, ListScreen(listId: id)));
      await tester.pumpAndSettle();

      // Add an existing rating from the picker
      await tester.tap(find.text('Hinzufügen'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'joghurt');
      await tester.pumpAndSettle();
      expect(find.text('Hafermilch Barista'), findsNothing);
      await tester.tap(find.text('Joghurt Kirsche'));
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.check_circle_rounded), findsOneWidget);

      // Nothing fits: add the search text as a plain entry
      await tester.enterText(find.byType(TextField), 'Brot');
      await tester.pumpAndSettle();
      await tester.tap(find.text('„Brot“ als Text hinzufügen'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Fertig'));
      await tester.pumpAndSettle();

      expect(find.text('Joghurt Kirsche'), findsOneWidget);
      expect(find.text('Brot'), findsOneWidget);
      expect(find.text('Liebe'), findsOneWidget);

      await tester.tap(find.byType(Checkbox).last);
      await tester.pumpAndSettle();
      expect(find.text('Erledigt · 1'), findsOneWidget);

      await tester.tap(find.text('Entfernen'));
      await tester.pumpAndSettle();
      expect(find.text('Brot'), findsNothing);
      expect(find.text('Joghurt Kirsche'), findsOneWidget);

      // Let the stream subscriptions close before the database does
      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(seconds: 1));
    });

    testWidgets('home header fits a 360 dp wide phone', (tester) async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
          const MethodChannel('plugins.flutter.io/quick_actions'), (_) async => null);
      await tester.runAsync(loadFonts);
      tester.view.physicalSize = const Size(360 * 3, 760 * 3);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      await tester.pumpWidget(app(db, const HomeScreen(), prefs: prefs));
      await tester.pumpAndSettle();
      expect(find.byTooltip('Listen'), findsOneWidget);
      expect(tester.takeException(), isNull);

      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(seconds: 1));
    });
  });
}
