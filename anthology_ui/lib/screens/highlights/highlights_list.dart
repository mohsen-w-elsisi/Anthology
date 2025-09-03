import 'package:anthology_common/highlight/entities.dart';
import 'package:flutter/material.dart';

class HighlightsList extends StatefulWidget {
  final List<Highlight> highlights;
  final ValueNotifier<bool> isExpanded;

  const HighlightsList({
    required this.highlights,
    required this.isExpanded,
    super.key,
  });

  @override
  State<HighlightsList> createState() => _HighlightsListState();
}

class _HighlightsListState extends State<HighlightsList>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.fastOutSlowIn,
    );
    _updateExpansionStatus();
    widget.isExpanded.addListener(_updateExpansionStatus);
  }

  @override
  void dispose() {
    widget.isExpanded.removeListener(_updateExpansionStatus);
    _controller.dispose();
    super.dispose();
  }

  void _updateExpansionStatus() {
    if (widget.isExpanded.value) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: SizeTransition(
        sizeFactor: _animation,
        child: ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          itemCount: widget.highlights.length,
          separatorBuilder: (_, _) => const Divider(),
          itemBuilder: (_, i) => _HighlightTile(
            highlight: widget.highlights[i],
          ),
        ),
      ),
    );
  }
}

class _HighlightTile extends StatelessWidget {
  final Highlight highlight;

  const _HighlightTile({super.key, required this.highlight});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        highlight.text,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: highlight.comment == null
          ? null
          : Text(
              highlight.comment!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
    );
  }
}
