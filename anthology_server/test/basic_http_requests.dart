import 'dart:convert';

import 'package:anthology_common/article/entities.dart';
import 'package:anthology_common/config/api_uris.dart';
import 'package:anthology_common/highlight/entities.dart';
import 'package:http/http.dart';

class BasicHttpRequests {
  final Uri _serverBaseUri;

  BasicHttpRequests(this._serverBaseUri);

  Uri apiUri(String path) => _serverBaseUri.replace(path: path);

  Future<Response> helloWorld() => get(apiUri(ApiUris.apiBase));

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
