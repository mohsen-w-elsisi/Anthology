import 'package:anthology_common/article_brief/entities.dart';

class TextNodeIndiciesAssigner {
  final List<TextNode> unindexedNodes;
  final List<TextNode> indexedNodes = [];

  int _currentIndex = 0;

  TextNodeIndiciesAssigner(this.unindexedNodes);

  List<TextNode> assignIndicies() {
    unindexedNodes.forEach(_assignIndexAndStepThrough);
    return indexedNodes;
  }

  void _assignIndexAndStepThrough(TextNode node) {
    final startIndex = _currentIndex;
    final endIndex = startIndex + node.text.length;
    indexedNodes.add(
      TextNode(
        text: node.text,
        type: node.type,
        startIndex: startIndex,
        endIndex: endIndex,
        data: node.data,
      ),
    );
    _currentIndex = endIndex;
  }
}
