import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Data passed from the quick-add sheet to the add rating screen.
class PrefillData {
  final String title;
  final String imageUrl;
  final List<String> tags;
  final String barcode;
  final String sourceUrl;
  final String notes;

  const PrefillData({
    this.title = '',
    this.imageUrl = '',
    this.tags = const [],
    this.barcode = '',
    this.sourceUrl = '',
    this.notes = '',
  });
}

class AddRatingState {
  final String title;
  final double score;
  final List<String> tags;
  final String notes;
  final String imageUrl;
  final String sourceUrl;
  final String barcode;
  final bool isLoading;

  const AddRatingState({
    this.title = '',
    this.score = 0,
    this.tags = const [],
    this.notes = '',
    this.imageUrl = '',
    this.sourceUrl = '',
    this.barcode = '',
    this.isLoading = false,
  });

  AddRatingState copyWith({
    String? title,
    double? score,
    List<String>? tags,
    String? notes,
    String? imageUrl,
    String? sourceUrl,
    String? barcode,
    bool? isLoading,
  }) {
    return AddRatingState(
      title: title ?? this.title,
      score: score ?? this.score,
      tags: tags ?? this.tags,
      notes: notes ?? this.notes,
      imageUrl: imageUrl ?? this.imageUrl,
      sourceUrl: sourceUrl ?? this.sourceUrl,
      barcode: barcode ?? this.barcode,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class AddRatingNotifier extends StateNotifier<AddRatingState> {
  AddRatingNotifier() : super(const AddRatingState());

  void setTitle(String title) => state = state.copyWith(title: title);
  void setScore(double score) => state = state.copyWith(score: score);
  void setNotes(String notes) => state = state.copyWith(notes: notes);
  void setImageUrl(String url) => state = state.copyWith(imageUrl: url);
  void setSourceUrl(String url) => state = state.copyWith(sourceUrl: url);
  void setBarcode(String barcode) => state = state.copyWith(barcode: barcode);
  void setLoading(bool loading) => state = state.copyWith(isLoading: loading);

  void addTag(String tag) {
    if (!state.tags.contains(tag) && tag.isNotEmpty) {
      state = state.copyWith(tags: [...state.tags, tag]);
    }
  }

  void removeTag(String tag) {
    state = state.copyWith(tags: state.tags.where((t) => t != tag).toList());
  }

  void reset() => state = const AddRatingState();

  void prefill({
    required String title,
    String imageUrl = '',
    List<String> tags = const [],
    String barcode = '',
    String sourceUrl = '',
  }) {
    state = AddRatingState(
      title: title,
      imageUrl: imageUrl,
      tags: tags,
      barcode: barcode,
      sourceUrl: sourceUrl,
    );
  }
}

final addRatingProvider =
    StateNotifierProvider.autoDispose<AddRatingNotifier, AddRatingState>((ref) {
  return AddRatingNotifier();
});
