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
  Future<CrudeArticleBrief> generate() async {
    final res = await http.get(_briefingServerUri);
    final json = jsonDecode(res.body) as Map<String, dynamic>;
    return CrudeArticleBrief(
      title: json["title"] as String,
      htmlContent: jsonDecode(res.body)["bodyHtml"] as String,
      byline: json["byline"] as String,
    );
  }

  Uri get _briefingServerUri => Uri(
    scheme: "http",
    host: "localhost",
    port: 8080,
    queryParameters: {"url": article.uri.toString()},
  );
}
