import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

/// Suggestions derived from a photo, entirely on the device (ML Kit).
class PhotoInsights {
  /// Likely product/book names, best first.
  final List<String> titles;

  /// Category keys (see `tag_l10n.dart`), e.g. `food`, `book`.
  final List<String> tags;

  const PhotoInsights({this.titles = const [], this.tags = const []});

  bool get isEmpty => titles.isEmpty && tags.isEmpty;
}

/// Reads the text on a package or cover and recognises what kind of thing
/// is in the photo. Nothing leaves the device.
Future<PhotoInsights> analyzePhoto(String path) async {
  final input = InputImage.fromFilePath(path);
  final recognizer = TextRecognizer(script: TextRecognitionScript.latin);
  final labeler = ImageLabeler(options: ImageLabelerOptions(confidenceThreshold: 0.6));
  try {
    final results = await Future.wait([
      recognizer.processImage(input),
      labeler.processImage(input),
    ]);
    return PhotoInsights(
      titles: titleCandidates(results[0] as RecognizedText),
      tags: tagsFromLabels((results[1] as List<ImageLabel>).map((l) => l.label)),
    );
  } catch (_) {
    return const PhotoInsights();
  } finally {
    recognizer.close();
    labeler.close();
  }
}

/// Picks the most prominent lines – on packaging and covers the name is
/// almost always the largest text – and also offers the two largest lines
/// combined ("Vegane" + "POMMERSCHE").
List<String> titleCandidates(RecognizedText text) {
  final lines = <({String text, double height, double top})>[];
  for (final block in text.blocks) {
    for (final line in block.lines) {
      final cleaned = _cleanLine(line.text);
      if (cleaned == null) continue;
      lines.add((text: cleaned, height: line.boundingBox.height, top: line.boundingBox.top));
    }
  }
  if (lines.isEmpty) return const [];

  final bySize = [...lines]..sort((a, b) => b.height.compareTo(a.height));
  final candidates = <String>[];
  void add(String s) {
    if (!candidates.any((c) => c.toLowerCase() == s.toLowerCase())) candidates.add(s);
  }

  // Two large lines of similar size are usually one name split over lines.
  if (bySize.length > 1 && bySize[1].height > bySize[0].height * 0.55) {
    final pair = [bySize[0], bySize[1]]..sort((a, b) => a.top.compareTo(b.top));
    final combined = '${pair[0].text} ${pair[1].text}';
    if (combined.length <= 40) add(combined);
  }
  for (final line in bySize.take(4)) {
    add(line.text);
  }
  return candidates.take(3).toList();
}

/// Normalises an OCR line, or returns null if it does not look like a name
/// (too short, mostly digits, weights, prices, …).
String? _cleanLine(String raw) {
  final line = raw.replaceAll(RegExp(r'\s+'), ' ').trim();
  if (line.length < 3 || line.length > 40) return null;
  final letters = RegExp(r'\p{L}', unicode: true).allMatches(line).length;
  if (letters < line.length * 0.6) return null;
  if (RegExp(r'^\d+([.,]\d+)?\s?(g|kg|ml|l|%|€)$', caseSensitive: false).hasMatch(line)) {
    return null;
  }
  // SHOUTED PACKAGING TEXT -> Title Case
  final isUpper = line == line.toUpperCase() && line != line.toLowerCase();
  if (!isUpper) return line;
  return line
      .split(' ')
      .map((w) => w.isEmpty ? w : w[0] + w.substring(1).toLowerCase())
      .join(' ');
}

/// Maps ML Kit's generic image labels onto the app's categories.
List<String> tagsFromLabels(Iterable<String> labels) {
  const mapping = {
    'food': ['Food', 'Dish', 'Cuisine', 'Pizza', 'Fruit', 'Vegetable', 'Bread', 'Cake',
        'Baked goods', 'Dessert', 'Snack', 'Meal', 'Drink', 'Coffee', 'Cup', 'Juice'],
    'book': ['Book', 'Publication', 'Novel', 'Comics', 'Paper'],
    'game': ['Toy', 'Board game', 'Game', 'Lego', 'Jigsaw puzzle', 'Dice', 'Playing card'],
    'music': ['Musical instrument', 'Guitar', 'Piano', 'Vinyl'],
    'place': ['Restaurant', 'Building', 'Tower', 'Bridge', 'Beach', 'Mountain',
        'Park', 'Church', 'Castle', 'Skyscraper'],
    'product': ['Mobile phone', 'Computer', 'Laptop', 'Gadget', 'Headphones', 'Television',
        'Camera', 'Bottle', 'Shoe', 'Bag', 'Watch', 'Sunglasses', 'Jacket', 'Clothing'],
  };
  final result = <String>[];
  for (final label in labels) {
    for (final entry in mapping.entries) {
      if (entry.value.any((v) => v.toLowerCase() == label.toLowerCase()) &&
          !result.contains(entry.key)) {
        result.add(entry.key);
      }
    }
  }
  return result.take(2).toList();
}
