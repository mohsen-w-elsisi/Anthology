import 'package:anthology_common/article_brief/entities.dart';
import 'package:anthology_common/highlight/data_gateway.dart';
import 'package:anthology_common/highlight/entities.dart';
import 'package:anthology_ui/screens/reader/highlight/context_menu_button_item_factory.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'text_node_widget/factory.dart';
import 'text_options/text_options.dart';

class ReaderViewTextArea extends StatelessWidget {
  final ArticleBrief brief;
  final ReaderViewTextOptions textOptions;

  const ReaderViewTextArea({
    required this.brief,
    required this.textOptions,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: _modifyedTextTheme(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ..._titleAndByline(context),
          const SizedBox(height: 8.0),
          _SelectableArea(brief: brief),
        ],
      ),
    );
  }

  ThemeData _modifyedTextTheme(BuildContext context) {
    return Theme.of(context).copyWith(
      textTheme: TextTheme.of(context).apply(
        fontSizeFactor: textOptions.textScaleFactor,
      ),
    );
  }

  List<Widget> _titleAndByline(BuildContext context) => [
    Text(
      brief.title,
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.headlineLarge,
    ),
    const SizedBox(height: 8.0),
    Text(
      brief.byline,
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.bodyLarge,
    ),
  ];
}

class _SelectableArea extends StatefulWidget {
  final ArticleBrief brief;

  const _SelectableArea({required this.brief});

  @override
  State<_SelectableArea> createState() => __SelectableAreaState();
}

class __SelectableAreaState extends State<_SelectableArea> {
  String _textSelection = "";

  @override
  Widget build(BuildContext context) {
    return SelectionArea(
      onSelectionChanged: (value) => _textSelection = value?.plainText ?? "",
      contextMenuBuilder: _buildContextMenu,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _textNodes,
      ),
    );
  }

  Widget _buildContextMenu(
    BuildContext context,
    SelectableRegionState selectableRegionState,
  ) {
    return AdaptiveTextSelectionToolbar.buttonItems(
      anchors: selectableRegionState.contextMenuAnchors,
      buttonItems: [
        if (_textSelection.isNotEmpty) _highlightButton,
        ...selectableRegionState.contextMenuButtonItems,
      ],
    );
  }

  ContextMenuButtonItem get _highlightButton {
    return HighlightContextMenuButtonItemFactory(
      textSelection: _textSelection,
      brief: widget.brief,
    ).buttonItem();
  }

  List<Widget> get _textNodes => [
    for (final node in widget.brief.body) TextNodeWidgetFactory(node).widget(),
  ];
}
