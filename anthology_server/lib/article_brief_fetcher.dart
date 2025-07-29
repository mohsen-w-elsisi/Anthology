import 'dart:async';
import 'dart:convert';
import 'package:anthology_server/local_json_article_data_gateway.dart';
import 'package:http/http.dart' as http;

class ArticleBriefFetcher {
  final String id;
  late final Uri _uri;
  late final String _brief;

  ArticleBriefFetcher(this.id);

  Future<String> fetchBrief() async {
    await _getArticleUri();
    await _requestBriefHtml();
    _parseBriefHtml();
    return _brief;
  }

  Future<void> _getArticleUri() async {
    final article = await LocalJsonArticleDataGateway().get(id);
    _uri = article.uri;
  }

  // TODO: method of reuesting brief should be injectable
  Future<void> _requestBriefHtml() async {
    final requestUri = Uri(
      scheme: "http",
      host: "localhost",
      port: 8080,
      queryParameters: {"url": _uri.toString()},
    );
    final res = await http.get(requestUri);
    _brief = jsonDecode(res.body)["bodyHtml"];
  }

  void _parseBriefHtml() {} // useful in future
}
