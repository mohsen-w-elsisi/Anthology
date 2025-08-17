import 'package:anthology_common/article/entities.dart';
import 'package:anthology_common/article_brief/generator.dart';
import 'package:anthology_common/server_request_interface.dart';

class ServerArticleBriefHtmlGenerator implements ArticleBriefHtmlGenerator {
  static late Uri _baseUri;

  static void setBaseUri(Uri baseUri) => _baseUri = baseUri;

  @override
  final Article article;

  ServerArticleBriefHtmlGenerator(this.article);

  @override
  Future<String> generate() async {
    final res = await ServerRequestInterface(
      _baseUri,
    ).getArticleBrief(article.id);
    assert(res.statusCode == 200);
    return res.body;
  }
}
