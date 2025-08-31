import 'dart:io';

import 'package:anthology_common/article/data_gaetway.dart';
import 'package:anthology_common/highlight/data_gateway.dart';
import 'package:anthology_common/feed/data_gateway.dart';
import 'package:anthology_server/server_initer.dart';
import 'package:get_it/get_it.dart';

class ServerTestsSetup {
  late HttpServer _server;

  final ArticleDataGateway? _articleDataGaetway;
  final HighlightDataGateway? _highlightDataGaetway;
  final FeedDataGateway? _feedDataGateway;

  ServerTestsSetup({
    ArticleDataGateway? articleDataGaetway,
    HighlightDataGateway? highlightDataGaetway,
    FeedDataGateway? feedDataGateway,
  }) : _highlightDataGaetway = highlightDataGaetway,
       _articleDataGaetway = articleDataGaetway,
       _feedDataGateway = feedDataGateway;

  Future<void> setupServer() async {
    await _initServerDependancies();
    await _startServer();
  }

  Future<void> _startServer() async {
    final serverIniter = ServerIniter();
    await serverIniter.startServer();
    _server = serverIniter.server;
  }

  Future<void> _initServerDependancies() async {
    await _clearData();
    _registerDataGatewaysWithGetit();
  }

  void _registerDataGatewaysWithGetit() {
    _registerIfNotNull<ArticleDataGateway>(_articleDataGaetway);
    _registerIfNotNull<HighlightDataGateway>(_highlightDataGaetway);
    _registerIfNotNull<FeedDataGateway>(_feedDataGateway);
  }

  void _registerIfNotNull<T extends Object>(T? instance) {
    if (instance != null) {
      GetIt.I.registerSingleton<T>(instance);
    }
  }

  Future<void> tearDown() async {
    await _clearData();
    _server.close();
    await GetIt.I.reset();
  }

  Future<void> _clearData() async {
    await _highlightDataGaetway?.deleteAll();
    await _articleDataGaetway?.deleteAll();
    await _feedDataGateway?.deleteAll();
  }

  Uri get serverUri => Uri(scheme: "http", host: "localhost", port: 3000);
}
