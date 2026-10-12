import 'package:flutter_test/flutter_test.dart';
import 'package:i_like/core/database/app_database.dart';
import 'package:i_like/features/home/home_provider.dart';

Rating rating(int id, String tags) => Rating(
      id: id,
      title: 'R$id',
      score: 5,
      tags: tags,
      notes: '',
      imageUrl: '',
      sourceUrl: '',
      barcode: '',
      localImagePath: '',
      creator: '',
      year: '',
      createdAt: DateTime(2026),
      updatedAt: DateTime(2026),
    );

void main() {
  test('groups by first category, biggest first, untagged last', () {
    final sections = groupByTag([
      rating(1, 'book'),
      rating(2, ''),
      rating(3, 'url, product'),
      rating(4, 'food, product'),
      rating(5, 'book, Krimi'),
      rating(6, 'url'),
      rating(7, 'product'),
    ]);
    expect(sections.map((s) => s.tag), ['book', 'product', 'food', null]);
    expect(sections[0].ratings.map((r) => r.id), [1, 5]);
    expect(sections[1].ratings.map((r) => r.id), [3, 7]);
    expect(sections[3].ratings.map((r) => r.id), [2, 6]);
  });
}
