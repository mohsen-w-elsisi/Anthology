import 'dart:io';

import 'package:anthology_common/article/data_gaetway.dart';
import 'package:anthology_common/article/entities.dart';
import 'package:anthology_common/article_brief/generator.dart';
import 'package:anthology_common/server_request_interface.dart';
import 'package:anthology_common/shared_impls/article_brief_html_generator.dart';
import 'package:anthology_ui/state/article_ui_notifier.dart';
import 'package:anthology_ui/state/highlight_ui_notifier.dart';
import 'package:anthology_ui/state/reader_view_status_notifier.dart';
import 'package:anthology_ui/state/tag_aggregator.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'config.dart';
import 'package:path_provider/path_provider.dart';

import 'data/data_gateway_manager.dart';

import 'data/article_brief_cache.dart';
import 'data/article_presentation_meta_data/cache.dart';
import 'data/readability_article_brief_generator.dart';

class AppDependencyIniter {
  static Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();
    _initServerRequestInterface();
    DataGatewayIniter(
      useHttp: await _useHttp,
      localDataFolder: await _localDataFolder,
      serverRequestInterface: GetIt.I<ServerRequestInterface>(),
    ).init();
    _initArticleUiNotifier();
    _initHighlightUiNotifier();
    await _initTagAggregator();
    await _initArticlePresentationMetaDataCache();
    await _initArticleBriefCache();
    await _initArticleBriefGenerator();
    _initReaderViewStatusNotifier();
  }

  static Future<bool> get _useHttp async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(SharedPrefsKeys.useHttpGateway) ?? false;
  }

  static Future<String> get _localDataFolder async {
    final prefs = await SharedPreferences.getInstance();
    final storedPath = prefs.getString(SharedPrefsKeys.localDataFolder);
    if (storedPath != null && storedPath.isNotEmpty) {
      return storedPath;
    } else {
      return (await getApplicationDocumentsDirectory()).path;
    }
  }

  static Future<void> _initTagAggregator() async {
    final articleDataGateway = GetIt.I<ArticleDataGateway>();
    final tagAggregator = TagAggregator(articleDataGateway);
    await tagAggregator.init();
    GetIt.I.registerSingleton<TagAggregator>(tagAggregator);
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

  static Future<void> _initArticleBriefGenerator() async {
    if (!Platform.isLinux) await ReadabilityArticleBriefGenerator.init();
    GetIt.I.registerFactoryParam<ArticleBriefHtmlGenerator, Article, Null>(
      (article, _) {
        if (Platform.isLinux) {
          return BriefingServerArticleBriefHtmlGenerator(article);
        } else {
          return ReadabilityArticleBriefGenerator(article);
        }
      },
    );
  }

  static void _initReaderViewStatusNotifier() {
    GetIt.I.registerSingleton(ReaderViewStatusNotifier());
  }

  static void _initArticleUiNotifier() {
    GetIt.I.registerSingleton(ArticleUiNotifier());
  }

  static void _initHighlightUiNotifier() {
    GetIt.I.registerSingleton(HighlightUiNotifier());
  }

  static void _initServerRequestInterface() {
    GetIt.I.registerSingleton(ServerRequestInterface(_serverBaseUri));
  }

  static final _serverBaseUri = Uri(
    scheme: 'http',
    host: 'localhost',
    port: 3000,
  );
}
