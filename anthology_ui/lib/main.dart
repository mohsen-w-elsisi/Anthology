import 'package:anthology_ui/app_routes.dart';
import 'package:anthology_ui/intents_and_actions.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import 'app_dependency_initer.dart';
import 'share_intent_handler_mixin.dart';

void main() async {
  await AppDependencyIniter.init();
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> with ShareIntentHandlerMixin {
  @override
  GlobalKey<NavigatorState> get navigatorKey =>
      GetIt.I<GlobalKey<NavigatorState>>();

  @override
  void initState() {
    super.initState();
    initShareIntentHandler();
  }

  @override
  void dispose() {
    cancelShareIntentSubscription();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Anthology',
      onGenerateRoute: (settings) => _generatePageTransition(settings, context),
      initialRoute: AppRoutes.main,
      navigatorKey: navigatorKey,
      shortcuts: globalShortcuts(),
      actions: globalActions(),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
      ),
    );
  }

  PageTransition<dynamic> _generatePageTransition(
    RouteSettings settings,
    BuildContext context,
  ) {
    final builder = AppRoutes.routes[settings.name]!;
    return PageTransition(
      type: PageTransitionType.fade,
      duration: const Duration(milliseconds: 100),
      child: builder(context),
      settings: settings,
    );
  }
}
