// Renders the raw screens for the Play Store screenshots; skipped in normal
// test runs. See tool/store_screenshots.py for how to run it.
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:i_like/core/database/app_database.dart';
import 'package:i_like/core/theme/app_theme.dart';
import 'package:i_like/features/add_rating/add_rating_provider.dart';
import 'package:i_like/features/add_rating/add_rating_screen.dart';
import 'package:i_like/features/add_rating/quick_add_sheet.dart';
import 'package:i_like/features/detail/detail_provider.dart';
import 'package:i_like/features/detail/detail_screen.dart';
import 'package:i_like/features/home/home_provider.dart';
import 'package:i_like/features/home/home_screen.dart';
import 'package:i_like/features/settings/settings_provider.dart';
import 'package:i_like/features/settings/settings_screen.dart';
import 'package:i_like/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

const enabled = bool.fromEnvironment('STORE_SHOTS');
const img = String.fromEnvironment('IMG', defaultValue: 'store/photos');
const lang = String.fromEnvironment('LANG', defaultValue: 'de');
const de = lang == 'de';

Future<void> loadFonts() async {
  final family = FontLoader('Schibsted Grotesk');
  for (final w in ['Regular', 'Medium', 'SemiBold', 'Bold', 'ExtraBold', 'Black']) {
    family.addFont(Future.value(ByteData.sublistView(
        File('assets/fonts/SchibstedGrotesk-$w.ttf').readAsBytesSync())));
  }
  await family.load();
  final root = Platform.environment['FLUTTER_ROOT']!;
  final icons = FontLoader('MaterialIcons')
    ..addFont(Future.value(ByteData.sublistView(File(
            '$root/bin/cache/artifacts/material_fonts/MaterialIcons-Regular.otf')
        .readAsBytesSync())));
  await icons.load();
}

Rating r(int id, String title, double score, String tags, String file, int daysAgo,
    {String notes = '', String source = '', String creator = '', String year = ''}) {
  final d = DateTime.now().subtract(Duration(days: daysAgo));
  return Rating(
    id: id, title: title, score: score, tags: tags, notes: notes,
    imageUrl: '', sourceUrl: source, barcode: '',
    localImagePath: '$img/$file', creator: creator, year: year,
    createdAt: d, updatedAt: d,
  );
}

final ratings = [
  r(1, 'Café Lindenblatt', 5, 'food', 'cafe.jpg', 0,
      notes: de ? 'Bester Flat White der Stadt – und die Zimtschnecken!' : 'Best flat white in town – and the cinnamon rolls!'),
  r(2, 'Pizza Rosmarino', 4, 'food', 'pizza.jpg', 1),
  r(3, de ? 'Der stille Sommer' : 'The Quiet Summer', 4, 'book', 'book.jpg', 3,
      creator: 'Lena Hartmann', year: '2023',
      notes: de ? 'Ruhig erzählt, bleibt lange im Kopf.' : 'Quietly told, stays with you for a long time.'),
  r(4, de ? 'Würfelglück' : 'Lucky Dice', 5, de ? 'game, Geschenkideen' : 'game, Gift ideas', 'boardgame.jpg', 5, creator: 'Spielwerk', year: '2021'),
  r(5, de ? 'Kinoabend: Nachtsignal' : 'Movie night: Night Signal', 3, 'movie', 'cinema.jpg', 8),
  r(6, de ? 'Bluetooth-Kopfhörer' : 'Wireless headphones', 1, de ? 'product, Geschenkideen' : 'product, Gift ideas', 'headphones.jpg', 12, creator: 'Soundbay'),
];

Future<void> shoot(WidgetTester tester, Widget home, String name,
    {Future<void> Function(WidgetTester, BuildContext)? after, bool grouped = false}) async {
  debugDisableShadows = false;
  tester.view.physicalSize = const Size(1080, 2340);
  tester.view.devicePixelRatio = 2.77;
  SharedPreferences.setMockInitialValues({'share_tip_dismissed': true});
  final prefs = await SharedPreferences.getInstance();
  final key = GlobalKey();
  await tester.pumpWidget(ProviderScope(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(prefs),
      groupByTagProvider.overrideWith((ref) => grouped),
      ratingsProvider.overrideWith((ref) => Stream.value(ratings)),
      ratingDetailProvider.overrideWith((ref, id) => Stream.value(ratings.firstWhere((x) => x.id == id))),
    ],
    child: MaterialApp(
      key: key,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      locale: Locale(lang),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: home,
    ),
  ));
  await tester.runAsync(() async {
    for (final x in ratings) {
      final ctx = tester.element(find.byType(Scaffold).first);
      await precacheImage(FileImage(File(x.localImagePath)), ctx);
    }
  });
  await tester.pumpAndSettle();
  if (after != null) {
    await after(tester, tester.element(find.byType(Scaffold).first));
    await tester.pumpAndSettle();
  }
  await expectLater(find.byKey(key), matchesGoldenFile('store/${lang}_$name.png'));
  debugDisableShadows = true;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
        const MethodChannel('plugins.flutter.io/quick_actions'), (_) async => null);
    await loadFonts();
  });

  testWidgets('home', skip: !enabled, (t) => shoot(t, const HomeScreen(), '1_home'));
  testWidgets('rate', skip: !enabled, (t) => shoot(
        t,
        AddRatingScreen(prefill: PrefillData(
          title: de ? 'Der stille Sommer' : 'The Quiet Summer',
          tags: ['book'],
          creator: 'Lena Hartmann',
          year: '2023',
        )),
        '2_rate',
        after: (t, ctx) async => t.tap(find.byIcon(Icons.favorite_rounded).last),
      ));
  testWidgets('detail', skip: !enabled, (t) => shoot(t, const DetailScreen(ratingId: 3), '3_detail'));
  testWidgets('add', skip: !enabled, (t) => shoot(t, const HomeScreen(), '4_add',
      after: (t, ctx) async => showQuickAddSheet(ctx)));
  testWidgets('grouped', skip: !enabled, (t) => shoot(t, const HomeScreen(), '5_grouped', grouped: true));
  testWidgets('settings', skip: !enabled, (t) => shoot(t, const SettingsScreen(), '6_settings'));
}
