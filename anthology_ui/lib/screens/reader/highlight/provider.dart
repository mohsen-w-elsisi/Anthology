import 'package:anthology_common/article_brief/entities.dart';
import 'package:anthology_common/highlight/data_gateway.dart';
import 'package:anthology_common/highlight/entities.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';

class ReaderScreenHighlightProvider {
  final String _articleId;
  List<Highlight>? _highlights;
  final initListenable = ValueNotifier(false);

  ReaderScreenHighlightProvider(this._articleId);

  Future<void> initHighlights() async {
    _highlights = await GetIt.I<HighlightDataGateway>().getArticleHighlights(
      _articleId,
    );
    _sortHighlights();
    initListenable.value = true;
  }

  void _sortHighlights() {
    _highlights!.sort((a, b) => a.startIndex.compareTo(b.startIndex));
  }

  List<Highlight> highlightsWithingNode(TextNode node) {
    if (_highlights == null) return [];
    return _highlights!
        .where(
          (highlight) =>
              highlight.startIndex < node.endIndex &&
              highlight.endIndex > node.startIndex,
        )
        .toList();
  }
}
