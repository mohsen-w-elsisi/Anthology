import 'package:anthology_ui/shared_widgets/navigation_bar.dart';
import 'package:anthology_ui/shared_widgets/settings.dart';
import 'package:flutter/material.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Feed"),
        actions: const [
          AddFeedButton(),
          SettingsButton(),
        ],
      ),
      drawer: FeedsDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.done_all),
      ),
      bottomNavigationBar: const BottomAppNavigation(),
    );
  }
}

class AddFeedButton extends StatelessWidget {
  const AddFeedButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.add_circle_outline),
      onPressed: _addFeed,
    );
  }

  void _addFeed() {}
}

class FeedsDrawer extends StatelessWidget {
  const FeedsDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          ListTile(
            title: const Text("All feeds"),
          ),
        ],
      ),
    );
  }
}
