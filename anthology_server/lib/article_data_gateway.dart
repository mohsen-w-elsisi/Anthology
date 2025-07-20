import 'dart:convert';
import 'dart:io';

import 'package:anthology_server/article.dart';

class ArticleDataGateway {
  static const savesFIlePath = "./db/saves.json";

  Future<void> save(Article article) async {
    final savedArticles = await _readJsonFile();
    final newArticles = <Article>[...savedArticles, article];
    _writeToJsonFile(newArticles);
  }

  Future<List<Article>> getAll() {
    return _readJsonFile();
  }

  Future<List<Article>> _readJsonFile() async {
    final jsonString = await File(savesFIlePath).readAsString();
    final json = (jsonDecode(jsonString) as List).cast<Json>();
    final savedArticles = [
      for (final articleJson in json) Article.fromJson(articleJson),
    ];
    return savedArticles;
  }

  Future<void> _writeToJsonFile(List<Article> artciles) async {
    final articlesAsJson = jsonEncode([
      for (final article in artciles) article.toJson(),
    ]);

    await File(savesFIlePath).writeAsString(articlesAsJson);
  }
}
