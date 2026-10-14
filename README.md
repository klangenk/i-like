# I Like

A Flutter app for rating anything: products, groceries, wine, books, board games, films, restaurants, links. Everything stays on the device in SQLite. There are no accounts, no ads and no tracking.

Available on Google Play as `de.langenk.ilike`.

## Features

### Rating
- Rate in words instead of stars, on five levels: **Nope · Naja (Meh) · Okay · Gut (Good) · Liebe (Love)**
- A **"to try" list**: save something now and rate it later
- Author, maker or brand and year for every rating, plus notes and a photo
- Built-in categories (product, food, book, film, series, game, music, magazine, place, …) and your own custom ones

### Quick add
- **Barcode scanning**: products (Open Food/Beauty/Products Facts), books by ISBN (Open Library, and the German National Library for German titles) and magazines. Scanning something you have already rated shows your earlier verdict first.
- **Share target**: share a link from any app (browser, Amazon, Netflix, …)
  - resolves short URLs (amzn.eu, bit.ly, …)
  - reads the title and image from page metadata and JSON-LD, and falls back to Microlink for pages behind bot checks
  - takes product titles from app share text and guesses the category from the URL
- **Search** for books (Open Library) and board games (Wikipedia), with covers in the results
- **Own photo**: on-device text recognition and image labelling (ML Kit) suggest a title and category
- **Quick Settings tile** and app shortcut that open quick add
- Manual entry

### Browsing
- Photo grid of all your ratings
- Filter by level, by category or to the "to try" list
- Sort by date, level or name, and group by category. These settings are remembered.
- Search across titles, makers, categories and notes
- Your balance: how your ratings are spread across the levels
- Share a rating as an image card

### Your data
- Ratings and photos are stored only on the device
- Optional backup to your own Google account through Android Auto Backup (off by default)
- Export as JSON or CSV, import from JSON
- Privacy policy in the app ([German](PRIVACY.md), [English](PRIVACY.en.md))

### Other
- German and English UI, following the device language
- Light and dark theme

## Tech stack

- **Flutter** with Material 3, Schibsted Grotesk font
- **Drift** (SQLite) for local storage
- **Riverpod** for state management
- **GoRouter** for navigation
- **mobile_scanner** for barcode scanning; **google_mlkit_text_recognition** and **google_mlkit_image_labeling** for photo suggestions
- **receive_sharing_intent** for the Android share target
- **cached_network_image**, **share_plus**, **file_picker**, **in_app_review**
- APIs (no keys needed): Open Library, DNB, Open Food/Beauty/Products Facts, Wikipedia, Microlink

## Getting started

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```

Run `flutter test` for the tests and `flutter analyze` for the linter.

### Release builds

```bash
flutter build appbundle --release
```

Signing reads `android/key.properties` (not in the repo). Without it, release builds are signed with the debug key.

Store listings, screenshots and release notes are in `store/`. `tool/play_publish.py` uploads builds and listings through the Google Play Developer API. `tool/store_screenshots.py` builds the store screenshots. Each script's docstring explains how to use it.

## Project structure

```
lib/
├── core/
│   ├── backup/         # Optional Android Auto Backup
│   ├── database/       # Drift database & DAO
│   ├── router/         # GoRouter configuration
│   ├── theme/          # Material 3 theme, colours, rating levels
│   └── utils/          # API lookups, URL & barcode helpers, image store, photo insights
├── features/
│   ├── add_rating/     # Add screen, quick-add sheet, barcode scanner
│   ├── detail/         # Rating detail, inline edit, share card
│   ├── home/           # Grid, filters, sorting, grouping, search, welcome
│   └── settings/       # Backup, export/import, privacy policy
├── shared/widgets/     # Level badge, rating image, photo picker, …
├── l10n/               # ARB files & generated localizations
└── main.dart           # Entry point, share intent & Quick Settings tile handling
store/                  # Play Store listings, screenshots, release notes
tool/                   # Play publishing & screenshot scripts
```
