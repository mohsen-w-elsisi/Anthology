import 'package:anthology_ui/shared_widgets/navigation_bar.dart';
import 'package:anthology_ui/shared_widgets/settings.dart';
import 'package:flutter/material.dart';

class HighlightsScreen extends StatelessWidget {
  const HighlightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Highlights'),
        actions: const [
          SearchHighlightsButton(),
          SettingsButton(),
        ],
      ),
      body: ListView(
        children: [
          ArticleHighlightsCard(),
        ],
      ),
      bottomNavigationBar: const BottomAppNavigation(),
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

class ArticleHighlightsCard extends StatelessWidget {
  const ArticleHighlightsCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: const Text('Highlight Title'),
        subtitle: const Text('Highlight Description'),
        trailing: SizedBox(
          height: 400,
          width: 400,
          child: Placeholder(),
        ),
      ),
    );
  }
}
