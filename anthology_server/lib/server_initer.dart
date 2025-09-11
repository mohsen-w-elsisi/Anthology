import 'dart:async';
import 'dart:io';

import 'package:alfred/alfred.dart';
import 'package:anthology_common/article/data_gaetway.dart';
import 'package:anthology_common/article_brief/article_brief_fetcher.dart';
import 'package:anthology_common/config/api_uris.dart';
import 'package:anthology_common/article/entities.dart';
import 'package:anthology_common/errors.dart';
import 'package:anthology_common/feed/data_gateway.dart';
import 'package:anthology_common/feed/entities.dart';
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
      (req, res) => GetIt.I<ArticleDataGateway>().getAll(),
    );

    _alfred.get("${ApiUris.article}/:id", (req, res) async {
      final id = req.params["id"];
      return await _reportIfArticleNotFound(res, () async {
        return await GetIt.I<ArticleDataGateway>().get(id);
      });
    });

    _alfred.post(ApiUris.article, (req, res) async {
      final json = await req.bodyAsJsonMap;
      final article = Article.fromJson(json);
      await GetIt.I<ArticleDataGateway>().save(article);
      res.statusCode = 200;
    });

    _alfred.delete(ApiUris.allArticles, (req, res) async {
      await GetIt.I<ArticleDataGateway>().deleteAll();
    });

    _alfred.delete("${ApiUris.article}/:id", (req, res) async {
      final id = req.params["id"];
      await _reportIfArticleNotFound(res, () async {
        await GetIt.I<ArticleDataGateway>().delete(id);
      });
    });

    _alfred.put("${ApiUris.markAsRead}/:id", (req, res) async {
      final id = req.params["id"];
      await _reportIfArticleNotFound(res, () async {
        await GetIt.I<ArticleDataGateway>().markRead(id);
      });
    });

    _alfred.put("${ApiUris.markAsUnRead}/:id", (req, res) async {
      final id = req.params["id"];
      await _reportIfArticleNotFound(res, () async {
        await GetIt.I<ArticleDataGateway>().markUnread(id);
      });
    });

    _alfred.get("${ApiUris.highlight}/:id", (req, res) async {
      final id = req.params["id"];
      return await _reportIfHighlightNotFound(res, () async {
        final highlight = await GetIt.I<HighlightDataGateway>().get(id);
        return highlight.toJson();
      });
    });

    _alfred.post(ApiUris.highlight, (req, res) async {
      final json = await req.bodyAsJsonMap;
      final highlight = Highlight.fromJson(json);
      await GetIt.I<HighlightDataGateway>().save(highlight);
    });

    _alfred.delete("${ApiUris.highlight}/:id", (req, res) async {
      final id = req.params["id"];
      await _reportIfHighlightNotFound(res, () async {
        await GetIt.I<HighlightDataGateway>().delete(id);
      });
    });

    _alfred.get("${ApiUris.articleHighlights}/:id", (req, res) async {
      final articleId = req.params["id"];
      return await _reportIfArticleNotFound(res, () async {
        final highlights = await GetIt.I<HighlightDataGateway>()
            .getArticleHighlights(articleId);
        return [for (final highlight in highlights) highlight.toJson()];
      });
    });

    _alfred.delete("${ApiUris.articleHighlights}/:id", (req, res) async {
      final articleId = req.params["id"];
      await _reportIfArticleNotFound(res, () async {
        await GetIt.I<HighlightDataGateway>().deleteForArticle(articleId);
      });
    });

    _alfred.get(ApiUris.allHighlights, (req, res) async {
      final highlights = await GetIt.I<HighlightDataGateway>().getAll();
      final jsonHighlights = {
        for (final highlightEntry in highlights.entries)
          highlightEntry.key: [
            for (final highlight in highlightEntry.value) highlight.toJson(),
          ],
      };
      return jsonHighlights;
    });

    _alfred.get(ApiUris.feed, (req, res) {
      return GetIt.I<FeedDataGateway>().getAll();
    });

    _alfred.get('${ApiUris.feed}/:id', (req, res) {
      final id = req.params['id'] as String;
      return _reportIfFeedNotFound(res, () {
        return GetIt.I<FeedDataGateway>().get(id);
      });
    });

    _alfred.post(ApiUris.feed, (req, res) async {
      final json = await req.bodyAsJsonMap;
      final feed = Feed.fromJson(json);
      await GetIt.I<FeedDataGateway>().save(feed);
    });

    _alfred.delete('${ApiUris.feed}/:id', (req, res) async {
      final id = req.params['id'] as String;
      await _reportIfFeedNotFound(res, () async {
        await GetIt.I<FeedDataGateway>().delete(id);
      });
    });

    _alfred.delete(ApiUris.feed, (req, res) async {
      await GetIt.I<FeedDataGateway>().deleteAll();
    });

    _alfred.put('${ApiUris.feed}/seen/:id', (req, res) async {
      return 500; // TODO: Implement mark feed as seen
    });

    _alfred.get("${ApiUris.articleBrief}/:id", (req, res) async {
      final id = req.params["id"] as String;
      return (await ArticleBriefFetcher(id).fetchBrief()).toJson();
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

Future _reportIfFeedNotFound(
  HttpResponse res,
  FutureOr Function() tryFunc,
) async {
  try {
    return await tryFunc();
  } on FeedNotFoundError catch (error) {
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
