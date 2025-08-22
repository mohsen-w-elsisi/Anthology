import 'package:flutter/material.dart';

import 'text_options_controller.dart';

class TextOptionsModal extends StatelessWidget {
  final TextOptionsController textOptionsController;

  const TextOptionsModal(this.textOptionsController, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Text Options', style: TextTheme.of(context).headlineLarge),
          const SizedBox(height: 16.0),
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        RoundedSquareTonalButton(
          onPressed: textOptionsController.increaseScale,
          child: const Icon(Icons.add),
        ),
        _scaleLabel(context),
        RoundedSquareTonalButton(
          onPressed: textOptionsController.decreaseScale,
          child: const Icon(Icons.remove),
        ),
      ],
    );
  }

  Widget _scaleLabel(BuildContext context) {
    return SizedBox(
      width: 100,
      child: ListenableBuilder(
        listenable: textOptionsController,
        builder: (_, _) => Text(
          "x${textOptionsController.options.textScaleFactor}".substring(0, 4),
          style: TextTheme.of(context).headlineSmall,
        ),
      ),
    );
  }
}

class RoundedSquareTonalButton extends StatelessWidget {
  final Function()? onPressed;
  final Widget? child;

  const RoundedSquareTonalButton({super.key, this.onPressed, this.child});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: AspectRatio(
        aspectRatio: 5 / 3,
        child: FilledButton.tonal(
          onPressed: onPressed,
          style: FilledButton.styleFrom(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(8.0),
              ),
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
