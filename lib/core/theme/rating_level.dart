import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';

/// The five word levels shown instead of stars. They map 1:1 onto the stored
/// integer score (1–5), so the database and export format are unchanged.
enum RatingLevel {
  nope(1, Color(0xFF7D7A8C), Color(0xFFECEBF0), Color(0xFF4E4C5C), Color(0xFF2C2B33), Color(0xFFC9C7D4)),
  naja(2, Color(0xFF4C8DF6), Color(0xFFE3EDFF), Color(0xFF2453B0), Color(0xFF152A52), Color(0xFF9DBDFF)),
  okay(3, Color(0xFF18A999), Color(0xFFDDF5F1), Color(0xFF0B6B5F), Color(0xFF0E3A34), Color(0xFF74DCCB)),
  gut(4, Color(0xFFF2A93B), Color(0xFFFFF0D6), Color(0xFF8A5200), Color(0xFF45300C), Color(0xFFFFC772)),
  liebe(5, Color(0xFFE5245E), Color(0xFFFFE3EC), Color(0xFFB0123F), Color(0xFF4A1426), Color(0xFFFF9BB8));

  const RatingLevel(this.value, this.dot, this._tint, this._strong, this._tintDark, this._strongDark);

  final int value;

  /// Solid signal colour (dots, bars). Never used behind text.
  final Color dot;
  final Color _tint;
  final Color _strong;
  final Color _tintDark;
  final Color _strongDark;

  /// Levels from best to worst, the order used in filters.
  static const List<RatingLevel> bestFirst = [liebe, gut, okay, naja, nope];

  /// Returns null for an unrated score (0).
  static RatingLevel? fromScore(double score) {
    final v = score.round();
    if (v < 1) return null;
    return values[v.clamp(1, 5) - 1];
  }

  /// Pill / panel background.
  Color tint(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? _tintDark : _tint;

  /// Text drawn on [tint]; meets 4.5:1.
  Color strong(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? _strongDark : _strong;

  String word(AppLocalizations l10n) => switch (this) {
        nope => l10n.levelNope,
        naja => l10n.levelNaja,
        okay => l10n.levelOkay,
        gut => l10n.levelGood,
        liebe => l10n.levelLove,
      };

  String phrase(AppLocalizations l10n) => switch (this) {
        nope => l10n.levelNopePhrase,
        naja => l10n.levelNajaPhrase,
        okay => l10n.levelOkayPhrase,
        gut => l10n.levelGoodPhrase,
        liebe => l10n.levelLovePhrase,
      };
}
