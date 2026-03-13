# I Like

A cross-platform Flutter app for rating anything — products, books, movies, series, places, URLs. All data is stored locally via SQLite. No accounts, no cloud, no ads.

## Features

### Rating & Organization
- 5-star integer rating with tap and swipe gesture support
- Tag-based categorization with localized default tags
- Full-text search with statistics (count, average score, tag breakdown)
- Filter by tag and minimum star rating
- Swipe-to-delete with confirmation

### Quick Add
- **Barcode scanning** — automatically looks up products (OpenFoodFacts) and books (Open Library) by ISBN
- **Share target** — share URLs from any app (browser, Amazon, Netflix, etc.) to create a rating
  - Resolves shortened URLs (amzn.eu, bit.ly, etc.)
  - Extracts metadata (title, image) from the shared page
  - Auto-detects content type (product, movie, series, book, place, etc.) from the URL
  - Extracts product titles from app share text (Amazon "Angebot:", Netflix, etc.)
  - Constructs product images from Amazon ASINs when metadata scraping is blocked
- **Movie/Series search** via TMDB API (user-provided API key)
- **Place search** via interactive OpenStreetMap with nearby POI discovery (Overpass API) and Nominatim geocoding
- **Book search** via Open Library
- **URL metadata fetching** with image preview
- **Manual entry**

### Localization
- Full German and English UI
- Device language auto-detection
- Localized tag names (internal keys stay English)

### Other
- Light and dark theme with amber accent
- Cached network images for fast loading
- Share and open URL from detail view
- TMDB API key management in settings

## Tech Stack

- **Flutter** with Material 3
- **Drift** (SQLite) for local database
- **Riverpod** for state management
- **GoRouter** for navigation
- **flutter_map** + **Overpass API** for interactive map with POIs
- **Geolocator** for GPS location
- **Nominatim** for geocoding and place search
- **TMDB**, **Open Library**, **OpenFoodFacts** APIs
- **receive_sharing_intent** for Android share target
- **cached_network_image** for image caching
- **mobile_scanner** for barcode scanning

## Getting Started

```bash
flutter pub get
dart run build_runner build
flutter run
```

### API Keys

- **TMDB** — enter your API key in Settings to enable movie/series search. Get one at [themoviedb.org](https://www.themoviedb.org/settings/api).
- **Nominatim / Overpass / OpenFoodFacts / Open Library** — no key required.

## Project Structure

```
lib/
├── core/
│   ├── database/       # Drift database & DAO
│   ├── router/         # GoRouter configuration
│   ├── theme/          # Material 3 theme & colors
│   └── utils/          # API service, URL helper, barcode helper, tag l10n
├── features/
│   ├── add_rating/     # Add screen, quick-add sheet, barcode scanner, map
│   ├── detail/         # Rating detail & inline edit
│   ├── home/           # Home screen, rating cards, filter chips
│   ├── search/         # Search & statistics
│   └── settings/       # API key management
├── shared/widgets/     # Star display, tag badge, empty state
├── l10n/               # ARB files & generated localizations
└── main.dart           # Entry point & share intent handling
```
