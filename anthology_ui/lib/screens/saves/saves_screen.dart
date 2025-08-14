import 'package:anthology_common/article/entities.dart';
import 'package:anthology_ui/screens/saves/save_card.dart';
import 'package:anthology_ui/shared_widgets/navigation_bar.dart';
import 'package:anthology_ui/shared_widgets/settings.dart';
import 'package:flutter/material.dart';

class SavesScreen extends StatelessWidget {
  const SavesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saves'),
        actions: const [SettingsButton()],
      ),
      body: ListView(
        children: [
          SaveCard(_article1),
          SaveCard(_article2),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: const BottomAppNavigation(),
    );
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
