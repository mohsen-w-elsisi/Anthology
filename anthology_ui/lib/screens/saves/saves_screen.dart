import 'package:anthology_common/article/entities.dart';
import 'package:anthology_ui/screens/saves/save_card.dart';
import 'package:anthology_ui/shared_widgets/navigation_bar.dart';
import 'package:anthology_ui/shared_widgets/settings.dart';
import 'package:flutter/material.dart';

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
      body: SaveCardsView([_article1, _article2]),
      floatingActionButton: FloatingActionButton(
        onPressed: () => NewSaveModal().show(context),
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: const BottomAppNavigation(),
    );
  }
}

class SaveCardsView extends StatelessWidget {
  static const _maximumColumnWidth = 450;
  static const _cardArea = 100000;

  final List<Article> articles;

  const SaveCardsView(this.articles, {super.key});

  @override
  Widget build(BuildContext context) {
    final cards = [for (final article in articles) SaveCard(article)];
    return LayoutBuilder(
      builder: (_, contraints) {
        return GridView.builder(
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

final _article1 = Article(
  uri: Uri.http("example.com"),
  id: "example-1",
  tags: {},
  dateSaved: DateTime.now(),
  read: false,
);

final _article2 = Article(
  uri: Uri.http("reddit.com"),
  id: "example-2",
  tags: {},
  dateSaved: DateTime.now(),
  read: false,
);
