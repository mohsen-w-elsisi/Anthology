import 'dart:io';

import 'package:anthology_ui/app_actions.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: PopScope(
        onPopInvokedWithResult: (_, _) => _hideAllSnackbars(context),
        child: ListView(
          children: [
            ListTile(
              onTap: () => _changeLocalStorageFolder(context),
              title: const Text("Change storage location"),
            ),
            ListTile(
              onTap: () => _clearCache(context),
              titleTextStyle: TextStyle(color: ColorScheme.of(context).error),
              title: const Text('Clear cache'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _clearCache(BuildContext context) async {
    await AppActions.clearCache();
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cache cleared.')),
      );
    }
  }

  Future<void> _changeLocalStorageFolder(BuildContext context) async {
    if (!await _androidPermissionGranted(context)) return;
    final selectedPath = await FilePicker.platform.getDirectoryPath(
      dialogTitle: 'Select Storage Folder',
    );
    if (selectedPath != null && selectedPath.isNotEmpty) {
      await AppActions.setLocalDataFolder(selectedPath);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Storage location changed.')),
        );
      }
    }
  }

  Future<bool> _androidPermissionGranted(BuildContext context) async {
    if (!Platform.isAndroid) return true;

    var status = await Permission.manageExternalStorage.status;
    if (status.isGranted) return true;

    status = await Permission.manageExternalStorage.request();
    if (status.isGranted) return true;

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Full storage access is required for this feature.'),
        ),
      );
    }
    return false;
  }

  void _hideAllSnackbars(BuildContext context) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
  }
}

class SettingsButton extends StatelessWidget {
  const SettingsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => _openSettingsScreen(context),
      icon: const Icon(Icons.settings),
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
