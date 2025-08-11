import 'dart:convert';

import 'package:anthology_common/server_request_interface.dart';
import 'package:anthology_server/local_json_article_data_gateway.dart';
import 'package:test/test.dart';

import 'server_tests_setup.dart';
import 'test_requests.dart';

void main() {
  final serverTestsSetup = ServerTestsSetup(
    articleDataGaetway: LocalJsonArticleDataGateway(),
  );

  setUp(serverTestsSetup.setupServer);
  tearDown(serverTestsSetup.tearDown);

  final baseRequests = ServerRequestInterface(serverTestsSetup.serverUri);
  final testRequests = TestRequests(baseRequests);

  test("hello world", () async {
    final res = await baseRequests.helloWorld();
    expect(res.body, "hello world");
  });

  group("checks that saving an article and getting it works", () {
    test('saving an article', () async {
      final res = await testRequests.saveArticle1();
      expect(res.statusCode, 200);
    });

    test("getting an article by its id", () async {
      await testRequests.saveArticle1();
      final res = await testRequests.getArticle1();
      expect(res.statusCode, 200);
      expect(res.body, jsonEncode(ExampleData.article1.toJson()));
    });
  });

  group("articles are marked as read and unread", () {
    test("article is marked as read", () async {
      await testRequests.saveArticle1();
      final markResponse = await testRequests.markArticle1Read();
      expect(markResponse.statusCode, 200);
      final article = await testRequests.getArticle1AsArticle();
      expect(article.read, true);
    });

    test("article is marked as unread", () async {
      await testRequests.saveArticle1();
      await testRequests.markArticle1Read();
      final markResponse = await testRequests.markArticle1Unread();
      expect(markResponse.statusCode, 200);
      final article = await testRequests.getArticle1AsArticle();
      expect(article.read, false);
    });
  });

  group('deletion requests', () {
    test("deleting an article using its id", () async {
      await testRequests.saveArticle1();
      final res = await testRequests.deleteArticle1();
      expect(res.statusCode, 200);
      final getRes = await testRequests.getArticle1();
      expect(getRes.statusCode, 404);
    });

    test('deleteing all articles', () async {
      await testRequests.saveArticle1();
      await testRequests.saveArticle2();
      final res = await baseRequests.deleteAllArticles();
      expect(res.statusCode, 200);
      final getRes = await baseRequests.getAllArticles();
      expect(jsonDecode(getRes.body), isEmpty);
    });
  });
}
