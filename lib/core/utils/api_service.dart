import 'dart:async';
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
  /// Sent with every API request. Wikimedia and Open Library throttle clients
  /// whose User-Agent has no way to reach the developer, so it names the app's
  /// store page.
  static const userAgent =
      'ILikeApp/1.0 (https://play.google.com/store/apps/details?id=de.langenk.ilike)';
  static const _headers = {'User-Agent': userAgent};

  static const _openLibraryBase = 'https://openlibrary.org';
  static const _tmdbBase = 'https://api.themoviedb.org/3';
  static const _nominatimBase = 'https://nominatim.openstreetmap.org';

  // --- Open Library ---

  static Future<Map<String, dynamic>?> lookupIsbn(String isbn) async {
    try {
      final response = await http.get(
        Uri.parse('$_openLibraryBase/api/books?bibkeys=ISBN:$isbn&format=json&jscmd=data'),
        headers: _headers,
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

  // --- Deutsche Nationalbibliothek ---

  /// ISBN lookup in the German National Library, which knows German books
  /// that Open Library lacks. Covers come from the publishers' catalogue (MVB).
  static Future<LookupInfo?> lookupIsbnDnb(String isbn) async {
    try {
      final response = await http.get(
        Uri.https('services.dnb.de', '/sru/dnb', {
          'version': '1.1',
          'operation': 'searchRetrieve',
          'query': 'num=$isbn',
          'recordSchema': 'oai_dc',
          'maximumRecords': '1',
        }),
        headers: _headers,
      );
      if (response.statusCode != 200) return null;
      final info = parseDnbRecord(utf8.decode(response.bodyBytes));
      if (info == null) return null;

      final cover = 'https://portal.dnb.de/opac/mvb/cover?isbn=$isbn';
      final hasCover = (await http.head(Uri.parse(cover), headers: _headers)).statusCode == 200;
      return (
        title: info.title,
        imageUrl: hasCover ? cover : '',
        tags: const ['book'],
        sourceUrl: 'https://portal.dnb.de/opac.htm?method=simpleSearch&query=$isbn',
        creator: info.creator,
        year: info.year,
      );
    } catch (_) {
      return null;
    }
  }

  /// Title, authors and year from a DNB Dublin Core record, or null.
  /// DNB titles carry the whole title statement, e.g.
  /// "[Saturday requiem] ; Böser Samstag : Psychothriller / Nicci French ; …".
  static ({String title, String creator, String year})? parseDnbRecord(String xml) {
    String unescape(String s) => s
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .replaceAll('&apos;', "'")
        .replaceAll('&amp;', '&');
    List<String> field(String name) => [
      for (final m in RegExp('<dc:$name[^>]*>([^<]*)</dc:$name>').allMatches(xml))
        unescape(m.group(1)!.trim()),
    ];

    final rawTitle = field('title').firstOrNull;
    if (rawTitle == null || rawTitle.isEmpty) return null;
    var title = rawTitle.split(' / ').first.replaceAll(RegExp(r'\[[^\]]*\]\s*;?\s*'), '');
    title = title.split(' : ').first.trim();
    if (title.isEmpty) return null;

    final creators = field('creator');
    final authors = creators.where((c) => c.contains('[Verfasser]')).toList();
    final names = [
      for (final c in authors.isNotEmpty ? authors : creators.take(1))
        _personName(c.replaceAll(RegExp(r'\s*\[[^\]]*\]'), '')),
    ];
    return (
      title: title,
      creator: names.take(2).join(', '),
      year: yearFrom(field('date').firstOrNull),
    );
  }

  /// "French, Nicci" -> "Nicci French".
  static String _personName(String name) {
    final parts = name.split(', ');
    return parts.length == 2 ? '${parts[1]} ${parts[0]}'.trim() : name.trim();
  }

  static Future<List<Map<String, dynamic>>> searchBooks(String query) async {
    try {
      final response = await http.get(
        Uri.parse('$_openLibraryBase/search.json?q=${Uri.encodeComponent(query)}&limit=10'),
        headers: _headers,
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final docs = data['docs'] as List<dynamic>? ?? [];
        return docs.cast<Map<String, dynamic>>();
      }
    } catch (_) {}
    return [];
  }

  // --- Open Food / Beauty / Products Facts ---

  /// The Open*Facts databases share one API: food first, then cosmetics
  /// (sunscreen, shampoo, …), then everything else.
  static const _openFactsHosts = [
    'world.openfoodfacts.org',
    'world.openbeautyfacts.org',
    'world.openproductsfacts.org',
  ];

  /// Looks the barcode up in all Open*Facts databases at once and returns the
  /// hit from the first one in [_openFactsHosts] order, or null.
  static Future<LookupInfo?> lookupOpenFacts(String barcode) async {
    final hits = await Future.wait(_openFactsHosts.map((host) => _openFactsProduct(host, barcode)));
    for (final (i, product) in hits.indexed) {
      if (product == null) continue;
      final host = _openFactsHosts[i];
      final info = extractProductInfo(product, food: i == 0);
      if (info.title.isEmpty) continue;
      return (
        title: info.title,
        imageUrl: info.imageUrl,
        tags: info.tags,
        sourceUrl: 'https://$host/product/$barcode',
        creator: info.creator,
        year: '',
      );
    }
    return null;
  }

  static Future<Map<String, dynamic>?> _openFactsProduct(String host, String barcode) async {
    try {
      final response = await http.get(
        Uri.https(host, '/api/v0/product/$barcode.json'),
        headers: _headers,
      );
      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
        if (data['status'] == 1) return data['product'] as Map<String, dynamic>;
      }
    } catch (_) {}
    return null;
  }

  // --- TMDB ---

  static Future<List<Map<String, dynamic>>> searchMovies(String query, String apiKey) async {
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

  static Future<List<Map<String, dynamic>>> searchTv(String query, String apiKey) async {
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
  static Future<List<Map<String, dynamic>>> searchTmdb(String query, String apiKey) async {
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
        headers: _headers,
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List<dynamic>;
        return data.cast<Map<String, dynamic>>();
      }
    } catch (_) {}
    return [];
  }

  // --- Info Extractors ---

  static LookupInfo extractBookInfo(Map<String, dynamic> data) {
    // Handles both ISBN lookups (jscmd=data) and search results (search.json).
    final title = data['title'] as String? ?? 'Unknown Book';
    final cover = data['cover'] as Map<String, dynamic>?;
    final coverId = data['cover_i'];
    final imageUrl =
        cover?['medium'] as String? ??
        (coverId != null ? 'https://covers.openlibrary.org/b/id/$coverId-L.jpg' : '');
    final sourceUrl =
        (data['url'] as String?) ?? (data['key'] != null ? '$_openLibraryBase${data['key']}' : '');
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

  static LookupInfo extractProductInfo(Map<String, dynamic> data, {bool food = true}) {
    final title = [
      data['product_name_de'],
      data['product_name'],
      data['generic_name'],
    ].whereType<String>().map((s) => s.trim()).firstWhere((s) => s.isNotEmpty, orElse: () => '');
    final imageUrl = data['image_url'] as String? ?? '';
    final brand = (data['brands'] as String? ?? '').split(',').first.trim();
    return (
      title: title,
      imageUrl: imageUrl,
      tags: food ? const ['product', 'food'] : const ['product'],
      sourceUrl: '',
      creator: brand,
      year: '',
    );
  }

  static LookupInfo extractTmdbInfo(Map<String, dynamic> data) {
    final mediaType = data['media_type'] as String? ?? 'movie';
    final title = (data['title'] ?? data['name'] ?? 'Unknown') as String;
    final posterPath = data['poster_path'] as String?;
    final imageUrl = posterPath != null ? 'https://image.tmdb.org/t/p/w342$posterPath' : '';
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

  static LookupInfo extractPlaceInfo(Map<String, dynamic> data) {
    final title = data['display_name'] as String? ?? 'Unknown Place';
    final osmType = data['osm_type'] as String? ?? '';
    final osmId = data['osm_id'];
    final sourceUrl = (osmType.isNotEmpty && osmId != null)
        ? 'https://www.openstreetmap.org/$osmType/$osmId'
        : '';
    return (
      title: title,
      imageUrl: '',
      tags: ['place'],
      sourceUrl: sourceUrl,
      creator: '',
      year: '',
    );
  }

  /// Reverse geocode coordinates to a place name
  static Future<Map<String, dynamic>?> reverseGeocode(double lat, double lon) async {
    try {
      final response = await http.get(
        Uri.parse('$_nominatimBase/reverse?lat=$lat&lon=$lon&format=json&addressdetails=1'),
        headers: _headers,
      );
      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      }
    } catch (_) {}
    return null;
  }

  /// Find nearby POIs (restaurants, shops, cafes, etc.) using Overpass API
  static Future<List<Map<String, dynamic>>> nearbyPois(
    double lat,
    double lon, {
    int radiusMeters = 200,
  }) async {
    try {
      final query =
          '''
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
        headers: _headers,
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

  // --- Board Games (Wikipedia + BoardGameGeek) ---

  /// Search board games on Wikipedia and BoardGameGeek. Restricting Wikipedia
  /// to articles that use the "Infobox game" template filters out designers,
  /// lists and other noise; BGG knows the many games without an article.
  /// Falls back to a plain Wikipedia search when neither finds anything.
  static Future<List<Map<String, dynamic>>> searchBoardGames(String query) async {
    final (wikipedia, bgg) = await (
      _searchWikipedia('$query hastemplate:"Infobox game"'),
      _searchBgg(query),
    ).wait;
    final games = mergeBoardGameResults(query, wikipedia, bgg);
    if (games.isNotEmpty) return games;
    return _searchWikipedia('$query board game');
  }

  /// Wikipedia hits, then BGG hits for games Wikipedia didn't return.
  /// Exact title matches move to the top, so "Flip 7" from BGG beats
  /// Wikipedia's "Uno Flip!".
  static List<Map<String, dynamic>> mergeBoardGameResults(
    String query,
    List<Map<String, dynamic>> wikipedia,
    List<Map<String, dynamic>> bgg,
  ) {
    final seen = {for (final r in wikipedia) _gameKey(r['title'] as String? ?? '')};
    final merged = [
      ...wikipedia,
      for (final r in bgg)
        if (seen.add(_gameKey(r['title'] as String? ?? ''))) r,
    ];
    final wanted = _gameKey(query);
    bool exact(Map<String, dynamic> r) => _gameKey(r['title'] as String? ?? '') == wanted;
    return [...merged.where(exact), ...merged.where((r) => !exact(r))];
  }

  /// "Azul (board game)" and "azul" both become "azul".
  static String _gameKey(String title) =>
      cleanGameTitle(title).toLowerCase().replaceAll(RegExp(r'[^\p{L}\p{N}]+', unicode: true), '');

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
        headers: _headers,
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final pages =
            (data['query']?['pages'] as Map<String, dynamic>? ?? {}).values
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
        headers: _headers,
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

  static LookupInfo extractBoardGameInfo(Map<String, dynamic> data) {
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

  /// Prefill for a board game search result. BGG results already carry
  /// everything; Wikipedia results need the article's infobox for designer
  /// and year, with the list thumbnail as the fallback image.
  static Future<LookupInfo> boardGameInfo(Map<String, dynamic> result) async {
    if (result['source'] == 'bgg') {
      return (
        title: result['title'] as String,
        imageUrl: result['fullImage'] as String,
        tags: const ['game'],
        sourceUrl: result['url'] as String,
        creator: result['designer'] as String,
        year: result['year'] as String,
      );
    }
    final pageTitle = result['title'] as String? ?? '';
    final listImage = result['image'] as String? ?? '';
    final details = pageTitle.isEmpty ? null : await getBoardGameDetails(pageTitle);
    return extractBoardGameInfo({
      'name': pageTitle,
      ...?details,
      if ((details?['image'] as String? ?? '').isEmpty) 'image': listImage,
    });
  }

  // --- BoardGameGeek ---

  /// BGG's XML API only answers registered apps. The token is passed at
  /// build time (`--dart-define=BGG_TOKEN=…`); without it, BGG is skipped.
  static const _bggToken = String.fromEnvironment('BGG_TOKEN');

  static bool get hasBgg => _bggToken.isNotEmpty;

  static Future<List<Map<String, dynamic>>> _searchBgg(String query) async {
    if (!hasBgg) return [];
    final headers = {..._headers, 'Authorization': 'Bearer $_bggToken'};
    try {
      final search = await http.get(
        Uri.https('boardgamegeek.com', '/xmlapi2/search', {'query': query, 'type': 'boardgame'}),
        headers: headers,
      );
      if (search.statusCode != 200) return [];
      final ids = parseBggSearch(query, utf8.decode(search.bodyBytes)).take(10).toList();
      if (ids.isEmpty) return [];
      // Search hits have no images; one /thing request fetches them for all ids.
      final things = await http.get(
        Uri.https('boardgamegeek.com', '/xmlapi2/thing', {'id': ids.join(',')}),
        headers: headers,
      );
      if (things.statusCode != 200) return [];
      final games = parseBggThings(utf8.decode(things.bodyBytes));
      return games
        ..sort((a, b) => ids.indexOf(a['id'] as String).compareTo(ids.indexOf(b['id'] as String)));
    } catch (_) {}
    return [];
  }

  /// Ids from a BGG search, exact name matches first, then names starting
  /// with the query, then the rest. Expansions are dropped: `type=boardgame`
  /// still returns them.
  static List<String> parseBggSearch(String query, String xml) {
    final wanted = _gameKey(query);
    int rank(String name) {
      final key = _gameKey(name);
      return key == wanted ? 0 : (key.startsWith(wanted) ? 1 : 2);
    }

    final hits = <({String id, int rank, int index})>[];
    for (final m in RegExp(
      r'<item type="boardgame" id="(\d+)">([\s\S]*?)</item>',
    ).allMatches(xml)) {
      final name = RegExp(r'<name [^>]*value="([^"]*)"').firstMatch(m.group(2)!)?.group(1);
      if (name == null || hits.any((h) => h.id == m.group(1))) continue;
      hits.add((id: m.group(1)!, rank: rank(_unescapeXml(name)), index: hits.length));
    }
    // BGG's own order breaks ties (List.sort isn't stable).
    hits.sort((a, b) => a.rank != b.rank ? a.rank - b.rank : a.index - b.index);
    return [for (final h in hits) h.id];
  }

  /// Search results from a BGG `/thing` response, in the shape the search
  /// dialog uses (`title`, `snippet`, `image`) plus the prefill fields.
  static List<Map<String, dynamic>> parseBggThings(String xml) => [
    for (final m in RegExp(r'<item type="boardgame" id="(\d+)">([\s\S]*?)</item>').allMatches(xml))
      _bggThing(m.group(1)!, m.group(2)!),
  ];

  static Map<String, dynamic> _bggThing(String id, String item) {
    String? tag(String name) => RegExp('<$name>([^<]*)</$name>').firstMatch(item)?.group(1)?.trim();
    List<String> values(String pattern) => [
      for (final m in RegExp(pattern).allMatches(item)) _unescapeXml(m.group(1)!),
    ];

    final title = values(r'<name type="primary"[^>]*value="([^"]*)"').firstOrNull ?? '';
    final image = _unescapeXml(tag('image') ?? '');
    final thumbnail = _unescapeXml(tag('thumbnail') ?? '');
    // Line breaks come as &#10;, and HTML entities are escaped once more
    // (&amp;mdash;). The first paragraph is enough for the result list.
    final description = _unescapeXml(
      _unescapeXml(tag('description') ?? ''),
    ).split('\n').first.trim();
    final designers = values(
      r'<link type="boardgamedesigner"[^>]*value="([^"]*)"',
    ).where((d) => d != '(Uncredited)');
    return {
      'source': 'bgg',
      'id': id,
      'title': title,
      'snippet': description,
      'image': thumbnail.isNotEmpty ? thumbnail : image,
      'fullImage': image.isNotEmpty ? image : thumbnail,
      'designer': designers.take(2).join(', '),
      'year': yearFrom(RegExp(r'<yearpublished value="(\d+)"').firstMatch(item)?.group(1)),
      'url': 'https://boardgamegeek.com/boardgame/$id',
    };
  }

  static String _unescapeXml(String s) => s
      .replaceAllMapped(
        RegExp(r'&#(x[0-9a-fA-F]+|\d+);'),
        (m) => String.fromCharCode(
          m.group(1)!.startsWith('x')
              ? int.parse(m.group(1)!.substring(1), radix: 16)
              : int.parse(m.group(1)!),
        ),
      )
      .replaceAll('&lt;', '<')
      .replaceAll('&gt;', '>')
      .replaceAll('&quot;', '"')
      .replaceAll('&apos;', "'")
      .replaceAll('&rsquo;', '’')
      .replaceAll('&lsquo;', '‘')
      .replaceAll('&rdquo;', '”')
      .replaceAll('&ldquo;', '“')
      .replaceAll('&mdash;', '—')
      .replaceAll('&ndash;', '–')
      .replaceAll('&hellip;', '…')
      .replaceAll('&nbsp;', ' ')
      .replaceAll('&amp;', '&');

  // --- General Barcode Lookup (UPC Item DB) ---

  /// Look up any barcode via UPC Item DB (free trial, no key needed)
  static Future<Map<String, dynamic>?> lookupBarcodeGeneral(String barcode) async {
    try {
      final response = await http.get(
        Uri.parse('https://api.upcitemdb.com/prod/trial/lookup?upc=$barcode'),
        headers: _headers,
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

  static LookupInfo extractGeneralProductInfo(Map<String, dynamic> data) {
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
