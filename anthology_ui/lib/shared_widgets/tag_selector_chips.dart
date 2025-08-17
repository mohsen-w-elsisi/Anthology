import 'package:anthology_ui/state/tag_aggregator.dart';
import 'package:anthology_ui/state/tag_selection_controller.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class TagSelectorChips extends StatelessWidget {
  final TagSelectionController tagSelectionController;

  const TagSelectorChips({
    super.key,
    required this.tagSelectionController,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: GetIt.I<TagAggregator>().stream,
      initialData: GetIt.I<TagAggregator>().tags,
      builder: (_, allTagsSnapshot) => StreamBuilder(
        stream: tagSelectionController.stream,
        initialData: tagSelectionController.selectedTags,
        builder: (_, selectedTagsSnapshot) => SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: _TagChipRow(
            tags: allTagsSnapshot.data!.toList(),
            selectionController: tagSelectionController,
          ),
        ),
      ),
    );
  }
}

class _TagChipRow extends StatelessWidget {
  final List<String> tags;
  final TagSelectionController selectionController;

  const _TagChipRow({
    required this.tags,
    required this.selectionController,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final tag in tags)
          _TagChip(
            tag: tag,
            selectionController: selectionController,
          ),
      ],
    );
  }
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
