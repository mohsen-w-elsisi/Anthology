import 'dart:async';

import 'package:flutter/material.dart';

class TagSelectionController with ChangeNotifier {
  final Set<String> _selectedTags = {};
  final _streamController = StreamController<Set<String>>.broadcast();

  TagSelectionController({Set<String>? initialTags}) {
    if (initialTags != null) {
      _selectedTags.addAll(initialTags);
    }
    _updateStream();
  }

  Stream<Set<String>> get stream => _streamController.stream;

  Set<String> get selectedTags => Set.unmodifiable(_selectedTags);

  void toggle(String tag) {
    if (isSelected(tag)) {
      unselect(tag);
    } else {
      select(tag);
    }
  }

  void select(String tag) {
    if (!isSelected(tag)) {
      _selectedTags.add(tag);
      _updateStream();
      notifyListeners();
    }
  }

  void unselect(String tag) {
    if (isSelected(tag)) {
      _selectedTags.remove(tag);
      _updateStream();
      notifyListeners();
    }
  }

  bool isSelected(String tag) => _selectedTags.contains(tag);

  void clear() {
    if (_selectedTags.isNotEmpty) {
      _selectedTags.clear();
      _updateStream();
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  void _updateStream() => _streamController.add(selectedTags);
}
