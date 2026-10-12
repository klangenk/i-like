import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:i_like/core/utils/api_service.dart';

Map<String, dynamic> _fixture(String name) =>
    json.decode(File('test/fixtures/$name').readAsStringSync()) as Map<String, dynamic>;

void main() {
  test('GameUPC: German board game edition', () {
    final info = ApiService.parseGameUpc(_fixture('gameupc_4260370820264.json'))!;
    expect(info.title, 'Terraforming Mars');
    expect(info.year, '2016');
    expect(info.tags, ['game']);
    expect(info.sourceUrl, 'https://boardgamegeek.com/boardgame/167791');
    expect(info.imageUrl, contains('pic3536616'));
  });

  test('GameUPC: a guess that disagrees with the search is ignored', () {
    // A pen's EAN, which the crowd-sourced data maps to the game "Twitch".
    expect(ApiService.parseGameUpc(_fixture('gameupc_4006381333931.json')), isNull);
  });

  test('GameUPC: verified matches are trusted, empty results are not', () {
    expect(
      ApiService.parseGameUpc({
        'name': 'Splendor',
        'searched_for': 'splendor box',
        'bgg_info_status': 'verified',
        'bgg_info': [
          {'name': 'Splendor', 'published': '2014'},
        ],
      })?.title,
      'Splendor',
    );
    expect(
      ApiService.parseGameUpc({'name': 'None', 'searched_for': 'None', 'bgg_info': []}),
      isNull,
    );
  });
}
