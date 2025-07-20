import 'dart:io';

import 'package:alfred/alfred.dart';
import 'package:anthology_server/article.dart';
import 'package:anthology_server/article_data_gateway.dart';

void main(List<String> arguments) {
  final alfred = Alfred();

  alfred.get("/app", (req, res) => File("./public/index.html"));

  alfred.get("/api", (req, res) => "hello world");

  alfred.get("/api/all-articles", (req, res) => ArticleDataGateway().getAll());

  alfred.post("/api/article", (req, res) async {
    final json = await req.bodyAsJsonMap;
    final article = Article.fromJson(json);
    await ArticleDataGateway().save(article);
    res.statusCode = 200;
  });

  alfred.listen();
}
