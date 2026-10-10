import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/database/app_database.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/url_helper.dart';
import 'features/add_rating/add_rating_provider.dart';
import 'features/add_rating/quick_add_sheet.dart';
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

  static const _shortcutChannel = MethodChannel('de.langenk.ilike/shortcuts');

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

    // Handle Quick Settings tile — cold start
    _shortcutChannel.invokeMethod<String>('getInitialShortcut').then((shortcut) {
      if (shortcut == 'quick_add') _openQuickAdd();
    });

    // Handle Quick Settings tile — app already running
    _shortcutChannel.setMethodCallHandler((call) async {
      if (call.method == 'onQuickAdd') _openQuickAdd();
    });
  }

  void _openQuickAdd() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ctx = rootNavigatorKey.currentContext;
      if (ctx != null) showQuickAddSheet(ctx);
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
      final rawUrl = text.trim();
      // Navigate immediately with what we know
      _navigateToAdd(PrefillData(
        title: extractDomain(rawUrl) ?? rawUrl,
        sourceUrl: rawUrl,
        tags: ['url'],
      ));
      // Fetch metadata in background and update the screen
      _fetchAndUpdateMetadata(rawUrl);
    } else {
      final rawUrl = extractUrlFromText(text);
      if (rawUrl != null) {
        final sharedTitle = extractTitleFromSharedText(text);
        // Navigate immediately with title from shared text
        _navigateToAdd(PrefillData(
          title: sharedTitle ?? extractDomain(rawUrl) ?? rawUrl,
          sourceUrl: rawUrl,
          tags: tagsFromUrl(rawUrl),
        ));
        // Fetch metadata in background and update the screen
        _fetchAndUpdateMetadata(rawUrl, sharedText: text, sharedTitle: sharedTitle);
      } else {
        // Plain text with no URL — use as title
        _navigateToAdd(PrefillData(title: text));
      }
    }
  }

  /// Fetch metadata asynchronously and update the add rating screen
  Future<void> _fetchAndUpdateMetadata(String rawUrl, {String? sharedText, String? sharedTitle}) async {
    final container = ProviderScope.containerOf(context);
    final url = await resolveUrl(rawUrl);
    final metadata = await fetchUrlMetadata(url);

    if (!mounted) return;
    final notifier = container.read(addRatingProvider.notifier);

    // Update source URL to resolved URL
    notifier.setSourceUrl(url);

    // Update tags based on resolved URL
    final tags = tagsFromUrl(url, title: metadata.title, description: metadata.description, sharedText: sharedText ?? '');
    for (final tag in tags) {
      notifier.addTag(tag);
    }

    // Update title if metadata has a better one
    final metaTitle = cleanPageTitle(metadata.title ?? '');
    if (_isMeaningfulTitle(metaTitle)) {
      notifier.setTitle(metaTitle);
    } else if (sharedTitle == null && metaTitle.isNotEmpty) {
      notifier.setTitle(metaTitle);
    }

    // Update image
    if (metadata.imageUrl != null && metadata.imageUrl!.isNotEmpty) {
      notifier.setImageUrl(metadata.imageUrl!);
    }

    // Brand / author, where the page reveals it (e.g. Amazon)
    if (metadata.creator != null && metadata.creator!.isNotEmpty) {
      notifier.setCreator(metadata.creator!);
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
