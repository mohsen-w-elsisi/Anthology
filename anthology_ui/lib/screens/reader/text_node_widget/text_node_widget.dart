import 'package:anthology_common/article_brief/entities.dart';
import 'package:flutter/material.dart';

import 'node_style_extractor.dart';

abstract class TextNodeWidget extends StatelessWidget {
  final TextNode node;

  const TextNodeWidget(this.node, {super.key});

  TextNodeType get nodeType;

  Widget buildNodeWidget(BuildContext context, {Key? key}) {
    final textTheme = Theme.of(context).textTheme;
    final style = NodeStyleExtractor(textTheme).styleFor(node.type);
    return Text(node.text, style: style, key: key);
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
