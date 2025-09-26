import 'package:anthology_common/article/entities.dart';
import 'package:anthology_ui/screens/saves/saves_provider.dart';
import 'package:anthology_ui/screens/saves/save_card.dart';
import 'package:anthology_ui/shared_widgets/navigation_bar.dart';
import 'package:anthology_ui/shared_widgets/filterable_chips.dart';
import 'package:anthology_ui/shared_widgets/settings.dart';
import 'package:anthology_ui/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'new_save_modal.dart';
import 'search.dart';

class SavesScreen extends StatelessWidget {
  const SavesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SavesProvider(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Saves'),
          actions: [const ArticleSearchButton(), const SettingsButton()],
        ),
        body: const MainSaveView(),
        floatingActionButton: FloatingActionButton(
          onPressed: () => NewSaveModal().show(),
          child: const Icon(Icons.add),
        ),
        bottomNavigationBar: AppNavigationBar.ifNotExpanded(context),
      ),
    );
  }
}

class MainSaveView extends StatelessWidget {
  const MainSaveView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: screenMainScrollViewHorizontalPadding(context),
      children: [
        const ArticleFilterChipsRow<SavesProvider>(),
        const SizedBox(height: 16),
        _buildArticleList(context),
      ],
    );
  }

  Widget _buildArticleList(BuildContext context) {
    final provider = context.watch<SavesProvider>();
    if (provider.isLoading && provider.articles == null) {
      return const Center(child: CircularProgressIndicator());
    } else if (provider.error != null) {
      return Center(child: Text('Error: ${provider.error}'));
    } else if (provider.articles?.isEmpty ?? true) {
      return const Center(child: Text('No articles saved yet.'));
    } else {
      final filteredArticles = provider.filteredArticles;
      return SaveCardsList(
        articles: filteredArticles,
        onArticleDismissed: (article) =>
            context.read<SavesProvider>().archiveArticle(article),
      );
    }
  }
}

class SaveCardsList extends StatelessWidget {
  final List<Article> articles;
  final Function(Article article) onArticleDismissed;

  const SaveCardsList({
    required this.articles,
    required this.onArticleDismissed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card.filled(
      clipBehavior: Clip.hardEdge,
      color: ColorScheme.of(context).surfaceContainerLowest,
      child: ListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          for (final article in articles)
            SaveTile(
              article,
              key: ValueKey(article.id),
              onDismissed: () => onArticleDismissed(article),
            ),
        ].reversed.toList(),
      ),
    );
  }
}
