import '../../l10n/app_localizations.dart';

/// Maps an internal tag key to its localized display name.
/// Unknown tags are returned as-is (user-created custom tags).
String localizedTagName(String tagKey, AppLocalizations l10n) {
  return switch (tagKey) {
    'product' => l10n.tagProduct,
    'book' => l10n.tagBook,
    'movie' => l10n.tagMovie,
    'series' => l10n.tagSeries,
    'place' => l10n.tagPlace,
    'url' => l10n.tagUrl,
    'food' => l10n.tagFood,
    'music' => l10n.tagMusic,
    'game' => l10n.tagGame,
    'app' => l10n.tagApp,
    'magazine' => l10n.tagMagazine,
    'other' => l10n.tagOther,
    _ => tagKey,
  };
}
