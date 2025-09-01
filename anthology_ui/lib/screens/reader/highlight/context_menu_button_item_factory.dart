import 'package:anthology_common/article_brief/entities.dart';
import 'package:anthology_common/highlight/data_gateway.dart';
import 'package:anthology_common/highlight/entities.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class HighlightContextMenuButtonItemFactory {
  final String _textSelection;
  final ArticleBrief _brief;

  HighlightContextMenuButtonItemFactory({
    required String textSelection,
    required ArticleBrief brief,
  }) : _textSelection = textSelection,
       _brief = brief;

  ContextMenuButtonItem buttonItem() => ContextMenuButtonItem(
    onPressed: _saveHighlight,
    label: "highlight",
  );

  // TODO: selecting a non-unique substring within the brief will not guarentee valid start/end index
  void _saveHighlight() {
    ContextMenuController.removeAny();
    GetIt.I<HighlightDataGateway>().save(_highlight());
  }

  Highlight _highlight() => Highlight(
    text: _textSelection,
    articleId: _brief.articleId,
    startIndex: _textStartIndex,
    endIndex: _textEndIndex,
    id: DateTime.now().toString(),
  );

  int get _textStartIndex {
    final splitTexts = _brief.text.split(_textSelection);
    return splitTexts.first.length;
  }

  int get _textEndIndex => _textStartIndex + _textSelection.length;
}
