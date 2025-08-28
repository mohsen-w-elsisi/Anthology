import 'package:flutter/material.dart';

mixin ReaderScreenUtilityModal on Widget {
  static const modalPadding = EdgeInsets.all(8.0);
  static const _breakpoint = 600.0;

  void show(BuildContext context) {
    if (_screenIsSmall(context)) {
      _showBottomSheet(context);
    } else {
      _showDialog(context);
    }
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: isScrollable,
      builder: (_) => this,
    );
  }

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(content: this),
    );
  }

  bool get isScrollable => false;

  bool _screenIsSmall(BuildContext context) =>
      _screenWidth(context) < _breakpoint;

  num _screenWidth(BuildContext context) => MediaQuery.of(context).size.width;

  Widget modalTitle(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 16.0),
    child: Text(
      title,
      textAlign: TextAlign.center,
      style: TextTheme.of(context).headlineLarge,
    ),
  );

  String get title;
}
