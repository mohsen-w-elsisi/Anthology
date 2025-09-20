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
  List<ArticleSearchResult>? _searchResults;

  Future<List<ArticleSearchResult>> search(String query) async {
    final allArticles = await _fetchAll();
    query = query.toLowerCase();

    return allArticles
        .map(_QuerySatisfier(query).assign)
        .where((item) => item.querySatisfiedIn.isNotEmpty)
        .toList();
  }

  Future<List<ArticleSearchResult>> _fetchAll() async {
    if (_searchResults != null) return _searchResults!;

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

    _searchResults = await Future.wait(futures);
    return _searchResults!;
  }

  Future<ArticleSearchResult> constructResult({
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
    return ArticleSearchResult.unQueried(
      article: article,
      meta: meta,
      brief: brief,
      highlights: highlights,
    );
  }
}

class _QuerySatisfier {
  final String query;

  _QuerySatisfier(this.query);

  ArticleSearchResult assign(ArticleSearchResult item) {
    final satisfiedIn = <ArticleSearchField>{};
    if (item.meta?.title.toLowerCase().contains(query) ?? false) {
      satisfiedIn.add(ArticleSearchField.title);
    }

    String? previewText;
    Highlight? matchingHighlight;
    if (item.highlights != null) {
      for (final h in item.highlights!) {
        if (h.text.toLowerCase().contains(query)) {
          matchingHighlight = h;
          break;
        }
      }
    }

    if (matchingHighlight != null) {
      satisfiedIn.add(ArticleSearchField.highlight);
      previewText = '"${matchingHighlight.text}"';
    } else if (item.brief?.text.toLowerCase().contains(query) ?? false) {
      satisfiedIn.add(ArticleSearchField.content);
      String? matchingNodeText;
      if (item.brief?.body != null) {
        for (final node in item.brief!.body) {
          if (node.text.toLowerCase().contains(query)) {
            matchingNodeText = node.text;
            break;
          }
        }
      }
      previewText = matchingNodeText ?? item.article.uri.host;
    }

    return ArticleSearchResult(
      article: item.article,
      meta: item.meta,
      brief: item.brief,
      highlights: item.highlights,
      querySatisfiedIn: satisfiedIn,
      previewText: previewText,
    );
  }
}

class ArticleSearchResult {
  final Article article;
  final ArticlePresentationMetaData? meta;
  final ArticleBrief? brief;
  final List<Highlight>? highlights;
  late final Set<ArticleSearchField> querySatisfiedIn;
  late final String? previewText;

  ArticleSearchResult({
    required this.article,
    this.meta,
    this.brief,
    this.highlights,
    required this.querySatisfiedIn,
    this.previewText,
  });

  ArticleSearchResult.unQueried({
    required this.article,
    this.meta,
    this.brief,
    this.highlights,
  });
}

enum ArticleSearchField {
  title,
  highlight,
  content,
}
