import 'package:anthology_ui/screens/highlights/article_highlights_card.dart';
import 'package:anthology_ui/shared_widgets/navigation_bar.dart';
import 'package:anthology_ui/shared_widgets/settings.dart';
import 'package:anthology_ui/shared_widgets/filterable_chips.dart';
import 'package:anthology_ui/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'highlights_provider.dart';

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
      body: ChangeNotifierProvider(
        create: (_) => HighlightsScreenProvider(),
        child: const _ArticleHighlightsList(),
      ),
      bottomNavigationBar: AppNavigationBar.ifNotExpanded(context),
    );
  }
}

class _ArticleHighlightsList extends StatelessWidget {
  const _ArticleHighlightsList();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: screenMainScrollViewHorizontalPadding(context),
      children: [
        const ArticleFilterChipsRow<HighlightsScreenProvider>(),
        const SizedBox(height: 16),
        _buildArticleHighlightsList(context),
      ],
    );
  }

  Widget _buildArticleHighlightsList(BuildContext context) {
    final provider = context.watch<HighlightsScreenProvider>();

    if (provider.isLoading && provider.filteredArticleHighlights == null) {
      return const Center(child: CircularProgressIndicator());
    } else if (provider.error != null) {
      return Center(child: Text('Error: ${provider.error}'));
    } else if (provider.articleHighlights?.isEmpty ?? true) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: Text("You haven't highlighted anything yet."),
        ),
      );
    } else if (provider.filteredArticleHighlights?.isEmpty ?? true) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: Text('No highlights match your filters.'),
        ),
      );
    }

    final items = provider.filteredArticleHighlights!;
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1400),
        child: Column(
          children: [
            for (final item in items)
              ArticleHighlightsCard(
                article: item.article,
                articleTitle: item.articleTitle,
                highlights: item.highlights,
                key: ValueKey(item.article.id),
              ),
          ],
        ),
      ),
    );
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
