import 'package:anthology_ui/screens/saves/article_searcher.dart';
import 'package:anthology_ui/state/tag_selection_controller.dart';
import 'package:flutter/material.dart';

class ArticleSearchProvider with ChangeNotifier {
  final _searcher = ArticleSearcher();
  final tagSelectionController = TagSelectionController();

  List<ArticleSearchResult>? _results;
  List<ArticleSearchResult>? get results => _results;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  String _query = '';
  String get query => _query;

  ArticleSearchProvider() {
    tagSelectionController.addListener(notifyListeners);
  }

  @override
  void dispose() {
    tagSelectionController.dispose();
    super.dispose();
  }

  Future<void> search(String query) async {
    if (_query == query && _results != null) return;
    _query = query;

    if (query.isEmpty) {
      _results = null;
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      _results = await _searcher.search(query);
      _error = null;
    } catch (e) {
      _error = e.toString();
      _results = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<ArticleSearchResult> get filteredResults {
    if (_results == null) return [];
    final selectedTags = tagSelectionController.selectedTags;
    if (selectedTags.isEmpty) return _results!;

    return _results!
        .where((result) => result.article.tags.any(selectedTags.contains))
        .toList();
  }
}
