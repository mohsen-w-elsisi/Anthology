import 'package:anthology_common/article/entities.dart';

abstract class ArticleBriefHtmlGenerator {
  final Article article;

  ArticleBriefHtmlGenerator(this.article);

  Future<String> generate();
}
