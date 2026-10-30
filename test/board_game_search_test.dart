import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:i_like/core/utils/api_service.dart';

void main() {
  test('BGG search: exact name first, expansions and duplicates dropped', () {
    final ids = ApiService.parseBggSearch(
      'flip 7',
      File('test/fixtures/bgg_search_flip.xml').readAsStringSync(),
    );
    // Exact match, then prefix match, then the rest in BGG's order.
    expect(ids, ['300004', '300001', '300003']);
  });

  test('BGG things: title, designer, year, images, unescaped first paragraph', () {
    final games = ApiService.parseBggThings(
      File('test/fixtures/bgg_thing_flip.xml').readAsStringSync(),
    );
    expect(games, hasLength(2));
    final flip = games.first;
    expect(flip['title'], 'Flip 7');
    expect(flip['designer'], 'Eric Olsen');
    expect(flip['year'], '2024');
    expect(flip['snippet'], 'Flip cards one at a time — but don’t bust! First to 200 points wins.');
    expect(flip['image'], contains('__thumb'));
    expect(flip['fullImage'], contains('__original'));
    expect(flip['url'], 'https://boardgamegeek.com/boardgame/300004');
    expect(games.last['designer'], '');
  });

  test('BGG result becomes a game prefill without another request', () async {
    final game = ApiService.parseBggThings(
      File('test/fixtures/bgg_thing_flip.xml').readAsStringSync(),
    ).first;
    final info = await ApiService.boardGameInfo(game);
    expect(info.title, 'Flip 7');
    expect(info.tags, ['game']);
    expect(info.creator, 'Eric Olsen');
    expect(info.year, '2024');
    expect(info.imageUrl, contains('__original'));
    expect(info.sourceUrl, 'https://boardgamegeek.com/boardgame/300004');
  });

  test('merge: exact title wins, Wikipedia duplicates of BGG hits are dropped', () {
    final merged = ApiService.mergeBoardGameResults(
      'Flip 7',
      [
        {'title': 'Uno Flip!'},
        {'title': 'Azul (board game)'},
      ],
      [
        {'title': 'Flip 7', 'source': 'bgg'},
        {'title': 'Azul', 'source': 'bgg'},
      ],
    );
    expect([for (final r in merged) r['title']], ['Flip 7', 'Uno Flip!', 'Azul (board game)']);
  });

  test('every API request identifies the app with a contact URL', () {
    expect(ApiService.userAgent, contains('https://'));
  });
}
