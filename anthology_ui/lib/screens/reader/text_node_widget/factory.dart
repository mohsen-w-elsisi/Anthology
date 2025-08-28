import 'package:anthology_common/article_brief/entities.dart';
import 'package:anthology_ui/screens/reader/text_node_widget/heading_impls.dart';
import 'package:flutter/material.dart';

import 'impls.dart';

class TextNodeWidgetFactory {
  final TextNode node;

  const TextNodeWidgetFactory(this.node);

  Widget widget() {
    switch (node.type) {
      case TextNodeType.heading1:
        return Heading1NodeWidget(node);
      case TextNodeType.heading2:
        return Heading2NodeWidget(node);
      case TextNodeType.heading3:
        return Heading3NodeWidget(node);
      case TextNodeType.heading4:
        return Heading4NodeWidget(node);
      case TextNodeType.heading5:
        return Heading5NodeWidget(node);
      case TextNodeType.heading6:
        return Heading6NodeWidget(node);
      case TextNodeType.body:
        return BodyTextNodeWidget(node);
      case TextNodeType.orderedList:
        return OrderedListTextNodeWidget(node);
      case TextNodeType.unorderedList:
        return UnorderedListTextNodeWidget(node);
    }
  }
}
