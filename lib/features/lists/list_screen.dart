import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import '../../core/database/app_database.dart';
import '../../core/database/lists_dao.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/rating_level.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/level_badge.dart';
import '../../shared/widgets/round_icon_button.dart';
import 'lists_provider.dart';
import 'lists_screen.dart';
import 'rating_picker_sheet.dart';

/// One list: its entries, ticked off or not, and a field to add more.
class ListScreen extends ConsumerStatefulWidget {
  final int listId;

  const ListScreen({super.key, required this.listId});

  @override
  ConsumerState<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends ConsumerState<ListScreen> {
  Future<void> _remove(ListEntry entry) async {
    final l10n = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);
    final dao = ref.read(listsDaoProvider);
    await dao.deleteEntry(entry.id);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(l10n.listEntryRemoved(entry.label)),
          action: SnackBarAction(
            label: l10n.undo,
            onPressed: () => dao.restoreEntry(entry),
          ),
        ),
      );
  }

  Future<void> _edit(RatingList list) async {
    final result = await showListDialog(context, list: list);
    if (result == null) return;
    final dao = ref.read(listsDaoProvider);
    if (result.name != list.name) await dao.renameList(list.id, result.name);
    if (result.checkable != list.checkable) {
      await dao.setCheckable(list.id, result.checkable);
    }
  }

  Future<void> _delete(RatingList list) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.deleteList),
        content: Text(l10n.deleteListConfirm(list.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.delete, style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await ref.read(listsDaoProvider).deleteList(list.id);
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final list = ref.watch(listProvider(widget.listId)).valueOrNull;
    final items =
        ref.watch(listItemsProvider(widget.listId)).valueOrNull ??
        const <ListItem>[];

    if (list == null) return const Scaffold();

    final open = list.checkable
        ? items.where((i) => !i.entry.checked).toList()
        : items;
    final done = list.checkable
        ? items.where((i) => i.entry.checked).toList()
        : const <ListItem>[];

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 68,
        titleSpacing: 16,
        title: RoundIconButton(
          icon: Icons.arrow_back_rounded,
          tooltip: l10n.back,
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        actions: [
          if (items.isNotEmpty)
            RoundIconButton(
              icon: Icons.ios_share_rounded,
              tooltip: l10n.share,
              onPressed: () => Share.share(listAsText(list, items)),
            ),
          const SizedBox(width: 8),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert_rounded),
            onSelected: (action) => switch (action) {
              'edit' => _edit(list),
              'delete' => _delete(list),
              _ => null,
            },
            itemBuilder: (_) => [
              PopupMenuItem(value: 'edit', child: Text(l10n.editList)),
              PopupMenuItem(value: 'delete', child: Text(l10n.deleteList)),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showRatingPickerSheet(context, list.id),
        icon: const Icon(Icons.add_rounded, size: 24),
        label: Text(l10n.add),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 112),
        children: [
          Text(list.name, style: Theme.of(context).textTheme.headlineLarge),
          const SizedBox(height: 16),
          if (items.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Text(
                '${l10n.listEmpty} ${l10n.listEmptyHint}',
                style: TextStyle(fontSize: 16, color: AppColors.muted(context)),
              ),
            ),
          for (final item in open) _entry(list, item),
          if (done.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.only(top: 18, bottom: 4),
              child: Row(
                children: [
                  Text(
                    '${l10n.listDone} · ${done.length}',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.muted(context),
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () =>
                        ref.read(listsDaoProvider).clearChecked(list.id),
                    child: Text(l10n.listClearDone),
                  ),
                ],
              ),
            ),
            for (final item in done) _entry(list, item),
          ],
        ],
      ),
    );
  }

  Widget _entry(RatingList list, ListItem item) {
    final entry = item.entry;
    return Dismissible(
      key: ValueKey(entry.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete_outline_rounded, color: Colors.red),
      ),
      onDismissed: (_) => _remove(entry),
      child: _EntryRow(
        item: item,
        checkable: list.checkable,
        onChecked: (v) => ref.read(listsDaoProvider).setChecked(entry.id, v),
      ),
    );
  }
}

class _EntryRow extends StatelessWidget {
  final ListItem item;
  final bool checkable;
  final ValueChanged<bool> onChecked;

  const _EntryRow({
    required this.item,
    required this.checkable,
    required this.onChecked,
  });

  @override
  Widget build(BuildContext context) {
    final entry = item.entry;
    final rating = item.rating;
    final level = rating == null ? null : RatingLevel.fromScore(rating.score);
    final done = checkable && entry.checked;

    // A linked rating opens its page; a plain entry on a checkable list toggles.
    final VoidCallback? onTap = rating != null
        ? () => context.push('/detail/${rating.id}')
        : checkable
        ? () => onChecked(!entry.checked)
        : null;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 52),
        child: Row(
          children: [
            if (checkable)
              Checkbox(
                value: entry.checked,
                onChanged: (v) => onChecked(v ?? false),
              ),
            if (rating != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Opacity(
                  opacity: done ? 0.5 : 1,
                  child: RatingThumb(rating: rating),
                ),
              )
            else if (!checkable)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Icon(Icons.circle, size: 7),
              ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                entry.label,
                style: TextStyle(
                  fontSize: 17,
                  decoration: done ? TextDecoration.lineThrough : null,
                  color: done ? AppColors.muted(context) : null,
                ),
              ),
            ),
            if (level != null)
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: LevelBadge(level: level),
              )
            else if (rating != null)
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Icon(
                  Icons.bookmark_rounded,
                  size: 20,
                  color: AppColors.muted(context),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
