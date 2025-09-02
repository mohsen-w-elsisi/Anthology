import 'package:flutter/widgets.dart';

import 'config.dart';

bool isExpanded(BuildContext context) {
  final width = MediaQuery.of(context).size.width;
  return width > expandedWidth;
}
