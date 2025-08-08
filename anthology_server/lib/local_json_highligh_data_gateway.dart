import 'dart:convert';
import 'dart:io';

import 'package:anthology_common/article/entities.dart';
import 'package:anthology_common/errors.dart';
import 'package:anthology_common/highlight/data_gateway.dart';
import 'package:anthology_common/highlight/entities.dart';

class LocalJsonHighlighDataGateway implements HightlightDataGateway {
  static final savesFIlePath = "./db/highlights.json";

  @override
  Future<Highlight> get(String id) async {
    final higlights = await _readJsonFile();
    await _assertHighlightExists(id);
    return higlights[id]!;
  }

  @override
  Future<Map<String, List<Highlight>>> getAll() async {
    final highlights = await _readJsonFile();
    final articleIds = {
      for (final highlight in highlights.values) highlight.articleId,
    };
    return {
      for (final articleId in articleIds)
        articleId: (await getArticleHighlights(articleId)),
    };
  }

  @override
  Future<List<Highlight>> getArticleHighlights(String articleId) async {
    final highlights = await _readJsonFile();
    return [
      for (final highlight in highlights.values)
        if (highlight.articleId == articleId) highlight,
    ];
  }

  @override
  Future<void> save(Highlight highlight) async {
    final highlights = await _readJsonFile();
    highlights[highlight.id] = highlight;
    await _writeToJsonFile(highlights);
  }

  @override
  Future<void> deleteAll() async {
    await _writeToJsonFile({});
  }

  @override
  Future<void> delete(String id) async {
    final highlights = await _readJsonFile();
    await _assertHighlightExists(id);
    highlights.remove(id);
    await _writeToJsonFile(highlights);
  }

  Future<void> _assertHighlightExists(String id) async {
    if (!(await highlightExists(id))) {
      throw HighlightNotFoundError(id);
    }
  }

  Future<bool> highlightExists(String id) async {
    final highlights = await _readJsonFile();
    return highlights.containsKey(id);
  }

  Future<Map<String, Highlight>> _readJsonFile() async {
    final jsonString = await File(savesFIlePath).readAsString();
    final json = (jsonDecode(jsonString) as Map).cast<String, Json>();
    return {
      for (final entry in json.entries)
        entry.key: Highlight.fromJson(entry.value),
    };
  }

  Future<void> _writeToJsonFile(Map<String, Highlight> highlights) async {
    final json = {
      for (final entry in highlights.entries) entry.key: entry.value.toJson(),
    };
    final jsonAsString = jsonEncode(json);
    await File(savesFIlePath).writeAsString(jsonAsString);
  }
}
