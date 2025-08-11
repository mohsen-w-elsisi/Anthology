import 'dart:convert';

import 'package:anthology_common/article/entities.dart';
import 'package:anthology_common/config/api_uris.dart';
import 'package:anthology_common/feed/entities.dart';
import 'package:anthology_common/highlight/entities.dart';
import 'package:http/http.dart';

class ServerRequestInterface extends _ApiUri
    with
        _ArticleRequestInterface,
        _HighlightRequestInterface,
        _FeedRequestInterface {
  ServerRequestInterface(super._baseUri);

  Future<Response> helloWorld() => get(apiUri(ApiUris.apiBase));
}

mixin _ArticleRequestInterface on _ApiUri {
  Future<Response> getAllArticles() => get(apiUri(ApiUris.allArticles));

  Future<Response> deleteAllArticles() => delete(apiUri(ApiUris.allArticles));

  Future<Response> getArticle(String id) =>
      get(apiUri("${ApiUris.article}/$id"));

  Future<Response> postArticle(Article article) => post(
    apiUri(ApiUris.article),
    body: jsonEncode(article.toJson()),
    headers: {"content-type": "application/json"},
  );

  Future<Response> deleteArticle(String id) =>
      delete(apiUri("${ApiUris.article}/$id"));

  Future<Response> markRead(String id) =>
      put(apiUri("${ApiUris.markAsRead}/$id"));

  Future<Response> markUnread(String id) =>
      put(apiUri("${ApiUris.markAsUnRead}/$id"));
}

mixin _HighlightRequestInterface on _ApiUri {
  Future<Response> getAllHighlights() => get(apiUri(ApiUris.allHighlights));

  Future<Response> getArticleHighlights(String id) =>
      get(apiUri("${ApiUris.articleHighlights}/$id"));

  Future<Response> getHighlight(String id) =>
      get(apiUri("${ApiUris.highlight}/$id"));

  Future<Response> saveHighlight(Highlight highlight) => post(
    apiUri(ApiUris.highlight),
    body: jsonEncode(highlight.toJson()),
    headers: {"content-type": "application/json"},
  );

  Future<Response> deleteHighlight(String id) =>
      delete(apiUri("${ApiUris.highlight}/$id"));
}

mixin _FeedRequestInterface on _ApiUri {
  Future<Response> getFeeds() => get(apiUri(ApiUris.feeds));

  Future<Response> getFeedItems(String feedId) =>
      get(apiUri("${ApiUris.feeds}/$feedId"));

  Future<Response> createFeed(Feed feed) => post(
    apiUri(ApiUris.feeds),
    body: jsonEncode(feed.toJson()),
    headers: {"content-type": "application/json"},
  );

  Future<Response> deleteFeed(String feedId) =>
      delete(apiUri("${ApiUris.feeds}/$feedId"));

  Future<Response> deleteAllFeeds() => delete(apiUri(ApiUris.feeds));

  Future<Response> markFeedItemsSeen(String feedId) =>
      put(apiUri("${ApiUris.markFeedSeen}/$feedId"));
}

abstract class _ApiUri {
  final Uri _baseUri;

  _ApiUri(this._baseUri);

  Uri apiUri(String path) => _baseUri.replace(path: path);
}
