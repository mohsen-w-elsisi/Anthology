import 'package:anthology_common/article_brief/entities.dart';

class TocGenerator {
  static const _headerTextNodeTypes = {
    TextNodeType.heading1,
    TextNodeType.heading2,
    TextNodeType.heading3,
    TextNodeType.heading4,
    TextNodeType.heading5,
    TextNodeType.heading6,
  };

  List<TextNode> _textNodes;
  final Toc _toc = [];

  TocGenerator(ArticleBrief brief) : _textNodes = brief.body;

  Toc generate() {
    _removeNonHeaderTextNodes();
    _mapTextNodesToTocNodes();
    return List.unmodifiable(_toc);
  }

  void _removeNonHeaderTextNodes() {
    _textNodes = [
      for (final node in _textNodes)
        if (_headerTextNodeTypes.contains(node.type)) node,
    ];
  }

  void _mapTextNodesToTocNodes() {
    for (var i = 0; i < _textNodes.length; i++) {
      final textNode = _textNodes[i];
      final tocNode = TocNode.fromTextNode(textNode, i);
      _toc.add(tocNode);
    }
  }
}

typedef Toc = List<TocNode>;

class TocNode {
  final String title;
  final int level;
  final int index;

  const TocNode({
    required this.title,
    required this.level,
    required this.index,
  });

  TocNode.fromTextNode(TextNode node, this.index)
    : title = node.text,
      level = node.type.index - TextNodeType.heading1.index + 1;
}
