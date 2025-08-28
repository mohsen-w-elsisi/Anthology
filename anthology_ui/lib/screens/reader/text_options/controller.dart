import 'package:flutter/material.dart';

import 'text_options.dart';

class TextOptionsController with ChangeNotifier {
  static const double minScale = 0.5;
  static const double maxScale = 2.0;

  ReaderViewTextOptions _options;

  TextOptionsController(this._options);

  TextOptionsController.inital() : _options = const ReaderViewTextOptions();

  ReaderViewTextOptions get options => _options;

  void increaseScale() {
    if (_options.textScaleFactor < maxScale) {
      _options = ReaderViewTextOptions(
        textScaleFactor: (_options.textScaleFactor + 0.1).clamp(
          minScale,
          maxScale,
        ),
      );
      notifyListeners();
    }
  }

  void decreaseScale() {
    if (_options.textScaleFactor > minScale) {
      _options = ReaderViewTextOptions(
        textScaleFactor: (_options.textScaleFactor - 0.1).clamp(
          minScale,
          maxScale,
        ),
      );
      notifyListeners();
    }
  }
}
