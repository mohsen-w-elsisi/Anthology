import 'package:anthology_common/article/entities.dart';
import 'package:anthology_common/article_brief/entities.dart';
import 'package:anthology_ui/app_actions.dart';
import 'package:anthology_ui/screens/reader/app_bar.dart';
import 'package:anthology_ui/screens/reader/reader_provider.dart';
import 'package:anthology_ui/screens/reader/reader_view_text_area.dart';
import 'package:anthology_ui/screens/reader/text_node_widget/heading_registry.dart';
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

  @override
  void initState() {
    super.initState();
    if (widget.isModal) _readerStatusNotifier.isReaderModalActive = true;
  }

  @override
  void dispose() {
    if (widget.isModal) _readerStatusNotifier.isReaderModalActive = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => HeadingRegistry()),
        ChangeNotifierProvider(
          create: (_) => ReaderProgressTracker(widget.article),
        ),
        ChangeNotifierProvider(
          create: (_) => TextOptionsController()..init(),
        ),
        ChangeNotifierProvider(
          create: (_) {
            return ReaderScreenHighlightProvider(widget.article.id)..init();
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
            builder: (context, snapshot) {
              final progressTracker = context.read<ReaderProgressTracker>();
              if (snapshot.hasData) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted) {
                    progressTracker.jumpToArticleProgress();
                  }
                });
              }
              return NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  if (notification is ScrollEndNotification) {
                    progressTracker.updateProgress();
                  }
                  return false;
                },
                child: CustomScrollView(
                  controller: progressTracker.scrollController,
                  slivers: [
                    ReaderScreenAppBar(
                      widget.article,
                      brief: snapshot.data,
                    ),
                    Consumer<TextOptionsController>(
                      builder: (_, textOptionsController, _) {
                        if (snapshot.hasData &&
                            textOptionsController.isInitialized) {
                          return _textView(snapshot.data!);
                        } else {
                          return _loadingSpinner;
                        }
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
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
