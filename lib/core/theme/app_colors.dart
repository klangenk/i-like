import 'package:flutter/material.dart';

class AppColors {
  // Brand
  static const Color raspberry = Color(0xFFD41D55); // Actions, white text passes AA
  static const Color heart = Color(0xFFE5245E); // Heart glyph only
  static const Color raspberryText = Color(0xFFC2184F); // Links on light

  // Neutrals – light
  static const Color ink = Color(0xFF1C1B22);
  static const Color inkMuted = Color(0xFF5E5C6B);
  static const Color mist = Color(0xFFF5F4F7);
  static const Color line = Color(0xFFECEBF0);

  // Neutrals – dark
  static const Color nightBackground = Color(0xFF121116);
  static const Color nightSurface = Color(0xFF1E1D24);
  static const Color nightLine = Color(0xFF2C2B33);
  static const Color nightInk = Color(0xFFF3F2F6);
  static const Color nightInkMuted = Color(0xFFA9A7B6);

  /// Kept for older call sites; the brand accent is now raspberry.
  static const Color accent = raspberry;

  static const Map<String, Color> tagColors = {
    'product': Color(0xFF2453B0),
    'book': Color(0xFF0B6B5F),
    'movie': Color(0xFF7A2DB8),
    'series': Color(0xFF7A2DB8),
    'place': Color(0xFF2D6A1F),
    'url': Color(0xFF0E6A8A),
    'food': Color(0xFF8A5200),
    'music': Color(0xFFB0123F),
    'game': Color(0xFFA11F55),
    'app': Color(0xFF0B6B5F),
    'other': Color(0xFF4E4C5C),
  };

  static Color tagColor(String tag) {
    final lower = tag.toLowerCase();
    return tagColors[lower] ?? _hashColor(lower);
  }

  static Color _hashColor(String tag) {
    final colors = tagColors.values.toList();
    return colors[tag.hashCode.abs() % colors.length];
  }

  /// Neutral surface for secondary fills (icon circles, inputs, segments).
  static Color subtle(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? nightSurface : mist;

  static Color muted(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? nightInkMuted : inkMuted;

  static Color divider(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? nightLine : line;
}
