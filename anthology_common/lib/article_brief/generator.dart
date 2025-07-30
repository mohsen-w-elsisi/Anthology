abstract class ArticleBriefHtmlGenerator {
  final Uri uri;

  ArticleBriefHtmlGenerator(this.uri);

  Future<String> generate();
}
