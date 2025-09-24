import 'package:flutter/material.dart';

class TextNodeRegistry {
  final Map<int, GlobalKey> _nodeKeys = {};

  void register(int index, GlobalKey key) {
    _nodeKeys[index] = key;
  }

  void scrollTo(int index) {
    final key = _nodeKeys[index];
    if (key?.currentContext != null) {
      Scrollable.ensureVisible(
        key!.currentContext!,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }
}
