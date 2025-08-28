import 'dart:convert';

import 'package:anthology_common/article/entities.dart';
import 'package:anthology_common/article_brief/entities.dart';
import 'package:anthology_common/server_request_interface.dart';
import 'package:anthology_ui/screens/reader/app_bar.dart';
import 'package:anthology_ui/screens/reader/reader_view_text_area.dart';
import 'package:anthology_ui/screens/reader/text_node_widget/heading_registry.dart';
import 'package:anthology_ui/screens/reader/text_options_controller.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class ReaderScreen extends StatefulWidget {
  final Article article;

  const ReaderScreen(this.article, {super.key});

  @override
  State<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends State<ReaderScreen> {
  final _textOptionsController = TextOptionsController.inital();

  @override
  void initState() {
    super.initState();
    GetIt.I.registerSingleton(HeadingRegistry());
  }

  @override
  void dispose() {
    GetIt.I.unregister<HeadingRegistry>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _getBrief(),
        builder: (_, snapshot) => CustomScrollView(
          slivers: [
            ReaderScreenAppBar(
              widget.article,
              brief: snapshot.data,
              textOptionsNotifier: _textOptionsController,
            ),
            snapshot.hasData ? _textView(snapshot.data!) : _locadingSpinner,
          ],
        ),
      ),
    );
  }

  Widget _textView(ArticleBrief brief) => SliverPadding(
    padding: EdgeInsetsGeometry.symmetric(horizontal: 20.0),
    sliver: SliverToBoxAdapter(
      child: ListenableBuilder(
        listenable: _textOptionsController,
        builder: (_, _) {
          return ReaderViewTextArea(
            brief: brief,
            textOptions: _textOptionsController.options,
          );
        },
      ),
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
    ).getArticleBrief(widget.article.id);
    return ArticleBrief.fromJson(jsonDecode(res.body));
  }
}
