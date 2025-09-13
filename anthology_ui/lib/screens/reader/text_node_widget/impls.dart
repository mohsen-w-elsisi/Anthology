import 'package:anthology_common/article_brief/entities.dart';
import 'package:flutter/material.dart';
import 'text_node_widget.dart';

class BodyTextNodeWidget extends TextNodeWidget {
  const BodyTextNodeWidget(super.node, {super.key});

  @override
  TextNodeType get nodeType => TextNodeType.body;
}

class OrderedListTextNodeWidget extends ListTextNodeWidget {
  const OrderedListTextNodeWidget(super.node, {super.key});

  @override
  TextNodeType get nodeType => TextNodeType.orderedList;
}

class UnorderedListTextNodeWidget extends ListTextNodeWidget {
  const UnorderedListTextNodeWidget(super.node, {super.key});

  @override
  TextNodeType get nodeType => TextNodeType.unorderedList;
}

abstract class ListTextNodeWidget extends TextNodeWidget {
  const ListTextNodeWidget(super.node, {super.key});
}

class ImageTextNodeWidget extends TextNodeWidget {
  const ImageTextNodeWidget(super.node, {super.key});

  @override
  Widget buildNodeWidget(BuildContext context, {Key? key}) {
    return node.data != null
        ? Image.network(
            node.data!,
            errorBuilder: (_, _, _) => const SizedBox.shrink(),
          )
        : const SizedBox.shrink();
  }

  @override
  TextNodeType get nodeType => TextNodeType.image;
}
