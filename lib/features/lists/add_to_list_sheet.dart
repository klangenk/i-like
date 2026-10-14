import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/database/app_database.dart';
import '../../core/theme/app_colors.dart';
import '../../l10n/app_localizations.dart';
import 'lists_provider.dart';
import 'lists_screen.dart';

/// Bottom sheet that puts [rating] on lists or takes it off them.
Future<void> showAddToListSheet(BuildContext context, Rating rating) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => _AddToListSheet(rating: rating),
  );
}

class _AddToListSheet extends ConsumerWidget {
  final Rating rating;

  const _AddToListSheet({required this.rating});

  Future<void> _newList(BuildContext context, WidgetRef ref) async {
    final result = await showListDialog(context);
    if (result == null) return;
    final dao = ref.read(listsDaoProvider);
    final id = await dao.createList(result.name, checkable: result.checkable);
    await dao.addRating(id, rating);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final lists = ref.watch(listsProvider).valueOrNull ?? const [];
    final onLists =
        ref.watch(listIdsForRatingProvider(rating.id)).valueOrNull ??
        const <int>{};
    final dao = ref.read(listsDaoProvider);

    return SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.7,
        ),
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
              child: Text(
                l10n.addToList,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            for (final summary in lists)
              CheckboxListTile(
                value: onLists.contains(summary.list.id),
                title: Text(summary.list.name),
                secondary: Icon(
                  summary.list.checkable
                      ? Icons.checklist_rounded
                      : Icons.bookmarks_outlined,
                  color: AppColors.accent,
                ),
                onChanged: (on) => on == true
                    ? dao.addRating(summary.list.id, rating)
                    : dao.removeRating(summary.list.id, rating.id),
              ),
            ListTile(
              leading: const Icon(Icons.add_rounded),
              title: Text(l10n.newList),
              onTap: () => _newList(context, ref),
            ),
          ],
        ),
      ),
    );
  }
}
