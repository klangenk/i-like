import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:i_like/core/utils/api_service.dart';
import 'package:i_like/core/utils/barcode_helper.dart';

void main() {
  test('DNB record: title without subtitle, author, year', () {
    final info = ApiService.parseDnbRecord(
      File('test/fixtures/dnb_9783466311934.xml').readAsStringSync(),
    )!;
    expect(info.title, 'Auf Kosten der Mütter');
    expect(info.creator, 'Birgit Happel');
    expect(info.year, '2023');
  });

  test('DNB record: original title and translator are dropped', () {
    final info = ApiService.parseDnbRecord(
      File('test/fixtures/dnb_9783328100447.xml').readAsStringSync(),
    )!;
    expect(info.title, 'Böser Samstag');
    expect(info.creator, 'Nicci French');
    expect(info.year, '2017');
  });

  test('empty DNB result', () {
    expect(ApiService.parseDnbRecord('<searchRetrieveResponse/>'), isNull);
  });

  test('Amazon warehouse labels are recognised', () {
    expect(isAmazonFnsku('X001KYHKNN'), isTrue);
    expect(isAmazonFnsku('9783466311934'), isFalse);
  });

  test('magazine codes are recognised', () {
    expect(isMagazineBarcode('4197083105909'), isTrue); // German press code
    expect(isMagazineBarcode('9770000000000'), isTrue); // ISSN
    expect(isMagazineBarcode('4260401414349'), isFalse); // sunscreen
    expect(tagsFromBarcode('4197083105909'), ['magazine']);
  });
}
