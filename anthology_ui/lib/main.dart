import 'package:flutter/material.dart';

import 'app_dependency_initer.dart';
import 'main_view.dart';

void main() async {
  await AppDependencyIniter.init();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
