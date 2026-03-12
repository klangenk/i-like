List<String> tagsFromBarcode(String barcode) {
  final tags = <String>['product'];

  if (barcode.startsWith('978') || barcode.startsWith('979')) {
    tags
      ..clear()
      ..add('book');
  }

  if (barcode.startsWith('977')) {
    tags
      ..clear()
      ..add('magazine');
  }

  return tags;
}

String barcodeType(String barcode) {
  if (barcode.length == 13) return 'EAN-13';
  if (barcode.length == 8) return 'EAN-8';
  if (barcode.length == 12) return 'UPC-A';
  return 'Unknown';
}
