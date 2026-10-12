List<String> tagsFromBarcode(String barcode) {
  final tags = <String>['product'];

  if (barcode.startsWith('978') || barcode.startsWith('979')) {
    tags
      ..clear()
      ..add('book');
  }

  if (isMagazineBarcode(barcode)) {
    tags
      ..clear()
      ..add('magazine');
  }

  return tags;
}

/// Magazines and newspapers: ISSN codes (977) and German press codes
/// (414, 419), whose registry is not public, so no service can look them up.
bool isMagazineBarcode(String barcode) =>
    barcode.length == 13 && RegExp(r'^(977|414|419)').hasMatch(barcode);

/// Amazon's own warehouse label ("X001KYHKNN"), stuck over the real EAN/ISBN.
bool isAmazonFnsku(String barcode) => RegExp(r'^X00[0-9A-Z]{7}$').hasMatch(barcode.trim());

String barcodeType(String barcode) {
  if (barcode.length == 13) return 'EAN-13';
  if (barcode.length == 8) return 'EAN-8';
  if (barcode.length == 12) return 'UPC-A';
  return 'Unknown';
}
