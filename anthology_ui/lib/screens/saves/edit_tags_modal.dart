import 'package:anthology_common/article/entities.dart';
import 'package:anthology_ui/app_actions.dart';
import 'package:anthology_ui/shared_widgets/tag_selector_chips.dart';
import 'package:anthology_ui/shared_widgets/new_tag_button.dart';
import 'package:anthology_ui/shared_widgets/utility_modal.dart';
import 'package:anthology_ui/state/tag_aggregator.dart';
import 'package:anthology_ui/state/tag_selection_controller.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class EditTagsModal extends StatefulWidget with UtilityModal {
  final Article article;

  const EditTagsModal({required this.article, super.key});

  @override
  String get title => 'Edit tags';

  @override
  bool get isScrollable => true;

  @override
  State<EditTagsModal> createState() => _EditTagsModalState();
}

class _EditTagsModalState extends State<EditTagsModal> {
  late final TagSelectionController _tagSelectionController;

  @override
  void initState() {
    super.initState();
    _tagSelectionController = TagSelectionController(
      initialTags: widget.article.tags,
    );
  }

  @override
  void dispose() {
    _tagSelectionController.dispose();
    GetIt.I<TagAggregator>().clearUnsavedTags();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: UtilityModal.modalPadding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          widget.modalTitle(context),
          _TagSelector(_tagSelectionController),
          const SizedBox(height: 24),
          _actionButtons(context),
        ],
      ),
    );
  }

  Widget _actionButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
        const SizedBox(width: 8),
        FilledButton(
          onPressed: _applyChanges,
          child: const Text('Apply'),
        ),
      ],
    );
  }

  void _applyChanges() {
    AppActions.updateArticleTags(
      widget.article.id,
      _tagSelectionController.selectedTags,
    );
    Navigator.pop(context);
  }
}

class _TagSelector extends StatelessWidget {
  final TagSelectionController tagSelectionController;

  const _TagSelector(this.tagSelectionController);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8.0,
      children: [
        TagSelectorChips(
          tagSelectionController: tagSelectionController,
          layout: TagSelectorLayout.wrap,
        ),
        NewTagButton(
          tagSelectionController: tagSelectionController,
        ),
      ],
    );
  }
}
