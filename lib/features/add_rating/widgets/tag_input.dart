import 'package:flutter/material.dart';
import '../../../core/utils/tag_l10n.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/tag_badge.dart';
import '../../../core/theme/app_colors.dart';

class TagInput extends StatefulWidget {
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
  State<TagInput> createState() => _TagInputState();
}

class _TagInputState extends State<TagInput> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  static const _suggestions = [
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
    }
  }

  @override
  Widget build(BuildContext context) {
    final availableSuggestions = _suggestions
        .where((s) => !widget.tags.contains(s))
        .toList();

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
            hintText: AppLocalizations.of(context)!.addTagHint,
            suffixIcon: IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => _addTag(_controller.text),
            ),
          ),
          onSubmitted: _addTag,
          textInputAction: TextInputAction.done,
        ),
        // Quick suggestions
        if (availableSuggestions.isNotEmpty) ...[
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: availableSuggestions.map((tag) {
              final l10n = AppLocalizations.of(context)!;
              return ActionChip(
                label: Text(localizedTagName(tag, l10n), style: const TextStyle(fontSize: 12)),
                avatar: Icon(Icons.add, size: 14, color: AppColors.tagColor(tag)),
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
