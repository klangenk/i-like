import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/utils/tag_l10n.dart';
import '../../../features/home/home_provider.dart';
import '../../../l10n/app_localizations.dart';

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
  bool _editing = false;

  /// Keeps the open picker short; typing narrows it further.
  static const _maxSuggestions = 6;

  static const _hardcoded = [
    'product', 'book', 'movie', 'series', 'place',
    'food', 'music', 'game', 'app',
  ];

  /// Built-in categories, stored as keys and shown translated.
  static const _builtIn = {..._hardcoded, 'url', 'magazine', 'other'};

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _addTag(String tag) {
    final resolved = _resolveTag(tag.trim(), AppLocalizations.of(context)!);
    if (resolved.isNotEmpty) widget.onTagAdded(resolved);
    _close();
  }

  /// Keeps what the user typed ("Krimi" stays "Krimi"), but reuses an
  /// existing tag that differs only in case, and maps a typed category name
  /// ("Buch") to its built-in key.
  String _resolveTag(String typed, AppLocalizations l10n) {
    if (typed.isEmpty) return typed;
    final lower = typed.toLowerCase();
    for (final key in _builtIn) {
      if (key == lower || localizedTagName(key, l10n).toLowerCase() == lower) return key;
    }
    final existing = ref.read(tagUsageProvider).keys;
    return existing.firstWhere((t) => t.toLowerCase() == lower, orElse: () => typed);
  }

  void _open() {
    setState(() => _editing = true);
  }

  void _close() {
    _controller.clear();
    _focusNode.unfocus();
    setState(() {
      _filterText = '';
      _editing = false;
    });
  }

  List<String> _buildSuggestions(Map<String, int> usage, AppLocalizations l10n) {
    // Your own tags first (most used first): they exist nowhere else in the
    // picker. Then the built-in categories, also by use. `url` is added
    // automatically for links and never suggested.
    int byUse(String a, String b) => (usage[b] ?? 0).compareTo(usage[a] ?? 0);
    final custom = usage.keys.where((t) => !_builtIn.contains(t)).toList()..sort(byUse);
    final builtIn = [..._hardcoded]..sort(byUse);
    return [...custom, ...builtIn]
        .where((t) => !widget.tags.contains(t))
        .where((t) =>
            _filterText.isEmpty ||
            t.toLowerCase().contains(_filterText) ||
            localizedTagName(t, l10n).toLowerCase().contains(_filterText))
        .take(_maxSuggestions)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final suggestions = _buildSuggestions(ref.watch(tagUsageProvider), l10n);
    final typed = _controller.text.trim();
    final scheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            // Selected categories – tap to remove
            for (final tag in widget.tags)
              Semantics(
                button: true,
                label: localizedTagName(tag, l10n),
                child: GestureDetector(
                  onTap: () => widget.onTagRemoved(tag),
                  child: Container(
                    height: 38,
                    padding: const EdgeInsets.only(left: 14, right: 10),
                    decoration: BoxDecoration(
                      color: scheme.onSurface,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          localizedTagName(tag, l10n),
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: scheme.surface,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Icon(Icons.close_rounded, size: 16, color: scheme.surface),
                      ],
                    ),
                  ),
                ),
              ),
            if (!_editing)
              Semantics(
                button: true,
                child: GestureDetector(
                  onTap: _open,
                  child: Container(
                    height: 38,
                    padding: const EdgeInsets.only(left: 10, right: 14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: scheme.outline, width: 1.5),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.add_rounded, size: 18, color: scheme.onSurface),
                        const SizedBox(width: 4),
                        Text(
                          l10n.addCategory,
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
        if (_editing) ...[
          const SizedBox(height: 12),
          if (suggestions.isNotEmpty) ...[
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final tag in suggestions)
                  ActionChip(
                    label: Text(localizedTagName(tag, l10n)),
                    onPressed: () => _addTag(tag),
                    visualDensity: VisualDensity.compact,
                  ),
              ],
            ),
            const SizedBox(height: 10),
          ],
          TextField(
            controller: _controller,
            focusNode: _focusNode,
            decoration: InputDecoration(
              hintText: l10n.addTagHint,
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (typed.isNotEmpty)
                    IconButton(
                      tooltip: l10n.add,
                      icon: Icon(Icons.check_rounded, color: scheme.primary),
                      onPressed: () => _addTag(typed),
                    ),
                  IconButton(
                    tooltip: l10n.close,
                    icon: const Icon(Icons.close_rounded),
                    onPressed: _close,
                  ),
                ],
              ),
            ),
            onChanged: (v) => setState(() => _filterText = v.trim().toLowerCase()),
            onSubmitted: _addTag,
            textInputAction: TextInputAction.done,
          ),
        ],
      ],
    );
  }
}
