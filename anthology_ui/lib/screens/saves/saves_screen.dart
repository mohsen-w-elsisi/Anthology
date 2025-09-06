import 'package:anthology_common/article/data_gaetway.dart';
import 'package:anthology_common/article/entities.dart';
import 'package:anthology_common/article/filterer.dart';
import 'package:anthology_ui/config.dart';
import 'package:anthology_ui/screens/saves/save_card.dart';
import 'package:anthology_ui/shared_widgets/navigation_bar.dart';
import 'package:anthology_ui/shared_widgets/settings.dart';
import 'package:anthology_ui/shared_widgets/tag_selector_chips.dart';
import 'package:anthology_ui/state/tag_selection_controller.dart';
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

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: screenMainScrollViewHorizontalPadding,
      children: [
        TagSelectorChips(tagSelectionController: _tagfilterationController),
        FutureBuilder(
          future: GetIt.I<ArticleDataGateway>().getAll(),
          initialData: <Article>[],
          builder: (_, allArticlesSnapshot) => StreamBuilder(
            stream: _tagfilterationController.stream,
            initialData: _tagfilterationController.selectedTags,
            builder: (_, _) => SaveCardsGrid(
              _filterArticles(allArticlesSnapshot.data!),
            ),
          ),
        ),
      ],
    );
  }

  List<Article> _filterArticles(List<Article> articles) {
    final selectedTags = _tagfilterationController.selectedTags;
    if (selectedTags.isNotEmpty) {
      return ArticleFilterer(articles).onlyTags(selectedTags).articles;
    } else {
      return articles;
    }
  }
}

class SaveCardsGrid extends StatelessWidget {
  static const _maximumColumnWidth = 450;
  static const _cardArea = 100000;

  final List<Article> articles;

  const SaveCardsGrid(this.articles, {super.key});

  @override
  Widget build(BuildContext context) {
    final cards = [for (final article in articles) SaveCard(article)];
    return LayoutBuilder(
      builder: (_, contraints) {
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: _columnsCount(contraints),
            mainAxisExtent: _rowHeight(contraints),
          ),
          itemBuilder: (_, i) => cards[i],
          itemCount: cards.length,
        );
      },
    );
  }

  int _columnsCount(BoxConstraints constraints) {
    final calculatedWidth = (constraints.maxWidth ~/ _maximumColumnWidth);
    return calculatedWidth == 0 ? 1 : calculatedWidth;
  }

  double _rowHeight(BoxConstraints constraints) {
    final cardWidth = (constraints.maxWidth ~/ _columnsCount(constraints));
    return _cardArea / cardWidth;
  }
}
