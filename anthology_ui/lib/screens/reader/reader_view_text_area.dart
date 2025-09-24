import 'package:anthology_common/article_brief/entities.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'highlight/context_menu_button_item_factory.dart';
import 'shortcuts.dart';
import 'text_node_registry.dart';
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
    if (brief.byline.isNotEmpty)
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
    return Shortcuts(
      shortcuts: _shortcuts,
      child: SelectionArea(
        onSelectionChanged: _updateSelectedText,
        contextMenuBuilder: _buildContextMenu,
        child: Column(
          key: const Key('text_nodes'),
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: _buildTextNodes(context),
        ),
      ),
    );
  }

  Map<ShortcutActivator, Intent> get _shortcuts => {
    SingleActivator(LogicalKeyboardKey.keyH): AddHighlightIntent(
      selectedText: _textSelection,
      brief: widget.brief,
    ),
  };

  void _updateSelectedText(value) => setState(() {
    _textSelection = value?.plainText ?? "";
  });

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

  List<Widget> _buildTextNodes(BuildContext context) {
    final registry = context.read<TextNodeRegistry>();
    final nodes = widget.brief.body;
    final widgets = <Widget>[];
    for (var i = 0; i < nodes.length; i++) {
      final key = GlobalKey();
      registry.register(i, key);
      widgets.add(
        Builder(
          key: key,
          builder: (context) => TextNodeWidgetFactory(nodes[i]).widget(),
        ),
      );
    }
    return widgets;
  }
}
