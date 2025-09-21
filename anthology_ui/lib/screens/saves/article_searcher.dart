import 'package:anthology_common/article/data_gaetway.dart';
import 'package:anthology_common/article/entities.dart';
import 'package:anthology_common/article_brief/entities.dart';
import 'package:anthology_common/highlight/data_gateway.dart';
import 'package:anthology_common/highlight/entities.dart';
import 'package:anthology_ui/data/article_brief_cache.dart';
import 'package:anthology_ui/data/article_presentation_meta_data/entities.dart';
import 'package:anthology_ui/data/article_presentation_meta_data/fetcher.dart';
import 'package:get_it/get_it.dart';

class ArticleSearcher {
  List<SearchableArticleBundle>? _articleBundles;

  Future<List<ArticleSearchResult>> search(String query) async {
    final allArticles = await _fetchAll();
    query = query.toLowerCase();

    return allArticles
        .expand(
          (bundle) => _ArticleSearcher(
            query: query,
            searchableBundle: bundle,
          ).search(),
        )
        .toList();
  }

  Future<List<SearchableArticleBundle>> _fetchAll() async {
    if (_articleBundles != null) return _articleBundles!;

    final articles = await GetIt.I<ArticleDataGateway>().getAll();
    if (articles.isEmpty) return [];

    final briefCache = GetIt.I<ArticleBriefCache>();

    final futures = articles
        .map(
          (article) async => constructResult(
            article: article,
            briefCache: briefCache,
          ),
        )
        .toList();

    _articleBundles = await Future.wait(futures);
    return _articleBundles!;
  }

  Future<SearchableArticleBundle> constructResult({
    required Article article,
    required ArticleBriefCache briefCache,
  }) async {
    ArticlePresentationMetaData? meta;
    try {
      meta = await ArticlePresentationMetaDataFetcher(article).fetch();
    } catch (_) {
      meta = null;
    }
    ArticleBrief? brief;
    if (await briefCache.isCached(article.id)) {
      brief = await briefCache.get(article.id);
    }
    List<Highlight>? highlights;
    try {
      highlights = await GetIt.I<HighlightDataGateway>().getArticleHighlights(
        article.id,
      );
    } catch (_) {
      highlights = null;
    }
    return SearchableArticleBundle(
      article: article,
      meta: meta,
      brief: brief,
      highlights: highlights,
    );
  }
}

class _ArticleSearcher {
  final String query;
  final SearchableArticleBundle searchableBundle;

  final List<ArticleSearchFieldResultDiscribtor> _searchResultDiscribtors = [];

  _ArticleSearcher({required this.query, required this.searchableBundle});

  List<ArticleSearchResult> search() {
    _searchTitle();
    _searchHighlight();
    _searchContent();

    return [
      for (final discribtor in _searchResultDiscribtors)
        ArticleSearchResult(
          article: searchableBundle.article,
          resultDiscribtor: discribtor,
        ),
    ];
  }

  void _searchTitle() {
    final title = searchableBundle.meta?.title ?? '';
    if (title.toLowerCase().contains(query)) {
      _searchResultDiscribtors.add(
        ArticleTitleSearchResultDiscribtor(title),
      );
    }
  }

  void _searchHighlight() {
    final highlights = searchableBundle.highlights ?? [];
    for (final highlight in highlights) {
      if (highlight.text.toLowerCase().contains(query)) {
        _searchResultDiscribtors.add(
          ArticleHighlightSearchResultDiscribtor(highlight),
        );
      }
    }
  }

  void _searchContent() {
    final body = searchableBundle.brief?.body ?? [];
    for (var i = 0; i < body.length; i++) {
      final node = body[i];
      if (node.text.toLowerCase().contains(query)) {
        _searchResultDiscribtors.add(
          ArticleContentSearchResultDiscribtor(node, i),
        );
      }
    }
  }
}

class SearchableArticleBundle {
  final Article article;
  final ArticlePresentationMetaData? meta;
  final ArticleBrief? brief;
  final List<Highlight>? highlights;

  SearchableArticleBundle({
    required this.article,
    this.meta,
    this.brief,
    this.highlights,
  });
}

class ArticleSearchResult {
  final Article article;
  final ArticleSearchFieldResultDiscribtor resultDiscribtor;

  const ArticleSearchResult({
    required this.article,
    required this.resultDiscribtor,
  });
}

enum ArticleSearchField {
  title,
  highlight,
  content,
}

sealed class ArticleSearchFieldResultDiscribtor {
  ArticleSearchField get field;

  String? previewText();
}

class ArticleTitleSearchResultDiscribtor
    implements ArticleSearchFieldResultDiscribtor {
  final String title;

  ArticleTitleSearchResultDiscribtor(this.title);

  @override
  ArticleSearchField get field => ArticleSearchField.title;

  @override
  String? previewText() => null;
}

class ArticleHighlightSearchResultDiscribtor
    implements ArticleSearchFieldResultDiscribtor {
  final Highlight highlight;

  ArticleHighlightSearchResultDiscribtor(this.highlight);

  @override
  ArticleSearchField get field => ArticleSearchField.highlight;

  @override
  String? previewText() => '"${highlight.text}"';
}

class ArticleContentSearchResultDiscribtor
    implements ArticleSearchFieldResultDiscribtor {
  final TextNode node;
  final int nodeIndex;

  ArticleContentSearchResultDiscribtor(this.node, this.nodeIndex);

  @override
  ArticleSearchField get field => ArticleSearchField.content;

  @override
  String? previewText() => node.text.trim();
}
