import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'I Like'**
  String get appTitle;

  /// No description provided for @homeTitle.
  ///
  /// In en, this message translates to:
  /// **'I Like'**
  String get homeTitle;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @detailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get detailsTitle;

  /// No description provided for @addRatingTitle.
  ///
  /// In en, this message translates to:
  /// **'New rating'**
  String get addRatingTitle;

  /// No description provided for @scanBarcodeTitle.
  ///
  /// In en, this message translates to:
  /// **'Scan Barcode'**
  String get scanBarcodeTitle;

  /// No description provided for @noRatingsYet.
  ///
  /// In en, this message translates to:
  /// **'No ratings yet'**
  String get noRatingsYet;

  /// No description provided for @noResults.
  ///
  /// In en, this message translates to:
  /// **'No results'**
  String get noResults;

  /// No description provided for @tryDifferentSearch.
  ///
  /// In en, this message translates to:
  /// **'Try a different search term'**
  String get tryDifferentSearch;

  /// No description provided for @stars.
  ///
  /// In en, this message translates to:
  /// **'Stars'**
  String get stars;

  /// No description provided for @rating.
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get rating;

  /// No description provided for @tags.
  ///
  /// In en, this message translates to:
  /// **'Tags'**
  String get tags;

  /// No description provided for @notes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @titleRequired.
  ///
  /// In en, this message translates to:
  /// **'Title *'**
  String get titleRequired;

  /// No description provided for @titleHint.
  ///
  /// In en, this message translates to:
  /// **'What are you rating?'**
  String get titleHint;

  /// No description provided for @notesHint.
  ///
  /// In en, this message translates to:
  /// **'Any thoughts...'**
  String get notesHint;

  /// No description provided for @addTagHint.
  ///
  /// In en, this message translates to:
  /// **'Add a tag...'**
  String get addTagHint;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search your ratings'**
  String get searchHint;

  /// No description provided for @searchEllipsis.
  ///
  /// In en, this message translates to:
  /// **'Search...'**
  String get searchEllipsis;

  /// No description provided for @pleaseEnterTitle.
  ///
  /// In en, this message translates to:
  /// **'Please enter a title'**
  String get pleaseEnterTitle;

  /// No description provided for @pleaseGiveRating.
  ///
  /// In en, this message translates to:
  /// **'How was it? Pick a level.'**
  String get pleaseGiveRating;

  /// No description provided for @quickAdd.
  ///
  /// In en, this message translates to:
  /// **'Quick Add (Scan, URL, ...)'**
  String get quickAdd;

  /// No description provided for @howToAdd.
  ///
  /// In en, this message translates to:
  /// **'How would you like to add?'**
  String get howToAdd;

  /// No description provided for @scanBarcode.
  ///
  /// In en, this message translates to:
  /// **'Scan Barcode'**
  String get scanBarcode;

  /// No description provided for @scanBarcodeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Recognise a product or book'**
  String get scanBarcodeSubtitle;

  /// No description provided for @fromUrl.
  ///
  /// In en, this message translates to:
  /// **'From link'**
  String get fromUrl;

  /// No description provided for @fromUrlSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Details load automatically'**
  String get fromUrlSubtitle;

  /// No description provided for @searchMovieSeries.
  ///
  /// In en, this message translates to:
  /// **'Movie & series'**
  String get searchMovieSeries;

  /// No description provided for @searchMovieSeriesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'The Movie Database'**
  String get searchMovieSeriesSubtitle;

  /// No description provided for @searchPlace.
  ///
  /// In en, this message translates to:
  /// **'Place'**
  String get searchPlace;

  /// No description provided for @searchPlaceSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Find it on OpenStreetMap'**
  String get searchPlaceSubtitle;

  /// No description provided for @searchBook.
  ///
  /// In en, this message translates to:
  /// **'Book'**
  String get searchBook;

  /// No description provided for @searchBookSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Search Open Library'**
  String get searchBookSubtitle;

  /// No description provided for @searchBoardGame.
  ///
  /// In en, this message translates to:
  /// **'Board game'**
  String get searchBoardGame;

  /// No description provided for @searchBoardGameSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Find it on Wikipedia'**
  String get searchBoardGameSubtitle;

  /// No description provided for @searchBoardGames.
  ///
  /// In en, this message translates to:
  /// **'Search Board Games'**
  String get searchBoardGames;

  /// No description provided for @manualEntry.
  ///
  /// In en, this message translates to:
  /// **'Enter it yourself'**
  String get manualEntry;

  /// No description provided for @manualEntrySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter all details yourself'**
  String get manualEntrySubtitle;

  /// No description provided for @enterUrl.
  ///
  /// In en, this message translates to:
  /// **'Enter URL'**
  String get enterUrl;

  /// No description provided for @pointCameraAtBarcode.
  ///
  /// In en, this message translates to:
  /// **'Point the camera at a barcode'**
  String get pointCameraAtBarcode;

  /// No description provided for @deleteRating.
  ///
  /// In en, this message translates to:
  /// **'Delete Rating'**
  String get deleteRating;

  /// No description provided for @deleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this rating?'**
  String get deleteConfirm;

  /// No description provided for @deleteItemConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete \"{title}\"?'**
  String deleteItemConfirm(String title);

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @scoreDisplay.
  ///
  /// In en, this message translates to:
  /// **'{score} / 5'**
  String scoreDisplay(String score);

  /// No description provided for @barcode.
  ///
  /// In en, this message translates to:
  /// **'Barcode: {code}'**
  String barcode(String code);

  /// No description provided for @created.
  ///
  /// In en, this message translates to:
  /// **'Created: {date}'**
  String created(String date);

  /// No description provided for @updated.
  ///
  /// In en, this message translates to:
  /// **'Updated: {date}'**
  String updated(String date);

  /// No description provided for @statistics.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get statistics;

  /// No description provided for @totalRatings.
  ///
  /// In en, this message translates to:
  /// **'Total Ratings'**
  String get totalRatings;

  /// No description provided for @averageScore.
  ///
  /// In en, this message translates to:
  /// **'Average Score'**
  String get averageScore;

  /// No description provided for @searchMoviesAndSeries.
  ///
  /// In en, this message translates to:
  /// **'Search Movies & Series'**
  String get searchMoviesAndSeries;

  /// No description provided for @searchPlaces.
  ///
  /// In en, this message translates to:
  /// **'Search Places'**
  String get searchPlaces;

  /// No description provided for @searchBooks.
  ///
  /// In en, this message translates to:
  /// **'Search Books'**
  String get searchBooks;

  /// No description provided for @tmdbTitle.
  ///
  /// In en, this message translates to:
  /// **'TMDB (Movies & Series)'**
  String get tmdbTitle;

  /// No description provided for @tmdbDescription.
  ///
  /// In en, this message translates to:
  /// **'To search for movies and series, you need a free TMDB API key. Sign up at themoviedb.org and create an API key in your account settings.'**
  String get tmdbDescription;

  /// No description provided for @apiKeyConfigured.
  ///
  /// In en, this message translates to:
  /// **'API key configured'**
  String get apiKeyConfigured;

  /// No description provided for @removeKey.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get removeKey;

  /// No description provided for @enterTmdbApiKey.
  ///
  /// In en, this message translates to:
  /// **'Enter your TMDB API key'**
  String get enterTmdbApiKey;

  /// No description provided for @tmdbApiKeySaved.
  ///
  /// In en, this message translates to:
  /// **'TMDB API key saved'**
  String get tmdbApiKeySaved;

  /// No description provided for @placesTitle.
  ///
  /// In en, this message translates to:
  /// **'Places (Nominatim)'**
  String get placesTitle;

  /// No description provided for @placesDescription.
  ///
  /// In en, this message translates to:
  /// **'Place search uses OpenStreetMap\'s Nominatim service. No API key required.'**
  String get placesDescription;

  /// No description provided for @readyToUse.
  ///
  /// In en, this message translates to:
  /// **'Ready to use'**
  String get readyToUse;

  /// No description provided for @errorPrefix.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String errorPrefix(String error);

  /// No description provided for @movie.
  ///
  /// In en, this message translates to:
  /// **'Movie'**
  String get movie;

  /// No description provided for @series.
  ///
  /// In en, this message translates to:
  /// **'Series'**
  String get series;

  /// No description provided for @tagProduct.
  ///
  /// In en, this message translates to:
  /// **'Product'**
  String get tagProduct;

  /// No description provided for @tagBook.
  ///
  /// In en, this message translates to:
  /// **'Book'**
  String get tagBook;

  /// No description provided for @tagMovie.
  ///
  /// In en, this message translates to:
  /// **'Movie'**
  String get tagMovie;

  /// No description provided for @tagSeries.
  ///
  /// In en, this message translates to:
  /// **'Series'**
  String get tagSeries;

  /// No description provided for @tagPlace.
  ///
  /// In en, this message translates to:
  /// **'Place'**
  String get tagPlace;

  /// No description provided for @tagUrl.
  ///
  /// In en, this message translates to:
  /// **'URL'**
  String get tagUrl;

  /// No description provided for @tagFood.
  ///
  /// In en, this message translates to:
  /// **'Food'**
  String get tagFood;

  /// No description provided for @tagMusic.
  ///
  /// In en, this message translates to:
  /// **'Music'**
  String get tagMusic;

  /// No description provided for @tagGame.
  ///
  /// In en, this message translates to:
  /// **'Game'**
  String get tagGame;

  /// No description provided for @tagApp.
  ///
  /// In en, this message translates to:
  /// **'App'**
  String get tagApp;

  /// No description provided for @tagMagazine.
  ///
  /// In en, this message translates to:
  /// **'Magazine'**
  String get tagMagazine;

  /// No description provided for @tagOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get tagOther;

  /// No description provided for @dataTitle.
  ///
  /// In en, this message translates to:
  /// **'Data'**
  String get dataTitle;

  /// No description provided for @exportRatings.
  ///
  /// In en, this message translates to:
  /// **'Export JSON'**
  String get exportRatings;

  /// No description provided for @importRatings.
  ///
  /// In en, this message translates to:
  /// **'Import JSON'**
  String get importRatings;

  /// No description provided for @exportSuccess.
  ///
  /// In en, this message translates to:
  /// **'Exported {count} ratings'**
  String exportSuccess(int count);

  /// No description provided for @importSuccess.
  ///
  /// In en, this message translates to:
  /// **'Imported {imported} ratings, {skipped} skipped'**
  String importSuccess(int imported, int skipped);

  /// No description provided for @importError.
  ///
  /// In en, this message translates to:
  /// **'Could not read the file. Please make sure it is a valid export file.'**
  String get importError;

  /// No description provided for @noRatingsToExport.
  ///
  /// In en, this message translates to:
  /// **'No ratings to export'**
  String get noRatingsToExport;

  /// No description provided for @sortNewest.
  ///
  /// In en, this message translates to:
  /// **'Newest first'**
  String get sortNewest;

  /// No description provided for @sortOldest.
  ///
  /// In en, this message translates to:
  /// **'Oldest first'**
  String get sortOldest;

  /// No description provided for @sortHighest.
  ///
  /// In en, this message translates to:
  /// **'Love first'**
  String get sortHighest;

  /// No description provided for @sortLowest.
  ///
  /// In en, this message translates to:
  /// **'Nope first'**
  String get sortLowest;

  /// No description provided for @sortAZ.
  ///
  /// In en, this message translates to:
  /// **'A – Z'**
  String get sortAZ;

  /// No description provided for @sortZA.
  ///
  /// In en, this message translates to:
  /// **'Z – A'**
  String get sortZA;

  /// No description provided for @exportCsv.
  ///
  /// In en, this message translates to:
  /// **'Export CSV'**
  String get exportCsv;

  /// No description provided for @onboardingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Scan a barcode, search for a movie, book, or place — or add anything manually.'**
  String get onboardingSubtitle;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get started'**
  String get getStarted;

  /// No description provided for @rateNowPlaying.
  ///
  /// In en, this message translates to:
  /// **'Just watched'**
  String get rateNowPlaying;

  /// No description provided for @rateNowPlayingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Netflix, Prime & more'**
  String get rateNowPlayingSubtitle;

  /// No description provided for @notificationPermissionTitle.
  ///
  /// In en, this message translates to:
  /// **'Notification Access Required'**
  String get notificationPermissionTitle;

  /// No description provided for @notificationPermissionBody.
  ///
  /// In en, this message translates to:
  /// **'To detect what you\'re watching, grant notification access in Settings.'**
  String get notificationPermissionBody;

  /// No description provided for @openSettings.
  ///
  /// In en, this message translates to:
  /// **'Open Settings'**
  String get openSettings;

  /// No description provided for @nothingPlaying.
  ///
  /// In en, this message translates to:
  /// **'Nothing is currently playing'**
  String get nothingPlaying;

  /// No description provided for @levelNope.
  ///
  /// In en, this message translates to:
  /// **'Nope'**
  String get levelNope;

  /// No description provided for @levelNaja.
  ///
  /// In en, this message translates to:
  /// **'Meh'**
  String get levelNaja;

  /// No description provided for @levelOkay.
  ///
  /// In en, this message translates to:
  /// **'Okay'**
  String get levelOkay;

  /// No description provided for @levelGood.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get levelGood;

  /// No description provided for @levelLove.
  ///
  /// In en, this message translates to:
  /// **'Love'**
  String get levelLove;

  /// No description provided for @levelNopePhrase.
  ///
  /// In en, this message translates to:
  /// **'Never again'**
  String get levelNopePhrase;

  /// No description provided for @levelNajaPhrase.
  ///
  /// In en, this message translates to:
  /// **'Rather not'**
  String get levelNajaPhrase;

  /// No description provided for @levelOkayPhrase.
  ///
  /// In en, this message translates to:
  /// **'It\'s fine'**
  String get levelOkayPhrase;

  /// No description provided for @levelGoodPhrase.
  ///
  /// In en, this message translates to:
  /// **'Would have it again'**
  String get levelGoodPhrase;

  /// No description provided for @levelLovePhrase.
  ///
  /// In en, this message translates to:
  /// **'Absolute favourite'**
  String get levelLovePhrase;

  /// No description provided for @filterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filterAll;

  /// No description provided for @filterByLevel.
  ///
  /// In en, this message translates to:
  /// **'Filter by level'**
  String get filterByLevel;

  /// No description provided for @homeSummary.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 thing rated} other{{count} things rated}} — you love {loved} of them.'**
  String homeSummary(int count, int loved);

  /// No description provided for @homeSummaryShort.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 thing rated} other{{count} things rated}}'**
  String homeSummaryShort(int count);

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @sort.
  ///
  /// In en, this message translates to:
  /// **'Sort'**
  String get sort;

  /// No description provided for @showResults.
  ///
  /// In en, this message translates to:
  /// **'Show'**
  String get showResults;

  /// No description provided for @newRating.
  ///
  /// In en, this message translates to:
  /// **'New rating'**
  String get newRating;

  /// No description provided for @whatToRate.
  ///
  /// In en, this message translates to:
  /// **'What do you want to rate?'**
  String get whatToRate;

  /// No description provided for @howWasIt.
  ///
  /// In en, this message translates to:
  /// **'How was it?'**
  String get howWasIt;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @editRating.
  ///
  /// In en, this message translates to:
  /// **'Edit rating'**
  String get editRating;

  /// No description provided for @ratedOn.
  ///
  /// In en, this message translates to:
  /// **'rated on {date}'**
  String ratedOn(String date);

  /// No description provided for @source.
  ///
  /// In en, this message translates to:
  /// **'Source'**
  String get source;

  /// No description provided for @barcodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Barcode'**
  String get barcodeLabel;

  /// No description provided for @sortNewestHint.
  ///
  /// In en, this message translates to:
  /// **'Most recently rated on top'**
  String get sortNewestHint;

  /// No description provided for @sortOldestHint.
  ///
  /// In en, this message translates to:
  /// **'Your first ratings on top'**
  String get sortOldestHint;

  /// No description provided for @sortHighestHint.
  ///
  /// In en, this message translates to:
  /// **'Your favourites on top'**
  String get sortHighestHint;

  /// No description provided for @sortLowestHint.
  ///
  /// In en, this message translates to:
  /// **'What you never want again'**
  String get sortLowestHint;

  /// No description provided for @sortAZHint.
  ///
  /// In en, this message translates to:
  /// **'Alphabetical'**
  String get sortAZHint;

  /// No description provided for @sortZAHint.
  ///
  /// In en, this message translates to:
  /// **'Reverse alphabetical'**
  String get sortZAHint;

  /// No description provided for @yourBalance.
  ///
  /// In en, this message translates to:
  /// **'Your balance'**
  String get yourBalance;

  /// No description provided for @ratingsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 rating} other{{count} ratings}}'**
  String ratingsCount(int count);

  /// No description provided for @servicesTitle.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get servicesTitle;

  /// No description provided for @moviesSeries.
  ///
  /// In en, this message translates to:
  /// **'Movies & series'**
  String get moviesSeries;

  /// No description provided for @tmdbNeedsKey.
  ///
  /// In en, this message translates to:
  /// **'Free TMDB key required'**
  String get tmdbNeedsKey;

  /// No description provided for @tmdbConnected.
  ///
  /// In en, this message translates to:
  /// **'Connected via TMDB'**
  String get tmdbConnected;

  /// No description provided for @setUp.
  ///
  /// In en, this message translates to:
  /// **'Set up'**
  String get setUp;

  /// No description provided for @ready.
  ///
  /// In en, this message translates to:
  /// **'Ready'**
  String get ready;

  /// No description provided for @placesShort.
  ///
  /// In en, this message translates to:
  /// **'Places'**
  String get placesShort;

  /// No description provided for @placesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'OpenStreetMap, no key needed'**
  String get placesSubtitle;

  /// No description provided for @exportJsonLong.
  ///
  /// In en, this message translates to:
  /// **'Export as JSON'**
  String get exportJsonLong;

  /// No description provided for @exportCsvLong.
  ///
  /// In en, this message translates to:
  /// **'Export as CSV'**
  String get exportCsvLong;

  /// No description provided for @nothingInLevel.
  ///
  /// In en, this message translates to:
  /// **'Nothing here yet'**
  String get nothingInLevel;

  /// No description provided for @nothingInLevelSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Once you rate something like this, it shows up here.'**
  String get nothingInLevelSubtitle;

  /// No description provided for @rateAction.
  ///
  /// In en, this message translates to:
  /// **'Rate'**
  String get rateAction;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'today'**
  String get today;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'yesterday'**
  String get yesterday;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @addCategory.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get addCategory;

  /// No description provided for @pickALevel.
  ///
  /// In en, this message translates to:
  /// **'Tap a level'**
  String get pickALevel;

  /// No description provided for @aboutTitle.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get aboutTitle;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy policy'**
  String get privacyPolicy;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @addPhoto.
  ///
  /// In en, this message translates to:
  /// **'Add photo'**
  String get addPhoto;

  /// No description provided for @changePhoto.
  ///
  /// In en, this message translates to:
  /// **'Change photo'**
  String get changePhoto;

  /// No description provided for @takePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take photo'**
  String get takePhoto;

  /// No description provided for @chooseFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from gallery'**
  String get chooseFromGallery;

  /// No description provided for @removePhoto.
  ///
  /// In en, this message translates to:
  /// **'Remove photo'**
  String get removePhoto;

  /// No description provided for @photoError.
  ///
  /// In en, this message translates to:
  /// **'The photo could not be loaded.'**
  String get photoError;

  /// No description provided for @creatorLabel.
  ///
  /// In en, this message translates to:
  /// **'By'**
  String get creatorLabel;

  /// No description provided for @creatorHint.
  ///
  /// In en, this message translates to:
  /// **'Author, maker, brand …'**
  String get creatorHint;

  /// No description provided for @yearLabel.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get yearLabel;

  /// No description provided for @byCreator.
  ///
  /// In en, this message translates to:
  /// **'by {creator}'**
  String byCreator(String creator);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
