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
  String get searchTitle => 'Suche';

  @override
  String get settingsTitle => 'Einstellungen';

  @override
  String get detailsTitle => 'Details';

  @override
  String get addRatingTitle => 'Bewertung hinzufügen';

  @override
  String get scanBarcodeTitle => 'Barcode scannen';

  @override
  String get homeTab => 'Start';

  @override
  String get searchTab => 'Suche';

  @override
  String get noRatingsYet => 'Noch keine Bewertungen';

  @override
  String get tapToRate => 'Tippe auf + um etwas zu bewerten!';

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
  String get searchHint => 'Bewertungen durchsuchen...';

  @override
  String get searchEllipsis => 'Suchen...';

  @override
  String get pleaseEnterTitle => 'Bitte gib einen Titel ein';

  @override
  String get pleaseGiveRating => 'Bitte vergib eine Bewertung';

  @override
  String get quickAdd => 'Schnell hinzufügen (Scan, URL, ...)';

  @override
  String get howToAdd => 'Wie möchtest du hinzufügen?';

  @override
  String get scanBarcode => 'Barcode scannen';

  @override
  String get scanBarcodeSubtitle => 'Produkt- oder Buch-Barcode scannen';

  @override
  String get fromUrl => 'Von URL';

  @override
  String get fromUrlSubtitle => 'Link einfügen für automatische Details';

  @override
  String get searchMovieSeries => 'Film / Serie suchen';

  @override
  String get searchMovieSeriesSubtitle =>
      'TMDB nach Filmen & Serien durchsuchen';

  @override
  String get searchPlace => 'Ort suchen';

  @override
  String get searchPlaceSubtitle => 'Einen Ort über OpenStreetMap finden';

  @override
  String get searchBook => 'Buch suchen';

  @override
  String get searchBookSubtitle => 'Open Library nach Büchern durchsuchen';

  @override
  String get searchBoardGame => 'Brettspiel suchen';

  @override
  String get searchBoardGameSubtitle => 'BoardGameGeek durchsuchen';

  @override
  String get searchBoardGames => 'Brettspiele suchen';

  @override
  String get manualEntry => 'Manuell eingeben';

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
  String get sortHighest => 'Beste zuerst';

  @override
  String get sortLowest => 'Schlechteste zuerst';

  @override
  String get sortAZ => 'A – Z';

  @override
  String get sortZA => 'Z – A';

  @override
  String get exportCsv => 'CSV exportieren';
}
