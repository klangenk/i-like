import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:any_link_preview/any_link_preview.dart';
import 'package:url_launcher/url_launcher.dart';

/// Shortened URL domains that need resolving
const _shortDomains = ['amzn.eu', 'amzn.to', 'a.co', 'bit.ly', 't.co', 'goo.gl', 'tinyurl.com'];

/// Check if a URL is shortened and needs resolving
bool _isShortUrl(String url) {
  final host = Uri.tryParse(url)?.host.toLowerCase() ?? '';
  return _shortDomains.any((d) => host == d || host.endsWith('.$d'));
}

/// Resolve a shortened URL by following redirects (without downloading the body)
Future<String> resolveUrl(String url) async {
  if (!_isShortUrl(url)) return url;
  try {
    final client = HttpClient();
    client.connectionTimeout = const Duration(seconds: 5);
    try {
      var currentUrl = url;
      for (var i = 0; i < 10; i++) {
        final request = await client.getUrl(Uri.parse(currentUrl));
        request.followRedirects = false;
        final response = await request.close().timeout(const Duration(seconds: 5));
        await response.drain<void>();
        if (response.isRedirect || (response.statusCode >= 300 && response.statusCode < 400)) {
          final location = response.headers.value('location');
          if (location == null) break;
          // Handle relative redirects
          currentUrl = Uri.parse(currentUrl).resolve(location).toString();
        } else {
          return currentUrl;
        }
      }
      return currentUrl;
    } finally {
      client.close();
    }
  } catch (e) {
    return url;
  }
}

Future<void> openUrl(String url) async {
  final uri = Uri.tryParse(url);
  if (uri != null && await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}

bool isValidUrl(String text) {
  final uri = Uri.tryParse(text);
  return uri != null && (uri.scheme == 'http' || uri.scheme == 'https');
}

/// Clean up a page title by removing common site-name suffixes
/// e.g. '"One Piece" ansehen | Netflix' → 'One Piece'
String cleanPageTitle(String title) {
  // Remove trailing " | Site Name" or " - Site Name"
  var cleaned = title.replaceAll(RegExp(r'\s*[|\-–—]\s*[^|\-–—]+$'), '').trim();
  // Remove trailing ": Site Name" (e.g. "Product: Amazon.de")
  cleaned = cleaned.replaceAll(RegExp(r'\s*:\s*(Amazon|Netflix|eBay|Google)[.\w]*$', caseSensitive: false), '').trim();
  // Remove action words like "ansehen", "watch", "streamen"
  cleaned = cleaned.replaceAll(RegExp(r'\s+(ansehen|streamen|watch|stream|jetzt\s+\w+)$', caseSensitive: false), '').trim();
  // Remove any kind of quotes (including stray single quotes at start or end)
  cleaned = cleaned.replaceAll(RegExp(r'^[\u201E\u201C\u201D\u201F\u0022\u201A\u2018\u2019\u00AB\u00BB„"""\u275D\u275E]+'), '').trim();
  cleaned = cleaned.replaceAll(RegExp(r'[\u201E\u201C\u201D\u201F\u0022\u201A\u2018\u2019\u00AB\u00BB„"""\u275D\u275E]+$'), '').trim();
  return cleaned.isEmpty ? title : cleaned;
}

/// Detect tags based on the URL domain and optional metadata
List<String> tagsFromUrl(String url, {String? title, String? description, String? sharedText}) {
  final host = Uri.tryParse(url)?.host.toLowerCase() ?? '';
  final isStreaming = host.contains('netflix.com') ||
      host.contains('disneyplus.com') ||
      host.contains('primevideo.com') ||
      (host.contains('amazon') && url.contains('/video/'));
  if (isStreaming) return [_movieOrSeries(title, description, sharedText), 'url'];
  if (host.contains('imdb.com')) return [_movieOrSeries(title, description, sharedText), 'url'];
  if (host.contains('youtube.com') || host.contains('youtu.be')) return ['video', 'url'];
  if (host.contains('spotify.com')) return ['music', 'url'];
  if (host.contains('amazon.')) return ['product', 'url'];
  if (host.contains('ebay.')) return ['product', 'url'];
  if (host.contains('maps.google') || host.contains('maps.apple')) return ['place', 'url'];
  if (host.contains('booking.com') || host.contains('airbnb.')) return ['place', 'url'];
  if (host.contains('goodreads.com')) return ['book', 'url'];
  if (host.contains('tripadvisor.')) return ['place', 'url'];
  return ['url'];
}

/// Guess whether content is a movie or series from metadata text
String _movieOrSeries(String? title, String? description, String? sharedText) {
  final text = '${title ?? ''} ${description ?? ''} ${sharedText ?? ''}'.toLowerCase();
  const seriesHints = [
    'series', 'serie', 'season', 'staffel', 'episode', 'episodes', 'folge',
    'folgen', 'tv show', 'tv-show', 'miniseries', 'miniserie', 'seasons',
    'staffeln', 'episoden',
  ];
  const movieHints = [
    'film', 'movie', 'kino', 'spielfilm', 'kinofilm',
  ];
  for (final hint in seriesHints) {
    if (text.contains(hint)) return 'series';
  }
  for (final hint in movieHints) {
    if (text.contains(hint)) return 'movie';
  }
  // Default to movie for IMDb/streaming if no hints found
  return 'movie';
}

/// Extract the first URL from a text string (e.g. shared text from Amazon, Netflix)
String? extractUrlFromText(String text) {
  final urlPattern = RegExp(r'https?://\S+');
  final match = urlPattern.firstMatch(text);
  return match?.group(0);
}

/// Extract a meaningful title from shared text by taking the part before the URL
/// and removing common share prefixes like "Angebot:", "Schau dir das an:", etc.
String? extractTitleFromSharedText(String text) {
  final url = extractUrlFromText(text);
  if (url == null) return null;

  var before = text.substring(0, text.indexOf(url)).trim();
  if (before.isEmpty) return null;

  // Remove common share prefixes (German & English)
  before = before.replaceAll(RegExp(
    r'^(Angebot:\s*|Schau dir das an:?\s*|Check this out:?\s*|'
    r'Hast du schon\s+|Ich habe .* gefunden:?\s*|'
    r'I found this:?\s*|Look at this:?\s*)',
    caseSensitive: false,
  ), '').trim();

  // Remove surrounding quotes
  before = before.replaceAll(RegExp(r'^[\u201E\u201C\u201D\u201F\u0022\u201A\u2018\u2019\u00AB\u00BB„"""\u275D\u275E]+'), '').trim();
  before = before.replaceAll(RegExp(r'[\u201E\u201C\u201D\u201F\u0022\u201A\u2018\u2019\u00AB\u00BB„"""\u275D\u275E]+$'), '').trim();

  // Remove trailing action phrases
  before = before.replaceAll(RegExp(
    r'\s*(auf Netflix gesehen\??|on Netflix\??|bei Amazon\??|ansehen|streamen|watch|stream)\s*$',
    caseSensitive: false,
  ), '').trim();

  // Remove surrounding quotes again after stripping phrases
  before = before.replaceAll(RegExp(r'^[\u201E\u201C\u201D\u201F\u0022\u201A\u2018\u2019\u00AB\u00BB„"""\u275D\u275E]+'), '').trim();
  before = before.replaceAll(RegExp(r'[\u201E\u201C\u201D\u201F\u0022\u201A\u2018\u2019\u00AB\u00BB„"""\u275D\u275E]+$'), '').trim();

  return before.isEmpty ? null : before;
}

String? extractDomain(String url) {
  final uri = Uri.tryParse(url);
  if (uri == null) return null;
  return uri.host;
}

/// Fetch metadata (title, description, image) from a URL
Future<({String? title, String? description, String? imageUrl})> fetchUrlMetadata(
    String url) async {
  // Resolve shortened URLs first
  final resolvedUrl = await resolveUrl(url);
  try {
    final metadata = await AnyLinkPreview.getMetadata(link: resolvedUrl);
    final hasImage = metadata?.image != null && metadata!.image!.isNotEmpty;
    if (metadata != null && hasImage) {
      return (
        title: metadata.title,
        description: metadata.desc,
        imageUrl: metadata.image,
      );
    }
    // If no image from AnyLinkPreview, try site-specific extraction or HTML fallback
    final fallbackImage = _siteSpecificImage(resolvedUrl);
    if (fallbackImage != null) {
      return (
        title: metadata?.title,
        description: metadata?.desc,
        imageUrl: fallbackImage,
      );
    }
    // Try direct HTML fetch for image
    final fallback = await _fetchMetaFromHtml(resolvedUrl);
    return (
      title: fallback.title ?? metadata?.title,
      description: fallback.description ?? metadata?.desc,
      imageUrl: fallback.imageUrl ?? metadata?.image,
    );
  } catch (_) {}
  // Last resort: try direct HTML fetch
  try {
    return await _fetchMetaFromHtml(resolvedUrl);
  } catch (_) {}
  return (title: null, description: null, imageUrl: null);
}

/// Try to construct an image URL from the URL structure (no network needed)
String? _siteSpecificImage(String url) {
  final host = Uri.tryParse(url)?.host.toLowerCase() ?? '';

  // Amazon: extract ASIN and construct image URL
  if (host.contains('amazon.')) {
    final asin = _extractAmazonAsin(url);
    if (asin != null) {
      return 'https://images-na.ssl-images-amazon.com/images/P/$asin.jpg';
    }
  }
  return null;
}

/// Extract ASIN from Amazon URL
/// Patterns: /dp/ASIN, /gp/product/ASIN, /gp/aw/d/ASIN, /ASIN/
String? _extractAmazonAsin(String url) {
  final patterns = [
    RegExp(r'/dp/([A-Z0-9]{10})'),
    RegExp(r'/gp/product/([A-Z0-9]{10})'),
    RegExp(r'/gp/aw/d/([A-Z0-9]{10})'),
  ];
  for (final pattern in patterns) {
    final match = pattern.firstMatch(url);
    if (match != null) return match.group(1);
  }
  return null;
}

/// Directly fetch HTML and extract metadata
Future<({String? title, String? description, String? imageUrl})> _fetchMetaFromHtml(
    String url) async {
  final client = HttpClient();
  try {
    client.connectionTimeout = const Duration(seconds: 10);
    final request = await client.getUrl(Uri.parse(url));
    request.headers.set('User-Agent',
        'Mozilla/5.0 (Linux; Android 13) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Mobile Safari/537.36');
    request.headers.set('Accept', 'text/html');
    request.headers.set('Accept-Language', 'de-DE,de;q=0.9,en;q=0.8');
    request.headers.set('Accept-Encoding', 'gzip, deflate');

    final response = await request.close().timeout(const Duration(seconds: 10));
    if (response.statusCode != 200) {
      return (title: null, description: null, imageUrl: null);
    }

    final bytes = await consolidateHttpClientResponseBytes(response);
    final html = utf8.decode(bytes, allowMalformed: true);

    final ogImage = _extractMeta(html, 'og:image');
    final ogTitle = _extractMeta(html, 'og:title');
    final ogDesc = _extractMeta(html, 'og:description');

    // Also try name="title" and name="description" (used by Amazon)
    final metaTitle = ogTitle ?? _extractMeta(html, 'title');
    final metaDesc = ogDesc ?? _extractMeta(html, 'description');

    // If no og:image, try to find product images in the HTML (Amazon, etc.)
    final imageUrl = ogImage ?? _extractProductImage(html, url);

    return (
      title: metaTitle,
      description: metaDesc,
      imageUrl: imageUrl,
    );
  } finally {
    client.close();
  }
}

/// Decompress and consolidate HttpClientResponse bytes
Future<List<int>> consolidateHttpClientResponseBytes(HttpClientResponse response) async {
  final bytes = <int>[];
  final completer = Completer<List<int>>();
  final encoding = response.headers.value('content-encoding');

  Stream<List<int>> stream = response;
  if (encoding == 'gzip') {
    stream = stream.transform(gzip.decoder);
  } else if (encoding == 'deflate') {
    stream = stream.transform(zlib.decoder);
  }

  stream.listen(
    bytes.addAll,
    onDone: () => completer.complete(bytes),
    onError: completer.completeError,
  );
  return completer.future;
}

/// Extract product image from HTML body (for sites without og:image)
String? _extractProductImage(String html, String url) {
  final host = Uri.tryParse(url)?.host.toLowerCase() ?? '';

  if (host.contains('amazon.')) {
    // Amazon product images: look for media-amazon.com product images
    final match = RegExp(
      r'"(https://m\.media-amazon\.com/images/I/[^"]+\.(jpg|png|webp))"',
    ).firstMatch(html);
    if (match != null) {
      return match.group(1);
    }
  }

  // Generic: look for the first large image in an img tag or JSON-LD
  final imgMatch = RegExp(
    r'"(https?://[^"]+\.(jpg|jpeg|png|webp))"',
    caseSensitive: false,
  ).firstMatch(html);
  return imgMatch?.group(1);
}

/// Extract content from a meta tag by property or name
String? _extractMeta(String html, String property) {
  // Match <meta property="..." content="..."> or <meta name="..." content="...">
  final pattern = RegExp(
    '<meta[^>]*(?:property|name)=["\']$property["\'][^>]*content=["\'](.*?)["\']'
    '|<meta[^>]*content=["\'](.*?)["\'][^>]*(?:property|name)=["\']$property["\']',
    caseSensitive: false,
  );
  final match = pattern.firstMatch(html);
  return match?.group(1) ?? match?.group(2);
}
