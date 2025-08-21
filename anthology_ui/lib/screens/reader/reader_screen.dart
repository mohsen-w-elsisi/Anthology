import 'dart:convert';

import 'package:anthology_common/article/entities.dart';
import 'package:anthology_common/article_brief/entities.dart';
import 'package:anthology_common/server_request_interface.dart';
import 'package:flutter/material.dart';

import 'text_node_widget/factory.dart';

class ReaderScreen extends StatelessWidget {
  final Article article;

  const ReaderScreen(this.article, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _AppBar(article),
          FutureBuilder(
            future: _getBrief(),
            builder: (_, snapshot) =>
                snapshot.hasData ? _textView(snapshot.data!) : _locadingSpinner,
          ),
        ],
      ),
    );
  }

  Widget _textView(ArticleBrief brief) => SliverPadding(
    padding: EdgeInsetsGeometry.symmetric(horizontal: 20.0),
    sliver: SliverToBoxAdapter(
      child: ReaderViewTextArea(brief),
    ),
  );

  Widget get _locadingSpinner => SliverFillRemaining(
    child: Center(child: CircularProgressIndicator()),
  );

  Future<ArticleBrief> _getBrief() async {
    final res = await ServerRequestInterface(
      Uri(
        scheme: 'http',
        host: 'localhost',
        port: 3000,
      ),
    ).getArticleBrief(article.id);
    return ArticleBrief.fromJson(jsonDecode(res.body));
  }
}

class _AppBar extends StatelessWidget {
  final Article article;

  const _AppBar(this.article);

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
        onPressed: () {},
        icon: Icon(Icons.format_color_text_outlined),
      ),
    ];
  }
}

class ReaderViewTextArea extends StatelessWidget {
  final ArticleBrief brief;

  const ReaderViewTextArea(this.brief, {super.key});

  @override
  Widget build(BuildContext context) {
    return SelectionArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ..._titleAndByline(context),
          const SizedBox(height: 24.0),
          for (final node in brief.body) TextNodeWidgetFactory(node).widget(),
        ],
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
