import 'package:anthology_common/article/entities.dart';

abstract class ArticleBriefHtmlGenerator {
  final Article article;

  ArticleBriefHtmlGenerator(this.article);

  Future<CrudeArticleBrief> generate();
}

class CrudeArticleBrief {
  final String title;
  final String htmlContent;
  final String byline;

  CrudeArticleBrief({
    required this.title,
    required this.htmlContent,
    required this.byline,
  });
}
