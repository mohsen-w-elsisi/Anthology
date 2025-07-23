import 'dart:async';
import 'dart:io';

import 'package:alfred/alfred.dart';
import 'package:anthology_common/config/api_uris.dart';
import 'package:anthology_common/entities/article.dart';
import 'package:anthology_common/errors.dart';

import 'local_json_article_data_gateway.dart';

class ServerIniter {
  final Alfred _alfred;
  late final HttpServer server;

  ServerIniter() : _alfred = Alfred() {
    _initRoutes();
  }

  void _initRoutes() {
    _alfred.get(ApiUris.webApp, (req, res) => File("./public/index.html"));

    _alfred.get(ApiUris.apiBase, (req, res) => "hello world");

    _alfred.get(
      ApiUris.allArticles,
      (req, res) => LocalJsonArticleDataGateway().getAll(),
    );

    _alfred.get("${ApiUris.article}/:id", (req, res) async {
      final id = req.params["id"];
      return await _reportIfArticleNotFound(res, () async {
        return await LocalJsonArticleDataGateway().get(id);
      });
    });

    _alfred.post(ApiUris.article, (req, res) async {
      final json = await req.bodyAsJsonMap;
      final article = Article.fromJson(json);
      await LocalJsonArticleDataGateway().save(article);
      res.statusCode = 200;
    });

    _alfred.delete(ApiUris.allArticles, (req, res) async {
      await LocalJsonArticleDataGateway().deleteAll();
    });

    _alfred.delete("${ApiUris.article}/:id", (req, res) async {
      final id = req.params["id"];
      await _reportIfArticleNotFound(res, () async {
        await LocalJsonArticleDataGateway().delete(id);
      });
    });

    _alfred.put("${ApiUris.markAsRead}/:id", (req, res) async {
      final id = req.params["id"];
      await _reportIfArticleNotFound(res, () async {
        await LocalJsonArticleDataGateway().markRead(id);
      });
    });

    _alfred.put("${ApiUris.markAsUnRead}/:id", (req, res) async {
      final id = req.params["id"];
      await _reportIfArticleNotFound(res, () async {
        await LocalJsonArticleDataGateway().markUnread(id);
      });
    });
  }

  Future<void> startServer() async {
    server = await _alfred.listen();
  }
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
