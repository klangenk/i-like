import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Data passed from the quick-add sheet to the add rating screen.
class PrefillData {
  final String title;
  final String imageUrl;
  final List<String> tags;
  final String barcode;
  final String sourceUrl;
  final String notes;
  final String creator;
  final String year;

  const PrefillData({
    this.title = '',
    this.imageUrl = '',
    this.tags = const [],
    this.barcode = '',
    this.sourceUrl = '',
    this.notes = '',
    this.creator = '',
    this.year = '',
  });
}

class AddRatingState {
  final String title;
  final double score;
  final List<String> tags;
  final String notes;
  final String imageUrl;

  /// Photo the user took or picked, already copied into app storage.
  /// Takes precedence over [imageUrl] when set.
  final String localImagePath;
  final String sourceUrl;
  final String barcode;
  final String creator;
  final String year;
  final bool isLoading;

  const AddRatingState({
    this.title = '',
    this.score = 0,
    this.tags = const [],
    this.notes = '',
    this.imageUrl = '',
    this.localImagePath = '',
    this.sourceUrl = '',
    this.barcode = '',
    this.creator = '',
    this.year = '',
    this.isLoading = false,
  });

  AddRatingState copyWith({
    String? title,
    double? score,
    List<String>? tags,
    String? notes,
    String? imageUrl,
    String? localImagePath,
    String? sourceUrl,
    String? barcode,
    String? creator,
    String? year,
    bool? isLoading,
  }) {
    return AddRatingState(
      title: title ?? this.title,
      score: score ?? this.score,
      tags: tags ?? this.tags,
      notes: notes ?? this.notes,
      imageUrl: imageUrl ?? this.imageUrl,
      localImagePath: localImagePath ?? this.localImagePath,
      sourceUrl: sourceUrl ?? this.sourceUrl,
      barcode: barcode ?? this.barcode,
      creator: creator ?? this.creator,
      year: year ?? this.year,
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
  void setLocalImage(String path) => state = state.copyWith(localImagePath: path);
  void clearImage() => state = state.copyWith(imageUrl: '', localImagePath: '');
  void setSourceUrl(String url) => state = state.copyWith(sourceUrl: url);
  void setCreator(String creator) => state = state.copyWith(creator: creator);
  void setYear(String year) => state = state.copyWith(year: year);
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
    String creator = '',
    String year = '',
  }) {
    state = AddRatingState(
      title: title,
      imageUrl: imageUrl,
      tags: tags,
      barcode: barcode,
      sourceUrl: sourceUrl,
      creator: creator,
      year: year,
    );
  }
}

final addRatingProvider =
    StateNotifierProvider.autoDispose<AddRatingNotifier, AddRatingState>((ref) {
  return AddRatingNotifier();
});
