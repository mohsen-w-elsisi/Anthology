import 'package:anthology_common/article/entities.dart';
import 'package:anthology_ui/screens/reader/reader_screen_settings.dart';
import 'package:flutter/widgets.dart';

class ReaderViewStatusNotifier with ChangeNotifier {
  Article? _activeArticle;
  ReaderScreenSettings? _activeReaderScreenSettings;

  bool isReaderModalActive = false;

  Article? get activeArticle => _activeArticle;
  ReaderScreenSettings? get activeReaderScreenSettings =>
      _activeReaderScreenSettings;

  void setActiveArticle(Article article) {
    if (_activeArticle?.id != article.id) {
      _activeArticle = article;
      _activeReaderScreenSettings = const ReaderScreenSettings(
        scrollDestination: ReaderProgressDestination(),
      );
      notifyListeners();
    }
  }

  void setActiveArticleWithSettings(
    Article article,
    ReaderScreenSettings settings,
  ) {
    if (_activeArticle?.id != article.id ||
        _activeReaderScreenSettings != settings) {
      _activeArticle = article;
      _activeReaderScreenSettings = settings;
      notifyListeners();
    }
  }

  void clearActiveArticle() {
    if (_activeArticle != null) {
      _activeArticle = null;
      _activeReaderScreenSettings = null;
      notifyListeners();
    }
  }
}
