import 'package:anthology_common/highlight/entities.dart';
import 'package:anthology_ui/screens/highlights/highlights_list.dart';
import 'package:anthology_ui/screens/highlights/show_highlights_button.dart';
import 'package:anthology_ui/utils.dart';
import 'package:flutter/material.dart';

class ArticleHighlightsCard extends StatefulWidget {
  final String articleTitle;
  final List<Highlight> highlights;

  const ArticleHighlightsCard({
    required this.articleTitle,
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
                  child: _highlightCountText,
                ),
                // if (isExpanded(context)) _actions(),
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
    style: isExpanded(context)
        ? TextTheme.of(context).headlineSmall
        : TextTheme.of(context).titleMedium,
  );

  Widget get _highlightCountText => Text(
    "${widget.highlights.length} highlights",
    style: isExpanded(context)
        ? TextTheme.of(context).titleMedium
        : TextTheme.of(context).bodyMedium,
  );
}
