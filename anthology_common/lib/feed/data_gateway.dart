import 'entities.dart';

abstract class FeedDataGateway {
  Future<List<Feed>> getAll();
  Future<Feed> get(String id);
  Future<void> save(Feed feed);
  Future<void> delete(String id);
  Future<void> deleteAll();
}
