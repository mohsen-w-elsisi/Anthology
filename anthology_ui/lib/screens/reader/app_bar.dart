import 'package:anthology_common/article/entities.dart';
import 'package:anthology_ui/screens/reader/text_options_controller.dart';
import 'package:flutter/material.dart';

import 'text_options_modal.dart';

class ReaderScreenAppBar extends StatelessWidget {
  final Article article;

  final TextOptionsController textOptionsNotifier;

  const ReaderScreenAppBar(
    this.article, {
    super.key,
    required this.textOptionsNotifier,
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
      IconButton(onPressed: () {}, icon: Icon(Icons.border_color_outlined)),
      IconButton(onPressed: () {}, icon: Icon(Icons.toc_outlined)),
      IconButton(onPressed: () {}, icon: Icon(Icons.headphones_outlined)),
      IconButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (_) => TextOptionsModal(textOptionsNotifier),
          );
        },
        icon: Icon(Icons.format_color_text_outlined),
      ),
    ];
  }
}
