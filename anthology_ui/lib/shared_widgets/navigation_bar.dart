import 'package:anthology_ui/app_routes.dart';
import 'package:anthology_ui/utils.dart';
import 'package:flutter/material.dart';

class AppNavigationBar extends StatelessWidget {
  static int _screenIndex = 0;

  final bool _isBottom;

  const AppNavigationBar({super.key}) : _isBottom = true;

  const AppNavigationBar.rail({super.key}) : _isBottom = false;

  static AppNavigationBar? ifNotExpanded(BuildContext context) =>
      isExpanded(context) ? null : const AppNavigationBar();

  @override
  Widget build(BuildContext context) {
    if (_isBottom) {
      return NavigationBar(
        selectedIndex: _screenIndex,
        destinations: _destinations.map(_buildDestination).toList(),
        onDestinationSelected: (index) => _openScreen(context, index),
      );
    } else {
      return NavigationRail(
        selectedIndex: _screenIndex,
        destinations: _destinations.map(_buildRailDestination).toList(),
        onDestinationSelected: (index) => _openScreen(context, index),
        labelType: NavigationRailLabelType.all,
        groupAlignment: 0,
      );
    }
  }

  NavigationDestination _buildDestination(_Destination destination) {
    return NavigationDestination(
      icon: Icon(destination.icon),
      selectedIcon: Icon(destination.selectedIcon),
      label: destination.label,
    );
  }

  NavigationRailDestination _buildRailDestination(_Destination destination) {
    return NavigationRailDestination(
      icon: Icon(destination.icon),
      selectedIcon: Icon(destination.selectedIcon),
      label: Text(destination.label),
    );
  }

  void _openScreen(BuildContext context, int index) {
    if (index != _screenIndex) {
      _screenIndex = index;
      final routeName = _destinations[index].routeName;
      Navigator.of(context).pushReplacementNamed(routeName);
    }
  }
}

const _destinations = <_Destination>[
  _Destination(
    icon: Icons.library_books_outlined,
    selectedIcon: Icons.library_books,
    label: 'Saves',
    routeName: AppRoutes.main,
  ),
  _Destination(
    icon: Icons.podcasts_outlined,
    selectedIcon: Icons.podcasts,
    label: 'Feed',
    routeName: AppRoutes.feed,
  ),
  _Destination(
    icon: Icons.bookmark_outline,
    selectedIcon: Icons.bookmark,
    label: 'highlights',
    routeName: AppRoutes.highlights,
  ),
];

class _Destination {
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final String routeName;

  const _Destination({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.routeName,
  });
}
