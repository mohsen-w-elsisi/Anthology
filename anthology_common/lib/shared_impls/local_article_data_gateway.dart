import 'dart:convert';
import 'dart:io';

import 'package:anthology_common/article/data_gaetway.dart';
import 'package:anthology_common/article/entities.dart';
import 'package:anthology_common/errors.dart';

import 'io_queue.dart';

class LocalArticleDataGateway with IoQueue implements ArticleDataGateway {
  final String path;

  LocalArticleDataGateway(this.path);

  @override
  Future<void> delete(String id) => queueUp(() async {
    final articles = await _readArticles();
    if (!articles.containsKey(id)) {
      throw ArticleNotFoundError(id);
    }
    articles.remove(id);
    await _writeArticles(articles);
  });

  @override
  Future<void> deleteAll() => queueUp(() async {
    await _writeArticles({});
  });

  @override
  Future<Article> get(String id) => queueUp(() async {
    final articles = await _readArticles();
    if (!articles.containsKey(id)) {
      throw ArticleNotFoundError(id);
    }
    return Article.fromJson(articles[id]!);
  });

  @override
  Future<List<Article>> getAll() => queueUp(() async {
    final articles = await _readArticles();
    return articles.values.map((json) => Article.fromJson(json)).toList();
  });

  @override
  Future<void> markRead(String id) => queueUp(() async {
    final articles = await _readArticles();
    if (!articles.containsKey(id)) {
      throw ArticleNotFoundError(id);
    }
    final article = Article.fromJson(articles[id]!);
    final updatedArticle = article.copyWith(read: true);
    articles[id] = updatedArticle.toJson();
    await _writeArticles(articles);
  });

  @override
  Future<void> markUnread(String id) => queueUp(() async {
    final articles = await _readArticles();
    if (!articles.containsKey(id)) {
      throw ArticleNotFoundError(id);
    }
    final article = Article.fromJson(articles[id]!);
    final updatedArticle = article.copyWith(read: false);
    articles[id] = updatedArticle.toJson();
    await _writeArticles(articles);
  });

  @override
  Future<void> updateProgress(String id, double progress) {
    return queueUp(() async {
      final articles = await _readArticles();
      if (!articles.containsKey(id)) throw ArticleNotFoundError(id);
      final article = Article.fromJson(articles[id]!);
      final updatedArticle = article.copyWith(progress: progress);
      articles[id] = updatedArticle.toJson();
      await _writeArticles(articles);
      print("updated progress to ${updatedArticle.progress}");
    });
  }

  @override
  Future<void> save(Article article) => queueUp(() async {
    final articles = await _readArticles();
    articles[article.id] = article.toJson();
    await _writeArticles(articles);
  });

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
    if (!await file.parent.exists()) {
      await file.parent.create(recursive: true);
    }
    await file.writeAsString(jsonEncode(articles));
  }
}
