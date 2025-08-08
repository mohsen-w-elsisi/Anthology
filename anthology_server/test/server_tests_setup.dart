import 'dart:io';

import 'package:anthology_common/article/data_gaetway.dart';
import 'package:anthology_common/article_brief/generator.dart';
import 'package:anthology_common/highlight/data_gateway.dart';
import 'package:anthology_server/article_brief_html_generator.dart';
import 'package:anthology_server/server_initer.dart';
import 'package:get_it/get_it.dart';

class ServerTestsSetup {
  late HttpServer _server;
  final ArticleDataGaetway _articleDataGaetway;
  final HightlightDataGateway _highlightDataGaetway;

  ServerTestsSetup({
    required ArticleDataGaetway articleDataGaetway,
    required HightlightDataGateway highlightDataGaetway,
  }) : _highlightDataGaetway = highlightDataGaetway,
       _articleDataGaetway = articleDataGaetway;

  Future<void> setupServer() async {
    await _initServerDependancies();
    await _startServer();
  }

  Future<void> _initServerDependancies() async {
    await _articleDataGaetway.deleteAll();
    GetIt.I.registerSingleton(_articleDataGaetway);
    await _highlightDataGaetway.deleteAll();
    GetIt.I.registerSingleton(_highlightDataGaetway);
    GetIt.I.registerFactoryParam<ArticleBriefHtmlGenerator, Uri, Null>(
      (uri, _) => BriefingServerArticleBriefHtmlGenerator(uri),
    );
  }

  Future<void> _startServer() async {
    final serverIniter = ServerIniter();
    await serverIniter.startServer();
    _server = serverIniter.server;
  }

  Future<void> tearDown() async {
    _articleDataGaetway.deleteAll();
    _highlightDataGaetway.deleteAll();
    _server.close();
    await GetIt.I.reset();
  }

  Uri get serverUri => Uri(scheme: "http", host: "localhost", port: 3000);
}
