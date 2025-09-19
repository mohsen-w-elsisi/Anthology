import 'package:flutter/material.dart';

import 'main_view.dart';
import 'screens/feed/feed_screen.dart';
import 'screens/highlights/highlights_screen.dart';

class AppRoutes {
  static const String main = '/';
  static const String highlights = '/highlights';
  static const String feed = '/feed';

  static Map<String, WidgetBuilder> get routes {
    return {
      main: (_) => const MainView(),
      highlights: (_) => const HighlightsScreen(),
      feed: (_) => const FeedScreen(),
    };
  }
}
