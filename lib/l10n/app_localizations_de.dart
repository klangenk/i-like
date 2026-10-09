// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'I Like';

  @override
  String get homeTitle => 'I Like';

  @override
  String get settingsTitle => 'Einstellungen';

  @override
  String get detailsTitle => 'Details';

  @override
  String get addRatingTitle => 'Neue Bewertung';

  @override
  String get scanBarcodeTitle => 'Barcode scannen';

  @override
  String get noRatingsYet => 'Noch keine Bewertungen';

  @override
  String get noResults => 'Keine Ergebnisse';

  @override
  String get tryDifferentSearch => 'Versuche einen anderen Suchbegriff';

  @override
  String get stars => 'Sterne';

  @override
  String get rating => 'Bewertung';

  @override
  String get tags => 'Tags';

  @override
  String get notes => 'Notizen';

  @override
  String get save => 'Speichern';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get delete => 'Löschen';

  @override
  String get add => 'Hinzufügen';

  @override
  String get titleRequired => 'Titel *';

  @override
  String get titleHint => 'Was möchtest du bewerten?';

  @override
  String get notesHint => 'Deine Gedanken...';

  @override
  String get addTagHint => 'Tag hinzufügen...';

  @override
  String get searchHint => 'In deinen Bewertungen suchen';

  @override
  String get searchEllipsis => 'Suchen...';

  @override
  String get pleaseEnterTitle => 'Bitte gib einen Titel ein';

  @override
  String get pleaseGiveRating => 'Wie fandest du’s? Wähle eine Stufe.';

  @override
  String get quickAdd => 'Schnell hinzufügen (Scan, URL, ...)';

  @override
  String get howToAdd => 'Wie möchtest du hinzufügen?';

  @override
  String get scanBarcode => 'Barcode scannen';

  @override
  String get scanBarcodeSubtitle => 'Produkt oder Buch erkennen';

  @override
  String get fromUrl => 'Von Link';

  @override
  String get fromUrlSubtitle => 'Details werden automatisch geladen';

  @override
  String get searchMovieSeries => 'Film & Serie';

  @override
  String get searchMovieSeriesSubtitle => 'The Movie Database';

  @override
  String get searchPlace => 'Ort';

  @override
  String get searchPlaceSubtitle => 'Über OpenStreetMap finden';

  @override
  String get searchBook => 'Buch';

  @override
  String get searchBookSubtitle => 'Open Library durchsuchen';

  @override
  String get searchBoardGame => 'Brettspiel';

  @override
  String get searchBoardGameSubtitle => 'BoardGameGeek durchsuchen';

  @override
  String get searchBoardGames => 'Brettspiele suchen';

  @override
  String get manualEntry => 'Selbst eintragen';

  @override
  String get manualEntrySubtitle => 'Alle Details selbst eingeben';

  @override
  String get enterUrl => 'URL eingeben';

  @override
  String get pointCameraAtBarcode => 'Kamera auf einen Barcode richten';

  @override
  String get deleteRating => 'Bewertung löschen';

  @override
  String get deleteConfirm => 'Möchtest du diese Bewertung wirklich löschen?';

  @override
  String deleteItemConfirm(String title) {
    return '„$title“ löschen?';
  }

  @override
  String get saveChanges => 'Änderungen speichern';

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
    return 'Erstellt: $date';
  }

  @override
  String updated(String date) {
    return 'Aktualisiert: $date';
  }

  @override
  String get statistics => 'Statistiken';

  @override
  String get totalRatings => 'Bewertungen gesamt';

  @override
  String get averageScore => 'Durchschnitt';

  @override
  String get searchMoviesAndSeries => 'Filme & Serien suchen';

  @override
  String get searchPlaces => 'Orte suchen';

  @override
  String get searchBooks => 'Bücher suchen';

  @override
  String get tmdbTitle => 'TMDB (Filme & Serien)';

  @override
  String get tmdbDescription =>
      'Um nach Filmen und Serien zu suchen, benötigst du einen kostenlosen TMDB-API-Schlüssel. Registriere dich auf themoviedb.org und erstelle einen API-Schlüssel in deinen Kontoeinstellungen.';

  @override
  String get apiKeyConfigured => 'API-Schlüssel konfiguriert';

  @override
  String get removeKey => 'Entfernen';

  @override
  String get enterTmdbApiKey => 'TMDB-API-Schlüssel eingeben';

  @override
  String get tmdbApiKeySaved => 'TMDB-API-Schlüssel gespeichert';

  @override
  String get placesTitle => 'Orte (Nominatim)';

  @override
  String get placesDescription =>
      'Die Ortssuche nutzt den Nominatim-Dienst von OpenStreetMap. Kein API-Schlüssel erforderlich.';

  @override
  String get readyToUse => 'Einsatzbereit';

  @override
  String errorPrefix(String error) {
    return 'Fehler: $error';
  }

  @override
  String get movie => 'Film';

  @override
  String get series => 'Serie';

  @override
  String get tagProduct => 'Produkt';

  @override
  String get tagBook => 'Buch';

  @override
  String get tagMovie => 'Film';

  @override
  String get tagSeries => 'Serie';

  @override
  String get tagPlace => 'Ort';

  @override
  String get tagUrl => 'URL';

  @override
  String get tagFood => 'Essen';

  @override
  String get tagMusic => 'Musik';

  @override
  String get tagGame => 'Spiel';

  @override
  String get tagApp => 'App';

  @override
  String get tagMagazine => 'Zeitschrift';

  @override
  String get tagOther => 'Sonstiges';

  @override
  String get dataTitle => 'Daten';

  @override
  String get exportRatings => 'JSON exportieren';

  @override
  String get importRatings => 'JSON importieren';

  @override
  String exportSuccess(int count) {
    return '$count Bewertungen exportiert';
  }

  @override
  String importSuccess(int imported, int skipped) {
    return '$imported importiert, $skipped übersprungen';
  }

  @override
  String get importError =>
      'Datei konnte nicht gelesen werden. Bitte stelle sicher, dass es eine gültige Exportdatei ist.';

  @override
  String get noRatingsToExport => 'Keine Bewertungen zum Exportieren';

  @override
  String get sortNewest => 'Neueste zuerst';

  @override
  String get sortOldest => 'Älteste zuerst';

  @override
  String get sortHighest => 'Liebe zuerst';

  @override
  String get sortLowest => 'Nope zuerst';

  @override
  String get sortAZ => 'A – Z';

  @override
  String get sortZA => 'Z – A';

  @override
  String get exportCsv => 'CSV exportieren';

  @override
  String get onboardingSubtitle =>
      'Scanne einen Barcode, suche nach einem Film, Buch oder Ort – oder füge alles manuell hinzu.';

  @override
  String get getStarted => 'Los geht\'s';

  @override
  String get rateNowPlaying => 'Gerade gesehen';

  @override
  String get rateNowPlayingSubtitle => 'Netflix, Prime & mehr';

  @override
  String get notificationPermissionTitle => 'Benachrichtigungszugriff benötigt';

  @override
  String get notificationPermissionBody =>
      'Um zu erkennen, was du gerade schaust, erlaube den Benachrichtigungszugriff in den Einstellungen.';

  @override
  String get openSettings => 'Einstellungen öffnen';

  @override
  String get nothingPlaying => 'Aktuell wird nichts abgespielt';

  @override
  String get levelNope => 'Nope';

  @override
  String get levelNaja => 'Naja';

  @override
  String get levelOkay => 'Okay';

  @override
  String get levelGood => 'Gut';

  @override
  String get levelLove => 'Liebe';

  @override
  String get levelNopePhrase => 'Nie wieder';

  @override
  String get levelNajaPhrase => 'Eher nicht';

  @override
  String get levelOkayPhrase => 'Kann man machen';

  @override
  String get levelGoodPhrase => 'Gerne wieder';

  @override
  String get levelLovePhrase => 'Absoluter Liebling';

  @override
  String get filterAll => 'Alle';

  @override
  String get filterByLevel => 'Nach Stufe filtern';

  @override
  String homeSummary(int count, int loved) {
    return '$count Dinge bewertet – $loved davon liebst du.';
  }

  @override
  String homeSummaryShort(int count) {
    return '$count Dinge bewertet';
  }

  @override
  String get search => 'Suchen';

  @override
  String get sort => 'Sortieren';

  @override
  String get showResults => 'Anzeigen';

  @override
  String get newRating => 'Neue Bewertung';

  @override
  String get whatToRate => 'Was möchtest du bewerten?';

  @override
  String get howWasIt => 'Wie fandest du’s?';

  @override
  String get category => 'Kategorie';

  @override
  String get editRating => 'Bewertung ändern';

  @override
  String ratedOn(String date) {
    return 'bewertet am $date';
  }

  @override
  String get source => 'Quelle';

  @override
  String get barcodeLabel => 'Barcode';

  @override
  String get sortNewestHint => 'Zuletzt bewertet oben';

  @override
  String get sortOldestHint => 'Deine ersten Bewertungen oben';

  @override
  String get sortHighestHint => 'Deine Lieblinge oben';

  @override
  String get sortLowestHint => 'Was du nie wieder willst';

  @override
  String get sortAZHint => 'Alphabetisch';

  @override
  String get sortZAHint => 'Alphabetisch rückwärts';

  @override
  String get yourBalance => 'Deine Bilanz';

  @override
  String ratingsCount(int count) {
    return '$count Bewertungen';
  }

  @override
  String get servicesTitle => 'Dienste';

  @override
  String get moviesSeries => 'Filme & Serien';

  @override
  String get tmdbNeedsKey => 'Kostenloser TMDB-Schlüssel nötig';

  @override
  String get tmdbConnected => 'Verbunden über TMDB';

  @override
  String get setUp => 'Einrichten';

  @override
  String get ready => 'Bereit';

  @override
  String get placesShort => 'Orte';

  @override
  String get placesSubtitle => 'OpenStreetMap, ohne Schlüssel';

  @override
  String get exportJsonLong => 'Als JSON exportieren';

  @override
  String get exportCsvLong => 'Als CSV exportieren';

  @override
  String get nothingInLevel => 'Hier ist noch nichts';

  @override
  String get nothingInLevelSubtitle =>
      'Sobald du etwas so bewertest, taucht es hier auf.';

  @override
  String get rateAction => 'Bewerten';

  @override
  String get today => 'heute';

  @override
  String get yesterday => 'gestern';

  @override
  String get close => 'Schließen';

  @override
  String get back => 'Zurück';

  @override
  String get share => 'Teilen';

  @override
  String get edit => 'Bearbeiten';

  @override
  String get addCategory => 'Hinzufügen';

  @override
  String get pickALevel => 'Tippe auf eine Stufe';

  @override
  String get aboutTitle => 'Über';

  @override
  String get privacyPolicy => 'Datenschutz';

  @override
  String get version => 'Version';
}
