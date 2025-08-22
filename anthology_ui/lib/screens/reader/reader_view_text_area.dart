import 'package:anthology_common/article_brief/entities.dart';
import 'package:flutter/material.dart';

import 'text_node_widget/factory.dart';

class ReaderViewTextArea extends StatelessWidget {
  final ArticleBrief brief;
  final ReaderViewTextOptions textOptions;

  const ReaderViewTextArea({
    required this.brief,
    required this.textOptions,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: _modifyedTextTheme(context),
      child: SelectionArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ..._titleAndByline(context),
            const SizedBox(height: 24.0),
            for (final node in brief.body) TextNodeWidgetFactory(node).widget(),
          ],
        ),
      ),
    );
  }

  ThemeData _modifyedTextTheme(BuildContext context) {
    return Theme.of(context).copyWith(
      textTheme: TextTheme.of(context).apply(
        fontSizeFactor: textOptions.textScaleFactor,
      ),
    );
  }

  List<Widget> _titleAndByline(BuildContext context) => [
    Text(
      brief.title,
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.headlineLarge,
    ),
    const SizedBox(height: 8.0),
    Text(
      brief.byline,
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.bodyLarge,
    ),
  ];
}

class ReaderViewTextOptions {
  final double textScaleFactor;

  const ReaderViewTextOptions({this.textScaleFactor = 1.0});
}
