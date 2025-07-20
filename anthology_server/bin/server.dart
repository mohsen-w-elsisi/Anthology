import 'dart:io';

import 'package:alfred/alfred.dart';
import 'package:anthology_common/config/api_uris.dart';
import 'package:anthology_common/entities/article.dart';

import 'package:anthology_server/article_data_gateway.dart';

void main(List<String> arguments) {
  final alfred = Alfred();

  alfred.get(ApiUris.webApp, (req, res) => File("./public/index.html"));

  alfred.get(ApiUris.apiBase, (req, res) => "hello world");

  alfred.get(
    ApiUris.allArticles,
    (req, res) => LocalJsonArticleDataGateway().getAll(),
  );

  alfred.post(ApiUris.article, (req, res) async {
    final json = await req.bodyAsJsonMap;
    final article = Article.fromJson(json);
    await LocalJsonArticleDataGateway().save(article);
    res.statusCode = 200;
  });

  alfred.listen();
}
