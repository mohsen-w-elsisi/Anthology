import 'package:anthology_common/article_brief/entities.dart';
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
