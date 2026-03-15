import 'dart:convert';

import 'package:drift/drift.dart';

import '../../core/database/app_database.dart';
import '../../core/database/ratings_dao.dart';

class ExportImportService {
  static Future<String> exportToJson(RatingsDao dao) async {
    final ratings = await dao.getAll();
    final ratingsJson = ratings.map((r) => {
      'title': r.title,
      'score': r.score,
      'tags': r.tags.isEmpty
          ? <String>[]
          : r.tags.split(',').map((t) => t.trim()).where((t) => t.isNotEmpty).toList(),
      'notes': r.notes,
      'imageUrl': r.imageUrl,
      'sourceUrl': r.sourceUrl,
      'barcode': r.barcode,
      'createdAt': r.createdAt.toUtc().toIso8601String(),
      'updatedAt': r.updatedAt.toUtc().toIso8601String(),
    }).toList();

    final envelope = {
      'version': 1,
      'exportedAt': DateTime.now().toUtc().toIso8601String(),
      'ratings': ratingsJson,
    };

    return const JsonEncoder.withIndent('  ').convert(envelope);
  }

  static Future<List<int>> exportToCsv(RatingsDao dao) async {
    final ratings = await dao.getAll();
    final buf = StringBuffer();
    buf.writeln('title;score;tags;notes;imageUrl;sourceUrl;barcode;createdAt;updatedAt');
    for (final r in ratings) {
      buf.writeln([
        _csvCell(r.title),
        r.score.toString(),
        _csvCell(r.tags),
        _csvCell(r.notes),
        _csvCell(r.imageUrl),
        _csvCell(r.sourceUrl),
        _csvCell(r.barcode),
        r.createdAt.toUtc().toIso8601String(),
        r.updatedAt.toUtc().toIso8601String(),
      ].join(';'));
    }
    // Prepend UTF-8 BOM as raw bytes so Excel detects encoding correctly
    return [0xEF, 0xBB, 0xBF, ...utf8.encode(buf.toString())];
  }

  static String _csvCell(String value) {
    if (value.contains(';') || value.contains('"') || value.contains('\n')) {
      return '"${value.replaceAll('"', '""')}"';
    }
    return value;
  }

  static Future<({int imported, int skipped})> importFromJson(
    String json,
    RatingsDao dao,
  ) async {
    final data = jsonDecode(json) as Map<String, dynamic>;

    if (data['version'] != 1) {
      throw FormatException('Unsupported export version: ${data['version']}');
    }

    final ratingsJson = data['ratings'] as List<dynamic>;

    // Build set of existing keys for duplicate detection
    final existing = await dao.getAll();
    final existingKeys = <String>{};
    for (final r in existing) {
      existingKeys.add('${r.title}|${r.barcode}|${r.sourceUrl}');
    }

    int imported = 0;
    int skipped = 0;

    for (final item in ratingsJson) {
      final map = item as Map<String, dynamic>;
      final key =
          '${map['title']}|${map['barcode'] ?? ''}|${map['sourceUrl'] ?? ''}';

      if (existingKeys.contains(key)) {
        skipped++;
        continue;
      }

      await dao.insertRating(RatingsCompanion(
        title: Value(map['title'] as String),
        score: Value((map['score'] as num).toDouble()),
        tags: Value(map['tags'] is List
            ? (map['tags'] as List).join(', ')
            : map['tags'] as String? ?? ''),
        notes: Value(map['notes'] as String? ?? ''),
        imageUrl: Value(map['imageUrl'] as String? ?? ''),
        sourceUrl: Value(map['sourceUrl'] as String? ?? ''),
        barcode: Value(map['barcode'] as String? ?? ''),
        createdAt: Value(DateTime.parse(map['createdAt'] as String)),
        updatedAt: Value(DateTime.parse(map['updatedAt'] as String)),
      ));

      existingKeys.add(key);
      imported++;
    }

    return (imported: imported, skipped: skipped);
  }
}
