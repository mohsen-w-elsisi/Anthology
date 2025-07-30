import 'package:anthology_common/article/data_gaetway.dart';
import 'package:anthology_common/article_brief/generator.dart';
import 'package:get_it/get_it.dart';

class ArticleBriefFetcher {
  final String id;
  late final Uri _uri;
  late final String _brief;

  ArticleBriefFetcher(this.id);

  Future<String> fetchBrief() async {
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
    _brief = await GetIt.I<ArticleBriefHtmlGenerator>(param1: _uri).generate();
  }

  void _parseBriefHtml() {} // useful in future
}
