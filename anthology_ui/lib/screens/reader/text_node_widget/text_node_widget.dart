import 'dart:math';

import 'package:anthology_common/article_brief/entities.dart';
import 'package:anthology_common/highlight/entities.dart';
import 'package:anthology_ui/screens/reader/highlight/provider.dart';
import 'package:anthology_ui/shared_widgets/highlight_detail_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:provider/provider.dart';

import 'node_style_extractor.dart';

abstract class TextNodeWidget extends StatelessWidget {
  final TextNode node;

  const TextNodeWidget(this.node, {super.key});

  TextNodeType get nodeType;

  Widget buildNodeWidget(BuildContext context, {Key? key}) {
    return NodeWidgetBuilder(
      node: node,
      context: context,
      key: key,
    ).build();
  }

  @override
  Widget build(BuildContext context) {
    assert(
      node.type == nodeType,
      'Incorrect node type for this widget. Expected $nodeType, but got ${node.type}',
    );
    return buildNodeWidget(context);
  }
}

class NodeWidgetBuilder {
  final TextNode node;
  final BuildContext context;
  final Key? key;

  late final List<Highlight> highlights;
  late final TextStyle _baseStyle;
  late final TextStyle _highlightStyle;

  final List<TextSpan> _spans = [];

  int _currentPosition = 0;

  late Highlight _highlight;
  late int _localHighlightStartIndex;
  late int _localHighlightEndIndex;
  late int _nodeBoundStartIndex;
  late int _nodeBoundEndIndex;

  NodeWidgetBuilder({
    required this.node,
    required this.context,
    this.key,
  }) {
    _fetchHighllights();
    _defineStyles();
  }

  void _fetchHighllights() {
    highlights = context
        .watch<ReaderScreenHighlightProvider>()
        .highlightsWithingNode(node);
  }

  void _defineStyles() {
    final textTheme = Theme.of(context).textTheme;
    _baseStyle = NodeStyleExtractor(textTheme).styleFor(node.type);
    _highlightStyle = _baseStyle.copyWith(
      backgroundColor: Colors.yellow.withValues(alpha: 0.5),
    );
  }

  Widget build() {
    if (highlights.isEmpty) {
      return _buildTextWidget(withHighlights: false);
    } else {
      _produceSpansWithHighlights();
      return _buildTextWidget(withHighlights: true);
    }
  }

  void _produceSpansWithHighlights() {
    for (_highlight in highlights) {
      _defineLocalHighlightIndicies();
      _defineNodeBoundIndicies();
      _appendTextBeforeHighlight();
      if (_nodeBoundRangeIsValid) _appendHighlightSpan();
      _incrementCurrentPosition();
    }
    _appendAnyTrailingUnhighlightedText();
  }

  void _defineLocalHighlightIndicies() {
    _localHighlightStartIndex = _highlight.startIndex - node.startIndex;
    _localHighlightEndIndex = _highlight.endIndex - node.startIndex;
  }

  void _defineNodeBoundIndicies() {
    _nodeBoundStartIndex = max(_currentPosition, _localHighlightStartIndex);
    _nodeBoundEndIndex = min(node.text.length, _localHighlightEndIndex);
  }

  void _appendTextBeforeHighlight() {
    if (_localHighlightStartIndex > _currentPosition) {
      _spans.add(
        TextSpan(
          text: node.text.substring(
            _currentPosition,
            _localHighlightStartIndex,
          ),
          mouseCursor: SystemMouseCursors.text,
        ),
      );
    }
  }

  bool get _nodeBoundRangeIsValid => _nodeBoundStartIndex < _nodeBoundEndIndex;

  void _appendHighlightSpan() {
    final highlightDetailModal = HighlightDetailModal(_highlight);
    _spans.add(
      TextSpan(
        text: node.text.substring(_nodeBoundStartIndex, _nodeBoundEndIndex),
        style: _highlightStyle,
        recognizer: TapGestureRecognizer()
          ..onTap = () => highlightDetailModal.show(context),
      ),
    );
  }

  void _incrementCurrentPosition() {
    _currentPosition = max(_currentPosition, _nodeBoundEndIndex);
  }

  void _appendAnyTrailingUnhighlightedText() {
    if (_currentPosition < node.text.length) {
      _spans.add(
        TextSpan(text: node.text.substring(_currentPosition)),
      );
    }
  }

  RichText _buildTextWidget({required bool withHighlights}) => RichText(
    key: key,
    selectionRegistrar: SelectionContainer.maybeOf(context),
    selectionColor: _selectionColor,
    textScaler: MediaQuery.of(context).textScaler,
    text: TextSpan(
      style: _baseStyle,
      children: withHighlights ? _spans : null,
      text: withHighlights ? null : node.text,
    ),
  );

  Color get _selectionColor {
    return TextSelectionTheme.of(context).selectionColor ??
        DefaultSelectionStyle.of(context).selectionColor!;
  }
}
