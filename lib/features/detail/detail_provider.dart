import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/database/app_database.dart';
import '../home/home_provider.dart';

final ratingDetailProvider =
    StreamProvider.family<Rating, int>((ref, id) {
  return ref.watch(ratingsDaoProvider).watchById(id);
});
