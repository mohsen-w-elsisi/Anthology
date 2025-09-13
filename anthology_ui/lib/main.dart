import 'package:flutter/material.dart';

import 'app_dependency_initer.dart';
import 'main_view.dart';
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
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

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
      navigatorKey: _navigatorKey,
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
      ),
      home: const MainView(),
    );
  }
}
