import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_colors.dart';

class StarInput extends StatefulWidget {
  final double score;
  final ValueChanged<double> onChanged;
  final double size;

  const StarInput({
    super.key,
    required this.score,
    required this.onChanged,
    this.size = 48,
  });

  @override
  State<StarInput> createState() => _StarInputState();
}

class _StarInputState extends State<StarInput> {
  final _rowKey = GlobalKey();
  double _lastHapticValue = 0;

  void _updateFromPosition(double globalX) {
    final box = _rowKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) return;

    final local = box.globalToLocal(Offset(globalX, 0));
    final starWidth = widget.size + 8; // size + horizontal padding (4*2)
    final totalWidth = starWidth * 5;
    final startX = (box.size.width - totalWidth) / 2;
    final relative = local.dx - startX;

    final value = (relative / starWidth).ceil().clamp(0, 5).toDouble();
    if (value != widget.score) {
      if (value != _lastHapticValue) {
        HapticFeedback.selectionClick();
        _lastHapticValue = value;
      }
      widget.onChanged(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragStart: (details) {
        _lastHapticValue = widget.score;
        _updateFromPosition(details.globalPosition.dx);
      },
      onHorizontalDragUpdate: (details) {
        _updateFromPosition(details.globalPosition.dx);
      },
      child: Row(
        key: _rowKey,
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(5, (index) {
          final starValue = (index + 1).toDouble();
          final isFilled = widget.score >= starValue;

          return GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              if (widget.score == starValue) {
                widget.onChanged(starValue - 1);
              } else {
                widget.onChanged(starValue);
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Icon(
                isFilled ? Icons.star : Icons.star_border,
                size: widget.size,
                color: isFilled
                    ? AppColors.accent
                    : AppColors.accent.withAlpha(80),
              ),
            ),
          );
        }),
      ),
    );
  }
}
