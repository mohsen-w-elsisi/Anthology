import 'package:anthology_common/article/data_gaetway.dart';
import 'package:anthology_common/article/entities.dart';
import 'package:anthology_common/article/filterer.dart';
import 'package:anthology_ui/app_actions.dart';
import 'package:anthology_ui/state/article_ui_notifier.dart';
import 'package:anthology_ui/state/tag_selection_controller.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class SavesProvider extends ChangeNotifier {
  ArticleDataGateway get _articleDataGateway => GetIt.I<ArticleDataGateway>();
  ArticleUiNotifier get _articleUiNotifier => GetIt.I<ArticleUiNotifier>();

  final TagSelectionController tagSelectionController =
      TagSelectionController();

  List<Article>? _articles;
  List<Article>? get articles => _articles;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  bool _showArchived = false;
  bool get showArchived => _showArchived;

  SavesProvider() {
    _articleUiNotifier.addListener(fetchArticles);
    tagSelectionController.addListener(_onTagFilterChanged);
    fetchArticles();
  }

  @override
  void dispose() {
    _articleUiNotifier.removeListener(fetchArticles);
    tagSelectionController.removeListener(_onTagFilterChanged);
    tagSelectionController.dispose();
    super.dispose();
  }

  void _onTagFilterChanged() {
    notifyListeners();
  }

  Future<void> fetchArticles() async {
    _isLoading = true;
    if (_articles == null) {
      notifyListeners();
    }

    try {
      _articles = await _articleDataGateway.getAll();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<Article> get filteredArticles {
    if (_articles == null) return [];
    var filterer = ArticleFilterer(_articles!).byArchiveStatus(_showArchived);
    final selectedTags = tagSelectionController.selectedTags;
    if (selectedTags.isNotEmpty) {
      filterer = filterer.onlyTags(selectedTags);
    }
    return filterer.articles;
  }

  void setShowArchived(bool value) {
    _showArchived = value;
    notifyListeners();
  }

  void archiveArticle(Article article) {
    if (!_showArchived) {
      _articles?.removeWhere((a) => a.id == article.id);
      notifyListeners();
    }
    AppActions.setArticleArchiveStatus(article.id, true);
  }
}
