// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'I Like';

  @override
  String get homeTitle => 'I Like';

  @override
  String get searchTitle => 'Search';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get detailsTitle => 'Details';

  @override
  String get addRatingTitle => 'Add Rating';

  @override
  String get scanBarcodeTitle => 'Scan Barcode';

  @override
  String get homeTab => 'Home';

  @override
  String get searchTab => 'Search';

  @override
  String get noRatingsYet => 'No ratings yet';

  @override
  String get tapToRate => 'Tap + to rate something!';

  @override
  String get noResults => 'No results';

  @override
  String get tryDifferentSearch => 'Try a different search term';

  @override
  String get stars => 'Stars';

  @override
  String get rating => 'Rating';

  @override
  String get tags => 'Tags';

  @override
  String get notes => 'Notes';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get add => 'Add';

  @override
  String get titleRequired => 'Title *';

  @override
  String get titleHint => 'What are you rating?';

  @override
  String get notesHint => 'Any thoughts...';

  @override
  String get addTagHint => 'Add a tag...';

  @override
  String get searchHint => 'Search ratings...';

  @override
  String get searchEllipsis => 'Search...';

  @override
  String get pleaseEnterTitle => 'Please enter a title';

  @override
  String get pleaseGiveRating => 'Please give a rating';

  @override
  String get quickAdd => 'Quick Add (Scan, URL, ...)';

  @override
  String get howToAdd => 'How would you like to add?';

  @override
  String get scanBarcode => 'Scan Barcode';

  @override
  String get scanBarcodeSubtitle => 'Scan a product or book barcode';

  @override
  String get fromUrl => 'From URL';

  @override
  String get fromUrlSubtitle => 'Paste a link to auto-fill details';

  @override
  String get searchMovieSeries => 'Search Movie / Series';

  @override
  String get searchMovieSeriesSubtitle => 'Search TMDB for movies & TV shows';

  @override
  String get searchPlace => 'Search Place';

  @override
  String get searchPlaceSubtitle => 'Find a place via OpenStreetMap';

  @override
  String get searchBook => 'Search Book';

  @override
  String get searchBookSubtitle => 'Search Open Library for books';

  @override
  String get searchBoardGame => 'Search Board Game';

  @override
  String get searchBoardGameSubtitle => 'Search BoardGameGeek';

  @override
  String get searchBoardGames => 'Search Board Games';

  @override
  String get manualEntry => 'Manual Entry';

  @override
  String get manualEntrySubtitle => 'Enter all details yourself';

  @override
  String get enterUrl => 'Enter URL';

  @override
  String get pointCameraAtBarcode => 'Point the camera at a barcode';

  @override
  String get deleteRating => 'Delete Rating';

  @override
  String get deleteConfirm => 'Are you sure you want to delete this rating?';

  @override
  String deleteItemConfirm(String title) {
    return 'Delete \"$title\"?';
  }

  @override
  String get saveChanges => 'Save Changes';

  @override
  String scoreDisplay(String score) {
    return '$score / 5';
  }

  @override
  String barcode(String code) {
    return 'Barcode: $code';
  }

  @override
  String created(String date) {
    return 'Created: $date';
  }

  @override
  String updated(String date) {
    return 'Updated: $date';
  }

  @override
  String get statistics => 'Statistics';

  @override
  String get totalRatings => 'Total Ratings';

  @override
  String get averageScore => 'Average Score';

  @override
  String get searchMoviesAndSeries => 'Search Movies & Series';

  @override
  String get searchPlaces => 'Search Places';

  @override
  String get searchBooks => 'Search Books';

  @override
  String get tmdbTitle => 'TMDB (Movies & Series)';

  @override
  String get tmdbDescription =>
      'To search for movies and series, you need a free TMDB API key. Sign up at themoviedb.org and create an API key in your account settings.';

  @override
  String get apiKeyConfigured => 'API key configured';

  @override
  String get removeKey => 'Remove';

  @override
  String get enterTmdbApiKey => 'Enter your TMDB API key';

  @override
  String get tmdbApiKeySaved => 'TMDB API key saved';

  @override
  String get placesTitle => 'Places (Nominatim)';

  @override
  String get placesDescription =>
      'Place search uses OpenStreetMap\'s Nominatim service. No API key required.';

  @override
  String get readyToUse => 'Ready to use';

  @override
  String errorPrefix(String error) {
    return 'Error: $error';
  }

  @override
  String get movie => 'Movie';

  @override
  String get series => 'Series';

  @override
  String get tagProduct => 'Product';

  @override
  String get tagBook => 'Book';

  @override
  String get tagMovie => 'Movie';

  @override
  String get tagSeries => 'Series';

  @override
  String get tagPlace => 'Place';

  @override
  String get tagUrl => 'URL';

  @override
  String get tagFood => 'Food';

  @override
  String get tagMusic => 'Music';

  @override
  String get tagGame => 'Game';

  @override
  String get tagApp => 'App';

  @override
  String get tagMagazine => 'Magazine';

  @override
  String get tagOther => 'Other';

  @override
  String get dataTitle => 'Data';

  @override
  String get exportRatings => 'Export JSON';

  @override
  String get importRatings => 'Import JSON';

  @override
  String exportSuccess(int count) {
    return 'Exported $count ratings';
  }

  @override
  String importSuccess(int imported, int skipped) {
    return 'Imported $imported ratings, $skipped skipped';
  }

  @override
  String get importError =>
      'Could not read the file. Please make sure it is a valid export file.';

  @override
  String get noRatingsToExport => 'No ratings to export';

  @override
  String get sortNewest => 'Newest first';

  @override
  String get sortOldest => 'Oldest first';

  @override
  String get sortHighest => 'Highest rated';

  @override
  String get sortLowest => 'Lowest rated';

  @override
  String get sortAZ => 'A – Z';

  @override
  String get sortZA => 'Z – A';

  @override
  String get exportCsv => 'Export CSV';

  @override
  String get onboardingSubtitle =>
      'Scan a barcode, search for a movie, book, or place — or add anything manually.';

  @override
  String get getStarted => 'Get started';
}
