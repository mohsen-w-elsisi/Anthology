import 'package:anthology_common/article/entities.dart';
import 'package:anthology_ui/app_actions.dart';
import 'package:flutter/material.dart';

class ReaderProgressTracker with ChangeNotifier {
  final Article article;
  final ScrollController scrollController = ScrollController();

  ReaderProgressTracker(this.article);

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void jumpToArticleProgress() {
    if (scrollController.hasClients && article.progress > 0) {
      final maxScroll = scrollController.position.maxScrollExtent;
      if (maxScroll > 0) {
        final offset = maxScroll * article.progress;
        scrollController.jumpTo(offset);
      }
    }
  }

  void updateProgress() {
    if (!scrollController.hasClients) return;

    final maxScroll = scrollController.position.maxScrollExtent;
    final progress =
        (maxScroll > 0
                ? (scrollController.position.pixels / maxScroll).clamp(0, 1)
                : 0.0)
            as double;

    AppActions.updateArticleProgress(article.id, progress);
  }
}
