import 'package:anthology_ui/state/tag_aggregator.dart';
import 'package:anthology_ui/state/tag_selection_controller.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

enum TagSelectorLayout { horizontal, wrap }

class TagSelectorChips extends StatelessWidget {
  final TagSelectionController tagSelectionController;
  final TagSelectorLayout layout;

  const TagSelectorChips({
    super.key,
    required this.tagSelectionController,
    this.layout = TagSelectorLayout.horizontal,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: GetIt.I<TagAggregator>().stream,
      initialData: GetIt.I<TagAggregator>().tags,
      builder: (_, allTagsSnapshot) => StreamBuilder(
        stream: tagSelectionController.stream,
        initialData: tagSelectionController.selectedTags,
        builder: (_, selectedTagsSnapshot) {
          final chips = _chipsFromTags(allTagsSnapshot.data!);
          if (layout == TagSelectorLayout.horizontal) {
            return Row(children: chips);
          } else {
            return Wrap(
              runSpacing: 8.0,
              children: chips,
            );
          }
        },
      ),
    );
  }

  List<Widget> _chipsFromTags(Set<String> tags) => [
    for (final tag in tags)
      _TagChip(tag: tag, selectionController: tagSelectionController),
  ];
}

class _TagChip extends StatelessWidget {
  final String tag;
  final TagSelectionController selectionController;

  const _TagChip({
    required this.tag,
    required this.selectionController,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: FilterChip(
        label: Text(tag),
        selected: selectionController.isSelected(tag),
        onSelected: (_) => selectionController.toggle(tag),
      ),
    );
  }
}
