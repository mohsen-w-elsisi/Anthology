import 'package:anthology_common/article_brief/entities.dart';
import 'package:anthology_ui/screens/reader/text_node_widget/heading_registry.dart';
import 'package:anthology_ui/screens/reader/toc_generator.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class TocModal extends StatelessWidget {
  final ArticleBrief brief;

  const TocModal({super.key, required this.brief});

  void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Contents', style: TextTheme.of(context).headlineLarge),
          const SizedBox(height: 16.0),
          _Table(toc: _toc),
        ],
      ),
    );
  }

  Toc get _toc => TocGenerator(brief).generate();
}

class _Table extends StatelessWidget {
  final Toc toc;

  const _Table({required this.toc});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [for (final tocNode in toc) _TocNodeButton(tocNode)],
    );
  }
}

class _TocNodeButton extends StatelessWidget {
  static const _levelIndent = 22.0;
  static const _nodeVerticalPadding = 12.0;

  final TocNode tocNode;

  const _TocNodeButton(this.tocNode);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => _scrollToHeading(context),
      style: TextButton.styleFrom(
        textStyle: TextStyle(fontSize: _largerFontSize(context)),
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(
          left: _leftIndent,
          top: _nodeVerticalPadding,
          bottom: _nodeVerticalPadding,
        ),
      ),
      child: Text(tocNode.title),
    );
  }

  double get _leftIndent => (tocNode.level - 1) * _levelIndent;

  double? _largerFontSize(BuildContext context) =>
      TextTheme.of(context).bodyLarge!.fontSize;

  void _scrollToHeading(BuildContext context) {
    Navigator.of(context).pop();
    Scrollable.ensureVisible(
      GetIt.I<HeadingRegistry>().keyFor(tocNode.node).currentContext!,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutQuad,
    );
  }
}
