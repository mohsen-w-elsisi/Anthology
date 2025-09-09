import 'package:anthology_common/article/entities.dart';
import 'package:anthology_common/article_brief/entities.dart';
import 'package:anthology_ui/screens/reader/highlight/modal.dart';
import 'package:anthology_ui/screens/reader/highlight/provider.dart';
import 'package:anthology_ui/screens/reader/text_node_widget/heading_registry.dart';
import 'package:anthology_ui/screens/reader/text_options/controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'text_options/modal.dart';
import 'toc/modal.dart';

class ReaderScreenAppBar extends StatelessWidget {
  final Article article;
  final ArticleBrief? brief;

  const ReaderScreenAppBar(
    this.article, {
    super.key,
    this.brief,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      floating: true,
      actions: _actionButtons(context),
    );
  }

  List<Widget> _actionButtons(BuildContext context) {
    return [
      IconButton(
        onPressed: () => _showHighlightsModal(context),
        icon: Icon(Icons.border_color_outlined),
      ),
      IconButton(
        onPressed: brief != null ? () => _showTocModal(context) : null,
        icon: Icon(Icons.toc_outlined),
      ),
      IconButton(
        onPressed: () {},
        icon: Icon(Icons.headphones_outlined),
      ),
      IconButton(
        onPressed: () => _showTextOptionsModal(context),
        icon: Icon(Icons.format_color_text_outlined),
      ),
    ];
  }

  void _showTextOptionsModal(BuildContext context) {
    TextOptionsModal(
      context.read<TextOptionsController>(),
    ).show(context);
  }

  void _showHighlightsModal(BuildContext context) {
    HighlightsModal(
      highlights: context.read<ReaderScreenHighlightProvider>().highlights,
    ).show(context);
  }

  void _showTocModal(BuildContext context) => TocModal(
    brief: brief!,
    headingRegistry: context.read<HeadingRegistry>(),
  ).show(context);
}
