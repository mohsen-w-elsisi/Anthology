import 'package:anthology_ui/screens/feed/feed_screen.dart';
import 'package:anthology_ui/screens/highlights/highlights_screen.dart';
import 'package:anthology_ui/screens/saves/saves_screen.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class BottomAppNavigation extends StatelessWidget {
  static int _screenIndex = 0;

  const BottomAppNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: _screenIndex,
      destinations: _destinations.map(_buildDestination).toList(),
      onDestinationSelected: (index) => _openScreen(context, index),
    );
  }

  NavigationDestination _buildDestination(_Destination destination) =>
      NavigationDestination(
        icon: Icon(destination.icon),
        selectedIcon: Icon(destination.selectedIcon),
        label: destination.label,
      );

  void _openScreen(BuildContext context, int index) {
    _screenIndex = index;
    final screen = _destinations[index].screen;
    final pageTransition = PageTransition(
      type: PageTransitionType.fade,
      duration: const Duration(milliseconds: 100),
      child: screen,
    );
    Navigator.of(context).pushReplacement(pageTransition);
  }
}

const _destinations = <_Destination>[
  _Destination(
    icon: Icons.library_books_outlined,
    selectedIcon: Icons.library_books,
    label: 'Saves',
    screen: SavesScreen(),
  ),
  _Destination(
    icon: Icons.podcasts_outlined,
    selectedIcon: Icons.podcasts,
    label: 'Feed',
    screen: FeedScreen(),
  ),
  _Destination(
    icon: Icons.bookmark_outline,
    selectedIcon: Icons.bookmark,
    label: 'highlights',
    screen: HighlightsScreen(),
  ),
];

class _Destination {
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final Widget screen;

  const _Destination({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.screen,
  });
}
