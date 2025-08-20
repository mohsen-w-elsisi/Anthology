import 'package:anthology_common/article/data_gaetway.dart';
import 'package:anthology_common/server_request_interface.dart';
import 'package:anthology_ui/data/http_article_data_gateway.dart';
import 'package:anthology_ui/state/tag_aggregator.dart';
import 'package:get_it/get_it.dart';

class AppDependencyIniter {
  static Future<void> init() async {
    _initArticleDataGateway();
    await _initTagAggregator();
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

  static final _serverBaseUri = Uri(
    scheme: 'http',
    host: 'localhost',
    port: 3000,
  );
}
