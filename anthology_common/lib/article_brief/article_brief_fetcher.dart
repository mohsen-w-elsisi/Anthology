import 'package:anthology_common/article/data_gaetway.dart';
import 'package:anthology_common/article_brief/entities.dart';
import 'package:anthology_common/article_brief/html_brief_parser/html_brief_parser.dart';
import 'package:get_it/get_it.dart';

import 'generator.dart';

class ArticleBriefFetcher {
  final String id;
  late final Uri _uri;
  late final String _htmlBrief;
  late final List<TextNode> _brief;

  ArticleBriefFetcher(this.id);

  Future<List<TextNode>> fetchBrief() async {
    await _getArticleUri();
    await _requestBriefHtml();
    _parseBriefHtml();
    return _brief;
  }

  Future<void> _getArticleUri() async {
    final article = await GetIt.I<ArticleDataGaetway>().get(id);
    _uri = article.uri;
  }

  Future<void> _requestBriefHtml() async {
    _htmlBrief = await GetIt.I<ArticleBriefHtmlGenerator>(
      param1: _uri,
    ).generate();
  }

  void _parseBriefHtml() {
    _brief = Htmlbriefparser(_htmlBrief).parse();
  }
}
