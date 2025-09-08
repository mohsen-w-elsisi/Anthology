import 'package:anthology_common/article/entities.dart';
import 'package:anthology_common/highlight/entities.dart';
import 'package:anthology_ui/screens/reader/reader_screen.dart';
import 'package:anthology_ui/utils.dart';
import 'package:flutter/gestures.dart';
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

  Widget get _subtitleText => RichText(
    maxLines: 1,
    textScaler: TextScaler.linear(1.4),
    text: TextSpan(
      style: TextTheme.of(context).titleMedium,
      children: [
        TextSpan(text: "${widget.highlights.length} highlights"),
        const TextSpan(text: " • "),
        TextSpan(
          text: "full article",
          recognizer: _fullArticleGestureRecogniser,
          style: TextStyle(decoration: TextDecoration.underline),
          mouseCursor: SystemMouseCursors.click,
        ),
      ],
    ),
  );

  TapGestureRecognizer get _fullArticleGestureRecogniser {
    return TapGestureRecognizer()
      ..onTap = () {
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => ReaderScreen(widget.article)));
      };
  }
}
