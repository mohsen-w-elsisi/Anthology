import 'dart:convert';
import 'dart:io';

import 'package:anthology_common/article/data_gaetway.dart';
import 'package:anthology_common/article/entities.dart';
import 'package:anthology_common/errors.dart';

class LocalArticleDataGateway implements ArticleDataGateway {
  final String path;

  LocalArticleDataGateway(this.path);

  @override
  Future<void> delete(String id) async {
    final articles = await _readArticles();
    if (!articles.containsKey(id)) {
      throw ArticleNotFoundError(id);
    }
    articles.remove(id);
    await _writeArticles(articles);
  }

  @override
  Future<void> deleteAll() async {
    await _writeArticles({});
  }

  @override
  Future<Article> get(String id) async {
    final articles = await _readArticles();
    if (!articles.containsKey(id)) {
      throw ArticleNotFoundError(id);
    }
    return Article.fromJson(articles[id]!);
  }

  @override
  Future<List<Article>> getAll() async {
    final articles = await _readArticles();
    return articles.values.map((json) => Article.fromJson(json)).toList();
  }

  @override
  Future<void> markRead(String id) async {
    final articles = await _readArticles();
    if (!articles.containsKey(id)) {
      throw ArticleNotFoundError(id);
    }
    final article = Article.fromJson(articles[id]!);
    final updatedArticle = article.copyWith(read: true);
    articles[id] = updatedArticle.toJson();
    await _writeArticles(articles);
  }

  @override
  Future<void> markUnread(String id) async {
    final articles = await _readArticles();
    if (!articles.containsKey(id)) {
      throw ArticleNotFoundError(id);
    }
    final article = Article.fromJson(articles[id]!);
    final updatedArticle = article.copyWith(read: false);
    articles[id] = updatedArticle.toJson();
    await _writeArticles(articles);
  }

  @override
  Future<void> save(Article article) async {
    final articles = await _readArticles();
    articles[article.id] = article.toJson();
    await _writeArticles(articles);
  }

  Future<Map<String, dynamic>> _readArticles() async {
    final file = File(path);
    if (!await file.exists() || (await file.readAsString()).isEmpty) {
      return {};
    }
    final content = await file.readAsString();
    return jsonDecode(content) as Map<String, dynamic>;
  }

  Future<void> _writeArticles(Map<String, dynamic> articles) async {
    final file = File(path);
    await file.writeAsString(jsonEncode(articles));
  }
}
