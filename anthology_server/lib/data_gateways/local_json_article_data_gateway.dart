import 'dart:convert';
import 'dart:io';

import 'package:anthology_common/article/entities.dart';
import 'package:anthology_common/article/data_gaetway.dart';
import 'package:anthology_common/errors.dart';

class LocalJsonArticleDataGateway extends ArticleDataGateway {
  static const savesFIlePath = "./db/saves.json";

  @override
  Future<void> save(Article article) async {
    assert(!(await _articleIsSaved(article.id)));
    final articles = await _readJsonFile();
    articles.add(article);
    await _writeToJsonFile(articles);
  }

  @override
  Future<List<Article>> getAll() {
    return _readJsonFile();
  }

  @override
  Future<Article> get(String id) async {
    var articles = await _readJsonFile();
    try {
      return articles.singleWhere((art) => art.id == id);
    } on StateError {
      throw ArticleNotFoundError(id);
    }
  }

  @override
  Future<void> delete(String id) async {
    final articles = await _readJsonFile();
    final index = await _findArticleIndex(id);
    articles.removeAt(index);
    _writeToJsonFile(articles);
  }

  @override
  Future<void> deleteAll() async {
    await _writeToJsonFile(<Article>[]);
  }

  @override
  Future<void> markRead(String id) async {
    final article = await get(id);
    final readArticle = article.copyWith.read(true);
    await _updateArticle(readArticle);
  }

  @override
  Future<void> markUnread(String id) async {
    final article = await get(id);
    final readArticle = article.copyWith.read(false);
    await _updateArticle(readArticle);
  }

  Future<void> _updateArticle(Article article) async {
    final index = await _findArticleIndex(article.id);
    final articles = await _readJsonFile();
    articles[index] = article;
    _writeToJsonFile(articles);
  }

  Future<List<Article>> _readJsonFile() async {
    final jsonString = await File(savesFIlePath).readAsString();
    final json = (jsonDecode(jsonString) as List).cast<Json>();
    final savedArticles = [
      for (final articleJson in json) Article.fromJson(articleJson),
    ];
    return savedArticles;
  }

  Future<void> _writeToJsonFile(List<Article> articles) async {
    final articlesAsJson = jsonEncode([
      for (final article in articles) article.toJson(),
    ]);
    await File(savesFIlePath).writeAsString(articlesAsJson);
  }

  Future<bool> _articleIsSaved(String id) async {
    try {
      await get(id);
      return true;
    } on ArticleNotFoundError {
      return false;
    }
  }

  Future<int> _findArticleIndex(String id) async {
    final articles = await _readJsonFile();
    final index = articles.indexWhere((article) => article.id == id);
    if (index.isNegative) throw ArticleNotFoundError(id);
    return index;
  }
}
