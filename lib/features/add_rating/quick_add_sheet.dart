import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/api_service.dart';
import '../../core/utils/barcode_helper.dart';
import '../../core/utils/url_helper.dart';
import '../../l10n/app_localizations.dart';
import 'add_rating_provider.dart';

void showQuickAddSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (ctx) => _QuickAddSheetContent(parentContext: context),
  );
}

class _QuickAddSheetContent extends ConsumerWidget {
  final BuildContext parentContext;

  const _QuickAddSheetContent({required this.parentContext});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;

    return SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.9),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(l10n.whatToRate, style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 16),
              // Primary: barcode
              Material(
                color: scheme.onSurface,
                borderRadius: BorderRadius.circular(22),
                child: InkWell(
                  borderRadius: BorderRadius.circular(22),
                  onTap: () {
                    Navigator.pop(context);
                    final ctx = parentContext;
                    ctx.push('/scanner').then((result) {
                      if (result != null && result is String && ctx.mounted) {
                        handleBarcode(ctx, result);
                      }
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: AppColors.raspberry,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(Icons.qr_code_scanner_rounded, color: Colors.white, size: 26),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.scanBarcode,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: scheme.surface,
                                ),
                              ),
                              Text(
                                l10n.scanBarcodeSubtitle,
                                style: TextStyle(fontSize: 14, color: scheme.surface.withAlpha(190)),
                              ),
                            ],
                          ),
                        ),
                        Icon(Icons.chevron_right_rounded, color: scheme.surface),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              _SourceTile(
                icon: Icons.link_rounded,
                title: l10n.fromUrl,
                subtitle: l10n.fromUrlSubtitle,
                onTap: () {
                  Navigator.pop(context);
                  _showUrlDialog(parentContext);
                },
              ),
              _SourceTile(
                icon: Icons.menu_book_outlined,
                title: l10n.searchBook,
                subtitle: l10n.searchBookSubtitle,
                onTap: () {
                  Navigator.pop(context);
                  _showApiSearchDialog(parentContext, 'book', '');
                },
              ),
              _SourceTile(
                icon: Icons.casino_outlined,
                title: l10n.searchBoardGame,
                subtitle: l10n.searchBoardGameSubtitle,
                onTap: () {
                  Navigator.pop(context);
                  _showApiSearchDialog(parentContext, 'boardgame', '');
                },
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                icon: const Icon(Icons.edit_outlined, size: 18),
                label: Text(l10n.manualEntry),
                onPressed: () {
                  Navigator.pop(context);
                  parentContext.push('/add');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SourceTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SourceTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 58),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 2),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: scheme.surfaceContainerHighest,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 20),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                    Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> handleBarcode(BuildContext context, String barcode) async {
  final tags = tagsFromBarcode(barcode);

  // Show loading indicator while fetching metadata
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => const PopScope(
      canPop: false,
      child: Center(child: CircularProgressIndicator()),
    ),
  );

  if (barcode.startsWith('978') || barcode.startsWith('979')) {
    // ISBN — look up as book
    final data = await ApiService.lookupIsbn(barcode);
    if (data != null) {
      final info = ApiService.extractBookInfo(data);
      if (context.mounted) {
        Navigator.pop(context); // dismiss loading
        context.push('/add', extra: PrefillData(
          title: info.title,
          imageUrl: info.imageUrl,
          tags: info.tags,
          sourceUrl: 'https://openlibrary.org/isbn/$barcode',
          barcode: barcode,
          creator: info.creator,
          year: info.year,
        ));
      }
      return;
    }
  } else {
    // Try OpenFoodFacts first (food products)
    final data = await ApiService.lookupBarcode(barcode);
    if (data != null) {
      final info = ApiService.extractProductInfo(data);
      if (context.mounted) {
        Navigator.pop(context); // dismiss loading
        context.push('/add', extra: PrefillData(
          title: info.title,
          imageUrl: info.imageUrl,
          tags: info.tags,
          sourceUrl: 'https://world.openfoodfacts.org/product/$barcode',
          barcode: barcode,
          creator: info.creator,
        ));
      }
      return;
    }

    // Try general barcode lookup (UPC Item DB — covers board games, electronics, etc.)
    final generalData = await ApiService.lookupBarcodeGeneral(barcode);
    if (generalData != null && context.mounted) {
      final info = ApiService.extractGeneralProductInfo(generalData);
      // Always try BGG to get a better image and proper game tagging
      final bggResult = await _tryBoardGameLookup(info.title);
      if (bggResult != null && context.mounted) {
        Navigator.pop(context); // dismiss loading
        context.push('/add', extra: PrefillData(
          title: bggResult.title,
          imageUrl: bggResult.imageUrl,
          tags: bggResult.tags,
          sourceUrl: bggResult.sourceUrl,
          barcode: barcode,
          creator: bggResult.creator.isNotEmpty ? bggResult.creator : info.creator,
          year: bggResult.year,
        ));
        return;
      }
      if (context.mounted) {
        Navigator.pop(context); // dismiss loading
        context.push('/add', extra: PrefillData(
          title: info.title,
          imageUrl: info.imageUrl,
          tags: info.tags,
          barcode: barcode,
          creator: info.creator,
        ));
      }
      return;
    }
  }

  if (context.mounted) {
    Navigator.pop(context); // dismiss loading
    context.push('/add', extra: PrefillData(tags: tags, barcode: barcode));
  }
}

/// Try to find a board game on Wikipedia by title and fetch its image
Future<LookupInfo?> _tryBoardGameLookup(String title) async {
  try {
    final results = await ApiService.searchBoardGames(title);
    if (results.isEmpty) return null;
    final pageTitle = results.first['title'] as String? ?? '';
    if (pageTitle.isEmpty) return null;
    final details = await ApiService.getBoardGameDetails(pageTitle);
    if (details == null) return null;
    final info = ApiService.extractBoardGameInfo(details);
    if (info.imageUrl.isEmpty) return null;
    return info;
  } catch (_) {
    return null;
  }
}

void _showUrlDialog(BuildContext context) {
  final urlController = TextEditingController();
  final l10n = AppLocalizations.of(context)!;

  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(l10n.enterUrl),
      content: TextField(
        controller: urlController,
        decoration: const InputDecoration(hintText: 'https://...'),
        autofocus: true,
        keyboardType: TextInputType.url,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: Text(l10n.cancel),
        ),
        TextButton(
          onPressed: () async {
            final url = urlController.text.trim();
            if (isValidUrl(url)) {
              Navigator.pop(ctx);
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => const PopScope(
                  canPop: false,
                  child: Center(child: CircularProgressIndicator()),
                ),
              );
              final resolved = await resolveUrl(url);
              final metadata = await fetchUrlMetadata(resolved);
              final title = metadata.title ?? extractDomain(resolved) ?? resolved;
              if (context.mounted) {
                Navigator.pop(context); // dismiss loading
                context.push('/add', extra: PrefillData(
                  title: title,
                  imageUrl: metadata.imageUrl ?? '',
                  sourceUrl: resolved,
                  tags: tagsFromUrl(resolved, title: metadata.title, description: metadata.description),
                  creator: metadata.creator ?? '',
                ));
              }
            }
          },
          child: Text(l10n.add),
        ),
      ],
    ),
  );
}

void _showApiSearchDialog(BuildContext context, String type, String tmdbApiKey) {
  final searchController = TextEditingController();
  showDialog(
    context: context,
    builder: (ctx) => _ApiSearchDialog(
      type: type,
      searchController: searchController,
      tmdbApiKey: tmdbApiKey,
      onSelected: (info) {
        context.push('/add', extra: PrefillData(
          title: info.title,
          imageUrl: info.imageUrl,
          tags: info.tags,
          sourceUrl: info.sourceUrl,
          creator: info.creator,
          year: info.year,
        ));
      },
    ),
  );
}

class _ApiSearchDialog extends StatefulWidget {
  final String type;
  final TextEditingController searchController;
  final String tmdbApiKey;
  final void Function(LookupInfo) onSelected;

  const _ApiSearchDialog({
    required this.type,
    required this.searchController,
    required this.tmdbApiKey,
    required this.onSelected,
  });

  @override
  State<_ApiSearchDialog> createState() => _ApiSearchDialogState();
}

class _ApiSearchDialogState extends State<_ApiSearchDialog> {
  List<Map<String, dynamic>> _results = [];
  bool _loading = false;

  String _dialogTitle(AppLocalizations l10n) {
    return switch (widget.type) {
      'tmdb' => l10n.searchMoviesAndSeries,
      'place' => l10n.searchPlaces,
      'book' => l10n.searchBooks,
      'boardgame' => l10n.searchBoardGames,
      _ => l10n.searchEllipsis,
    };
  }

  Future<void> _search(String query) async {
    if (query.trim().isEmpty) return;
    setState(() => _loading = true);

    final results = switch (widget.type) {
      'tmdb' => await ApiService.searchTmdb(query, widget.tmdbApiKey),
      'place' => await ApiService.searchPlaces(query),
      'book' => await ApiService.searchBooks(query),
      'boardgame' => await ApiService.searchBoardGames(query),
      _ => <Map<String, dynamic>>[],
    };

    if (mounted) {
      setState(() {
        _results = results;
        _loading = false;
      });
    }
  }

  Future<void> _selectResult(Map<String, dynamic> result) async {
    if (widget.type == 'boardgame') {
      Navigator.pop(context);
      final pageTitle = result['title'] as String? ?? '';
      final listImage = result['image'] as String? ?? '';
      // Details add designer and year; the list thumbnail is the fallback image.
      final details = pageTitle.isEmpty ? null : await ApiService.getBoardGameDetails(pageTitle);
      widget.onSelected(ApiService.extractBoardGameInfo({
        'name': pageTitle,
        ...?details,
        if ((details?['image'] as String? ?? '').isEmpty) 'image': listImage,
      }));
      return;
    }

    final info = switch (widget.type) {
      'tmdb' => ApiService.extractTmdbInfo(result),
      'place' => ApiService.extractPlaceInfo(result),
      'book' => ApiService.extractBookInfo(result),
      _ => (title: 'Unknown', imageUrl: '', tags: <String>[], sourceUrl: '', creator: '', year: ''),
    };
    widget.onSelected(info);
    Navigator.pop(context);
  }

  /// Thumbnail for the result list: Wikipedia page image or Open Library cover.
  String? _resultImage(Map<String, dynamic> result) {
    switch (widget.type) {
      case 'boardgame':
        final image = result['image'] as String? ?? '';
        return image.isEmpty ? '' : image;
      case 'book':
        final cover = result['cover_i'];
        return cover == null ? '' : 'https://covers.openlibrary.org/b/id/$cover-M.jpg';
      default:
        return null;
    }
  }

  Widget _thumbPlaceholder(BuildContext context) => Container(
        width: 48,
        height: 56,
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        child: Icon(Icons.image_outlined, size: 20, color: Theme.of(context).colorScheme.onSurfaceVariant),
      );

  String _resultTitle(Map<String, dynamic> result) {
    return switch (widget.type) {
      'tmdb' => (result['title'] ?? result['name'] ?? 'Unknown') as String,
      'place' => result['display_name'] as String? ?? 'Unknown',
      'book' => result['title'] as String? ?? 'Unknown',
      'boardgame' => ApiService.cleanGameTitle(result['title'] as String? ?? 'Unknown'),
      _ => 'Unknown',
    };
  }

  String? _resultSubtitle(Map<String, dynamic> result) {
    switch (widget.type) {
      case 'tmdb':
        final l10n = AppLocalizations.of(context)!;
        final date = (result['release_date'] ?? result['first_air_date'] ?? '') as String;
        final type = result['media_type'] == 'tv' ? l10n.series : l10n.movie;
        return date.isNotEmpty ? '$type · $date' : type;
      case 'place':
        return result['type'] as String?;
      case 'book':
        final authors = result['author_name'] as List<dynamic>?;
        return authors?.join(', ');
      case 'boardgame':
        // Wikipedia search results have a snippet
        final snippet = (result['snippet'] as String? ?? '')
            .replaceAll(RegExp(r'<[^>]*>'), '') // strip HTML
            .replaceAll('&quot;', '"')
            .replaceAll('&#039;', "'")
            .replaceAll('&lt;', '<')
            .replaceAll('&gt;', '>')
            .replaceAll('&amp;', '&');
        return snippet.isNotEmpty ? snippet : null;
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500, maxHeight: 500),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(_dialogTitle(l10n), style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
              TextField(
                controller: widget.searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: l10n.searchEllipsis,
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () => _search(widget.searchController.text),
                  ),
                ),
                onSubmitted: _search,
              ),
              const SizedBox(height: 8),
              if (_loading)
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: CircularProgressIndicator(),
                )
              else
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _results.length,
                    itemBuilder: (context, index) {
                      final result = _results[index];
                      final image = _resultImage(result);
                      return ListTile(
                        leading: image == null
                            ? null
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: CachedNetworkImage(
                                  imageUrl: image,
                                  width: 48,
                                  height: 56,
                                  fit: BoxFit.cover,
                                  errorWidget: (_, _, _) => _thumbPlaceholder(context),
                                  placeholder: (_, _) => _thumbPlaceholder(context),
                                ),
                              ),
                        title: Text(
                          _resultTitle(result),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: _resultSubtitle(result) != null
                            ? Text(_resultSubtitle(result)!, maxLines: 2, overflow: TextOverflow.ellipsis)
                            : null,
                        onTap: () => _selectResult(result),
                        dense: true,
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
