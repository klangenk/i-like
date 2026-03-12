import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class StarDisplay extends StatelessWidget {
  final double score;
  final double size;
  final Color? color;

  const StarDisplay({
    super.key,
    required this.score,
    this.size = 20,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final starColor = color ?? AppColors.accent;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final starValue = index + 1;
        if (score >= starValue) {
          return Icon(Icons.star, size: size, color: starColor);
        } else {
          return Icon(Icons.star_border, size: size, color: starColor.withAlpha(100));
        }
      }),
    );
  }
}
