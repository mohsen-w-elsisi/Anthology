import 'dart:convert';

import 'package:anthology_common/errors.dart';
import 'package:anthology_common/highlight/data_gateway.dart';
import 'package:anthology_common/highlight/entities.dart';
import 'package:anthology_common/server_request_interface.dart';
import 'package:http/http.dart';

import 'server_response_exception.dart';

class HttpHighlightDataGateway implements HighlightDataGateway {
  final ServerRequestInterface _server;

  HttpHighlightDataGateway(this._server);

  @override
  Future<void> delete(String id) async {
    final res = await _server.deleteHighlight(id);
    _checkForError(res, "delete", id);
  }

  @override
  Future<void> deleteForArticle(String articleId) {
    // TODO: Implement deleteForArticle. This requires a new method on ServerRequestInterface to call the DELETE /api/highlights/article/:id endpoint.
    throw UnimplementedError();
  }

  @override
  Future<void> deleteAll() {
    // TODO: implement deleteAll
    throw UnimplementedError();
  }

  @override
  Future<Highlight> get(String id) async {
    final res = await _server.getHighlight(id);
    _checkForError(res, "get", id);
    return Highlight.fromJson(jsonDecode(res.body));
  }

  @override
  Future<Map<String, List<Highlight>>> getAll() async {
    final res = await _server.getAllHighlights();
    _checkForError(res, "get");
    final json = jsonDecode(res.body) as Map<String, dynamic>;
    final highlights = <String, List<Highlight>>{
      for (final entry in json.entries)
        entry.key: [for (final json in entry.value) Highlight.fromJson(json)],
    };
    return highlights;
  }

  @override
  Future<List<Highlight>> getArticleHighlights(String articleId) async {
    final res = await _server.getArticleHighlights(articleId);
    _checkForError(res, "get", articleId);
    return [for (final json in jsonDecode(res.body)) Highlight.fromJson(json)];
  }

  @override
  Future<void> save(Highlight highlight) async {
    final res = await _server.saveHighlight(highlight);
    _checkForError(res, "save", highlight.id);
  }

  void _checkForError(Response response, String action, [String? id]) {
    if (response.statusCode == 404 && id != null) {
      throw HighlightNotFoundError(id);
    } else if (response.statusCode != 200) {
      throw ServerHighlightResponseException(response, action, id);
    }
  }
}

class ServerHighlightResponseException extends ServerResponseException {
  ServerHighlightResponseException(super.response, super.action, [super.id]);

  @override
  String get entityName => "highlight";
}
