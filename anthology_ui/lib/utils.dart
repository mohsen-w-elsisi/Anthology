import 'package:flutter/widgets.dart';

import 'config.dart';

bool isExpanded(BuildContext context) {
  final width = MediaQuery.of(context).size.width;
  return width > expandedWidth;
}

EdgeInsets screenMainScrollViewHorizontalPadding(BuildContext context) {
  final bottomPaddingWithOffset =
      MediaQuery.of(context).viewPadding.bottom + 16.0;
  final horizontalPadding = isExpanded(context) ? 24.0 : 8.0;
  return EdgeInsets.only(
    left: horizontalPadding,
    right: horizontalPadding,
    bottom: bottomPaddingWithOffset,
  );
}
