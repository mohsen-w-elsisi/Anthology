import 'package:anthology_common/article_brief/entities.dart';
import 'package:anthology_common/highlight/data_gateway.dart';
import 'package:anthology_common/highlight/entities.dart';
import 'package:anthology_ui/state/highlight_ui_notifier.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';

class ReaderScreenHighlightProvider with ChangeNotifier {
  final String _articleId;
  List<Highlight>? _highlights;

  ReaderScreenHighlightProvider(this._articleId);

  Future<void> init() async {
    await _getCurrentHighlights();
    GetIt.I<HighlightUiNotifier>().addListener(_getCurrentHighlights);
  }

  @override
  void dispose() {
    GetIt.I<HighlightUiNotifier>().removeListener(_getCurrentHighlights);
    super.dispose();
  }

  Future<void> _getCurrentHighlights() async {
    _highlights = await GetIt.I<HighlightDataGateway>().getArticleHighlights(
      _articleId,
    );
    _sortHighlights();
    notifyListeners();
  }

  void _sortHighlights() {
    _highlights!.sort((a, b) => a.startIndex.compareTo(b.startIndex));
  }

  List<Highlight> get highlights =>
      _highlights != null ? List.unmodifiable(_highlights!) : [];

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
