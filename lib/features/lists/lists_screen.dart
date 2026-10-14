import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/database/app_database.dart';
import '../../core/database/lists_dao.dart';
import '../../core/theme/app_colors.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/empty_state.dart';
import '../../shared/widgets/round_icon_button.dart';
import 'lists_provider.dart';

/// Overview of the user's lists.
class ListsScreen extends ConsumerWidget {
  const ListsScreen({super.key});

  Future<void> _create(
    BuildContext context,
    WidgetRef ref, {
    String? name,
    bool checkable = true,
  }) async {
    final result = name != null
        ? (name: name, checkable: checkable)
        : await showListDialog(context);
    if (result == null) return;
    final id = await ref
        .read(listsDaoProvider)
        .createList(result.name, checkable: result.checkable);
    if (context.mounted) context.push('/lists/$id');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final lists = ref.watch(listsProvider);

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
      ),
      floatingActionButton: (lists.valueOrNull?.isEmpty ?? true)
          ? null
          : FloatingActionButton.extended(
              onPressed: () => _create(context, ref),
              icon: const Icon(Icons.add_rounded, size: 24),
              label: Text(l10n.newList),
            ),
      body: lists.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) =>
            Center(child: Text(l10n.errorPrefix(error.toString()))),
        data: (lists) => ListView(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 112),
          children: [
            Text(
              l10n.listsTitle,
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 20),
            if (lists.isEmpty)
              EmptyState(
                icon: Icons.checklist_rounded,
                title: l10n.listsEmptyTitle,
                subtitle: l10n.listsEmptySubtitle,
                action: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ActionChip(
                      avatar: const Icon(
                        Icons.shopping_basket_outlined,
                        size: 18,
                      ),
                      label: Text(l10n.listShoppingName),
                      onPressed: () =>
                          _create(context, ref, name: l10n.listShoppingName),
                    ),
                    ActionChip(
                      avatar: const Icon(Icons.card_giftcard_rounded, size: 18),
                      label: Text(l10n.listGiftsName),
                      onPressed: () => _create(
                        context,
                        ref,
                        name: l10n.listGiftsName,
                        checkable: false,
                      ),
                    ),
                    ActionChip(
                      avatar: const Icon(Icons.add_rounded, size: 18),
                      label: Text(l10n.listOwn),
                      onPressed: () => _create(context, ref),
                    ),
                  ],
                ),
              )
            else
              for (final summary in lists) _ListTile(summary: summary),
          ],
        ),
      ),
    );
  }
}

class _ListTile extends StatelessWidget {
  final ListSummary summary;

  const _ListTile({required this.summary});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final list = summary.list;
    final scheme = Theme.of(context).colorScheme;
    final count = list.checkable && summary.total > 0
        ? l10n.listOpenCount(summary.open, summary.total)
        : l10n.listEntryCount(summary.total);

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () => context.push('/lists/${list.id}'),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 12, 14),
            child: Row(
              children: [
                Icon(
                  list.checkable
                      ? Icons.checklist_rounded
                      : Icons.bookmarks_outlined,
                  color: AppColors.accent,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        list.name,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        count,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.muted(context),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.muted(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Asks for a list's name and whether entries are ticked off. Pass [list] to
/// edit an existing one. Returns null when cancelled.
Future<({String name, bool checkable})?> showListDialog(
  BuildContext context, {
  RatingList? list,
}) {
  return showDialog<({String name, bool checkable})>(
    context: context,
    builder: (_) => _ListDialog(list: list),
  );
}

class _ListDialog extends StatefulWidget {
  final RatingList? list;

  const _ListDialog({this.list});

  @override
  State<_ListDialog> createState() => _ListDialogState();
}

class _ListDialogState extends State<_ListDialog> {
  late final _name = TextEditingController(text: widget.list?.name ?? '');
  late bool _checkable = widget.list?.checkable ?? true;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  void _submit() {
    final name = _name.text.trim();
    if (name.isEmpty) return;
    Navigator.pop(context, (name: name, checkable: _checkable));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(widget.list == null ? l10n.newList : l10n.editList),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _name,
            autofocus: true,
            maxLength: 100,
            textCapitalization: TextCapitalization.sentences,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(labelText: l10n.listName),
            onChanged: (_) => setState(() {}),
            onSubmitted: (_) => _submit(),
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(l10n.listCheckable),
            subtitle: Text(l10n.listCheckableHint),
            value: _checkable,
            onChanged: (v) => setState(() => _checkable = v),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
        TextButton(
          onPressed: _name.text.trim().isEmpty ? null : _submit,
          child: Text(l10n.save),
        ),
      ],
    );
  }
}
