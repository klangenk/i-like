import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/rating_level.dart';
import '../../../l10n/app_localizations.dart';
import '../home_provider.dart';

/// Six-way segmented control: All · Liebe · Gut · Okay · Naja · Nope.
/// Fits on one row, so nothing scrolls sideways.
class LevelFilter extends ConsumerWidget {
  const LevelFilter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final selected = ref.watch(levelFilterProvider);
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Widget segment({required RatingLevel? level, required String label, required Color dot}) {
      final isSelected = selected == level;
      return Expanded(
        child: Semantics(
          button: true,
          selected: isSelected,
          label: label,
          excludeSemantics: true,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              HapticFeedback.selectionClick();
              ref.read(levelFilterProvider.notifier).state = level;
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              height: 50,
              decoration: BoxDecoration(
                color: isSelected
                    ? (isDark ? const Color(0xFF34333C) : Colors.white)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(14),
                boxShadow: isSelected && !isDark
                    ? const [BoxShadow(color: Color(0x241C1B22), blurRadius: 4, offset: Offset(0, 1))]
                    : null,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(color: dot, shape: BoxShape.circle),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.fade,
                    softWrap: false,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: scheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          segment(level: null, label: l10n.filterAll, dot: scheme.onSurface),
          for (final level in RatingLevel.bestFirst)
            segment(level: level, label: level.word(l10n), dot: level.dot),
        ],
      ),
    );
  }
}
