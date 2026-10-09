import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/rating_level.dart';
import '../../../l10n/app_localizations.dart';

/// Word-level rating input: a large panel showing the chosen word and phrase,
/// above five round buttons from Nope (1) to Liebe (5).
/// [score] 0 means nothing chosen yet.
class LevelPicker extends StatelessWidget {
  final double score;
  final ValueChanged<double> onChanged;

  const LevelPicker({super.key, required this.score, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final current = RatingLevel.fromScore(score);
    final scheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          height: 150,
          decoration: BoxDecoration(
            color: current?.tint(context) ?? scheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(28),
          ),
          child: Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 180),
              child: current == null
                  ? Text(
                      l10n.pickALevel,
                      key: const ValueKey('none'),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: scheme.onSurfaceVariant,
                      ),
                    )
                  : Column(
                      key: ValueKey(current),
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          current.word(l10n),
                          style: TextStyle(
                            fontSize: 64,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -2.5,
                            height: 1,
                            color: current.strong(context),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          current.phrase(l10n),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: current.strong(context),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
        const SizedBox(height: 22),
        Row(
          children: [
            for (final level in RatingLevel.values)
              Expanded(
                child: _LevelButton(
                  level: level,
                  label: level.word(l10n),
                  selected: level == current,
                  onTap: () {
                    HapticFeedback.selectionClick();
                    onChanged(level.value.toDouble());
                  },
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _LevelButton extends StatelessWidget {
  final RatingLevel level;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _LevelButton({
    required this.level,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Semantics(
      inMutuallyExclusiveGroup: true,
      checked: selected,
      button: true,
      label: label,
      excludeSemantics: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected ? level.tint(context) : scheme.surfaceContainerHighest,
                border: Border.all(
                  color: selected ? level.strong(context) : Colors.transparent,
                  width: 3,
                ),
              ),
              alignment: Alignment.center,
              child: level == RatingLevel.liebe
                  ? Icon(Icons.favorite_rounded, size: 26, color: level.dot)
                  : Text(
                      '${level.value}',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: level.strong(context),
                      ),
                    ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: selected ? FontWeight.w800 : FontWeight.w700,
                color: scheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
