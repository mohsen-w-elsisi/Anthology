import 'dart:io';

import 'package:anthology_common/article/data_gaetway.dart';
import 'package:anthology_server/server_initer.dart';
import 'package:get_it/get_it.dart';

class ServerTestsSetup {
  late HttpServer _server;
  final ArticleDataGaetway _articleDataGaetway;

  ServerTestsSetup({required ArticleDataGaetway articleDataGaetway})
    : _articleDataGaetway = articleDataGaetway;

  Future<void> setupServer() async {
    await _initServerDependancies();
    await _startServer();
  }

  Future<void> _initServerDependancies() async {
    GetIt.I.registerSingleton(_articleDataGaetway);
    await _articleDataGaetway.deleteAll();
  }

  Future<void> _startServer() async {
    final serverIniter = ServerIniter();
    await serverIniter.startServer();
    _server = serverIniter.server;
  }

  Future<void> tearDown() async {
    _articleDataGaetway.deleteAll();
    _server.close();
    await GetIt.I.reset();
  }

  Uri get serverUri => Uri(scheme: "http", host: "localhost", port: 3000);
}
