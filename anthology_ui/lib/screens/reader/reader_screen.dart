import 'dart:convert';

import 'package:anthology_common/article/entities.dart';
import 'package:anthology_common/article_brief/entities.dart';
import 'package:anthology_common/server_request_interface.dart';
import 'package:flutter/material.dart';

class ReaderScreen extends StatelessWidget {
  final Article article;

  const ReaderScreen(this.article, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            actions: _actionButtons(context),
            floating: true,
          ),
          FutureBuilder(
            future: _getBrief(),
            builder: (_, snapshot) {
              if (snapshot.hasData) {
                return SliverPadding(
                  padding: EdgeInsetsGeometry.symmetric(horizontal: 20.0),
                  sliver: SliverList.list(
                    children: [
                      for (final node in snapshot.data!.body) Text(node.text),
                    ],
                  ),
                );
              } else {
                return SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                );
              }
            },
          ),
        ],
      ),
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
