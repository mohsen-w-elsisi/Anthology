import 'package:anthology_common/article/entities.dart';
import 'package:flutter/widgets.dart';

class ReaderViewStatusNotifier with ChangeNotifier {
  Article? _activeArticle;

  Article? get activeArticle => _activeArticle;

  void setActiveArticle(Article article) {
    if (_activeArticle?.id != article.id) {
      _activeArticle = article;
      notifyListeners();
    }
  }

  void clearActiveArticle() {
    if (_activeArticle != null) {
      _activeArticle = null;
      notifyListeners();
    }
  }
}
