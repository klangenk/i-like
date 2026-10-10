import 'dart:convert';
import 'package:http/http.dart' as http;

/// Normalised result of a book/product/game lookup, used to prefill a rating.
typedef LookupInfo = ({
  String title,
  String imageUrl,
  List<String> tags,
  String sourceUrl,
  String creator,
  String year,
});

/// First four-digit year in [value] ("June 12, 1995" -> "1995"), or ''.
String yearFrom(Object? value) =>
    RegExp(r'\b(1[5-9]\d\d|20\d\d)\b').firstMatch('${value ?? ''}')?.group(1) ?? '';

class ApiService {
  static const _openLibraryBase = 'https://openlibrary.org';
  static const _openFoodFactsBase = 'https://world.openfoodfacts.org/api/v0';
  static const _tmdbBase = 'https://api.themoviedb.org/3';
  static const _nominatimBase = 'https://nominatim.openstreetmap.org';

  // --- Open Library ---

  static Future<Map<String, dynamic>?> lookupIsbn(String isbn) async {
    try {
      final response = await http.get(
        Uri.parse('$_openLibraryBase/api/books?bibkeys=ISBN:$isbn&format=json&jscmd=data'),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final key = 'ISBN:$isbn';
        if (data.containsKey(key)) {
          return data[key] as Map<String, dynamic>;
        }
      }
    } catch (_) {}
    return null;
  }

  static Future<List<Map<String, dynamic>>> searchBooks(String query) async {
    try {
      final response = await http.get(
        Uri.parse('$_openLibraryBase/search.json?q=${Uri.encodeComponent(query)}&limit=10'),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final docs = data['docs'] as List<dynamic>? ?? [];
        return docs.cast<Map<String, dynamic>>();
      }
    } catch (_) {}
    return [];
  }

  // --- OpenFoodFacts ---

  static Future<Map<String, dynamic>?> lookupBarcode(String barcode) async {
    try {
      final response = await http.get(
        Uri.parse('$_openFoodFactsBase/product/$barcode.json'),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        if (data['status'] == 1) {
          return data['product'] as Map<String, dynamic>;
        }
      }
    } catch (_) {}
    return null;
  }

  // --- TMDB ---

  static Future<List<Map<String, dynamic>>> searchMovies(
      String query, String apiKey) async {
    if (apiKey.isEmpty) return [];
    try {
      final response = await http.get(
        Uri.parse(
          '$_tmdbBase/search/movie?api_key=$apiKey&query=${Uri.encodeComponent(query)}&language=en-US&page=1',
        ),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final results = data['results'] as List<dynamic>? ?? [];
        return results.cast<Map<String, dynamic>>();
      }
    } catch (_) {}
    return [];
  }

  static Future<List<Map<String, dynamic>>> searchTv(
      String query, String apiKey) async {
    if (apiKey.isEmpty) return [];
    try {
      final response = await http.get(
        Uri.parse(
          '$_tmdbBase/search/tv?api_key=$apiKey&query=${Uri.encodeComponent(query)}&language=en-US&page=1',
        ),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final results = data['results'] as List<dynamic>? ?? [];
        return results.cast<Map<String, dynamic>>();
      }
    } catch (_) {}
    return [];
  }

  /// Search both movies and TV shows at once
  static Future<List<Map<String, dynamic>>> searchTmdb(
      String query, String apiKey) async {
    if (apiKey.isEmpty) return [];
    try {
      final response = await http.get(
        Uri.parse(
          '$_tmdbBase/search/multi?api_key=$apiKey&query=${Uri.encodeComponent(query)}&language=en-US&page=1',
        ),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final results = data['results'] as List<dynamic>? ?? [];
        // Only keep movie and tv results
        return results
            .cast<Map<String, dynamic>>()
            .where((r) => r['media_type'] == 'movie' || r['media_type'] == 'tv')
            .toList();
      }
    } catch (_) {}
    return [];
  }

  // --- Nominatim (Places) ---

  static Future<List<Map<String, dynamic>>> searchPlaces(String query) async {
    try {
      final response = await http.get(
        Uri.parse(
          '$_nominatimBase/search?q=${Uri.encodeComponent(query)}&format=json&limit=10&addressdetails=1',
        ),
        headers: {'User-Agent': 'ILikeApp/1.0'},
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List<dynamic>;
        return data.cast<Map<String, dynamic>>();
      }
    } catch (_) {}
    return [];
  }

  // --- Info Extractors ---

  static LookupInfo extractBookInfo(
      Map<String, dynamic> data) {
    // Handles both ISBN lookups (jscmd=data) and search results (search.json).
    final title = data['title'] as String? ?? 'Unknown Book';
    final cover = data['cover'] as Map<String, dynamic>?;
    final coverId = data['cover_i'];
    final imageUrl = cover?['medium'] as String? ??
        (coverId != null ? 'https://covers.openlibrary.org/b/id/$coverId-L.jpg' : '');
    final sourceUrl = (data['url'] as String?) ??
        (data['key'] != null ? '$_openLibraryBase${data['key']}' : '');
    final authors = [
      for (final a in data['authors'] as List<dynamic>? ?? const [])
        if (a is Map && a['name'] is String) a['name'] as String,
      for (final a in data['author_name'] as List<dynamic>? ?? const []) '$a',
    ];
    return (
      title: title,
      imageUrl: imageUrl,
      tags: ['book'],
      sourceUrl: sourceUrl,
      creator: authors.take(2).join(', '),
      year: yearFrom(data['first_publish_year'] ?? data['publish_date']),
    );
  }

  static LookupInfo extractProductInfo(
      Map<String, dynamic> data) {
    final title = data['product_name'] as String? ?? 'Unknown Product';
    final imageUrl = data['image_url'] as String? ?? '';
    final brand = (data['brands'] as String? ?? '').split(',').first.trim();
    return (
      title: title,
      imageUrl: imageUrl,
      tags: ['product', 'food'],
      sourceUrl: '',
      creator: brand,
      year: '',
    );
  }

  static LookupInfo extractTmdbInfo(
      Map<String, dynamic> data) {
    final mediaType = data['media_type'] as String? ?? 'movie';
    final title = (data['title'] ?? data['name'] ?? 'Unknown') as String;
    final posterPath = data['poster_path'] as String?;
    final imageUrl =
        posterPath != null ? 'https://image.tmdb.org/t/p/w342$posterPath' : '';
    final tag = mediaType == 'tv' ? 'series' : 'movie';
    final id = data['id'];
    final sourceUrl = id != null
        ? 'https://www.themoviedb.org/${mediaType == 'tv' ? 'tv' : 'movie'}/$id'
        : '';
    return (
      title: title,
      imageUrl: imageUrl,
      tags: [tag],
      sourceUrl: sourceUrl,
      creator: '',
      year: yearFrom(data['release_date'] ?? data['first_air_date']),
    );
  }

  static LookupInfo extractPlaceInfo(
      Map<String, dynamic> data) {
    final title = data['display_name'] as String? ?? 'Unknown Place';
    final osmType = data['osm_type'] as String? ?? '';
    final osmId = data['osm_id'];
    final sourceUrl = (osmType.isNotEmpty && osmId != null)
        ? 'https://www.openstreetmap.org/$osmType/$osmId'
        : '';
    return (title: title, imageUrl: '', tags: ['place'], sourceUrl: sourceUrl, creator: '', year: '');
  }

  /// Reverse geocode coordinates to a place name
  static Future<Map<String, dynamic>?> reverseGeocode(double lat, double lon) async {
    try {
      final response = await http.get(
        Uri.parse(
          '$_nominatimBase/reverse?lat=$lat&lon=$lon&format=json&addressdetails=1',
        ),
        headers: {'User-Agent': 'ILikeApp/1.0'},
      );
      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      }
    } catch (_) {}
    return null;
  }

  /// Find nearby POIs (restaurants, shops, cafes, etc.) using Overpass API
  static Future<List<Map<String, dynamic>>> nearbyPois(double lat, double lon, {int radiusMeters = 200}) async {
    try {
      final query = '''
[out:json][timeout:10];
(
  node["name"]["amenity"](around:$radiusMeters,$lat,$lon);
  node["name"]["shop"](around:$radiusMeters,$lat,$lon);
  node["name"]["tourism"](around:$radiusMeters,$lat,$lon);
  node["name"]["leisure"](around:$radiusMeters,$lat,$lon);
);
out body;
''';
      final response = await http.post(
        Uri.parse('https://overpass-api.de/api/interpreter'),
        body: {'data': query},
        headers: {'User-Agent': 'ILikeApp/1.0'},
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final elements = data['elements'] as List<dynamic>? ?? [];
        return elements.cast<Map<String, dynamic>>();
      }
    } catch (_) {}
    return [];
  }

  /// Extract a short display name from an Overpass POI element
  static String poiDisplayName(Map<String, dynamic> element) {
    final tags = element['tags'] as Map<String, dynamic>? ?? {};
    return tags['name'] as String? ?? 'Unknown';
  }

  /// Extract the type/category of a POI
  static String poiType(Map<String, dynamic> element) {
    final tags = element['tags'] as Map<String, dynamic>? ?? {};
    return (tags['amenity'] ?? tags['shop'] ?? tags['tourism'] ?? tags['leisure'] ?? '') as String;
  }

  // --- Board Games (via Wikipedia) ---

  /// Search board games via Wikipedia. Restricting to articles that use the
  /// "Infobox game" template filters out designers, lists and other noise;
  /// falls back to a plain search when nothing matches.
  static Future<List<Map<String, dynamic>>> searchBoardGames(String query) async {
    final games = await _searchWikipedia('$query hastemplate:"Infobox game"');
    if (games.isNotEmpty) return games;
    return _searchWikipedia('$query board game');
  }

  /// One request returns titles, a short intro and a thumbnail per hit, so
  /// the result list can show images without extra lookups.
  static Future<List<Map<String, dynamic>>> _searchWikipedia(String searchQuery) async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://en.wikipedia.org/w/api.php?action=query&format=json'
          '&generator=search&gsrsearch=${Uri.encodeComponent(searchQuery)}&gsrlimit=10'
          // pilicense=any: box art is non-free, so the default (free-only) skips it.
          '&prop=pageimages|extracts&piprop=thumbnail&pithumbsize=600&pilicense=any'
          '&exintro=1&explaintext=1&exsentences=2&exlimit=max',
        ),
        headers: {'User-Agent': 'ILikeApp/1.0'},
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final pages = (data['query']?['pages'] as Map<String, dynamic>? ?? {})
            .values
            .cast<Map<String, dynamic>>()
            .toList()
          ..sort((a, b) => (a['index'] as int? ?? 0).compareTo(b['index'] as int? ?? 0));
        return [
          for (final page in pages)
            {
              'title': page['title'] as String? ?? '',
              'snippet': page['extract'] as String? ?? '',
              'image': (page['thumbnail'] as Map<String, dynamic>?)?['source'] as String? ?? '',
            },
        ];
      }
    } catch (_) {}
    return [];
  }

  /// "Azul (board game)" -> "Azul"
  static String cleanGameTitle(String title) =>
      title.replaceFirst(RegExp(r'\s*\((board |card |tabletop )?game\)$'), '');

  /// Image, designer and release year for a Wikipedia board game article.
  static Future<Map<String, dynamic>?> getBoardGameDetails(String pageTitle) async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://en.wikipedia.org/w/api.php?action=query&format=json&formatversion=2'
          '&titles=${Uri.encodeComponent(pageTitle)}'
          // pilicense=any: box art is non-free, so the default (free-only) skips it.
          '&prop=pageimages|revisions&pithumbsize=600&pilicense=any'
          '&rvprop=content&rvslots=main&rvsection=0',
        ),
        headers: {'User-Agent': 'ILikeApp/1.0'},
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final pages = data['query']?['pages'] as List<dynamic>? ?? const [];
        for (final page in pages.cast<Map<String, dynamic>>()) {
          if (page['missing'] == true) continue;
          final revisions = page['revisions'] as List<dynamic>? ?? const [];
          final wikitext = revisions.isEmpty
              ? ''
              : (revisions.first['slots']?['main']?['content'] as String? ?? '');
          return {
            'name': page['title'] as String? ?? '',
            'image': (page['thumbnail'] as Map<String, dynamic>?)?['source'] as String? ?? '',
            'designer': _cleanWikiValue(_infoboxField(wikitext, 'designer')),
            'year': yearFrom(_infoboxField(wikitext, 'date') ?? _infoboxField(wikitext, 'years')),
          };
        }
      }
    } catch (_) {}
    return null;
  }

  /// Raw value of `| field = …` in an infobox, including continuation lines
  /// (e.g. `{{plainlist|` blocks) up to the next field.
  static String? _infoboxField(String wikitext, String field) {
    final match = RegExp(
      r'^\s*\|\s*' + field + r'\s*=([\s\S]*?)(?=^\s*\|\s*[\w ]+=|^\}\})',
      multiLine: true,
    ).firstMatch(wikitext);
    final value = match?.group(1)?.trim();
    return (value == null || value.isEmpty) ? null : value;
  }

  /// `[[Klaus Teuber]]<ref>…</ref>` -> `Klaus Teuber`
  static String _cleanWikiValue(String? raw) {
    if (raw == null) return '';
    var v = raw
        .replaceAll(RegExp(r'<ref[^>]*/>'), '')
        .replaceAll(RegExp(r'<ref[\s\S]*?</ref>'), '')
        .replaceAll(RegExp(r'<br\s*/?>'), ', ')
        .replaceAllMapped(RegExp(r'\[\[(?:[^|\]]*\|)?([^\]]+)\]\]'), (m) => m.group(1)!)
        .replaceAll(RegExp(r'\{\{[^{}]*\|'), '')
        .replaceAll(RegExp(r'[{}]'), '')
        .replaceAll("''", '')
        .replaceAll(RegExp(r'^\s*\*\s*', multiLine: true), '')
        .replaceAll(RegExp(r'\s*\n\s*'), ', ')
        .trim();
    v = v.replaceAll(RegExp(r'^,\s*|,\s*$'), '');
    return v.length > 80 ? '${v.substring(0, 77)}…' : v;
  }

  static LookupInfo extractBoardGameInfo(
      Map<String, dynamic> data) {
    final pageTitle = data['name'] as String? ?? 'Unknown Game';
    final imageUrl = data['image'] as String? ?? '';
    final sourceUrl = pageTitle.isNotEmpty
        ? 'https://en.wikipedia.org/wiki/${Uri.encodeComponent(pageTitle.replaceAll(' ', '_'))}'
        : '';
    return (
      title: cleanGameTitle(pageTitle),
      imageUrl: imageUrl,
      tags: ['game'],
      sourceUrl: sourceUrl,
      creator: data['designer'] as String? ?? '',
      year: data['year'] as String? ?? '',
    );
  }

  // --- General Barcode Lookup (UPC Item DB) ---

  /// Look up any barcode via UPC Item DB (free trial, no key needed)
  static Future<Map<String, dynamic>?> lookupBarcodeGeneral(String barcode) async {
    try {
      final response = await http.get(
        Uri.parse('https://api.upcitemdb.com/prod/trial/lookup?upc=$barcode'),
        headers: {'User-Agent': 'ILikeApp/1.0'},
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final items = data['items'] as List<dynamic>? ?? [];
        if (items.isNotEmpty) {
          return items.first as Map<String, dynamic>;
        }
      }
    } catch (_) {}
    return null;
  }

  static LookupInfo extractGeneralProductInfo(
      Map<String, dynamic> data) {
    final title = data['title'] as String? ?? 'Unknown Product';
    final images = data['images'] as List<dynamic>? ?? [];
    final imageUrl = images.isNotEmpty ? images.first as String : '';
    final category = (data['category'] as String? ?? '').toLowerCase();
    final tags = <String>['product'];
    if (category.contains('game') || category.contains('toy') || category.contains('puzzle')) {
      tags
        ..clear()
        ..add('game');
    }
    return (
      title: title,
      imageUrl: imageUrl,
      tags: tags,
      sourceUrl: '',
      creator: (data['brand'] as String? ?? '').trim(),
      year: '',
    );
  }
}
