import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'text_options.dart';

class TextOptionsController with ChangeNotifier {
  static const _textOptionsKey = 'reader_text_options';

  static const double minScale = 0.5;
  static const double maxScale = 2.0;

  ReaderViewTextOptions? _options;

  ReaderViewTextOptions get options {
    if (!isInitialized) {
      throw StateError(
        'TextOptionsController not initialized. Ensure init() has completed and listen to changes.',
      );
    }
    return _options!;
  }

  bool get isInitialized => _options != null;

  Future<void> init() async {
    await _loadOptions();
    addListener(_saveOptions);
  }

  @override
  void dispose() {
    removeListener(_saveOptions);
    super.dispose();
  }

  Future<void> _loadOptions() async {
    final prefs = await SharedPreferences.getInstance();
    final optionsJson = prefs.getString(_textOptionsKey);

    if (optionsJson != null) {
      _options = ReaderViewTextOptions.fromJson(jsonDecode(optionsJson));
    } else {
      _options = const ReaderViewTextOptions();
    }
    notifyListeners();
  }

  Future<void> _saveOptions() async {
    if (!isInitialized) return;
    final prefs = await SharedPreferences.getInstance();
    final optionsJson = jsonEncode(options.toJson());
    await prefs.setString(_textOptionsKey, optionsJson);
  }

  void updateScale(double newScale) {
    if (!isInitialized) return;
    _options = ReaderViewTextOptions(
      textScaleFactor: newScale.clamp(minScale, maxScale),
    );
    notifyListeners();
  }
}
