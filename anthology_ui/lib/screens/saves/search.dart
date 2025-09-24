import 'package:anthology_ui/data/article_presentation_meta_data/entities.dart';
import 'package:anthology_ui/data/article_presentation_meta_data/fetcher.dart';
import 'package:anthology_ui/screens/reader/reader_screen_settings.dart';
import 'package:anthology_ui/screens/saves/article_searcher.dart';
import 'package:anthology_ui/state/reader_view_status_notifier.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class ArticleSearchButton extends StatelessWidget {
  const ArticleSearchButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.search),
      onPressed: () async {
        final result = await showSearch<ArticleSearchResult?>(
          context: context,
          delegate: ArticleSearchDelegate(),
        );
        if (result != null && context.mounted) {
          final ScrollDestination destination;
          final discribtor = result.resultDiscribtor;
          if (discribtor is ArticleContentSearchResultDiscribtor) {
            destination = TextNodeDestination(index: discribtor.nodeIndex);
          } else {
            destination = const BeginningDestination();
          }

          final settings = ReaderScreenSettings(
            scrollDestination: destination,
            isModal: false,
          );
          GetIt.I<ReaderViewStatusNotifier>().setActiveArticleWithSettings(
            result.article,
            settings,
          );
        }
      },
    );
  }
}

class ArticleSearchDelegate extends SearchDelegate<ArticleSearchResult?> {
  final _searcher = ArticleSearcher();

  Widget? _previousSearchContent;

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          showSuggestions(context);
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults(context);
  }

  Widget _buildSearchResults(BuildContext context) {
    if (query.isEmpty) {
      return _emptySearchMessage;
    }

    return FutureBuilder<List<ArticleSearchResult>>(
      future: _searcher.search(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _previousSearchContent ?? _emptySearchMessage;
        }

        late Widget currentContent;
        final searchresults = snapshot.data ?? [];

        if (snapshot.hasError) {
          currentContent = Center(child: Text('Error: ${snapshot.error}'));
        } else if (searchresults.isEmpty) {
          currentContent = Center(child: Text('No results for "$query"'));
        } else {
          currentContent = ListView(
            children: [
              for (final result in searchresults)
                ArticleSearchTile(
                  result,
                  onTap: (searchResult) => close(context, searchResult),
                ),
            ],
          );
        }

        _previousSearchContent = currentContent;
        return currentContent;
      },
    );
  }

  Center get _emptySearchMessage {
    return const Center(
      child: Text('Search saved articles by title and content.'),
    );
  }
}

class ArticleSearchTile extends StatelessWidget {
  final ArticleSearchResult searchResult;
  final Function(ArticleSearchResult searchResult) onTap;

  const ArticleSearchTile(this.searchResult, {super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => onTap(searchResult),
      isThreeLine: _previewText != null,
      leading: icon,
      title: articleTitle,
      subtitle: _previewText,
    );
  }

  Widget get icon => Padding(
    padding: const EdgeInsets.only(top: 8.0),
    child: Icon(
      _articleFieldIconMap[searchResult.resultDiscribtor.field]!,
    ),
  );

  Widget get articleTitle => FutureBuilder(
    future: ArticlePresentationMetaDataFetcher(searchResult.article).fetch(),
    initialData: ArticlePresentationMetaData(title: ""),
    builder: (context, snapshot) => Text(snapshot.data!.title),
  );

  Widget? get _previewText {
    final previewText = searchResult.resultDiscribtor.previewText();
    if (previewText == null) return null;
    return Text(
      previewText,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }
}

const _articleFieldIconMap = {
  ArticleSearchField.title: Icons.title,
  ArticleSearchField.content: Icons.article,
  ArticleSearchField.highlight: Icons.border_color,
};
