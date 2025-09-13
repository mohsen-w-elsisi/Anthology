import 'package:anthology_common/article_brief/entities.dart';
import 'package:anthology_common/article_brief/article_brief_fetcher.dart';
import 'package:anthology_ui/data/article_brief_cache.dart';
import 'package:anthology_common/article/data_gaetway.dart';
import 'package:anthology_common/article/entities.dart';
import 'package:anthology_common/highlight/data_gateway.dart';
import 'package:anthology_common/highlight/entities.dart';
import 'package:anthology_ui/data/data_gateway_manager.dart';
import 'package:anthology_ui/state/article_ui_notifier.dart';
import 'package:anthology_ui/state/highlight_ui_notifier.dart';
import 'package:share_plus/share_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'config.dart';

abstract class AppActions {
  static Future<ArticleBrief> getBrief(String articleId) async {
    final cache = GetIt.I<ArticleBriefCache>();
    if (await cache.isCached(articleId)) {
      return cache.get(articleId);
    } else {
      final brief = await ArticleBriefFetcher(articleId).fetchBrief();
      cache.cache(articleId, brief);
      return brief;
    }
  }

  static Future<void> setLocalDataFolder(String folderPath) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(SharedPrefsKeys.localDataFolder, folderPath);
    DataGatewayIniter(useHttp: false, localDataFolder: folderPath).reInit();
    _articleUiNotifier.notify();
    _highlightUiNotifier.notify();
  }

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

  static Future<void> clearCache() async {
    throw UnimplementedError();
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
