import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/database/app_database.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/rating_level.dart';
import '../../core/utils/tag_l10n.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/level_badge.dart';
import '../../shared/widgets/rating_image.dart';
import '../home/home_provider.dart';
import 'lists_provider.dart';

/// Bottom sheet for filling a list: search the user's ratings and tap to put
/// them on the list or take them off. When nothing fits, the search text can
/// be added as a plain entry (e.g. "Milch" on a shopping list).
Future<void> showRatingPickerSheet(BuildContext context, int listId) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => _RatingPickerSheet(listId: listId),
  );
}

/// Whether [rating] matches the search [query] (already lower case).
bool ratingMatches(Rating rating, String query, AppLocalizations l10n) {
  if (query.isEmpty) return true;
  final tags = rating.tags
      .split(',')
      .map((t) => localizedTagName(t.trim(), l10n));
  return [
    rating.title,
    rating.creator,
    rating.tags,
    ...tags,
  ].any((s) => s.toLowerCase().contains(query));
}

class _RatingPickerSheet extends ConsumerStatefulWidget {
  final int listId;

  const _RatingPickerSheet({required this.listId});

  @override
  ConsumerState<_RatingPickerSheet> createState() => _RatingPickerSheetState();
}

class _RatingPickerSheetState extends ConsumerState<_RatingPickerSheet> {
  final _search = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  Future<void> _addText() async {
    final label = _search.text.trim();
    if (label.isEmpty) return;
    await ref.read(listsDaoProvider).addText(widget.listId, label);
    _search.clear();
    setState(() => _query = '');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final ratings = ref.watch(ratingsProvider).valueOrNull ?? const <Rating>[];
    final items =
        ref.watch(listItemsProvider(widget.listId)).valueOrNull ?? const [];
    final onList = {
      for (final i in items)
        if (i.entry.ratingId != null) i.entry.ratingId!,
    };
    final matches = ratings
        .where((r) => ratingMatches(r, _query, l10n))
        .toList();
    final dao = ref.read(listsDaoProvider);
    final text = _search.text.trim();

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SizedBox(
        height: MediaQuery.sizeOf(context).height * 0.8,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _search,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        hintText: l10n.searchHint,
                        prefixIcon: const Icon(Icons.search_rounded),
                      ),
                      onChanged: (v) =>
                          setState(() => _query = v.trim().toLowerCase()),
                      onSubmitted: (_) => matches.isEmpty ? _addText() : null,
                    ),
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(l10n.done),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 16),
                children: [
                  if (text.isNotEmpty)
                    ListTile(
                      leading: const Icon(Icons.short_text_rounded),
                      title: Text(l10n.addAsText(text)),
                      onTap: _addText,
                    ),
                  for (final rating in matches)
                    _RatingRow(
                      rating: rating,
                      selected: onList.contains(rating.id),
                      onTap: () => onList.contains(rating.id)
                          ? dao.removeRating(widget.listId, rating.id)
                          : dao.addRating(widget.listId, rating),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RatingRow extends StatelessWidget {
  final Rating rating;
  final bool selected;
  final VoidCallback onTap;

  const _RatingRow({
    required this.rating,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final level = RatingLevel.fromScore(rating.score);
    return ListTile(
      onTap: onTap,
      leading: RatingThumb(rating: rating),
      title: Text(rating.title, maxLines: 2, overflow: TextOverflow.ellipsis),
      subtitle: rating.creator.isEmpty
          ? null
          : Text(rating.creator, maxLines: 1),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (level != null) LevelBadge(level: level),
          const SizedBox(width: 8),
          Icon(
            selected
                ? Icons.check_circle_rounded
                : Icons.add_circle_outline_rounded,
            color: selected ? AppColors.accent : AppColors.muted(context),
          ),
        ],
      ),
    );
  }
}

/// Small square photo of a rating, used in list rows.
class RatingThumb extends StatelessWidget {
  final Rating rating;
  final double size;

  const RatingThumb({super.key, required this.rating, this.size = 48});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SizedBox.square(
      dimension: size,
      child: RatingImage(
        imageUrl: rating.imageUrl,
        localImagePath: rating.localImagePath,
        width: size,
        height: size,
        borderRadius: BorderRadius.circular(10),
        placeholder: Container(
          decoration: BoxDecoration(
            color: scheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            Icons.image_outlined,
            size: size / 2.4,
            color: scheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
