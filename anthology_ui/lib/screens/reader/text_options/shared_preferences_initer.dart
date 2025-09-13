import 'dart:convert';

import 'package:anthology_ui/screens/reader/text_options/controller.dart';
import 'package:anthology_ui/screens/reader/text_options/text_options.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TextOptionsPersistence {
  static const _textOptionsKey = 'reader_text_options';

  late TextOptionsController _controller;

  Future<TextOptionsController> loadController() async {
    final prefs = await SharedPreferences.getInstance();
    final optionsJson = prefs.getString(_textOptionsKey);

    final ReaderViewTextOptions options;
    if (optionsJson != null) {
      options = ReaderViewTextOptions.fromJson(jsonDecode(optionsJson));
      _controller = TextOptionsController(options);
    } else {
      _controller = TextOptionsController.inital();
    }

    _controller.addListener(_saveOptions);
    return _controller;
  }

  Future<void> _saveOptions() async {
    final prefs = await SharedPreferences.getInstance();
    final optionsJson = jsonEncode(_controller.options.toJson());
    await prefs.setString(_textOptionsKey, optionsJson);
  }
}
