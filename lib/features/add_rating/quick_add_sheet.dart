import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/utils/api_service.dart';
import '../../core/utils/barcode_helper.dart';
import '../../core/utils/url_helper.dart';
import '../../l10n/app_localizations.dart';
import '../settings/settings_provider.dart';
import 'add_rating_provider.dart';

void showQuickAddSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (ctx) => _QuickAddSheetContent(parentContext: context),
  );
}

class _QuickAddSheetContent extends ConsumerWidget {
  final BuildContext parentContext;

  const _QuickAddSheetContent({required this.parentContext});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final hasTmdbKey = ref.watch(tmdbApiKeyProvider).isNotEmpty;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.howToAdd,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.qr_code_scanner),
              title: Text(l10n.scanBarcode),
              subtitle: Text(l10n.scanBarcodeSubtitle),
              onTap: () {
                Navigator.pop(context);
                final ctx = parentContext;
                ctx.push('/scanner').then((result) {
                  if (result != null && result is String && ctx.mounted) {
                    _handleBarcode(ctx, result);
                  }
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.link),
              title: Text(l10n.fromUrl),
              subtitle: Text(l10n.fromUrlSubtitle),
              onTap: () {
                Navigator.pop(context);
                _showUrlDialog(parentContext);
              },
            ),
            ListTile(
              leading: const Icon(Icons.movie_outlined),
              title: Text(l10n.searchMovieSeries),
              subtitle: Text(l10n.searchMovieSeriesSubtitle),
              enabled: hasTmdbKey,
              onTap: () {
                Navigator.pop(context);
                _showApiSearchDialog(parentContext, 'tmdb', ref.read(tmdbApiKeyProvider));
              },
            ),
            ListTile(
              leading: const Icon(Icons.place_outlined),
              title: Text(l10n.searchPlace),
              subtitle: Text(l10n.searchPlaceSubtitle),
              onTap: () {
                Navigator.pop(context);
                final ctx = parentContext;
                ctx.push('/map').then((result) {
                  if (result != null && ctx.mounted) {
                    final info = result as ({String title, String imageUrl, List<String> tags});
                    ctx.push('/add', extra: PrefillData(
                      title: info.title,
                      imageUrl: info.imageUrl,
                      tags: info.tags,
                    ));
                  }
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.menu_book_outlined),
              title: Text(l10n.searchBook),
              subtitle: Text(l10n.searchBookSubtitle),
              onTap: () {
                Navigator.pop(context);
                _showApiSearchDialog(parentContext, 'book', '');
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit),
              title: Text(l10n.manualEntry),
              subtitle: Text(l10n.manualEntrySubtitle),
              onTap: () {
                Navigator.pop(context);
                parentContext.push('/add');
              },
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> _handleBarcode(BuildContext context, String barcode) async {
  final tags = tagsFromBarcode(barcode);

  if (barcode.startsWith('978') || barcode.startsWith('979')) {
    final data = await ApiService.lookupIsbn(barcode);
    if (data != null) {
      final info = ApiService.extractBookInfo(data);
      if (context.mounted) {
        context.push('/add', extra: PrefillData(
          title: info.title,
          imageUrl: info.imageUrl,
          tags: info.tags,
          barcode: barcode,
        ));
      }
      return;
    }
  } else {
    final data = await ApiService.lookupBarcode(barcode);
    if (data != null) {
      final info = ApiService.extractProductInfo(data);
      if (context.mounted) {
        context.push('/add', extra: PrefillData(
          title: info.title,
          imageUrl: info.imageUrl,
          tags: info.tags,
          barcode: barcode,
        ));
      }
      return;
    }
  }

  if (context.mounted) {
    context.push('/add', extra: PrefillData(tags: tags, barcode: barcode));
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
              final metadata = await fetchUrlMetadata(url);
              final title = metadata.title ?? extractDomain(url) ?? url;
              if (context.mounted) {
                context.push('/add', extra: PrefillData(
                  title: title,
                  imageUrl: metadata.imageUrl ?? '',
                  sourceUrl: url,
                  notes: metadata.description ?? '',
                  tags: ['url'],
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
        ));
      },
    ),
  );
}

class _ApiSearchDialog extends StatefulWidget {
  final String type;
  final TextEditingController searchController;
  final String tmdbApiKey;
  final void Function(({String title, String imageUrl, List<String> tags})) onSelected;

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
      _ => l10n.searchTitle,
    };
  }

  Future<void> _search(String query) async {
    if (query.trim().isEmpty) return;
    setState(() => _loading = true);

    final results = switch (widget.type) {
      'tmdb' => await ApiService.searchTmdb(query, widget.tmdbApiKey),
      'place' => await ApiService.searchPlaces(query),
      'book' => await ApiService.searchBooks(query),
      _ => <Map<String, dynamic>>[],
    };

    if (mounted) {
      setState(() {
        _results = results;
        _loading = false;
      });
    }
  }

  void _selectResult(Map<String, dynamic> result) {
    final info = switch (widget.type) {
      'tmdb' => ApiService.extractTmdbInfo(result),
      'place' => ApiService.extractPlaceInfo(result),
      'book' => ApiService.extractBookInfo(result),
      _ => (title: 'Unknown', imageUrl: '', tags: <String>[]),
    };
    widget.onSelected(info);
    Navigator.pop(context);
  }

  String _resultTitle(Map<String, dynamic> result) {
    return switch (widget.type) {
      'tmdb' => (result['title'] ?? result['name'] ?? 'Unknown') as String,
      'place' => result['display_name'] as String? ?? 'Unknown',
      'book' => result['title'] as String? ?? 'Unknown',
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
                      return ListTile(
                        title: Text(
                          _resultTitle(result),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: _resultSubtitle(result) != null
                            ? Text(_resultSubtitle(result)!)
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
