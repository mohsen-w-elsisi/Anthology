import 'dart:convert';
import 'dart:io';

import 'package:anthology_common/config/api_uris.dart';
import 'package:anthology_common/entities/article.dart';
import 'package:anthology_server/local_json_article_data_gateway.dart';
import 'package:anthology_server/server_initer.dart';
import 'package:test/test.dart';
import 'package:http/http.dart' as http;

void main() {
  late HttpServer server;

  setUp(() async {
    await LocalJsonArticleDataGateway().deleteAll();
    final serverIniter = ServerIniter();
    await serverIniter.startServer();
    server = serverIniter.server;
  });

  tearDown(() async {
    await LocalJsonArticleDataGateway().deleteAll();
    server.close();
  });

  Uri apiUri(String path) =>
      Uri(scheme: "http", host: "localhost", port: server.port, path: path);

  test("hello world", () async {
    final res = await http.get(apiUri(ApiUris.apiBase));
    expect(res.body, "hello world");
  });

  final exampleArticle = Article(
    uri: Uri.http("example.com"),
    id: "example-1",
    tags: {},
    dateSaved: DateTime.now(),
    read: false,
  );

  final example2Article = Article(
    uri: Uri.http("example.com"),
    id: "example-2",
    tags: {},
    dateSaved: DateTime.now(),
    read: false,
  );

  Future<http.Response> requestSaveExampleArticle() async {
    return await http.post(
      apiUri(ApiUris.article),
      body: jsonEncode(exampleArticle.toJson()),
      headers: {"content-type": "application/json"},
    );
  }

  Future<http.Response> requestSaveExample2Article() async {
    return await http.post(
      apiUri(ApiUris.article),
      body: jsonEncode(example2Article.toJson()),
      headers: {"content-type": "application/json"},
    );
  }

  Future<http.Response> requestGetExampleArticle() async {
    return await http.get(apiUri("${ApiUris.article}/example-1"));
  }

  Future<Article> getExampleArticleFromServer() async {
    final res = await requestGetExampleArticle();
    return Article.fromJson(jsonDecode(res.body));
  }

  Future<http.Response> requestGetAllArticles() async {
    return await http.get(apiUri(ApiUris.allArticles));
  }

  group("checks that saving an article and getting it works", () {
    test('saving an article', () async {
      final res = await requestSaveExampleArticle();
      expect(res.statusCode, 200);
    });

    test("getting an article by its id", () async {
      await requestSaveExampleArticle();
      final res = await requestGetExampleArticle();
      expect(res.statusCode, 200);
      expect(res.body, jsonEncode(exampleArticle.toJson()));
    });
  });

  group("articles are marked as read and unread", () {
    Future<http.Response> markExampleAsRead() async {
      return http.put(apiUri("${ApiUris.markAsRead}/example-1"));
    }

    Future<http.Response> markExampleAsUnread() async {
      return http.put(apiUri("${ApiUris.markAsUnRead}/example-1"));
    }

    test("article is marked as read", () async {
      await requestSaveExampleArticle();
      final markResponse = await markExampleAsRead();
      expect(markResponse.statusCode, 200);
      final article = await getExampleArticleFromServer();
      expect(article.read, true);
    });

    test("article is marked as unread", () async {
      await requestSaveExampleArticle();
      await markExampleAsRead();
      final markResponse = await markExampleAsUnread();
      expect(markResponse.statusCode, 200);
      final article = await getExampleArticleFromServer();
      expect(article.read, false);
    });
  });

  group('deletion requests', () {
    Future<http.Response> deleteExampleArticle() async {
      return await http.delete(apiUri("${ApiUris.article}/example-1"));
    }

    test("deleting an article using its id", () async {
      await requestSaveExampleArticle();
      final res = await deleteExampleArticle();
      expect(res.statusCode, 200);
      final getRes = await requestGetExampleArticle();
      expect(getRes.statusCode, 404);
    });

    test('deleteing all articles', () async {
      await requestSaveExampleArticle();
      await requestSaveExample2Article();
      final res = await http.delete(apiUri(ApiUris.allArticles));
      expect(res.statusCode, 200);
      final getRes = await requestGetAllArticles();
      expect(jsonDecode(getRes.body), isEmpty);
    });
  });
}
