import 'package:anthology_ui/config.dart';
import 'package:anthology_ui/shared_widgets/navigation_bar.dart';
import 'package:anthology_ui/shared_widgets/settings.dart';
import 'package:anthology_ui/utils.dart';
import 'package:flutter/material.dart';

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
      body: ListView(
        padding: screenMainScrollViewHorizontalPadding,
        children: [
          ArticleHighlightsCard(),
        ],
      ),
      bottomNavigationBar: AppNavigationBar.ifNotExpanded(context),
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
