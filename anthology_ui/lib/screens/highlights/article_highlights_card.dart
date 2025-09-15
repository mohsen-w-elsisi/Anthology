import 'package:anthology_common/article/entities.dart';
import 'package:anthology_common/highlight/entities.dart';
import 'package:anthology_ui/screens/reader/reader_screen.dart';
import 'package:anthology_ui/utils.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

import 'show_highlights_button.dart';
import 'highlights_list.dart';

class ArticleHighlightsCard extends StatefulWidget {
  final String articleTitle;
  final Article article;
  final List<Highlight> highlights;

  const ArticleHighlightsCard({
    required this.articleTitle,
    required this.article,
    required this.highlights,
    super.key,
  });

  @override
  State<ArticleHighlightsCard> createState() => _ArticleHighlightsCardState();
}

class _ArticleHighlightsCardState extends State<ArticleHighlightsCard> {
  final _isExpanded = ValueNotifier<bool>(false);

  @override
  void dispose() {
    _isExpanded.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.hardEdge,
      child: Column(
        children: [
          ListTile(
            onTap: _toggleExpanded,
            enableFeedback: false,
            splashColor: Colors.transparent,
            title: _articleTitleText,
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: _subtitleText,
                ),
              ],
            ),
            trailing: _expansionIcom(),
          ),
          HighlightsList(
            highlights: widget.highlights,
            isExpanded: _isExpanded,
          ),
        ],
      ),
    );
  }

  Widget _expansionIcom() => ValueListenableBuilder(
    valueListenable: _isExpanded,
    builder: (_, isExpanded, _) {
      return Transform.scale(
        scale: 1.5,
        child: AnimatedExpandIcon(isExpanded: isExpanded),
      );
    },
  );

  void _toggleExpanded() => _isExpanded.value = !_isExpanded.value;

  Widget get _articleTitleText => Text(
    widget.articleTitle,
    maxLines: 2,
    overflow: TextOverflow.ellipsis,
    style: isExpanded(context)
        ? TextTheme.of(context).headlineSmall
        : TextTheme.of(context).titleMedium,
  );

  Widget get _subtitleText => Wrap(
    runSpacing: 8.0,
    crossAxisAlignment: WrapCrossAlignment.center,
    children: [
      Text("${widget.highlights.length} highlights"),
      Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton.icon(
            onPressed: _openFullArticle,
            icon: const Icon(Icons.open_in_new_outlined),
            label: const Text("View article"),
          ),
          TextButton.icon(
            onPressed: _copyHighlightsToClipboard,
            icon: const Icon(Icons.copy_all_outlined),
            label: const Text("Copy all"),
          ),
        ],
      ),
    ],
  );

  void _openFullArticle() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => ReaderScreen(widget.article)));
  }

  void _copyHighlightsToClipboard() {
    final buffer = StringBuffer();
    for (final highlight in widget.highlights) {
      buffer.writeln('"${highlight.text}"');
      if (highlight.comment?.isNotEmpty ?? false) {
        buffer.writeln('Comment: ${highlight.comment}');
      }
      buffer.writeln();
    }
    if (buffer.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: buffer.toString().trim()));
      ScaffoldMessenger.maybeOf(context)?.showSnackBar(
        const SnackBar(content: Text('Highlights copied to clipboard.')),
      );
    }
  }
}
