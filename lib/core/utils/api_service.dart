import 'dart:convert';
import 'package:http/http.dart' as http;
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

  static ({String title, String imageUrl, List<String> tags, String sourceUrl}) extractBookInfo(
      Map<String, dynamic> data) {
    final title = data['title'] as String? ?? 'Unknown Book';
    final cover = data['cover'] as Map<String, dynamic>?;
    final imageUrl = cover?['medium'] as String? ?? '';
    final sourceUrl = (data['url'] as String?) ??
        (data['key'] != null ? '$_openLibraryBase${data['key']}' : '');
    return (title: title, imageUrl: imageUrl, tags: ['book'], sourceUrl: sourceUrl);
  }

  static ({String title, String imageUrl, List<String> tags, String sourceUrl}) extractProductInfo(
      Map<String, dynamic> data) {
    final title = data['product_name'] as String? ?? 'Unknown Product';
    final imageUrl = data['image_url'] as String? ?? '';
    return (title: title, imageUrl: imageUrl, tags: ['product', 'food'], sourceUrl: '');
  }

  static ({String title, String imageUrl, List<String> tags, String sourceUrl}) extractTmdbInfo(
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
    return (title: title, imageUrl: imageUrl, tags: [tag], sourceUrl: sourceUrl);
  }

  static ({String title, String imageUrl, List<String> tags, String sourceUrl}) extractPlaceInfo(
      Map<String, dynamic> data) {
    final title = data['display_name'] as String? ?? 'Unknown Place';
    final osmType = data['osm_type'] as String? ?? '';
    final osmId = data['osm_id'];
    final sourceUrl = (osmType.isNotEmpty && osmId != null)
        ? 'https://www.openstreetmap.org/$osmType/$osmId'
        : '';
    return (title: title, imageUrl: '', tags: ['place'], sourceUrl: sourceUrl);
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

  /// Search board games via Wikipedia
  static Future<List<Map<String, dynamic>>> searchBoardGames(String query) async {
    try {
      // Search Wikipedia with "board game" or "card game" appended for better results
      final searchQuery = '$query board game';
      final response = await http.get(
        Uri.parse(
          'https://en.wikipedia.org/w/api.php?action=query&list=search'
          '&srsearch=${Uri.encodeComponent(searchQuery)}'
          '&format=json&srlimit=10',
        ),
        headers: {'User-Agent': 'ILikeApp/1.0'},
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final results = data['query']?['search'] as List<dynamic>? ?? [];
        return results.cast<Map<String, dynamic>>();
      }
    } catch (_) {}
    return [];
  }

  /// Get board game image from Wikipedia by page title
  static Future<Map<String, dynamic>?> getBoardGameDetails(String pageTitle) async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://en.wikipedia.org/w/api.php?action=query'
          '&titles=${Uri.encodeComponent(pageTitle)}'
          '&prop=pageimages|extracts&pithumbsize=400&exintro=1&explaintext=1'
          '&format=json',
        ),
        headers: {'User-Agent': 'ILikeApp/1.0'},
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final pages = data['query']?['pages'] as Map<String, dynamic>? ?? {};
        for (final page in pages.values) {
          final pageData = page as Map<String, dynamic>;
          if (pageData.containsKey('missing')) continue;
          final name = pageData['title'] as String? ?? '';
          final thumbnail = pageData['thumbnail'] as Map<String, dynamic>?;
          final imageUrl = thumbnail?['source'] as String? ?? '';
          return {'name': name, 'image': imageUrl};
        }
      }
    } catch (_) {}
    return null;
  }

  static ({String title, String imageUrl, List<String> tags, String sourceUrl}) extractBoardGameInfo(
      Map<String, dynamic> data) {
    final title = data['name'] as String? ?? 'Unknown Game';
    final imageUrl = data['image'] as String? ?? '';
    final sourceUrl = title.isNotEmpty
        ? 'https://en.wikipedia.org/wiki/${Uri.encodeComponent(title)}'
        : '';
    return (title: title, imageUrl: imageUrl, tags: ['game'], sourceUrl: sourceUrl);
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

  static ({String title, String imageUrl, List<String> tags, String sourceUrl}) extractGeneralProductInfo(
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
    return (title: title, imageUrl: imageUrl, tags: tags, sourceUrl: '');
  }
}
