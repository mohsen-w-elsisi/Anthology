import 'package:flutter/material.dart';

class ShowHighlightsButton extends StatelessWidget {
  final ValueNotifier<bool> isExpanded;

  const ShowHighlightsButton({super.key, required this.isExpanded});

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      style: FilledButton.styleFrom(
        visualDensity: VisualDensity.comfortable,
        iconAlignment: IconAlignment.end,
      ),
      onPressed: () => isExpanded.value = !isExpanded.value,
      icon: ValueListenableBuilder(
        valueListenable: isExpanded,
        builder: (_, isExpanded, __) =>
            _AnimatedExpandIcon(isExpanded: isExpanded),
      ),
      label: const Text("show highlights"),
    );
  }
}

class _AnimatedExpandIcon extends StatefulWidget {
  final bool isExpanded;

  const _AnimatedExpandIcon({required this.isExpanded});

  @override
  State<_AnimatedExpandIcon> createState() => _AnimatedExpandIconState();
}

class _AnimatedExpandIconState extends State<_AnimatedExpandIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    if (widget.isExpanded) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(_AnimatedExpandIcon oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isExpanded != oldWidget.isExpanded) {
      if (widget.isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: Tween(begin: 0.0, end: -0.5).animate(_controller),
      child: const Icon(Icons.expand_more),
    );
  }
}
