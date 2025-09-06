import 'package:anthology_common/article/entities.dart';
import 'package:anthology_common/article_brief/entities.dart';
import 'package:anthology_common/article_brief/article_brief_fetcher.dart';
import 'package:anthology_ui/screens/reader/app_bar.dart';
import 'package:anthology_ui/screens/reader/reader_view_text_area.dart';
import 'package:anthology_ui/screens/reader/text_node_widget/heading_registry.dart';
import 'package:anthology_ui/screens/reader/text_options/controller.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../data/article_brief_cache.dart';
import 'highlight/provider.dart';

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
    final highlightProvider = ReaderScreenHighlightProvider(widget.article.id);
    highlightProvider.initHighlights();
    GetIt.I.registerSingleton(highlightProvider);
  }

  @override
  void dispose() {
    GetIt.I.unregister<HeadingRegistry>();
    GetIt.I.unregister<ReaderScreenHighlightProvider>();
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
            snapshot.hasData ? _textView(snapshot.data!) : _loadingSpinner,
          ],
        ),
      ),
    );
  }

  Widget _textView(ArticleBrief brief) => SliverPadding(
    padding: EdgeInsetsGeometry.symmetric(horizontal: 20.0),
    sliver: SliverToBoxAdapter(
      child: ListenableBuilder(
        listenable: Listenable.merge([
          _textOptionsController,
          GetIt.I<ReaderScreenHighlightProvider>().initListenable,
        ]),
        builder: (_, _) {
          return ReaderViewTextArea(
            brief: brief,
            textOptions: _textOptionsController.options,
          );
        },
      ),
    ),
  );

  Widget get _loadingSpinner => SliverFillRemaining(
    child: Center(child: CircularProgressIndicator()),
  );

  Future<ArticleBrief> _getBrief() async {
    final articleBriefCache = GetIt.I<ArticleBriefCache>();
    if (await articleBriefCache.isCached(widget.article.id)) {
      return articleBriefCache.get(widget.article.id);
    } else {
      final articleBrief = await ArticleBriefFetcher(
        widget.article.id,
      ).fetchBrief();
      articleBriefCache.cache(widget.article.id, articleBrief);
      return articleBrief;
    }
  }
}
