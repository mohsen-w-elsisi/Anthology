import 'dart:convert';
import 'dart:io';

import 'package:anthology_common/errors.dart';
import 'package:anthology_common/highlight/data_gateway.dart';
import 'package:anthology_common/highlight/entities.dart';
import 'package:anthology_common/shared_impls/io_queue.dart';

class LocalHighlightDataGateway with IoQueue implements HighlightDataGateway {
  final String path;

  LocalHighlightDataGateway(this.path);

  @override
  Future<void> delete(String id) => queueUp(() async {
    final highlights = await _readHighlights();
    highlights.removeWhere((key, value) => key == id);
    await _writeHighlights(highlights);
  });

  @override
  Future<void> deleteAll() => queueUp(() async {
    await _writeHighlights({});
  });

  @override
  Future<Highlight> get(String id) => queueUp(() async {
    final highlights = await _readHighlights();
    if (!highlights.containsKey(id)) {
      throw HighlightNotFoundError(id);
    }
    return Highlight.fromJson(highlights[id]!);
  });

  @override
  Future<Map<String, List<Highlight>>> getAll() => queueUp(() async {
    final highlights = await _readHighlights();
    final groupedHighlights = <String, List<Highlight>>{};
    for (final highlight in highlights.values) {
      final parsedHighlight = Highlight.fromJson(highlight);
      final articleId = parsedHighlight.articleId;
      groupedHighlights.putIfAbsent(articleId, () => []);
      groupedHighlights[articleId]!.add(parsedHighlight);
    }
    return groupedHighlights;
  });

  @override
  Future<List<Highlight>> getArticleHighlights(String articleId) =>
      queueUp(() async {
        final highlights = await _readHighlights();
        return highlights.values
            .map((json) => Highlight.fromJson(json))
            .where((highlight) => highlight.articleId == articleId)
            .toList();
      });

  @override
  Future<void> save(Highlight highlight) => queueUp(() async {
    final highlights = await _readHighlights();
    highlights[highlight.id] = highlight.toJson();
    await _writeHighlights(highlights);
  });

  Future<Map<String, dynamic>> _readHighlights() async {
    final file = File(path);
    if (!await file.exists() || (await file.readAsString()).isEmpty) {
      return {};
    }
    final content = await file.readAsString();
    try {
      return jsonDecode(content) as Map<String, dynamic>;
    } catch (e) {
      print('Error decoding JSON: $e');
      return {};
    }
  }

  Future<void> _writeHighlights(Map<String, dynamic> highlights) async {
    final file = File(path);
    if (!await file.parent.exists()) {
      await file.parent.create(recursive: true);
    }
    await file.writeAsString(jsonEncode(highlights));
  }
}
