import 'entities.dart';

abstract class HightlightDataGateway {
  Future<Map<String, List<Highlight>>> getAll();
  Future<List<Highlight>> getArticleHighlights(String articleId);
  Future<Highlight> get(String id);
  Future<void> save(Highlight highlight);
  Future<void> delete(String id);
  Future<void> deleteAll();
}
