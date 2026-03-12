import 'package:flutter/material.dart';

class AppColors {
  static const Color accent = Color(0xFFF59E0B); // Amber
  static const Color accentLight = Color(0xFFFBBF24);
  static const Color accentDark = Color(0xFFD97706);

  static const Map<String, Color> tagColors = {
    'product': Color(0xFF3B82F6),   // Blue
    'book': Color(0xFF8B5CF6),      // Purple
    'movie': Color(0xFFEF4444),     // Red
    'series': Color(0xFFF97316),    // Orange
    'place': Color(0xFF10B981),     // Green
    'url': Color(0xFF06B6D4),       // Cyan
    'food': Color(0xFFF59E0B),      // Amber
    'music': Color(0xFFEC4899),     // Pink
    'game': Color(0xFF6366F1),      // Indigo
    'app': Color(0xFF14B8A6),       // Teal
    'other': Color(0xFF6B7280),     // Gray
  };

  static Color tagColor(String tag) {
    final lower = tag.toLowerCase();
    return tagColors[lower] ?? _hashColor(lower);
  }

  static Color _hashColor(String tag) {
    final hash = tag.hashCode;
    final colors = [
      const Color(0xFF3B82F6),
      const Color(0xFF8B5CF6),
      const Color(0xFFEF4444),
      const Color(0xFFF97316),
      const Color(0xFF10B981),
      const Color(0xFF06B6D4),
      const Color(0xFFEC4899),
      const Color(0xFF6366F1),
      const Color(0xFF14B8A6),
    ];
    return colors[hash.abs() % colors.length];
  }
}
