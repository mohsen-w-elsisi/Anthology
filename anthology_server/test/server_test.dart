import 'dart:io';

import 'package:anthology_common/config/api_uris.dart';
import 'package:anthology_server/local_json_article_data_gateway.dart';
import 'package:anthology_server/server_initer.dart';
import 'package:test/test.dart';
import 'package:http/http.dart' as http;

void main() {
  late final HttpServer server;

  setUp(() async {
    final serverIniter = ServerIniter();
    await serverIniter.startServer();
    server = serverIniter.server;
  });

  tearDown(() async {
    await LocalJsonArticleDataGateway().deleteAll();
    server.close();
  });

  test("hello world", () async {
    final res = await http.get(
      Uri(
        scheme: "http",
        host: "localhost",
        port: server.port,
        path: ApiUris.apiBase,
      ),
    );

    expect(res.body, "hello world");
  });
}
