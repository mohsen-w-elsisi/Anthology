import 'dart:async';

class TagSelectionController {
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
    }
  }

  void unselect(String tag) {
    if (isSelected(tag)) {
      _selectedTags.remove(tag);
      _updateStream();
    }
  }

  bool isSelected(String tag) => _selectedTags.contains(tag);

  void clear() {
    _selectedTags.clear();
    _updateStream();
  }

  void dispose() => _streamController.close();

  void _updateStream() => _streamController.add(selectedTags);
}
