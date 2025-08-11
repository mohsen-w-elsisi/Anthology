import 'entities.dart';

abstract class FeedDataGateway {
  Future<List<Feed>> getAll();
  Future<void> save(Feed feed);
  Future<void> delete(String feedId);
}
