import 'dart:convert';

import 'package:anthology_common/article/data_gaetway.dart';
import 'package:anthology_common/article/entities.dart';
import 'package:anthology_common/errors.dart';
import 'package:anthology_common/server_request_interface.dart';
import 'package:http/http.dart';

class HttpArticleDataGateway implements ArticleDataGaetway {
  final ServerRequestInterface _server;

  HttpArticleDataGateway(this._server);

  @override
  Future<void> delete(String id) async {
    final response = await _server.deleteArticle(id);
    _checkForError(response, "delete", id);
  }

  @override
  Future<void> deleteAll() async {
    final response = await _server.deleteAllArticles();
    _checkForError(response, 'delete');
  }

  @override
  Future<Article> get(String id) async {
    final response = await _server.getArticle(id);
    _checkForError(response, 'get', id);
    return Article.fromJson(jsonDecode(response.body));
  }

  @override
  Future<List<Article>> getAll() async {
    final response = await _server.getAllArticles();
    _checkForError(response, 'get');
    final jsonList = jsonDecode(response.body) as List<dynamic>;
    return [for (final json in jsonList) Article.fromJson(json)];
  }

  @override
  Future<void> markRead(String id) async {
    final response = await _server.markRead(id);
    _checkForError(response, 'mark read', id);
  }

  @override
  Future<void> markUnread(String id) async {
    final response = await _server.markUnread(id);
    _checkForError(response, 'mark unread', id);
  }

  @override
  Future<void> save(Article article) async {
    final response = await _server.postArticle(article);
    _checkForError(response, 'save', article.id);
  }

  void _checkForError(Response response, String action, [String? id]) {
    if (response.statusCode == 404 && id != null) {
      throw ArticleNotFoundError(id);
    } else if (response.statusCode != 200) {
      throw ServerArticleResponseError(response, action, id);
    }
  }
}

class ServerArticleResponseError extends Error {
  final Response response;
  final String action;
  final String? id;

  ServerArticleResponseError(this.response, this.action, [this.id]);

  @override
  String toString() {
    if (id == null) {
      return 'failed to $action all articles. $_serverResponseMessage';
    } else {
      return 'Failed to $action article with id $id. $_serverResponseMessage';
    }
  }

  String get _serverResponseMessage =>
      "Server returned ${response.statusCode}:\n${response.body}";
}
