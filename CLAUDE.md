# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

"I Like" (`de.langenk.ilike`): a Flutter app for rating anything (products, books, films, series, places, links). All data stays on the device in SQLite. There are no accounts and no server. It ships on Google Play, and Android is the platform that matters most: share target, Quick Settings tile and Auto Backup are Android-only. The UI is in German and English.
## Commands

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs   # after changing Drift tables/DAO (regenerates app_database.g.dart)
flutter gen-l10n                                            # after editing lib/l10n/*.arb (also runs on flutter run/build)
flutter analyze
flutter test                                                # all tests
flutter test test/shared_link_test.dart                     # one file
flutter test --plain-name "some test name"                  # one test
flutter build appbundle --release --dart-define=BGG_TOKEN=$BGG_TOKEN   # -> build/app/outputs/bundle/release/app-release.aab
```

Release signing reads `android/key.properties` (gitignored). Without that file, release builds fall back to debug signing.

The BoardGameGeek token (how to register: boardgamegeek.com/using_the_xml_api) is never committed. It is passed with `--dart-define=BGG_TOKEN=…`; builds without it search board games on Wikipedia only. BGG's terms require the "Powered by BGG" logo wherever its results show: the official file belongs in `assets/bgg/powered_by_bgg.png`, and without it the search dialog shows a text credit.

### Releasing to Google Play
- Bump `version:` in `pubspec.yaml` (`1.0.N+build`, and increment both parts). Then update `store/release-notes/{de-DE,en-US}.txt`.
- `tool/play_publish.py` uses the Android Publisher API. It needs `google-auth` and a service-account key from `--key` or `$PLAY_SERVICE_ACCOUNT_JSON`. Without `--commit`, it validates the edit and then discards it. `--status` shows the current state on Play.
- Usual flow: upload to `--track internal --commit`, then promote with `--version-code N --track alpha --commit`. Production commits also need `--yes-production`. Use it only when the owner explicitly asks for a production release in that conversation.
- Store listings and images live in `store/listings/<lang>/`. To regenerate screenshots, render them with `test/store_shots_test.dart` (`--update-goldens --dart-define=STORE_SHOTS=true --dart-define=LANG=de|en`, skipped in normal runs) and then run `python tool/store_screenshots.py`. The docstring in that script has the full steps.
- Commit messages follow the pattern "Do X, do Y, release 1.0.N".

## Architecture

The structure is feature-first: `lib/core/` (database, router, theme, utils, backup), `lib/features/<feature>/` (screen + Riverpod provider) and `lib/shared/widgets/`.

**Data model.** Drift tables in `lib/core/database/app_database.dart`: `Ratings` (via `RatingsDao`) plus `RatingLists` / `ListEntries` (via `ListsDao`, schema v4). Things to know:
- `score` is a real that holds integers 1–5. `0` means unrated, which is the "to try" (Later) list: it is excluded from counts and averages and sorted last.
- `tags` is a single comma-separated string. Built-in tags are stored as English keys (`product`, `book`, `movie`, `food`, …) and shown through `localizedTagName` in `lib/core/utils/tag_l10n.dart`. Unknown tags are user-created custom tags and keep their case.
- `localImagePath` is a downloaded copy of `imageUrl` (`lib/core/utils/image_store.dart`). Display code should prefer it because remote URLs go stale.
- Schema changes: add the column, bump `schemaVersion` and add an `if (from < N)` step in `onUpgrade`. The doc comment in `app_database.dart` describes this, and existing users' databases depend on it.
- A list entry links to a rating (`ratingId`, set null when the rating is deleted) or is free text; `label` always holds the text. Lists say what to do with things (shopping, gifts); tags say what they are. Lists are filled mainly from existing ratings (`features/lists/`: rating picker sheet, "add to list" sheet on the detail page).
- The JSON export/import format (`features/settings/export_import_service.dart`) is versioned (`version: 1`). Keep it compatible. It does not include lists yet.

**Rating levels.** `RatingLevel` (`lib/core/theme/rating_level.dart`) maps score 1–5 onto Nope / Naja / Okay / Gut / Liebe and holds the colours for each level. Always go through this enum and never through raw stars or numbers in the UI.

**State.** Riverpod 2 (`Provider`, `StateProvider`, `StateNotifierProvider`, `StreamProvider`). `databaseProvider` and `sharedPreferencesProvider` are created in `main()` and injected through `ProviderScope` overrides. The core providers live in `features/home/home_provider.dart`: `ratingsProvider` streams the whole table, and `filteredRatingsProvider` applies search, tag, level, to-try and sort in memory. `PersistedController` keeps sort, grouping and category filter in SharedPreferences.

**Ways in to add a rating.** Every path ends at `/add` with a `PrefillData` that goes into `addRatingProvider`:
- Android share intent, handled in `main.dart`. It navigates right away with what it has, then resolves the URL and fetches metadata in the background, and pushes updates into the notifier.
- Quick Settings tile / shortcut over the MethodChannel `de.langenk.ilike/shortcuts` (`QuickAddTileService.kt`, `MainActivity.kt`), which opens `quick_add_sheet.dart`.
- Barcode scanner. An already-rated barcode shows `known_barcode_sheet.dart` first.
- Book and board-game searches inside the quick-add sheet. Board games come from Wikipedia and BoardGameGeek together (`searchBoardGames`), with exact title matches first. `map_screen.dart` (the `/map` route) and the TMDB, Nominatim and Overpass calls in `api_service.dart` are still in the code, but nothing in the UI reaches them any more.
- Photo: on-device ML Kit OCR and labelling (`photo_insights.dart`) suggest a title and category.

**Lookups.** `lib/core/utils/api_service.dart` is static calls to free APIs: Open Library, DNB (German ISBNs, parsed from XML), Open Food/Beauty/Products Facts, Wikipedia and BoardGameGeek (board games; BGG needs `BGG_TOKEN`), plus the unused TMDB, Nominatim and Overpass calls. Every request sends `ApiService.userAgent`, which carries a contact URL, because Wikimedia throttles generic User-Agents. `lib/core/utils/url_helper.dart` covers link handling: resolving short URLs, scraping metadata including JSON-LD, falling back to Microlink for pages behind bot checks, pulling titles out of app share text (Amazon, Netflix) and guessing tags from URLs. `barcode_helper.dart` classifies EAN/ISBN/magazine codes. Most unit tests cover these parsers and use fixtures in `test/fixtures/`.

**Backup.** `lib/core/backup/backup_service.dart` is opt-in and Android-only. While it is on, it mirrors the database and photos (up to 20 MB) into `files/ilike_backup/`, the only path the Auto Backup rules include (`android/app/src/main/res/xml/*backup*`). On a fresh install, `restoreIfNeeded` runs *before* the database opens and rewrites the photo paths.

**Localisation.** The ARB template is `lib/l10n/app_en.arb`, with `app_de.arb` alongside. Add every new string to both. The generated `app_localizations*.dart` files are committed. The user-facing tone is casual German ("du").

**Privacy docs.** `PRIVACY.md` (de) and `PRIVACY.en.md` are bundled as assets and shown in the app. Update both, plus the store descriptions, whenever a feature changes which data leaves the device or gets stored.
