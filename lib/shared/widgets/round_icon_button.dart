import 'package:flutter/material.dart';

/// 44 px circular icon button on a soft fill, used in headers and over photos.
class RoundIconButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;
  final Color? background;
  final Color? foreground;

  const RoundIconButton({
    super.key,
    required this.icon,
    required this.tooltip,
    this.onPressed,
    this.background,
    this.foreground,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return IconButton(
      tooltip: tooltip,
      onPressed: onPressed,
      icon: Icon(icon, size: 21),
      style: IconButton.styleFrom(
        backgroundColor: background ?? scheme.surfaceContainerHighest,
        foregroundColor: foreground ?? scheme.onSurface,
        fixedSize: const Size(44, 44),
        minimumSize: const Size(44, 44),
      ),
    );
  }
}
