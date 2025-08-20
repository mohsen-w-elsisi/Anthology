import 'package:anthology_common/article_brief/entities.dart';
import 'package:flutter/material.dart';

class NodeStyleExtractor {
  final TextTheme textTheme;

  NodeStyleExtractor(this.textTheme);

  TextStyle styleFor(TextNodeType type) => _nodeStylesMap[type]!;

  Map<TextNodeType, TextStyle> get _nodeStylesMap => {
    TextNodeType.heading1: textTheme.headlineLarge!,
    TextNodeType.heading2: textTheme.headlineMedium!,
    TextNodeType.heading3: textTheme.headlineSmall!,
    TextNodeType.heading4: textTheme.titleLarge!,
    TextNodeType.heading5: textTheme.titleMedium!,
    TextNodeType.heading6: textTheme.titleSmall!,
    TextNodeType.body: textTheme.bodyMedium!,
  };
}
