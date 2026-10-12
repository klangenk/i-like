import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/backup/backup_service.dart';
import '../home/home_provider.dart';

const _tmdbApiKeyPref = 'tmdb_api_key';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences must be overridden in ProviderScope');
});

/// Whether the optional Google-account backup is on (Android only).
final backupEnabledProvider = StateProvider<bool>((ref) {
  return BackupService.isEnabled(ref.watch(sharedPreferencesProvider));
});

/// Refreshes the backup copy whenever the ratings change.
final backupSchedulerProvider = Provider<BackupScheduler>((ref) {
  final scheduler = BackupScheduler(
    ref.watch(databaseProvider),
    ref.watch(sharedPreferencesProvider),
  );
  ref.listen(ratingsProvider, (_, _) => scheduler.changed());
  ref.onDispose(scheduler.dispose);
  return scheduler;
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
