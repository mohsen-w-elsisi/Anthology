import 'package:anthology_common/article/entities.dart';
import 'package:anthology_common/article_brief/entities.dart';
import 'package:anthology_common/article_brief/article_brief_fetcher.dart';
import 'package:anthology_ui/screens/reader/app_bar.dart';
import 'package:anthology_ui/screens/reader/reader_view_text_area.dart';
import 'package:anthology_ui/screens/reader/text_node_widget/heading_registry.dart';
import 'package:anthology_ui/state/reader_view_status_notifier.dart';
import 'package:anthology_ui/screens/reader/text_options/controller.dart';
import 'package:anthology_ui/data/article_brief_cache.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get_it/get_it.dart';

import 'highlight/provider.dart';

class ReaderScreen extends StatefulWidget {
  final Article article;
  final bool isModal;

  const ReaderScreen(this.article, {super.key, this.isModal = false});

  @override
  State<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends State<ReaderScreen> {
  final _textOptionsController = TextOptionsController.inital();
  // TODO: there should be more restrain and flags behind altering global state like this
  final _readerStatusNotifier = GetIt.I<ReaderViewStatusNotifier>();

  @override
  void initState() {
    super.initState();
    if (widget.isModal) _readerStatusNotifier.isReaderModalActive = true;
  }

  @override
  void dispose() {
    if (widget.isModal) _readerStatusNotifier.isReaderModalActive = false;
    _textOptionsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => HeadingRegistry()),
        Provider(
          create: (_) {
            return ReaderScreenHighlightProvider(widget.article.id)
              ..initHighlights();
          },
        ),
      ],
      child: Scaffold(
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
      ),
    );
  }

  Widget _textView(ArticleBrief brief) => SliverPadding(
    padding: const EdgeInsets.symmetric(horizontal: 20.0),
    sliver: SliverToBoxAdapter(
      child: Consumer<ReaderScreenHighlightProvider>(
        builder: (_, highlightProvider, _) => ListenableBuilder(
          listenable: Listenable.merge([
            _textOptionsController,
            highlightProvider.initListenable,
          ]),
          builder: (_, __) {
            return ReaderViewTextArea(
              brief: brief,
              textOptions: _textOptionsController.options,
            );
          },
        ),
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
