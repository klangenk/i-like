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

/// Categories where a year (release, publication) means nothing.
const _undatedTags = {'food', 'place', 'product'};

/// Tags that say nothing about the kind of thing.
const _neutralTags = {'url', 'other'};

/// Whether the year field fits these tags. It is hidden only when the rating
/// is clearly food, a place or a product; books, films, games, music and
/// custom tags (wine vintages, …) keep it.
bool tagsHaveYear(Iterable<String> tags) {
  final kinds = tags.where((t) => !_neutralTags.contains(t)).toList();
  return kinds.isEmpty || kinds.any((t) => !_undatedTags.contains(t));
}
