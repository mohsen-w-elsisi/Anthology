import 'package:anthology_ui/app_actions.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          ListTile(
            onTap: () => _changeLocalStorageFolder(context),
            title: Text("chang storage locations"),
          ),
          ListTile(
            onTap: AppActions.clearCache,
            titleTextStyle: TextStyle(color: ColorScheme.of(context).error),
            title: const Text('Clear cache'),
          ),
        ],
      ),
    );
  }

  Future<void> _changeLocalStorageFolder(BuildContext context) async {
    final selectedPath = await FilePicker.platform.getDirectoryPath(
      dialogTitle: 'Select Storage Folder',
    );
    if (selectedPath != null && selectedPath.isNotEmpty) {
      await AppActions.setLocalDataFolder(selectedPath);
      ScaffoldMessenger.maybeOf(context)?.showSnackBar(
        SnackBar(content: Text('Storage location changes.')),
      );
    }
  }
}

class SettingsButton extends StatelessWidget {
  const SettingsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => _openSettingsScreen(context),
      icon: Icon(Icons.settings),
    );
  }

  void _openSettingsScreen(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const SettingsScreen(),
      ),
    );
  }
}
