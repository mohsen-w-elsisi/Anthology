import 'entities.dart';

class ArticleFilterer {
  final List<Article> articles;

  ArticleFilterer(List<Article> articles)
    : articles = List.unmodifiable(articles);

  ArticleFilterer byArchiveStatus(bool isArchived) {
    final filteredArticles = [
      for (final article in articles)
        if (article.isArchived == isArchived) article,
    ];
    return ArticleFilterer(filteredArticles);
  }

  ArticleFilterer onlyTags(Set<String> tags) {
    assert(tags.isNotEmpty, "Tags cannot be empty for filtering");
    final filteredArticles = [
      for (final article in articles)
        if (article.tags.any((tag) => tags.contains(tag))) article,
    ];
    return ArticleFilterer(filteredArticles);
  }
}
