import 'package:anthology_common/article/data_gaetway.dart';
import 'package:anthology_common/highlight/data_gateway.dart';
import 'package:anthology_common/server_request_interface.dart';
import 'package:anthology_ui/data/http_article_data_gateway.dart';
import 'package:anthology_ui/state/tag_aggregator.dart';
import 'package:get_it/get_it.dart';
import 'package:path_provider/path_provider.dart';

import 'data/article_brief_cache.dart';
import 'data/article_presentation_meta_data/cache.dart';
import 'data/http_highlight_data_gateway.dart';

class AppDependencyIniter {
  static Future<void> init() async {
    _initArticleDataGateway();
    _initHighlightDataGateway();
    await _initTagAggregator();
    await _initArticlePresentationMetaDataCache();
    await _initArticleBriefCache();
  }

  static void _initArticleDataGateway() {
    GetIt.I.registerSingleton<ArticleDataGateway>(
      HttpArticleDataGateway(
        ServerRequestInterface(
          _serverBaseUri,
        ),
      ),
    );
  }

  static Future<void> _initTagAggregator() async {
    final articleDataGateway = GetIt.I<ArticleDataGateway>();
    final tagAggregator = TagAggregator(articleDataGateway);
    await tagAggregator.init();
    GetIt.I.registerSingleton<TagAggregator>(tagAggregator);
  }

  static void _initHighlightDataGateway() {
    GetIt.I.registerSingleton<HighlightDataGateway>(
      HttpHighlightDataGateway(
        ServerRequestInterface(
          _serverBaseUri,
        ),
      ),
    );
  }

  static Future<void> _initArticlePresentationMetaDataCache() async {
    GetIt.I.registerSingleton(
      ArticlePresentationMetaDataCache(
        (await getApplicationCacheDirectory()).path + "/metadata.json",
      ),
    );
  }

  static Future<void> _initArticleBriefCache() async {
    GetIt.I.registerSingleton(
      ArticleBriefCache(
        (await getApplicationCacheDirectory()).path + "/article_brief.json",
      ),
    );
  }

  static final _serverBaseUri = Uri(
    scheme: 'http',
    host: 'localhost',
    port: 3000,
  );
}
