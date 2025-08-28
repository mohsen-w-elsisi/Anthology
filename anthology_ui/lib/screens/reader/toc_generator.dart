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
    for (final textNode in _textNodes) {
      final tocNode = TocNode.fromTextNode(textNode);
      _toc.add(tocNode);
    }
  }
}

typedef Toc = List<TocNode>;

class TocNode {
  final TextNode node;
  final String title;
  final int level;

  const TocNode({
    required this.node,
    required this.title,
    required this.level,
  });

  TocNode.fromTextNode(this.node)
    : title = node.text,
      level = node.type.index - TextNodeType.heading1.index + 1;
}
