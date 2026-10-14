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
  String get settingsTitle => 'Settings';

  @override
  String get detailsTitle => 'Details';

  @override
  String get addRatingTitle => 'New rating';

  @override
  String get scanBarcodeTitle => 'Scan Barcode';

  @override
  String get noRatingsYet => 'No ratings yet';

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
  String get searchHint => 'Search your ratings';

  @override
  String get searchEllipsis => 'Search...';

  @override
  String get pleaseEnterTitle => 'Please enter a title';

  @override
  String get pleaseGiveRating => 'How was it? Pick a level.';

  @override
  String get quickAdd => 'Quick Add (Scan, URL, ...)';

  @override
  String get howToAdd => 'How would you like to add?';

  @override
  String get scanBarcode => 'Scan Barcode';

  @override
  String get scanBarcodeSubtitle => 'Recognise a product or book';

  @override
  String get fromUrl => 'From link';

  @override
  String get fromUrlSubtitle => 'Paste a link – or share it from any app';

  @override
  String get searchMovieSeries => 'Movie & series';

  @override
  String get searchMovieSeriesSubtitle => 'The Movie Database';

  @override
  String get searchPlace => 'Place';

  @override
  String get searchPlaceSubtitle => 'Find it on OpenStreetMap';

  @override
  String get searchBook => 'Book';

  @override
  String get searchBookSubtitle => 'Search Open Library';

  @override
  String get searchBoardGame => 'Board game';

  @override
  String get searchBoardGameSubtitle => 'Find it on Wikipedia';

  @override
  String get searchBoardGames => 'Search Board Games';

  @override
  String get manualEntry => 'Enter it yourself';

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
  String get tagFood => 'Food & drink';

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
  String get sortHighest => 'Love first';

  @override
  String get sortLowest => 'Nope first';

  @override
  String get sortAZ => 'A – Z';

  @override
  String get sortZA => 'Z – A';

  @override
  String get exportCsv => 'Export CSV';

  @override
  String get getStarted => 'Get started';

  @override
  String get rateNowPlaying => 'Just watched';

  @override
  String get rateNowPlayingSubtitle => 'Netflix, Prime & more';

  @override
  String get notificationPermissionTitle => 'Notification Access Required';

  @override
  String get notificationPermissionBody =>
      'To detect what you\'re watching, grant notification access in Settings.';

  @override
  String get openSettings => 'Open Settings';

  @override
  String get nothingPlaying => 'Nothing is currently playing';

  @override
  String get levelNope => 'Nope';

  @override
  String get levelNaja => 'Meh';

  @override
  String get levelOkay => 'Okay';

  @override
  String get levelGood => 'Good';

  @override
  String get levelLove => 'Love';

  @override
  String get levelNopePhrase => 'Never again';

  @override
  String get levelNajaPhrase => 'Rather not';

  @override
  String get levelOkayPhrase => 'It\'s fine';

  @override
  String get levelGoodPhrase => 'Would have it again';

  @override
  String get levelLovePhrase => 'Absolute favourite';

  @override
  String get filterAll => 'All';

  @override
  String get filterByLevel => 'Filter by level';

  @override
  String homeSummary(int count, int loved) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count things rated',
      one: '1 thing rated',
    );
    return '$_temp0 — you love $loved of them.';
  }

  @override
  String homeSummaryShort(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count things rated',
      one: '1 thing rated',
    );
    return '$_temp0';
  }

  @override
  String get search => 'Search';

  @override
  String get sort => 'Sort & filter';

  @override
  String get showResults => 'Show';

  @override
  String get newRating => 'New rating';

  @override
  String get whatToRate => 'What do you want to rate?';

  @override
  String get howWasIt => 'How was it?';

  @override
  String get category => 'Category';

  @override
  String get editRating => 'Edit rating';

  @override
  String ratedOn(String date) {
    return 'rated on $date';
  }

  @override
  String get source => 'Source';

  @override
  String get barcodeLabel => 'Barcode';

  @override
  String get sortNewestHint => 'Most recently rated on top';

  @override
  String get sortOldestHint => 'Your first ratings on top';

  @override
  String get sortHighestHint => 'Your favourites on top';

  @override
  String get sortLowestHint => 'What you never want again';

  @override
  String get sortAZHint => 'Alphabetical';

  @override
  String get sortZAHint => 'Reverse alphabetical';

  @override
  String get amazonStickerHint =>
      'That\'s an Amazon warehouse label, not a product code. Scan the barcode on the packaging instead – it\'s often under the sticker.';

  @override
  String barcodeNotFound(String barcode) {
    return 'We couldn\'t find anything for barcode $barcode. Just enter it yourself.';
  }

  @override
  String get searchBarcodeOnline => 'Search barcode on Google';

  @override
  String linkUnreadable(String site) {
    return '$site can\'t be read automatically. Just enter the title yourself.';
  }

  @override
  String get searchLinkOnline => 'Search link on Google';

  @override
  String get welcomeTitle => 'Welcome to I Like';

  @override
  String get welcomeSubtitle =>
      'Keep track of what you like – and what you don\'t. From Nope to Love, privately on your phone.';

  @override
  String get welcomeScanTitle => 'Scan';

  @override
  String get welcomeScanText =>
      'Barcodes on books, food or cosmetics – title and picture come in automatically.';

  @override
  String get welcomeShareTitle => 'Share from any app';

  @override
  String get welcomeShareText =>
      'In your browser, on Amazon & co., tap \"Share\" and pick I Like.';

  @override
  String get welcomeManualTitle => 'Photo or type it in';

  @override
  String get welcomeManualText =>
      'Take a photo – the app suggests a title. Or just type it.';

  @override
  String get shareTip =>
      'Tip: In any app, tap \"Share\" → I Like to rate it right away.';

  @override
  String get magazineNotFound =>
      'Magazines can\'t be looked up automatically. Take a photo of the cover – the app suggests the title.';

  @override
  String get knownBarcodeTitle => 'Already rated';

  @override
  String get rateAgain => 'Rate it again';

  @override
  String get toTry => 'To try';

  @override
  String get saveToTry => 'Later';

  @override
  String toTryCount(int count) {
    return '$count to try';
  }

  @override
  String get notTriedYet => 'Not tried yet. Rate it once you know it.';

  @override
  String get rateNow => 'Rate it now';

  @override
  String get backupTitle => 'Back up to your Google account';

  @override
  String get backupSubtitle =>
      'Encrypted via Android backup – for a new phone. Only if you turn it on.';

  @override
  String get webSearch => 'Search the web';

  @override
  String get groupByCategory => 'Group by category';

  @override
  String get groupByCategoryHint => 'One section per category';

  @override
  String get noCategory => 'No category';

  @override
  String get yourBalance => 'Your balance';

  @override
  String ratingsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ratings',
      one: '1 rating',
    );
    return '$_temp0';
  }

  @override
  String get servicesTitle => 'Services';

  @override
  String get moviesSeries => 'Movies & series';

  @override
  String get tmdbNeedsKey => 'Free TMDB key required';

  @override
  String get tmdbConnected => 'Connected via TMDB';

  @override
  String get setUp => 'Set up';

  @override
  String get ready => 'Ready';

  @override
  String get placesShort => 'Places';

  @override
  String get placesSubtitle => 'OpenStreetMap, no key needed';

  @override
  String get exportJsonLong => 'Export as JSON';

  @override
  String get exportCsvLong => 'Export as CSV';

  @override
  String get nothingInLevel => 'Nothing here yet';

  @override
  String get nothingInLevelSubtitle =>
      'Once you rate something like this, it shows up here.';

  @override
  String get rateAction => 'Rate';

  @override
  String get today => 'today';

  @override
  String get yesterday => 'yesterday';

  @override
  String get close => 'Close';

  @override
  String get back => 'Back';

  @override
  String get share => 'Share';

  @override
  String get edit => 'Edit';

  @override
  String get addCategory => 'Add';

  @override
  String get pickALevel => 'Tap a level';

  @override
  String get aboutTitle => 'About';

  @override
  String get privacyPolicy => 'Privacy policy';

  @override
  String get version => 'Version';

  @override
  String get addPhoto => 'Add photo';

  @override
  String get changePhoto => 'Change photo';

  @override
  String get takePhoto => 'Take photo';

  @override
  String get chooseFromGallery => 'Choose from gallery';

  @override
  String get removePhoto => 'Remove photo';

  @override
  String get photoError => 'The photo could not be loaded.';

  @override
  String get creatorLabel => 'By';

  @override
  String get creatorHint => 'Author, maker, brand …';

  @override
  String get yearLabel => 'Year';

  @override
  String byCreator(String creator) {
    return 'by $creator';
  }

  @override
  String get photoSuggestions => 'Suggestions from the photo';

  @override
  String get analyzingPhoto => 'Reading photo …';

  @override
  String get listsTitle => 'Lists';

  @override
  String get listsEmptyTitle => 'No lists yet';

  @override
  String get listsEmptySubtitle =>
      'Shopping, gift ideas, places for the holiday: collect whatever you like.';

  @override
  String get listShoppingName => 'Shopping list';

  @override
  String get listGiftsName => 'Gift ideas';

  @override
  String get listOwn => 'Your own list';

  @override
  String get newList => 'New list';

  @override
  String get editList => 'Edit list';

  @override
  String get listName => 'Name';

  @override
  String get listCheckable => 'Tick off entries';

  @override
  String get listCheckableHint => 'For shopping and to-dos';

  @override
  String listOpenCount(int open, int total) {
    return '$open of $total open';
  }

  @override
  String listEntryCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count entries',
      one: '1 entry',
      zero: 'Empty',
    );
    return '$_temp0';
  }

  @override
  String get listEmpty => 'Nothing on this list yet.';

  @override
  String get listAddHint => 'Add something …';

  @override
  String get listDone => 'Done';

  @override
  String get listClearDone => 'Remove';

  @override
  String get deleteList => 'Delete list';

  @override
  String deleteListConfirm(String name) {
    return 'Delete \"$name\" and everything on it?';
  }

  @override
  String listEntryRemoved(String label) {
    return 'Removed \"$label\"';
  }

  @override
  String get undo => 'Undo';

  @override
  String get addToList => 'Add to list';

  @override
  String get done => 'Done';

  @override
  String addAsText(String text) {
    return 'Add \"$text\" as text';
  }

  @override
  String get listEmptyHint => 'Add things you\'ve rated, or just a few words.';
}
