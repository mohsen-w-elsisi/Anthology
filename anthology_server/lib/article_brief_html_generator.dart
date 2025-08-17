import 'dart:convert';

import 'package:anthology_common/article/entities.dart';
import 'package:http/http.dart' as http;
import 'package:anthology_common/article_brief/generator.dart';

class BriefingServerArticleBriefHtmlGenerator
    implements ArticleBriefHtmlGenerator {
  @override
  final Article article;

  BriefingServerArticleBriefHtmlGenerator(this.article);

  @override
  Future<String> generate() async {
    final res = await http.get(_briefingServerUri);
    return jsonDecode(res.body)["bodyHtml"];
  }

  Uri get _briefingServerUri => Uri(
    scheme: "http",
    host: "localhost",
    port: 8080,
    queryParameters: {"url": article.uri.toString()},
  );
}
