import 'dart:convert';

import 'package:anthology_common/feed/data_gateway.dart';
import 'package:anthology_common/feed/entities.dart';
import 'package:anthology_server/data_gateways/local_json_feed_data_gateway.dart';
import 'package:get_it/get_it.dart';
import 'package:test/test.dart';
import 'package:anthology_common/server_request_interface.dart';

import 'server_tests_setup.dart';
import 'test_requests.dart';

void main() {
  final serverTestsSetup = ServerTestsSetup(
    feedDataGateway: LocalJsonFeedDataGateway(),
  );

  setUp(serverTestsSetup.setupServer);
  tearDown(serverTestsSetup.tearDown);

  final testRequests = TestRequests(
    ServerRequestInterface(serverTestsSetup.serverUri),
  );

  group("feed CRUD functionallity", () {
    test("saving a feed", () async {
      final res = await testRequests.saveFeed1();
      expect(res.statusCode, 200);
      expect(GetIt.I<FeedDataGateway>().get(ExampleData.feed1.id), completes);
    });

    test("getting a feed returns OK if found, 404 otherwise", () async {
      final failRes = await testRequests.getFeed1();
      expect(failRes.statusCode, 404);
      await testRequests.saveFeed1();
      final successRes = await testRequests.getFeed1();
      expect(successRes.statusCode, 200);
    });

    test('getting a feed return correct feed', () async {
      await testRequests.saveFeed1();
      await testRequests.saveFeed2();
      final res = await testRequests.getFeed1();
      final fetchedFeed = Feed.fromJson(jsonDecode(res.body));
      expect(fetchedFeed.id, ExampleData.feed1.id);
    });

    test('deleteing a feed delets correct feed', () async {
      await testRequests.saveFeed1();
      await testRequests.saveFeed2();
      await testRequests.deleteFeed1();
      final res1 = await testRequests.getFeed1();
      expect(res1.statusCode, 404);
      final res2 = await testRequests.getFeed2();
      expect(res2.statusCode, 200);
    });

    test("deleting a feed returns OK if found, 404 otherwise", () async {
      final failRes = await testRequests.deleteFeed1();
      expect(failRes.statusCode, 404);
      await testRequests.saveFeed1();
      final successRes = await testRequests.deleteFeed1();
      expect(successRes.statusCode, 200);
    });

    test('deleting all feeds', () async {
      await testRequests.saveFeed1();
      await testRequests.saveFeed2();
      final res = await testRequests.deleteAllFeeds();
      expect(res.statusCode, 200);
      final results = await Future.wait([
        testRequests.getFeed1(),
        testRequests.getFeed2(),
      ]);
      expect(results[0].statusCode, 404);
      expect(results[1].statusCode, 404);
    });
  });
}
