import 'package:anthology_common/article_brief/entities.dart';
import 'package:anthology_ui/app_actions.dart';
import 'package:flutter/material.dart';

import 'highlight_factory.dart';

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

  void _saveHighlight() {
    ContextMenuController.removeAny();
    final highlight = HighlightFactory(
      textSelection: _textSelection,
      brief: _brief,
    ).create();
    AppActions.saveHighlight(highlight);
  }
}
