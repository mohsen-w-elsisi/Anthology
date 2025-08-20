import 'package:anthology_common/article_brief/entities.dart';
import 'package:flutter/material.dart';

import 'text_node_widget.dart';

class BodyTextNodeWidget extends TextNodeWidget {
  const BodyTextNodeWidget(super.node, {super.key});

  @override
  TextNodeType get nodeType => TextNodeType.body;
}

class Heading1NodeWidget extends TextNodeWidget {
  const Heading1NodeWidget(super.node, {super.key});

  @override
  TextNodeType get nodeType => TextNodeType.heading1;
}

class Heading2NodeWidget extends TextNodeWidget {
  const Heading2NodeWidget(super.node, {super.key});

  @override
  TextNodeType get nodeType => TextNodeType.heading2;
}

class Heading3NodeWidget extends TextNodeWidget {
  const Heading3NodeWidget(super.node, {super.key});

  @override
  TextNodeType get nodeType => TextNodeType.heading3;
}

class Heading4NodeWidget extends TextNodeWidget {
  const Heading4NodeWidget(super.node, {super.key});

  @override
  TextNodeType get nodeType => TextNodeType.heading4;
}

class Heading5NodeWidget extends TextNodeWidget {
  const Heading5NodeWidget(super.node, {super.key});

  @override
  TextNodeType get nodeType => TextNodeType.heading5;
}

class Heading6NodeWidget extends TextNodeWidget {
  const Heading6NodeWidget(super.node, {super.key});

  @override
  TextNodeType get nodeType => TextNodeType.heading6;
}

class OrderedListTextNodeWidget extends TextNodeWidget {
  const OrderedListTextNodeWidget(super.node, {super.key});

  @override
  TextNodeType get nodeType => TextNodeType.orderedList;

  @override
  Widget buildNodeWidget(BuildContext context) {
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
  Widget buildNodeWidget(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [for (final item in _listItems()) Text(item)],
    );
  }

  List<String> _listItems() {
    return node.text.split('\n').where((item) => item.isNotEmpty).toList();
  }
}
