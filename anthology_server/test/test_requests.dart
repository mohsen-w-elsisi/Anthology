import 'dart:convert';
import 'dart:typed_data';

import 'package:anthology_common/article/entities.dart';
import 'package:anthology_common/feed/entities.dart';
import 'package:anthology_common/highlight/entities.dart';
import 'package:anthology_common/server_request_interface.dart';
import 'package:http/http.dart';

class TestRequests {
  final ServerRequestInterface serverRequestInterface;

  TestRequests(this.serverRequestInterface);

  Future<Response> getArticle1() {
    return serverRequestInterface.getArticle(ExampleData.article1.id);
  }

  Future<Article> getArticle1AsArticle() async {
    final res = await getArticle1();
    return Article.fromJson(jsonDecode(res.body));
  }

  Future<Response> saveArticle1() {
    return serverRequestInterface.postArticle(ExampleData.article1);
  }

  Future<Response> saveArticle2() {
    return serverRequestInterface.postArticle(ExampleData.article2);
  }

  Future<Response> deleteArticle1() {
    return serverRequestInterface.deleteArticle(ExampleData.article1.id);
  }

  Future<Response> markArticle1Read() {
    return serverRequestInterface.markRead(ExampleData.article1.id);
  }

  Future<Response> markArticle1Unread() {
    return serverRequestInterface.markUnread(ExampleData.article1.id);
  }

  Future<Response> saveHighlight1() {
    return serverRequestInterface.saveHighlight(ExampleData.highlight1);
  }

  Future<Response> getHighlight1() {
    return serverRequestInterface.getHighlight(ExampleData.highlight1.id);
  }

  Future<Response> deleteHighlight1() {
    return serverRequestInterface.deleteHighlight(ExampleData.highlight1.id);
  }

  Future<Response> saveHighlight2() {
    return serverRequestInterface.saveHighlight(ExampleData.highlight2);
  }

  Future<Response> getHighlight2() {
    return serverRequestInterface.getHighlight(ExampleData.highlight2.id);
  }

  Future<Response> deleteHighlight2() {
    return serverRequestInterface.deleteHighlight(ExampleData.highlight2.id);
  }

  Future<Response> saveHighlight3() {
    return serverRequestInterface.saveHighlight(ExampleData.highlight3);
  }

  Future<Response> getHighlightsForArticle1() {
    return serverRequestInterface.getArticleHighlights(ExampleData.article1.id);
  }

  // Feed related requests
  Future<Response> saveFeed1() {
    return serverRequestInterface.createFeed(ExampleData.feed1);
  }

  Future<Response> saveFeed2() {
    return serverRequestInterface.createFeed(ExampleData.feed2);
  }

  Future<Response> getFeed1() {
    return serverRequestInterface.getFeedItems(ExampleData.feed1.id);
  }

  Future<Response> getFeed2() {
    return serverRequestInterface.getFeedItems(ExampleData.feed2.id);
  }

  Future<Response> deleteFeed1() {
    return serverRequestInterface.deleteFeed(ExampleData.feed1.id);
  }

  Future<Response> deleteAllFeeds() {
    return serverRequestInterface.deleteAllFeeds();
  }
}

class ExampleData {
  static final article1 = Article(
    uri: Uri.http("example.com"),
    id: "example-1",
    tags: {},
    dateSaved: DateTime.now(),
    read: false,
    progress: 0,
  );

  static final article2 = Article(
    uri: Uri.http("example.com"),
    id: "example-2",
    tags: {},
    dateSaved: DateTime.now(),
    read: false,
    progress: 0,
  );

  static final highlight1 = Highlight(
    id: 'example-1.1',
    articleId: 'example-1',
    text: 'T',
    startIndex: 0,
    endIndex: 0,
  );

  static final highlight2 = Highlight(
    id: 'example-1.2',
    articleId: 'example-1',
    text: 'domain is for use',
    startIndex: 5,
    endIndex: 21,
  );

  static final highlight3 = Highlight(
    id: 'example-2.1',
    articleId: 'example-2',
    text: 'hi',
    startIndex: 1,
    endIndex: 2,
  );

  static final feed1 = Feed(
    id: 'feed-1',
    name: 'Feed 1',
    type: FeedType.rss,
    data: Uint8List(0),
  );

  static final feed2 = Feed(
    id: 'feed-2',
    name: 'Feed 2',
    type: FeedType.rss,
    data: Uint8List(0),
  );
}
