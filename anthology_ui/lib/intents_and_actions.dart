import 'package:anthology_ui/screens/saves/new_save_modal.dart';
import 'package:anthology_ui/screens/saves/search.dart';
import 'package:anthology_ui/shared_widgets/settings.dart';
import 'package:anthology_ui/app_routes.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Intents
class NavigateToSavesIntent extends Intent {}

class NavigateToFeedIntent extends Intent {}

class NavigateToHighlightsIntent extends Intent {}

class OpenSettingsIntent extends Intent {}

class NewSaveIntent extends Intent {}

class ShowSearchIntent extends Intent {}

class ShowGlobalSearchIntent extends ShowSearchIntent {}

// Actions
class NavigateToSavesAction extends Action<NavigateToSavesIntent> {
  @override
  void invoke(NavigateToSavesIntent intent) {
    GetIt.I<GlobalKey<NavigatorState>>().currentState?.pushReplacementNamed(
      AppRoutes.main,
    );
  }
}

class NavigateToFeedAction extends Action<NavigateToFeedIntent> {
  @override
  void invoke(NavigateToFeedIntent intent) {
    GetIt.I<GlobalKey<NavigatorState>>().currentState?.pushReplacementNamed(
      AppRoutes.feed,
    );
  }
}

class NavigateToHighlightsAction extends Action<NavigateToHighlightsIntent> {
  @override
  void invoke(NavigateToHighlightsIntent intent) {
    GetIt.I<GlobalKey<NavigatorState>>().currentState?.pushReplacementNamed(
      AppRoutes.highlights,
    );
  }
}

class OpenSettingsAction extends Action<OpenSettingsIntent> {
  @override
  void invoke(OpenSettingsIntent intent) {
    GetIt.I<GlobalKey<NavigatorState>>().currentState?.push(
      MaterialPageRoute(
        builder: (_) => const SettingsScreen(),
      ),
    );
  }
}

class NewSaveAction extends Action<NewSaveIntent> {
  @override
  void invoke(NewSaveIntent intent) {
    NewSaveModal().show();
  }
}

class ShowGloablSearchAction extends Action<ShowSearchIntent> {
  @override
  void invoke(ShowSearchIntent intent) {
    final context = GetIt.I<GlobalKey<NavigatorState>>().currentContext!;
    showSearch(context: context, delegate: ArticleSearchDelegate());
  }
}

// Shortcuts map
Map<ShortcutActivator, Intent> globalShortcuts() {
  return {
    const SingleActivator(LogicalKeyboardKey.digit1, control: true):
        NavigateToSavesIntent(),
    const SingleActivator(LogicalKeyboardKey.digit2, control: true):
        NavigateToFeedIntent(),
    const SingleActivator(LogicalKeyboardKey.digit3, control: true):
        NavigateToHighlightsIntent(),
    const SingleActivator(LogicalKeyboardKey.comma, control: true):
        OpenSettingsIntent(),
    const SingleActivator(LogicalKeyboardKey.keyN, control: true):
        NewSaveIntent(),
    const SingleActivator(LogicalKeyboardKey.keyF, control: true):
        ShowSearchIntent(),
    const SingleActivator(LogicalKeyboardKey.keyF, control: true, shift: true):
        ShowGlobalSearchIntent(),
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
    ShowSearchIntent: ShowGloablSearchAction(),
  };
}
