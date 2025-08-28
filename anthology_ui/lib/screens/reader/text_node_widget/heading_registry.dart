import 'package:anthology_common/article_brief/entities.dart';
import 'package:flutter/material.dart';

class HeadingRegistry {
  final Map<int, GlobalKey> _registry = {};

  GlobalKey register(TextNode node) {
    final key = GlobalKey();
    _registry[node.hashCode] = key;
    return key;
  }

  GlobalKey keyFor(TextNode node) {
    final key = _registry[node.hashCode];
    if (key == null) throw HeadingNotRegisteredError(node);
    return key;
  }
}

class HeadingNotRegisteredError extends Error {
  final TextNode node;

  HeadingNotRegisteredError(this.node);

  @override
  String toString() => "Heading node not registered: '${node.text}'";
}
