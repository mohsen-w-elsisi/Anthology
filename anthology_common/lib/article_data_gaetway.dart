import 'entities/article.dart';

abstract class ArticleDataGaetway {
  Future<void> save(Article article);
  Future<Article> get(String id);
  Future<List<Article>> getAll();
}
