import 'package:anthology_common/article/data_gaetway.dart';
import 'package:anthology_common/article/entities.dart';
import 'package:anthology_common/article_brief/generator.dart';
import 'package:anthology_common/highlight/data_gateway.dart';
import 'package:anthology_ui/state/reader_view_status_notifier.dart';
import 'package:anthology_ui/state/tag_aggregator.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:anthology_common/shared_impls/local_article_data_gateway.dart';
import 'package:anthology_common/shared_impls/local_highlight_data_gateway.dart';
import 'package:path_provider/path_provider.dart';

import 'data/article_brief_cache.dart';
import 'data/article_presentation_meta_data/cache.dart';
import 'data/readability_article_brief_generator.dart';

class AppDependencyIniter {
  static Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();
    await _initArticleDataGateway();
    await _initHighlightDataGateway();
    await _initTagAggregator();
    await _initArticlePresentationMetaDataCache();
    await _initArticleBriefCache();
    _initArticleBriefGenerator();
    _initReaderViewStatusNotifier();
  }

  static Future<void> _initArticleDataGateway() async {
    GetIt.I.registerSingleton<ArticleDataGateway>(
      LocalArticleDataGateway(
        "${(await getApplicationDocumentsDirectory()).path}/articles.json",
      ),
    );
  }

  static Future<void> _initTagAggregator() async {
    final articleDataGateway = GetIt.I<ArticleDataGateway>();
    final tagAggregator = TagAggregator(articleDataGateway);
    await tagAggregator.init();
    GetIt.I.registerSingleton<TagAggregator>(tagAggregator);
  }

  static Future<void> _initHighlightDataGateway() async {
    GetIt.I.registerSingleton<HighlightDataGateway>(
      LocalHighlightDataGateway(
        "${(await getApplicationDocumentsDirectory()).path}/highlights.json",
      ),
    );
  }

  static Future<void> _initArticlePresentationMetaDataCache() async {
    GetIt.I.registerSingleton(
      ArticlePresentationMetaDataCache(
        "${(await getApplicationCacheDirectory()).path}/metadata.json",
      ),
    );
  }

  static Future<void> _initArticleBriefCache() async {
    GetIt.I.registerSingleton(
      ArticleBriefCache(
        "${(await getApplicationCacheDirectory()).path}/article_brief.json",
      ),
    );
  }

  static void _initArticleBriefGenerator() {
    ReadabilityArticleBriefGenerator.init();
    GetIt.I.registerFactoryParam<ArticleBriefHtmlGenerator, Article, Null>(
      (article, _) => ReadabilityArticleBriefGenerator(article),
    );
  }

  static void _initReaderViewStatusNotifier() {
    GetIt.I.registerSingleton(ReaderViewStatusNotifier());
  }

  static final _serverBaseUri = Uri(
    scheme: 'http',
    host: 'localhost',
    port: 3000,
  );
}
