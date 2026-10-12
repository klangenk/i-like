import 'package:flutter_test/flutter_test.dart';
import 'package:i_like/core/utils/tag_l10n.dart';

void main() {
  test('year is hidden for food, places and products', () {
    expect(tagsHaveYear(['food']), isFalse);
    expect(tagsHaveYear(['place', 'url']), isFalse);
    expect(tagsHaveYear(['product', 'other']), isFalse);
  });

  test('year stays for dated, custom or unknown kinds', () {
    expect(tagsHaveYear([]), isTrue);
    expect(tagsHaveYear(['url']), isTrue);
    expect(tagsHaveYear(['book']), isTrue);
    expect(tagsHaveYear(['product', 'game']), isTrue);
    expect(tagsHaveYear(['Wein']), isTrue);
  });
}
