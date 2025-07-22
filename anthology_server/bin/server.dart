import 'dart:async';
import 'dart:io';

import 'package:alfred/alfred.dart';
import 'package:anthology_common/config/api_uris.dart';
import 'package:anthology_common/entities/article.dart';
import 'package:anthology_common/errors.dart';
import 'package:anthology_server/local_json_article_data_gateway.dart';

void main(List<String> arguments) {
  final alfred = Alfred();

  alfred.get(ApiUris.webApp, (req, res) => File("./public/index.html"));

  alfred.get(ApiUris.apiBase, (req, res) => "hello world");

  alfred.get(
    ApiUris.allArticles,
    (req, res) => LocalJsonArticleDataGateway().getAll(),
  );

  alfred.get("${ApiUris.article}/:id", (req, res) async {
    final id = req.params["id"];
    return await _reportIfArticleNotFound(res, () async {
      return await LocalJsonArticleDataGateway().get(id);
    });
  });

  alfred.post(ApiUris.article, (req, res) async {
    final json = await req.bodyAsJsonMap;
    final article = Article.fromJson(json);
    await LocalJsonArticleDataGateway().save(article);
    res.statusCode = 200;
  });

  alfred.delete(ApiUris.allArticles, (req, res) async {
    await LocalJsonArticleDataGateway().deleteAll();
  });

  alfred.delete("${ApiUris.article}/:id", (req, res) async {
    final id = req.params["id"];
    await _reportIfArticleNotFound(res, () async {
      await LocalJsonArticleDataGateway().delete(id);
    });
  });

  alfred.put("${ApiUris.markAsRead}/:id", (req, res) async {
    final id = req.params["id"];
    await _reportIfArticleNotFound(res, () async {
      await LocalJsonArticleDataGateway().markRead(id);
    });
  });

  alfred.put("${ApiUris.markAsUnRead}/:id", (req, res) async {
    final id = req.params["id"];
    await _reportIfArticleNotFound(res, () async {
      await LocalJsonArticleDataGateway().markUnread(id);
    });
  });

  alfred.listen();
}

Future _reportIfArticleNotFound(
  HttpResponse res,
  FutureOr Function() tryFunc,
) async {
  try {
    return await tryFunc();
  } on ArticleNotFoundError catch (error) {
    res
      ..statusCode = 404
      ..write(error.message);
  }
}
