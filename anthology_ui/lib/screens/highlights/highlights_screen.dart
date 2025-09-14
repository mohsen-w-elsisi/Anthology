import 'package:anthology_common/article/data_gaetway.dart';
import 'package:anthology_common/article/entities.dart';
import 'package:anthology_common/highlight/data_gateway.dart';
import 'package:anthology_common/highlight/entities.dart';
import 'package:anthology_ui/config.dart';
import 'package:anthology_ui/screens/highlights/article_highlights_card.dart';
import 'package:anthology_ui/data/article_presentation_meta_data/fetcher.dart';
import 'package:anthology_ui/shared_widgets/navigation_bar.dart';
import 'package:anthology_ui/shared_widgets/settings.dart';
import 'package:anthology_ui/state/highlight_ui_notifier.dart';
import 'package:anthology_ui/utils.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class HighlightsScreen extends StatelessWidget {
  const HighlightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if (isExpanded(context)) {
      return Row(
        children: [
          const AppNavigationBar.rail(),
          Expanded(child: _scaffold(context)),
        ],
      );
    } else {
      return _scaffold(context);
    }
  }

  Widget _scaffold(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Highlights'),
        actions: const [
          SearchHighlightsButton(),
          SettingsButton(),
        ],
      ),
      body: const _ArticleHighlightsList(),
      bottomNavigationBar: AppNavigationBar.ifNotExpanded(context),
    );
  }
}

class _ArticleHighlightsList extends StatelessWidget {
  const _ArticleHighlightsList();

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: GetIt.I<HighlightUiNotifier>(),
      builder: (context, _) {
        return FutureBuilder<List<_ArticleHighlights>>(
          future: _getArticleHighlights(),
          builder: (_, snapshot) {
            if (snapshot.hasData) {
              final items = snapshot.data!;
              if (items.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: Text("You haven't highlighted anything yet."),
                  ),
                );
              }
              return Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1400),
                  child: ListView(
                    padding: screenMainScrollViewHorizontalPadding,
                    children: [
                      for (final item in items)
                        ArticleHighlightsCard(
                          article: item.article,
                          articleTitle: item.articleTitle,
                          highlights: item.highlights,
                        ),
                    ],
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        );
      },
    );
  }

  Future<List<_ArticleHighlights>> _getArticleHighlights() async {
    final highlightsByArticleId = await GetIt.I<HighlightDataGateway>()
        .getAll();
    final futures = highlightsByArticleId.entries.map((entry) async {
      final articleId = entry.key;
      final highlights = entry.value;
      final article = await GetIt.I<ArticleDataGateway>().get(articleId);
      final articleDataFetcher = ArticlePresentationMetaDataFetcher(article);
      await articleDataFetcher.fetch();
      return _ArticleHighlights(
        article: article,
        articleTitle: articleDataFetcher.metaData.title,
        highlights: highlights,
      );
    });
    return await Future.wait(futures);
  }
}

class _ArticleHighlights {
  final Article article;
  final String articleTitle;
  final List<Highlight> highlights;

  _ArticleHighlights({
    required this.article,
    required this.articleTitle,
    required this.highlights,
  });
}

class SearchHighlightsButton extends StatelessWidget {
  const SearchHighlightsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.search),
      onPressed: () => _openSearchHighlightsScreen(context),
    );
  }

  void _openSearchHighlightsScreen(BuildContext context) {}
}
