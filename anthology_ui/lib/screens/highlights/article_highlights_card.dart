import 'package:anthology_common/highlight/entities.dart';
import 'package:anthology_ui/screens/highlights/highlights_list.dart';
import 'package:anthology_ui/screens/highlights/show_highlights_button.dart';
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
            title: _articleTitleText,
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: _highlightCountText,
                ),
                _actions(),
              ],
            ),
          ),
          HighlightsList(
            highlights: widget.highlights,
            isExpanded: _isExpanded,
          ),
        ],
      ),
    );
  }

  Widget get _articleTitleText => Text(
    widget.articleTitle,
    style: TextTheme.of(context).headlineMedium,
  );

  Widget get _highlightCountText => Text(
    "${widget.highlights.length} highlights",
    style: TextTheme.of(context).titleMedium,
  );

  Widget _actions() {
    return Align(
      alignment: Alignment.centerRight,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: FilledButton.tonalIcon(
                style: FilledButton.styleFrom(
                  visualDensity: VisualDensity.comfortable,
                  iconAlignment: IconAlignment.end,
                ),
                onPressed: () {},
                label: const Text("view"),
                icon: const Icon(Icons.open_in_new),
              ),
            ),
            const SizedBox(width: 16.0),
            Expanded(
              flex: 2,
              child: ShowHighlightsButton(isExpanded: _isExpanded),
            ),
          ],
        ),
      ),
    );
  }
}
