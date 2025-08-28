import 'package:anthology_common/article_brief/entities.dart';
import 'package:flutter/material.dart';

import 'text_node_widget.dart';

class BodyTextNodeWidget extends TextNodeWidget {
  const BodyTextNodeWidget(super.node, {super.key});

  @override
  TextNodeType get nodeType => TextNodeType.body;
}

class OrderedListTextNodeWidget extends TextNodeWidget {
  const OrderedListTextNodeWidget(super.node, {super.key});

  @override
  TextNodeType get nodeType => TextNodeType.orderedList;

  @override
  Widget buildNodeWidget(BuildContext context, {Key? key}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [for (final item in _listItems()) Text(item)],
    );
  }

  List<String> _listItems() {
    return node.text.split('\n').where((item) => item.isNotEmpty).toList();
  }
}

class UnorderedListTextNodeWidget extends TextNodeWidget {
  const UnorderedListTextNodeWidget(super.node, {super.key});

  @override
  TextNodeType get nodeType => TextNodeType.unorderedList;

  @override
  Widget buildNodeWidget(BuildContext context, {Key? key}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [for (final item in _listItems()) Text(item)],
    );
  }

  List<String> _listItems() {
    return node.text.split('\n').where((item) => item.isNotEmpty).toList();
  }
}
