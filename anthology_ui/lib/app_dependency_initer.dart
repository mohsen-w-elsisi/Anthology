import 'package:anthology_common/article/data_gaetway.dart';
import 'package:anthology_common/server_request_interface.dart';
import 'package:anthology_ui/persistance/http_article_data_gateway.dart';
import 'package:get_it/get_it.dart';

class AppDependencyIniter {
  static void init() {
    GetIt.I.registerSingleton<ArticleDataGaetway>(
      HttpArticleDataGateway(
        ServerRequestInterface(
          Uri(
            scheme: 'http',
            host: 'localhost',
            port: 3000,
          ),
        ),
      ),
    );
  }
}
