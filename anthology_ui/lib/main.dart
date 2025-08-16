import 'package:anthology_ui/screens/saves/saves_screen.dart';
import 'package:flutter/material.dart';

import 'app_dependency_initer.dart';

void main() {
  AppDependencyIniter.init();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SavesScreen(),
    );
  }
}
