import 'package:anthology_ui/shared_widgets/utility_modal.dart';
import 'package:flutter/material.dart';

import 'controller.dart';

class TextOptionsModal extends StatelessWidget with UtilityModal {
  final TextOptionsController textOptionsController;

  const TextOptionsModal(this.textOptionsController, {super.key});

  @override
  String get title => "Text Options";

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: UtilityModal.modalPadding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          modalTitle(context),
          Text("Text size", style: TextTheme.of(context).headlineSmall),
          _TextScaleControls(textOptionsController),
        ],
      ),
    );
  }
}

class _TextScaleControls extends StatelessWidget {
  final TextOptionsController textOptionsController;

  const _TextScaleControls(this.textOptionsController);

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: textOptionsController,
      builder: (context, child) {
        final scaleFactor = textOptionsController.options.textScaleFactor;
        return Slider(
          padding: EdgeInsets.symmetric(vertical: 8),
          value: scaleFactor,
          min: TextOptionsController.minScale,
          max: TextOptionsController.maxScale,
          divisions: _divisions,
          label: "x${scaleFactor.toStringAsFixed(1)}",
          onChanged: textOptionsController.updateScale,
        );
      },
    );
  }

  int get _divisions =>
      ((TextOptionsController.maxScale - TextOptionsController.minScale) / 0.1)
          .round();
}
