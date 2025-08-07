import 'dart:convert';

import 'package:anthology_common/article/entities.dart';
import 'package:anthology_common/config/api_uris.dart';
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
}
