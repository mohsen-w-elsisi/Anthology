import 'package:anthology_common/article/entities.dart';
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
        final result = await showSearch<Article?>(
          context: context,
          delegate: ArticleSearchDelegate(),
        );
        if (result != null && context.mounted) {
          GetIt.I<ReaderViewStatusNotifier>().setActiveArticle(result);
        }
      },
    );
  }
}

class ArticleSearchDelegate extends SearchDelegate<Article?> {
  final _searcher = ArticleSearcher();

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
      return const Center(
        child: Text('Search saved articles by title and content.'),
      );
    }

    return FutureBuilder<List<ArticleSearchResult>>(
      future: _searcher.search(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        final filteredArticles = snapshot.data ?? [];

        if (filteredArticles.isEmpty) {
          return Center(child: Text('No results for "$query"'));
        }

        return ListView.builder(
          itemCount: filteredArticles.length,
          itemBuilder: (context, index) {
            final item = filteredArticles[index];
            final article = item.article;
            final meta = item.meta;
            return ListTile(
              leading: _articleFieldIconMap[item.querySatisfiedIn.first] != null
                  ? Icon(_articleFieldIconMap[item.querySatisfiedIn.first])
                  : null,
              title: Text(meta?.title ?? 'No title'),
              subtitle: item.previewText != null
                  ? Text(
                      item.previewText!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    )
                  : null,
              onTap: () => close(context, article),
            );
          },
        );
      },
    );
  }
}

const _articleFieldIconMap = {
  ArticleSearchField.title: Icons.title,
  ArticleSearchField.content: Icons.article,
  ArticleSearchField.highlight: Icons.border_color,
};
