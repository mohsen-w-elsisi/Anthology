import 'package:anthology_common/article_brief/entities.dart';
import 'package:anthology_ui/screens/reader/toc_generator.dart';
import 'package:flutter/material.dart';

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
  static const _levelIndent = 22.0;
  static const _nodeVerticalPadding = 12.0;

  final Toc toc;

  const _Table({required this.toc});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [for (final tocNode in toc) _nodeButotn(context, tocNode)],
    );
  }

  Widget _nodeButotn(BuildContext context, TocNode tocNode) {
    return TextButton(
      onPressed: () {},
      style: TextButton.styleFrom(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(
          left: (tocNode.level - 1) * _levelIndent,
          top: _nodeVerticalPadding,
          bottom: _nodeVerticalPadding,
        ),
        textStyle: TextStyle(
          fontSize: TextTheme.of(context).bodyLarge!.fontSize,
        ),
      ),
      child: Text(tocNode.title),
    );
  }
}
