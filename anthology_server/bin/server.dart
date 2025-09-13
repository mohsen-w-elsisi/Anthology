import 'package:anthology_common/article/data_gaetway.dart';
import 'package:anthology_common/article/entities.dart';
import 'package:anthology_common/article_brief/generator.dart';
import 'package:anthology_common/highlight/data_gateway.dart';
import 'package:anthology_common/shared_impls/local_article_data_gateway.dart';
import 'package:anthology_common/shared_impls/local_highlight_data_gateway.dart';
import 'package:anthology_common/shared_impls/article_brief_html_generator.dart';
import 'package:anthology_server/server_initer.dart';
import 'package:get_it/get_it.dart';

void main(List<String> arguments) {
  GetIt.I.registerSingleton<ArticleDataGateway>(
    LocalArticleDataGateway("./db/saves.json"),
  );
  GetIt.I.registerSingleton<HighlightDataGateway>(
    LocalHighlightDataGateway("./db/highlights.json"),
  );
  GetIt.I.registerFactoryParam<ArticleBriefHtmlGenerator, Article, Null>(
    (article, _) => BriefingServerArticleBriefHtmlGenerator(article),
  );
  ServerIniter().startServer();
}
