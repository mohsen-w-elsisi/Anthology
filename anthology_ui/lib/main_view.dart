import 'package:flutter/material.dart';

import 'screens/saves/saves_screen.dart';
import 'shared_widgets/navigation_bar.dart';

class MainView extends StatelessWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    if (isExpanded(context)) {
      return const Row(
        children: [
          AppNavigationBar.rail(),
          Expanded(child: SavesScreen()),
          Expanded(
            child: Center(
              child: Text("empty screen"),
            ),
          ),
        ],
      );
    } else {
      return const SavesScreen();
    }
  }

  bool isExpanded(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width > 840;
  }
}
