import 'package:anthology_common/article/data_gaetway.dart';
import 'package:anthology_common/article/entities.dart';
import 'package:anthology_common/highlight/data_gateway.dart';
import 'package:anthology_common/highlight/entities.dart';
import 'package:anthology_ui/state/article_ui_notifier.dart';
import 'package:anthology_ui/state/highlight_ui_notifier.dart';
import 'package:share_plus/share_plus.dart';
import 'package:get_it/get_it.dart';

abstract class AppActions {
  static Future<void> saveArticle(Article article) async {
    await _articleDataGateway.save(article);
    _articleUiNotifier.notify();
  }

  static Future<void> updateArticleProgress(String id, double progress) async {
    await _articleDataGateway.updateProgress(id, progress);
    _articleUiNotifier.notify();
  }

  static Future<void> saveHighlight(Highlight highlight) async {
    await _highlightDataGateway.save(highlight);
    _highlightUiNotifier.notify();
  }

  static Future<void> updateHighlightComment(String id, String comment) async {
    final highlight = await _highlightDataGateway.get(id);
    final alteredHighlight = highlight.copyWith(comment: comment);
    await _highlightDataGateway.save(alteredHighlight);
    _highlightUiNotifier.notify();
  }

  static Future<void> deleteArticle(String articleId) async {
    await _articleDataGateway.delete(articleId);
    await _highlightDataGateway.deleteForArticle(articleId);
    _articleUiNotifier.notify();
    _highlightUiNotifier.notify();
  }

  static void shareArticle(Article article) {
    SharePlus.instance.share(ShareParams(uri: article.uri));
  }

  static ArticleDataGateway get _articleDataGateway =>
      GetIt.I<ArticleDataGateway>();
  static ArticleUiNotifier get _articleUiNotifier =>
      GetIt.I<ArticleUiNotifier>();
  static HighlightDataGateway get _highlightDataGateway =>
      GetIt.I<HighlightDataGateway>();
  static HighlightUiNotifier get _highlightUiNotifier =>
      GetIt.I<HighlightUiNotifier>();
}
