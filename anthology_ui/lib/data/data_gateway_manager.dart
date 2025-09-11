import 'package:anthology_common/article/data_gaetway.dart';
import 'package:anthology_common/highlight/data_gateway.dart';
import 'package:anthology_common/server_request_interface.dart';
import 'package:anthology_common/shared_impls/local_article_data_gateway.dart';
import 'package:anthology_common/shared_impls/local_highlight_data_gateway.dart';
import 'package:anthology_ui/data/http_article_data_gateway.dart';
import 'package:anthology_ui/data/http_highlight_data_gateway.dart';
import 'package:get_it/get_it.dart';

class DataGatewayIniter {
  static const _articleFileName = "articles.json";
  static const _highlightFileName = "highlights.json";

  final bool useHttp;
  final String localDataFolder;
  final ServerRequestInterface? serverRequestInterface;

  DataGatewayIniter({
    required this.useHttp,
    required this.localDataFolder,
    this.serverRequestInterface,
  }) {
    assert(!useHttp || (serverRequestInterface != null));
  }

  void init() {
    GetIt.I.registerSingleton<ArticleDataGateway>(_articleGateway);
    GetIt.I.registerSingleton<HighlightDataGateway>(_highlightGateway);
  }

  void reInit() {
    GetIt.I.unregister<ArticleDataGateway>();
    GetIt.I.unregister<HighlightDataGateway>();
    init();
  }

  ArticleDataGateway get _articleGateway {
    if (useHttp) {
      return HttpArticleDataGateway(serverRequestInterface!);
    } else {
      return LocalArticleDataGateway('$localDataFolder/$_articleFileName');
    }
  }

  HighlightDataGateway get _highlightGateway {
    if (useHttp) {
      return HttpHighlightDataGateway(serverRequestInterface!);
    } else {
      return LocalHighlightDataGateway('$localDataFolder/$_highlightFileName');
    }
  }
}
