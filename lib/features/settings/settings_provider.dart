import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _tmdbApiKeyPref = 'tmdb_api_key';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences must be overridden in ProviderScope');
});

final tmdbApiKeyProvider = StateNotifierProvider<TmdbApiKeyNotifier, String>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return TmdbApiKeyNotifier(prefs);
});

class TmdbApiKeyNotifier extends StateNotifier<String> {
  final SharedPreferences _prefs;

  TmdbApiKeyNotifier(this._prefs) : super(_prefs.getString(_tmdbApiKeyPref) ?? '');

  Future<void> setApiKey(String key) async {
    state = key;
    await _prefs.setString(_tmdbApiKeyPref, key);
  }

  Future<void> clearApiKey() async {
    state = '';
    await _prefs.remove(_tmdbApiKeyPref);
  }

  bool get hasKey => state.isNotEmpty;
}
