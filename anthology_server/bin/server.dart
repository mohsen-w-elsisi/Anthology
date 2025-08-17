import 'package:anthology_common/article/data_gaetway.dart';
import 'package:anthology_common/article/entities.dart';
import 'package:anthology_common/article_brief/generator.dart';
import 'package:anthology_server/article_brief_html_generator.dart';
import 'package:anthology_server/data_gateways/local_json_article_data_gateway.dart';
import 'package:anthology_server/data_gateways/local_json_highligh_data_gateway.dart';
import 'package:anthology_server/server_initer.dart';
import 'package:get_it/get_it.dart';

void main(List<String> arguments) {
  GetIt.I.registerSingleton<ArticleDataGateway>(LocalJsonArticleDataGateway());
  GetIt.I.registerSingleton(LocalJsonHighlighDataGateway());
  GetIt.I.registerFactoryParam<ArticleBriefHtmlGenerator, Article, Null>(
    (article, _) => BriefingServerArticleBriefHtmlGenerator(article),
  );
  ServerIniter().startServer();
}
