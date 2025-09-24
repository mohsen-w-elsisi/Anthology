import 'package:anthology_common/article/entities.dart';
import 'package:anthology_common/article_brief/entities.dart';
import 'package:anthology_ui/app_actions.dart';
import 'package:anthology_ui/screens/reader/reader_screen_settings.dart';
import 'package:anthology_ui/screens/reader/app_bar.dart';
import 'package:anthology_ui/screens/reader/progress_tracker.dart';
import 'package:anthology_ui/screens/reader/reader_view_text_area.dart';
import 'package:anthology_ui/screens/reader/text_node_widget/heading_registry.dart';
import 'package:anthology_ui/state/reader_view_status_notifier.dart';
import 'package:anthology_ui/screens/reader/text_options/controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:get_it/get_it.dart';

import 'highlight/provider.dart';
import 'shortcuts.dart';
import 'text_node_registry.dart';

class ReaderScreen extends StatefulWidget {
  final Article article;
  final ReaderScreenSettings settings;

  const ReaderScreen({
    super.key,
    required this.article,
    required this.settings,
  });

  @override
  State<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends State<ReaderScreen> {
  // TODO: there should be more restrain and flags behind altering global state like this
  final _readerStatusNotifier = GetIt.I<ReaderViewStatusNotifier>();

  @override
  void initState() {
    super.initState();
    if (widget.settings.isModal) {
      _readerStatusNotifier.isReaderModalActive = true;
    }
  }

  @override
  void dispose() {
    if (widget.settings.isModal) {
      _readerStatusNotifier.isReaderModalActive = false;
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        FutureProvider<ArticleBrief?>(
          create: (_) => AppActions.getBrief(widget.article.id),
          initialData: null,
        ),
        Provider(create: (_) => HeadingRegistry()),
        Provider(create: (_) => TextNodeRegistry()),
        ChangeNotifierProvider(
          create: (_) => ReaderProgressTracker(
            widget.article,
            widget.settings.scrollDestination,
          ),
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
      child: Actions(
        actions: {
          AddHighlightIntent: AddHighlightAction(),
          ShowTocIntent: ShowTocModalActions(),
          ShowHighlightsModalIntent: ShowHighlightsModalAction(),
          ShowTextOptionsIntent: ShowTextOptionsModalAction(),
          ScrollUpIntent: ScrollUpAction(),
          ScrollDownIntent: ScrollDownAction(),
        },
        child: PopScope(
          onPopInvokedWithResult: (_, _) {
            GetIt.I<ReaderViewStatusNotifier>().clearActiveArticle();
          },
          child: Scaffold(
            body: Consumer<ArticleBrief?>(
              builder: (context, brief, _) {
                final progressTracker = context.read<ReaderProgressTracker>();
                if (brief != null) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted) _handleScrollDestination(context);
                  });
                }
                return Shortcuts(
                  shortcuts: _shortcuts(context),
                  child: NotificationListener<ScrollNotification>(
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
                          brief: brief,
                        ),
                        Consumer<TextOptionsController>(
                          builder: (_, textOptionsController, _) {
                            if (brief != null &&
                                textOptionsController.isInitialized) {
                              return _textView(brief);
                            } else {
                              return _loadingSpinner;
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  void _handleScrollDestination(BuildContext context) {
    final destination = widget.settings.scrollDestination;
    final progressTracker = context.read<ReaderProgressTracker>();

    switch (destination) {
      case BeginningDestination():
        progressTracker.jumpToBeginning();
        break;
      case ReaderProgressDestination():
        progressTracker.jumpToArticleProgress();
        break;
      case TextNodeDestination():
        final registry = context.read<TextNodeRegistry>();
        registry.scrollTo(destination.index);
        break;
    }
  }

  Map<ShortcutActivator, Intent> _shortcuts(BuildContext context) {
    final brief = context.watch<ArticleBrief?>();
    final progressTracker = context.read<ReaderProgressTracker>();
    return {
      if (brief != null)
        const SingleActivator(
          LogicalKeyboardKey.keyC,
        ): ShowTocIntent(
          brief: brief,
          headingRegistry: context.read<HeadingRegistry>(),
          context: context,
        ),
      const SingleActivator(
        LogicalKeyboardKey.keyH,
        alt: true,
      ): ShowHighlightsModalIntent(
        context: context,
        highlights: context.watch<ReaderScreenHighlightProvider>().highlights,
      ),
      const SingleActivator(
        LogicalKeyboardKey.keyT,
      ): ShowTextOptionsIntent(
        context: context,
        controller: context.read<TextOptionsController>(),
      ),
      SingleActivator(
        LogicalKeyboardKey.arrowUp,
      ): ScrollUpIntent(
        progressTracker: progressTracker,
      ),
      SingleActivator(
        LogicalKeyboardKey.arrowDown,
      ): ScrollDownIntent(
        progressTracker: progressTracker,
      ),
    };
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
