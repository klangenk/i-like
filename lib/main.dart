import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/database/app_database.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/url_helper.dart';
import 'features/add_rating/add_rating_provider.dart';
import 'features/home/home_provider.dart';
import 'features/settings/settings_provider.dart';
import 'l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final database = AppDatabase();
  final prefs = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        databaseProvider.overrideWithValue(database),
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const ILikeApp(),
    ),
  );
}

class ILikeApp extends StatefulWidget {
  const ILikeApp({super.key});

  @override
  State<ILikeApp> createState() => _ILikeAppState();
}

class _ILikeAppState extends State<ILikeApp> {
  StreamSubscription<List<SharedMediaFile>>? _shareSubscription;

  @override
  void initState() {
    super.initState();

    // Handle shared content when app is already running
    _shareSubscription = ReceiveSharingIntent.instance
        .getMediaStream()
        .listen(_handleSharedMedia);

    // Handle shared content that launched the app
    ReceiveSharingIntent.instance.getInitialMedia().then((value) {
      if (value.isNotEmpty) {
        _handleSharedMedia(value);
      }
    });
  }

  Future<void> _handleSharedMedia(List<SharedMediaFile> files) async {
    if (files.isEmpty) return;

    final shared = files.first;
    final text = shared.path;

    if (text.isEmpty) return;

    // Reset so we don't process it again
    ReceiveSharingIntent.instance.reset();

    if (isValidUrl(text.trim())) {
      // Pure URL — resolve shortened URLs and fetch metadata
      final url = await resolveUrl(text.trim());
      final metadata = await fetchUrlMetadata(url);
      final title = cleanPageTitle(metadata.title ?? extractDomain(url) ?? url);
      _navigateToAdd(PrefillData(
        title: title,
        imageUrl: metadata.imageUrl ?? '',
        sourceUrl: url,
        tags: tagsFromUrl(url, title: metadata.title, description: metadata.description),
      ));
    } else {
      // Text that may contain a URL (e.g. Amazon, Netflix share text)
      final rawUrl = extractUrlFromText(text);
      if (rawUrl != null) {
        // Resolve shortened URLs (amzn.eu, bit.ly, etc.) to get the real URL
        final url = await resolveUrl(rawUrl);
        final metadata = await fetchUrlMetadata(url);
        final metaTitle = cleanPageTitle(metadata.title ?? '');
        final sharedTitle = extractTitleFromSharedText(text);
        // Use shared text title as fallback when metadata is generic/empty
        final title = _isMeaningfulTitle(metaTitle)
            ? metaTitle
            : sharedTitle ?? (metaTitle.isNotEmpty ? metaTitle : (extractDomain(url) ?? url));
        _navigateToAdd(PrefillData(
          title: title,
          imageUrl: metadata.imageUrl ?? '',
          sourceUrl: url,
          tags: tagsFromUrl(url, title: metadata.title, description: metadata.description, sharedText: text),
        ));
      } else {
        // Plain text with no URL — use as title
        _navigateToAdd(PrefillData(title: text));
      }
    }
  }

  /// Check if a metadata title is meaningful (not just a domain or site name)
  bool _isMeaningfulTitle(String title) {
    if (title.isEmpty) return false;
    final lower = title.toLowerCase();
    const genericTitles = [
      'amazon', 'ebay', 'netflix', 'google', 'facebook', 'instagram',
      'twitter', 'youtube', 'spotify', 'booking', 'airbnb', 'tripadvisor',
    ];
    for (final generic in genericTitles) {
      // "Amazon.de", "eBay Kleinanzeigen" etc. are not meaningful
      if (lower.replaceAll(RegExp(r'[.\-\s].*'), '') == generic) return false;
    }
    return true;
  }

  void _navigateToAdd(PrefillData prefill) {
    // Wait a frame to ensure the router is ready (especially on cold start)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final context = rootNavigatorKey.currentContext;
      if (context != null) {
        appRouter.push('/add', extra: prefill);
      }
    });
  }

  @override
  void dispose() {
    _shareSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'I Like',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      routerConfig: appRouter,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
