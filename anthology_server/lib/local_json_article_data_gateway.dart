import 'dart:convert';
import 'dart:io';

import 'package:anthology_common/entities/article.dart';
import 'package:anthology_common/article_data_gaetway.dart';

class LocalJsonArticleDataGateway extends ArticleDataGaetway {
  static const savesFIlePath = "./db/saves.json";

  @override
  Future<void> save(Article article) async {
    final savedArticles = await _readJsonFile();
    final newArticles = <Article>[...savedArticles, article];
    _writeToJsonFile(newArticles);
  }

  @override
  Future<List<Article>> getAll() {
    return _readJsonFile();
  }

  @override
  Future<Article> get(String id) {
    throw UnimplementedError();
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
