import 'package:anthology_common/article_brief/entities.dart';
import 'package:anthology_common/highlight/entities.dart';
import 'package:anthology_ui/app_actions.dart';
import 'package:anthology_ui/screens/reader/highlight/modal.dart';
import 'package:anthology_ui/screens/reader/text_options/controller.dart';
import 'package:anthology_ui/screens/reader/progress_tracker.dart';
import 'package:anthology_ui/screens/reader/text_options/modal.dart';
import 'package:flutter/material.dart';

import 'highlight/highlight_factory.dart';
import 'text_node_widget/heading_registry.dart';
import 'toc/modal.dart';

class AddHighlightAction extends Action<AddHighlightIntent> {
  @override
  void invoke(covariant AddHighlightIntent intent) {
    ContextMenuController.removeAny();
    final highlight = HighlightFactory(
      textSelection: intent.selectedText,
      brief: intent.brief,
    ).create();
    AppActions.saveHighlight(highlight);
  }
}

class ShowTocModalActions extends Action<ShowTocIntent> {
  @override
  void invoke(covariant ShowTocIntent intent) {
    TocModal(
      brief: intent.brief,
      headingRegistry: intent.headingRegistry,
    ).show();
  }
}

class ShowHighlightsModalAction extends Action<ShowHighlightsModalIntent> {
  @override
  void invoke(covariant ShowHighlightsModalIntent intent) {
    HighlightsModal(highlights: intent.highlights).show();
  }
}

class ShowTextOptionsModalAction extends Action<ShowTextOptionsIntent> {
  @override
  void invoke(covariant ShowTextOptionsIntent intent) {
    if (intent.controller.isInitialized) {
      TextOptionsModal(intent.controller).show();
    }
  }
}

class ScrollUpAction extends Action<ScrollUpIntent> {
  @override
  void invoke(covariant ScrollUpIntent intent) {
    intent.progressTracker.scrollUp();
  }
}

class ScrollDownAction extends Action<ScrollDownIntent> {
  @override
  void invoke(covariant ScrollDownIntent intent) {
    intent.progressTracker.scrollDown();
  }
}

class AddHighlightIntent extends Intent {
  final String selectedText;
  final ArticleBrief brief;

  const AddHighlightIntent({required this.selectedText, required this.brief});
}

class ScrollUpIntent extends Intent {
  final ReaderProgressTracker progressTracker;

  const ScrollUpIntent({required this.progressTracker});
}

class ScrollDownIntent extends Intent {
  final ReaderProgressTracker progressTracker;

  const ScrollDownIntent({required this.progressTracker});
}

class ShowTocIntent extends Intent {
  final ArticleBrief brief;
  final HeadingRegistry headingRegistry;
  final BuildContext context;

  const ShowTocIntent({
    required this.brief,
    required this.headingRegistry,
    required this.context,
  });
}

class ShowHighlightsModalIntent extends Intent {
  final BuildContext context;
  final List<Highlight> highlights;

  const ShowHighlightsModalIntent({
    required this.context,
    required this.highlights,
  });
}

class ShowTextOptionsIntent extends Intent {
  final BuildContext context;
  final TextOptionsController controller;

  const ShowTextOptionsIntent({
    required this.context,
    required this.controller,
  });
}
