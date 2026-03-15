import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/utils/tag_l10n.dart';
import '../../../core/theme/app_colors.dart';
import '../../../features/home/home_provider.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/tag_badge.dart';

class TagInput extends ConsumerStatefulWidget {
  final List<String> tags;
  final ValueChanged<String> onTagAdded;
  final ValueChanged<String> onTagRemoved;

  const TagInput({
    super.key,
    required this.tags,
    required this.onTagAdded,
    required this.onTagRemoved,
  });

  @override
  ConsumerState<TagInput> createState() => _TagInputState();
}

class _TagInputState extends ConsumerState<TagInput> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  String _filterText = '';

  static const _hardcoded = [
    'product', 'book', 'movie', 'series', 'place',
    'url', 'food', 'music', 'game', 'app',
  ];

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _addTag(String tag) {
    final trimmed = tag.trim().toLowerCase();
    if (trimmed.isNotEmpty) {
      widget.onTagAdded(trimmed);
      _controller.clear();
      setState(() => _filterText = '');
    }
  }

  List<String> _buildSuggestions(List<String> historyTags) {
    // History tags first, then hardcoded ones not already in history
    final seen = <String>{};
    final result = <String>[];
    for (final tag in [...historyTags, ..._hardcoded]) {
      if (seen.add(tag)) result.add(tag);
    }
    // Remove already-selected and apply text filter
    return result
        .where((t) => !widget.tags.contains(t))
        .where((t) => _filterText.isEmpty || t.contains(_filterText))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final historyAsync = ref.watch(allTagsProvider);
    final historyTags = historyAsync.valueOrNull ?? [];
    final suggestions = _buildSuggestions(historyTags);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Current tags
        if (widget.tags.isNotEmpty) ...[
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: widget.tags.map((tag) {
              return TagBadge(
                tag: tag,
                selected: true,
                onTap: () => widget.onTagRemoved(tag),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
        ],
        // Text input
        TextField(
          controller: _controller,
          focusNode: _focusNode,
          decoration: InputDecoration(
            hintText: l10n.addTagHint,
            suffixIcon: IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => _addTag(_controller.text),
            ),
          ),
          onChanged: (v) => setState(() => _filterText = v.trim().toLowerCase()),
          onSubmitted: _addTag,
          textInputAction: TextInputAction.done,
        ),
        // Suggestions
        if (suggestions.isNotEmpty) ...[
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: suggestions.map((tag) {
              final isHistory = historyTags.contains(tag);
              return ActionChip(
                label: Text(
                  isHistory ? tag : localizedTagName(tag, l10n),
                  style: const TextStyle(fontSize: 12),
                ),
                avatar: Icon(
                  isHistory ? Icons.history : Icons.add,
                  size: 14,
                  color: AppColors.tagColor(tag),
                ),
                onPressed: () => _addTag(tag),
                visualDensity: VisualDensity.compact,
              );
            }).toList(),
          ),
        ],
      ],
    );
  }
}
