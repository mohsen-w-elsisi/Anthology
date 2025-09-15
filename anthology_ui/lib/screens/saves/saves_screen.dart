import 'package:anthology_common/article/data_gaetway.dart';
import 'package:anthology_common/article/entities.dart';
import 'package:anthology_common/article/filterer.dart';
import 'package:anthology_ui/screens/saves/save_card.dart';
import 'package:anthology_ui/shared_widgets/navigation_bar.dart';
import 'package:anthology_ui/shared_widgets/settings.dart';
import 'package:anthology_ui/shared_widgets/tag_selector_chips.dart';
import 'package:anthology_ui/state/article_ui_notifier.dart';
import 'package:anthology_ui/state/tag_selection_controller.dart';
import 'package:anthology_ui/utils.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'new_save_modal.dart';

class SavesScreen extends StatelessWidget {
  const SavesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saves'),
        actions: const [SettingsButton()],
      ),
      body: const MainSaveView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => NewSaveModal().show(context),
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: AppNavigationBar.ifNotExpanded(context),
    );
  }
}

class MainSaveView extends StatefulWidget {
  const MainSaveView({super.key});

  @override
  State<MainSaveView> createState() => _MainSaveViewState();
}

class _MainSaveViewState extends State<MainSaveView> {
  final _tagfilterationController = TagSelectionController();
  late Future<List<Article>> _articlesFuture;
  List<Article>? _previousArticles;
  bool _showArchived = false;

  @override
  void initState() {
    super.initState();
    _articlesFuture = _getArticles();
    GetIt.I<ArticleUiNotifier>().addListener(_refreshArticles);
  }

  @override
  void dispose() {
    _tagfilterationController.dispose();
    GetIt.I<ArticleUiNotifier>().removeListener(_refreshArticles);
    super.dispose();
  }

  Future<List<Article>> _getArticles() =>
      GetIt.I<ArticleDataGateway>().getAll()..then(
        (articles) => _previousArticles = articles,
      ); // to avoid harsh UI flickers while fetching

  void _refreshArticles() {
    setState(() {
      _articlesFuture = _getArticles();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: screenMainScrollViewHorizontalPadding(context),
      children: [
        _topChips,
        const SizedBox(height: 16),
        FutureBuilder(
          future: _articlesFuture,
          initialData: _previousArticles,
          builder: (_, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            } else {
              if (snapshot.data!.isNotEmpty) {
                return StreamBuilder(
                  stream: _tagfilterationController.stream,
                  initialData: _tagfilterationController.selectedTags,
                  builder: (_, _) => SaveCardsList(
                    _filterArticles(snapshot.data!),
                  ),
                );
              } else {
                return Center(child: Text('No articles saved yet.'));
              }
            }
          },
        ),
      ],
    );
  }

  Row get _topChips => Row(
    children: [
      FilterChip(
        avatar: Icon(Icons.archive_outlined),
        label: const Text('Archived'),
        selected: _showArchived,
        onSelected: (value) => setState(() => _showArchived = value),
      ),
      const SizedBox(width: 4),
      Expanded(
        child: TagSelectorChips(
          tagSelectionController: _tagfilterationController,
        ),
      ),
    ],
  );

  List<Article> _filterArticles(List<Article> articles) {
    var filterer = ArticleFilterer(articles).byArchiveStatus(_showArchived);
    final selectedTags = _tagfilterationController.selectedTags;
    if (selectedTags.isNotEmpty) {
      filterer = filterer.onlyTags(selectedTags);
    }
    return filterer.articles;
  }
}

class SaveCardsList extends StatelessWidget {
  final List<Article> articles;

  const SaveCardsList(this.articles, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card.filled(
      color: ColorScheme.of(context).surfaceContainerLowest,
      child: ListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          for (final article in articles)
            SaveTile(article, key: ValueKey(article.id)),
        ].reversed.toList(),
      ),
    );
  }
}
