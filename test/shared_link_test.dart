import 'package:flutter_test/flutter_test.dart';
import 'package:i_like/core/utils/url_helper.dart';

void main() {
  const thalia = 'https://www.thalia.de/shop/home/artikeldetails/A1080181880';

  test('a shop share sentence is not a title', () {
    expect(extractTitleFromSharedText('Schau mal hier, mein Artikel auf thalia.de $thalia'), isNull);
    expect(extractTitleFromSharedText('Look at this: my item on example.com $thalia'), isNull);
  });

  test('a real title in the share text is kept', () {
    expect(extractTitleFromSharedText('„Böser Samstag" $thalia'), 'Böser Samstag');
    expect(extractTitleFromSharedText('Dune bei thalia.de $thalia'), 'Dune');
    expect(extractTitleFromSharedText('Dune von Frank Herbert $thalia'), 'Dune von Frank Herbert');
  });

  test('bot checks are recognised', () {
    expect(isBlockPageTitle('Sicherheits-Check'), isTrue);
    expect(isBlockPageTitle('Just a moment...'), isTrue);
    expect(isBlockPageTitle('Böser Samstag - Nicci French | Thalia'), isFalse);
    expect(isBlockPageTitle(null), isFalse);
  });

  test('web search query drops scheme, www and parameters', () {
    expect(linkSearchQuery('$thalia?utm_source=share'), 'thalia.de/shop/home/artikeldetails/A1080181880');
  });

  test('shop titles lose the call to buy', () {
    expect(
      cleanShopTitle('Legami löschbarer Gelstift - Trick or Treat - Spooky Party kaufen'),
      'Legami löschbarer Gelstift - Trick or Treat - Spooky Party',
    );
    expect(cleanShopTitle('Böser Samstag online bestellen'), 'Böser Samstag');
    expect(cleanShopTitle('Ich kaufe'), 'Ich kaufe');
    expect(cleanShopTitle('Nutella 750g bei REWE online bestellen! REWE.de'), 'Nutella 750g');
  });

  test('page titles lose the site name but keep inner dashes and quotes', () {
    const lidl = 'https://www.lidl.de/p/x/p100411005';
    expect(
      cleanPageTitle('Herren Kaschmirpullover »Jogi Löw - Kollektion« - Lidl', url: lidl),
      'Herren Kaschmirpullover »Jogi Löw - Kollektion«',
    );
    expect(cleanPageTitle('„Böser Samstag"'), 'Böser Samstag');
    expect(cleanPageTitle('Dune | Goodreads', url: 'https://www.goodreads.com/book/1'), 'Dune');
  });

  test('a shop offer phrase is not part of the title', () {
    expect(
      extractTitleFromSharedText(
        'Top Angebot für dich bei Lidl: Herren Kaschmirpullover »Jogi Löw - Kollektion«! https://www.lidl.de/p/x',
      ),
      startsWith('Herren Kaschmirpullover'),
    );
  });
}
