import 'package:anthology_ui/screens/saves/new_save_modal.dart';
import 'package:anthology_ui/shared_widgets/settings.dart';
import 'package:anthology_ui/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Intents
class NavigateToSavesIntent extends Intent {
  final BuildContext context;
  const NavigateToSavesIntent(this.context);
}

class NavigateToFeedIntent extends Intent {
  final BuildContext context;
  const NavigateToFeedIntent(this.context);
}

class NavigateToHighlightsIntent extends Intent {
  final BuildContext context;
  const NavigateToHighlightsIntent(this.context);
}

class OpenSettingsIntent extends Intent {
  final BuildContext context;
  const OpenSettingsIntent(this.context);
}

class NewSaveIntent extends Intent {
  final BuildContext context;
  const NewSaveIntent(this.context);
}

// Actions
class NavigateToSavesAction extends Action<NavigateToSavesIntent> {
  @override
  void invoke(NavigateToSavesIntent intent) {
    Navigator.of(intent.context).pushReplacementNamed(AppRoutes.main);
  }
}

class NavigateToFeedAction extends Action<NavigateToFeedIntent> {
  @override
  void invoke(NavigateToFeedIntent intent) {
    Navigator.of(intent.context).pushReplacementNamed(AppRoutes.feed);
  }
}

class NavigateToHighlightsAction extends Action<NavigateToHighlightsIntent> {
  @override
  void invoke(NavigateToHighlightsIntent intent) {
    Navigator.of(intent.context).pushReplacementNamed(AppRoutes.highlights);
  }
}

class OpenSettingsAction extends Action<OpenSettingsIntent> {
  @override
  void invoke(OpenSettingsIntent intent) {
    print("should open settings screen");
    Navigator.of(intent.context).push(
      MaterialPageRoute(
        builder: (_) => const SettingsScreen(),
      ),
    );
  }
}

class NewSaveAction extends Action<NewSaveIntent> {
  @override
  void invoke(NewSaveIntent intent) {
    NewSaveModal().show(intent.context);
  }
}

// Shortcuts map
Map<ShortcutActivator, Intent> globalShortcuts(BuildContext context) {
  return {
    const SingleActivator(LogicalKeyboardKey.keyS, control: true):
        NavigateToSavesIntent(context),
    const SingleActivator(LogicalKeyboardKey.keyF, control: true):
        NavigateToFeedIntent(context),
    const SingleActivator(LogicalKeyboardKey.keyH, control: true):
        NavigateToHighlightsIntent(context),
    const SingleActivator(LogicalKeyboardKey.comma, control: true):
        OpenSettingsIntent(context),
    const SingleActivator(LogicalKeyboardKey.keyN, control: true):
        NewSaveIntent(context),
  };
}

// Actions map
Map<Type, Action<Intent>> globalActions() {
  return {
    NavigateToSavesIntent: NavigateToSavesAction(),
    NavigateToFeedIntent: NavigateToFeedAction(),
    NavigateToHighlightsIntent: NavigateToHighlightsAction(),
    OpenSettingsIntent: OpenSettingsAction(),
    NewSaveIntent: NewSaveAction(),
  };
}
