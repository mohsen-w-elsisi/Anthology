import 'entities.dart';

abstract class HighlightDataGateway {
  Future<Map<String, List<Highlight>>> getAll();
  Future<List<Highlight>> getArticleHighlights(String articleId);
  Future<Highlight> get(String id);
  Future<void> save(Highlight highlight);
  Future<void> delete(String id);
  Future<void> deleteForArticle(String articleId);
  Future<void> deleteAll();
}
