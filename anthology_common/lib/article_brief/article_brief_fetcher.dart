import 'package:anthology_common/article/data_gaetway.dart';
import 'package:anthology_common/article/entities.dart';
import 'package:anthology_common/article_brief/entities.dart';
import 'package:anthology_common/article_brief/html_brief_parser/html_brief_parser.dart';
import 'package:get_it/get_it.dart';

import 'generator.dart';

class ArticleBriefFetcher {
  final String id;
  late final Article _article;
  late final CrudeArticleBrief _curdeBrief;
  late final ArticleBrief _brief;

  ArticleBriefFetcher(this.id);

  Future<ArticleBrief> fetchBrief() async {
    await _getArticle();
    await _requestCrudeBrief();
    _parseCrudeBrief();
    return _brief;
  }

  Future<void> _getArticle() async {
    _article = await GetIt.I<ArticleDataGateway>().get(id);
  }

  Future<void> _requestCrudeBrief() async {
    _curdeBrief = await GetIt.I<ArticleBriefHtmlGenerator>(
      param1: _article,
    ).generate();
  }

  void _parseCrudeBrief() {
    final parsedNodes = Htmlbriefparser(_curdeBrief.htmlContent).parse();
    final textNodesWithIndices = TextNodeIndiciesAssigner(
      parsedNodes,
    ).assignIndicies();
    _brief = ArticleBrief(
      articleId: _article.id,
      title: _curdeBrief.title,
      byline: _curdeBrief.byline,
      body: textNodesWithIndices,
      uri: _article.uri,
    );
  }
}

class TextNodeIndiciesAssigner {
  final List<TextNode> unindexedNodes;
  final List<TextNode> indexedNodes = [];

  int _currentIndex = 0;

  TextNodeIndiciesAssigner(this.unindexedNodes);

  List<TextNode> assignIndicies() {
    unindexedNodes.forEach(_assignIndexAndStepThrough);
    return indexedNodes;
  }

  void _assignIndexAndStepThrough(TextNode node) {
    final startIndex = _currentIndex;
    final endIndex = startIndex + node.text.length;
    indexedNodes.add(
      TextNode(
        text: node.text,
        type: node.type,
        bold: node.bold,
        italic: node.italic,
        startIndex: startIndex,
        endIndex: endIndex,
      ),
    );
    _currentIndex = endIndex;
  }
}
