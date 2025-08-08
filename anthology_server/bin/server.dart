import 'package:anthology_common/article/data_gaetway.dart';
import 'package:anthology_common/article_brief/generator.dart';
import 'package:anthology_server/article_brief_html_generator.dart';
import 'package:anthology_server/local_json_article_data_gateway.dart';
import 'package:anthology_server/local_json_highligh_data_gateway.dart';
import 'package:anthology_server/server_initer.dart';
import 'package:get_it/get_it.dart';

void main(List<String> arguments) {
  GetIt.I.registerSingleton<ArticleDataGaetway>(LocalJsonArticleDataGateway());
  GetIt.I.registerSingleton(LocalJsonHighlighDataGateway());
  GetIt.I.registerFactoryParam<ArticleBriefHtmlGenerator, Uri, Null>(
    (uri, _) => BriefingServerArticleBriefHtmlGenerator(uri),
  );
  ServerIniter().startServer();
}
