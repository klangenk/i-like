import 'package:in_app_review/in_app_review.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _askedAtKey = 'review_asked_at';

/// Rated-things counts at which Google Play's review dialog is requested,
/// each at most once. Play itself further limits how often it really shows.
const _milestones = [10, 40];

/// Asks for a store review once someone clearly uses the app.
Future<void> maybeAskForReview(SharedPreferences prefs, int ratedCount) async {
  final askedAt = prefs.getInt(_askedAtKey) ?? 0;
  final due = _milestones.where((m) => m > askedAt && ratedCount >= m);
  if (due.isEmpty) return;
  await prefs.setInt(_askedAtKey, ratedCount);
  try {
    final review = InAppReview.instance;
    if (await review.isAvailable()) await review.requestReview();
  } catch (_) {}
}
