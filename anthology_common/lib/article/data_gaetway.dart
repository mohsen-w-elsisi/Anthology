import 'entities.dart';

abstract class ArticleDataGateway {
  Future<Article> get(String id);
  Future<List<Article>> getAll();
  Future<void> save(Article article);
  Future<void> delete(String id);
  Future<void> deleteAll();
  Future<void> markRead(String id);
  Future<void> markUnread(String id);
}
