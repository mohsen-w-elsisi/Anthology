import 'package:anthology_common/article_brief/entities.dart';
import 'package:anthology_ui/screens/reader/text_node_widget/heading_registry.dart';
import 'package:anthology_ui/screens/reader/text_node_widget/text_node_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Heading1NodeWidget extends HeadingNodeWidget {
  const Heading1NodeWidget(super.node, {super.key});

  @override
  TextNodeType get nodeType => TextNodeType.heading1;
}

class Heading2NodeWidget extends HeadingNodeWidget {
  const Heading2NodeWidget(super.node, {super.key});

  @override
  TextNodeType get nodeType => TextNodeType.heading2;
}

class Heading3NodeWidget extends HeadingNodeWidget {
  const Heading3NodeWidget(super.node, {super.key});

  @override
  TextNodeType get nodeType => TextNodeType.heading3;
}

class Heading4NodeWidget extends HeadingNodeWidget {
  const Heading4NodeWidget(super.node, {super.key});

  @override
  TextNodeType get nodeType => TextNodeType.heading4;
}

class Heading5NodeWidget extends HeadingNodeWidget {
  const Heading5NodeWidget(super.node, {super.key});

  @override
  TextNodeType get nodeType => TextNodeType.heading5;
}

class Heading6NodeWidget extends HeadingNodeWidget {
  const Heading6NodeWidget(super.node, {super.key});

  @override
  TextNodeType get nodeType => TextNodeType.heading6;
}

abstract class HeadingNodeWidget extends TextNodeWidget {
  const HeadingNodeWidget(super.node, {super.key});

  @override
  Widget buildNodeWidget(BuildContext context, {Key? key}) {
    final headingKey = context.read<HeadingRegistry>().register(node);
    return super.buildNodeWidget(context, key: headingKey);
  }
}
