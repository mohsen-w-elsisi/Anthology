import 'package:anthology_common/article/data_gaetway.dart';
import 'package:anthology_common/article/entities.dart';
import 'package:anthology_common/highlight/data_gateway.dart';
import 'package:anthology_common/highlight/entities.dart';
import 'package:anthology_ui/data/article_presentation_meta_data/fetcher.dart';
import 'package:anthology_ui/shared_widgets/filterable_chips.dart';
import 'package:anthology_ui/state/highlight_ui_notifier.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class HighlightsScreenProvider with ChangeNotifier, ArticleFilterNotifier {
  final HighlightUiNotifier _highlightUiNotifier =
      GetIt.I<HighlightUiNotifier>();

  List<ArticleHighlights>? _articleHighlights;
  List<ArticleHighlights>? get articleHighlights => _articleHighlights;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Object? _error;
  Object? get error => _error;

  HighlightsScreenProvider() {
    _highlightUiNotifier.addListener(fetchArticleHighlights);
    initFilterable();
    fetchArticleHighlights();
  }

  @override
  void dispose() {
    _highlightUiNotifier.removeListener(fetchArticleHighlights);
    disposeFilterable();
    super.dispose();
  }

  Future<void> fetchArticleHighlights() async {
    _isLoading = true;
    _error = null;
    if (_articleHighlights == null) {
      notifyListeners();
    }

    try {
      _articleHighlights = await ArticleHighlightsFetcher().fetch();
    } catch (e) {
      _error = e;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<ArticleHighlights>? get filteredArticleHighlights {
    if (_articleHighlights == null) return null;

    return _articleHighlights!.where((articleHighlight) {
      final article = articleHighlight.article;
      final tags = tagSelectionController.selectedTags;

      final isArchived = article.isArchived;
      final hasSelectedTags =
          tags.isEmpty || tags.any((tag) => article.tags.contains(tag));

      if (showArchived) {
        return isArchived && hasSelectedTags;
      } else {
        return !isArchived && hasSelectedTags;
      }
    }).toList();
  }
}

class ArticleHighlightsFetcher {
  final HighlightDataGateway _highlightGateway =
      GetIt.I<HighlightDataGateway>();
  final ArticleDataGateway _articleGateway = GetIt.I<ArticleDataGateway>();

  late final Map<String, List<Highlight>> _highlightsByArticleId;
  late final List<ArticleHighlights> _articleHighlights;

  Future<List<ArticleHighlights>> fetch() async {
    await _fetchGroupedHighlights();
    await _mapEntriesToArticleHighlights();
    _sortArticleHighlights();
    return _articleHighlights;
  }

  Future<void> _fetchGroupedHighlights() async {
    _highlightsByArticleId = await _highlightGateway.getAll();
  }

  Future<void> _mapEntriesToArticleHighlights() async {
    final futures = _highlightsByArticleId.entries.map(
      _createArticleHighlightsFromEntry,
    );
    _articleHighlights = await Future.wait(futures);
  }

  Future<ArticleHighlights> _createArticleHighlightsFromEntry(
    MapEntry<String, List<Highlight>> entry,
  ) async {
    final articleId = entry.key;
    final highlights = entry.value;
    final article = await _articleGateway.get(articleId);
    final articleMetadata = await ArticlePresentationMetaDataFetcher(
      article,
    ).fetch();

    return ArticleHighlights(
      article: article,
      articleTitle: articleMetadata.title,
      highlights: highlights,
    );
  }

  void _sortArticleHighlights() {
    _articleHighlights.sort(
      (a, b) => a.articleTitle.toLowerCase().compareTo(
        b.articleTitle.toLowerCase(),
      ),
    );
  }
}

class ArticleHighlights {
  final Article article;
  final String articleTitle;
  final List<Highlight> highlights;

  ArticleHighlights({
    required this.article,
    required this.articleTitle,
    required this.highlights,
  });
}
