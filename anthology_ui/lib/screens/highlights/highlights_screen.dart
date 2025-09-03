import 'package:anthology_common/article/data_gaetway.dart';
import 'package:anthology_common/article/entities.dart';
import 'package:anthology_common/highlight/data_gateway.dart';
import 'package:anthology_common/highlight/entities.dart';
import 'package:anthology_ui/config.dart';
import 'package:anthology_ui/screens/highlights/article_highlights_card.dart';
import 'package:anthology_ui/screens/saves/article_presentation_meta_data_fetcher.dart';
import 'package:anthology_ui/shared_widgets/navigation_bar.dart';
import 'package:anthology_ui/shared_widgets/settings.dart';
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
    return FutureBuilder(
      future: _getAllHighlights(),
      builder: (_, snapshot) {
        if (snapshot.hasData) {
          return ListView(
            padding: screenMainScrollViewHorizontalPadding,
            children: [
              for (final entry in snapshot.data!.entries)
                ArticleHighlightsCard(
                  articleTitle: entry.key,
                  highlights: entry.value,
                ),
            ],
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Future<Map<String, List<Highlight>>> _getAllHighlights() async {
    final highlightsWithIds = await GetIt.I<HighlightDataGateway>().getAll();
    final articleNames = highlightsWithIds.keys.map(_getArticleName).toList();

    final highlightsWithNames = <String, List<Highlight>>{};
    for (var i = 0; i < highlightsWithIds.length; i++) {
      final id = highlightsWithIds.keys.elementAt(i);
      final highlights = highlightsWithIds[id]!;
      final name = await articleNames[i];
      highlightsWithNames[name] = highlights;
    }

    return highlightsWithNames;
  }

  Future<String> _getArticleName(String id) async {
    final article = await GetIt.I<ArticleDataGateway>().get(id);
    final articleDataFetcher = ArticlePresentationMetaDataFetcher(article);
    await articleDataFetcher.fetch();
    return articleDataFetcher.title;
  }
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
