import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:i_like/core/database/app_database.dart';
import 'package:i_like/features/add_rating/known_barcode_sheet.dart';
import 'package:i_like/l10n/app_localizations.dart';

Rating rating(int id, String title, double score) => Rating(
      id: id,
      title: title,
      score: score,
      tags: 'food',
      notes: '',
      imageUrl: '',
      sourceUrl: '',
      barcode: '4000417025005',
      localImagePath: '',
      creator: '',
      year: '',
      createdAt: DateTime(2026, 3, 3),
      updatedAt: DateTime(2026, 3, 3),
    );

void main() {
  testWidgets('shows earlier ratings and lets the user rate again', (tester) async {
    bool? again;
    await tester.pumpWidget(MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Builder(
        builder: (context) => TextButton(
          onPressed: () async => again = await showKnownBarcodeSheet(
            context,
            [rating(1, 'Ritter Sport Marzipan', 1), rating(2, 'Ritter Sport Nuss', 0)],
          ),
          child: const Text('scan'),
        ),
      ),
    ));
    await tester.tap(find.text('scan'));
    await tester.pumpAndSettle();

    expect(find.text('Already rated'), findsOneWidget);
    expect(find.text('Ritter Sport Marzipan'), findsOneWidget);
    expect(find.text('Nope'), findsOneWidget); // level of the first
    expect(find.text('To try'), findsOneWidget); // the second has no level yet
    expect(find.textContaining('rated on'), findsNWidgets(2));

    await tester.tap(find.text('Rate it again'));
    await tester.pumpAndSettle();
    expect(again, isTrue);
  });
}
