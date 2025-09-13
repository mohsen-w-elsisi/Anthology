import 'package:anthology_common/article/entities.dart';
import 'package:anthology_common/article_brief/entities.dart';
import 'package:anthology_ui/app_actions.dart';
import 'package:anthology_ui/screens/reader/app_bar.dart';
import 'package:anthology_ui/screens/reader/reader_view_text_area.dart';
import 'package:anthology_ui/screens/reader/text_node_widget/heading_registry.dart';
import 'package:anthology_ui/screens/reader/text_options/shared_preferences_initer.dart';
import 'package:anthology_ui/state/reader_view_status_notifier.dart';
import 'package:anthology_ui/screens/reader/text_options/controller.dart';
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
  // TODO: there should be more restrain and flags behind altering global state like this
  final _readerStatusNotifier = GetIt.I<ReaderViewStatusNotifier>();

  late final ScrollController _scrollController;
  TextOptionsController? _textOptionsController;

  @override
  void initState() {
    super.initState();
    if (widget.isModal) _readerStatusNotifier.isReaderModalActive = true;
    _scrollController = ScrollController();
    _loadTextOptionsController();
  }

  void _loadTextOptionsController() async {
    final controller = await TextOptionsPersistence().loadController();
    if (mounted) {
      setState(() {
        _textOptionsController = controller;
      });
    }
  }

  @override
  void dispose() {
    if (widget.isModal) _readerStatusNotifier.isReaderModalActive = false;
    _scrollController.dispose();
    _textOptionsController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_textOptionsController == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: _textOptionsController!),
        Provider(create: (_) => HeadingRegistry()),
        ChangeNotifierProvider(
          create: (_) {
            return ReaderScreenHighlightProvider(widget.article.id)
              ..initHighlights();
          },
        ),
      ],
      child: PopScope(
        onPopInvokedWithResult: (_, _) {
          GetIt.I<ReaderViewStatusNotifier>().clearActiveArticle();
        },
        child: Scaffold(
          body: FutureBuilder(
            future: AppActions.getBrief(widget.article.id),
            builder: (_, snapshot) {
              if (snapshot.hasData) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _jumpToArticleProgress();
                });
              }
              return NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  if (notification is ScrollEndNotification) {
                    if (_scrollController.hasClients) {
                      _updateProgress();
                    }
                  }
                  return false;
                },
                child: CustomScrollView(
                  controller: _scrollController,
                  slivers: [
                    ReaderScreenAppBar(
                      widget.article,
                      brief: snapshot.data,
                    ),
                    snapshot.hasData
                        ? _textView(snapshot.data!)
                        : _loadingSpinner,
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _jumpToArticleProgress() {
    if (mounted &&
        _scrollController.hasClients &&
        widget.article.progress > 0) {
      final maxScroll = _scrollController.position.maxScrollExtent;
      final offset = maxScroll * widget.article.progress;
      _scrollController.jumpTo(offset);
    }
  }

  void _updateProgress() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    late final double progress;
    if (maxScroll > 0) {
      progress = (_scrollController.position.pixels / maxScroll).clamp(0, 1);
    } else {
      progress = 0.0;
    }
    AppActions.updateArticleProgress(widget.article.id, progress);
  }

  Widget _textView(ArticleBrief brief) => SliverPadding(
    padding: const EdgeInsets.symmetric(horizontal: 20.0),
    sliver: SliverToBoxAdapter(
      child: Consumer<TextOptionsController>(
        builder: (_, textOptionsController, _) {
          return ReaderViewTextArea(
            brief: brief,
            textOptions: textOptionsController.options,
            key: UniqueKey(),
          );
        },
      ),
    ),
  );

  Widget get _loadingSpinner => const SliverFillRemaining(
    child: Center(child: CircularProgressIndicator()),
  );
}
