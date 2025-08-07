import 'dart:async';
import 'dart:io';

import 'package:alfred/alfred.dart';
import 'package:anthology_common/article/data_gaetway.dart';
import 'package:anthology_common/article_brief/article_brief_fetcher.dart';
import 'package:anthology_common/config/api_uris.dart';
import 'package:anthology_common/article/entities.dart';
import 'package:anthology_common/errors.dart';
import 'package:anthology_common/highlight/data_gateway.dart';
import 'package:anthology_common/highlight/entities.dart';
import 'package:get_it/get_it.dart';

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
      (req, res) => GetIt.I<ArticleDataGaetway>().getAll(),
    );

    _alfred.get("${ApiUris.article}/:id", (req, res) async {
      final id = req.params["id"];
      return await _reportIfArticleNotFound(res, () async {
        return await GetIt.I<ArticleDataGaetway>().get(id);
      });
    });

    _alfred.post(ApiUris.article, (req, res) async {
      final json = await req.bodyAsJsonMap;
      final article = Article.fromJson(json);
      await GetIt.I<ArticleDataGaetway>().save(article);
      res.statusCode = 200;
    });

    _alfred.delete(ApiUris.allArticles, (req, res) async {
      await GetIt.I<ArticleDataGaetway>().deleteAll();
    });

    _alfred.delete("${ApiUris.article}/:id", (req, res) async {
      final id = req.params["id"];
      await _reportIfArticleNotFound(res, () async {
        await GetIt.I<ArticleDataGaetway>().delete(id);
      });
    });

    _alfred.put("${ApiUris.markAsRead}/:id", (req, res) async {
      final id = req.params["id"];
      await _reportIfArticleNotFound(res, () async {
        await GetIt.I<ArticleDataGaetway>().markRead(id);
      });
    });

    _alfred.put("${ApiUris.markAsUnRead}/:id", (req, res) async {
      final id = req.params["id"];
      await _reportIfArticleNotFound(res, () async {
        await GetIt.I<ArticleDataGaetway>().markUnread(id);
      });
    });

    _alfred.get("${ApiUris.articleBrief}/:id", (req, res) async {
      final id = req.params["id"] as String;
      return await _reportIfArticleNotFound(res, () async {
        final brief = await ArticleBriefFetcher(id).fetchBrief();
        return [for (final node in brief) node.text];
      });
    });

    _alfred.get("${ApiUris.highlight}/:id", (req, res) async {
      final id = req.params["id"];
      return await _reportIfHighlightNotFound(res, () async {
        final highlight = await GetIt.I<HightlightDataGateway>().get(id);
        return highlight.toJson();
      });
    });

    _alfred.post(ApiUris.highlight, (req, res) async {
      final json = await req.bodyAsJsonMap;
      final highlight = Highlight.fromJson(json);
      await GetIt.I<HightlightDataGateway>().save(highlight);
    });

    _alfred.delete("${ApiUris.highlight}/:id", (req, res) async {
      final id = req.params["id"];
      await _reportIfHighlightNotFound(res, () async {
        await GetIt.I<HightlightDataGateway>().delete(id);
      });
    });

    _alfred.get("${ApiUris.articleHighlights}/:id", (req, res) async {
      final articleId = req.params["id"];
      return await _reportIfArticleNotFound(res, () async {
        final highlights = await GetIt.I<HightlightDataGateway>()
            .getArticleHighlights(articleId);
        return [for (final highlight in highlights) highlight.toJson()];
      });
    });

    _alfred.get(ApiUris.allHighlights, (req, res) async {
      final highlights = await GetIt.I<HightlightDataGateway>().getAll();
      final jsonHighlights = {
        for (final highlight in highlights.entries)
          highlight.key: highlight.value.toJson(),
      };
      return jsonHighlights;
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

Future _reportIfHighlightNotFound(
  HttpResponse res,
  FutureOr Function() tryFunc,
) async {
  try {
    return await tryFunc();
  } on HighlightNotFoundError catch (error) {
    res
      ..statusCode = 404
      ..write(error.message);
  }
}
