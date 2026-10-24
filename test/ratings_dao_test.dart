import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:i_like/core/database/app_database.dart';
import 'package:i_like/core/database/ratings_dao.dart';

void main() {
  late AppDatabase db;
  late RatingsDao dao;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    dao = RatingsDao(db);
  });

  tearDown(() => db.close());

  Future<int> insert({String imageUrl = 'https://x.test/a.jpg', String localPath = ''}) =>
      dao.insertRating(RatingsCompanion.insert(
        title: 'Kaffee',
        score: 4,
        imageUrl: Value(imageUrl),
        localImagePath: Value(localPath),
      ));

  group('setDownloadedImage', () {
    test('stores the copy on a rating that still shows the URL', () async {
      final id = await insert();
      expect(await dao.setDownloadedImage(id, 'https://x.test/a.jpg', '/img/1.jpg'), isTrue);
      expect((await dao.getById(id)).localImagePath, '/img/1.jpg');
    });

    test('skips a deleted rating', () async {
      final id = await insert();
      await dao.deleteRating(id);
      expect(await dao.setDownloadedImage(id, 'https://x.test/a.jpg', '/img/1.jpg'), isFalse);
    });

    test('skips a rating whose image changed meanwhile', () async {
      final id = await insert();
      final rating = await dao.getById(id);
      await dao.updateRating(rating.copyWith(imageUrl: 'https://x.test/b.jpg'));
      expect(await dao.setDownloadedImage(id, 'https://x.test/a.jpg', '/img/1.jpg'), isFalse);
      expect((await dao.getById(id)).localImagePath, '');
    });

    test('keeps a photo the user picked meanwhile', () async {
      final id = await insert(localPath: '/img/own.jpg');
      expect(await dao.setDownloadedImage(id, 'https://x.test/a.jpg', '/img/1.jpg'), isFalse);
      expect((await dao.getById(id)).localImagePath, '/img/own.jpg');
    });
  });
}
