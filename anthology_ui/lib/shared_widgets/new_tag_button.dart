import 'package:anthology_ui/state/tag_aggregator.dart';
import 'package:anthology_ui/state/tag_selection_controller.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class NewTagButton extends StatelessWidget {
  final TagSelectionController tagSelectionController;

  const NewTagButton({super.key, required this.tagSelectionController});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () => _addNewTag(context),
      label: const Text("New tag"),
      icon: const Icon(Icons.add),
    );
  }

  void _addNewTag(BuildContext context) => showDialog(
    context: context,
    builder: (context) => _NewTagModal(
      tagSelectionController: tagSelectionController,
    ),
  );
}

class _NewTagModal extends StatefulWidget {
  final TagSelectionController tagSelectionController;

  const _NewTagModal({required this.tagSelectionController});

  @override
  State<_NewTagModal> createState() => _NewTagModalState();
}

class _NewTagModalState extends State<_NewTagModal> {
  String _tagName = "";

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("New tag"),
      content: TextField(
        decoration: const InputDecoration(hintText: "Tag name"),
        autofocus: true,
        onChanged: (value) => setState(() => _tagName = value.trim()),
        onSubmitted: (_) => _saveNewTag(),
      ),
      actions: [
        TextButton(onPressed: _closeModal, child: const Text("Cancel")),
        FilledButton.tonal(
          onPressed: _saveNewTag,
          child: const Text("Add tag"),
        ),
      ],
    );
  }

  void _saveNewTag() {
    if (_tagName.isNotEmpty) {
      GetIt.I<TagAggregator>().addNewTag(_tagName);
      widget.tagSelectionController.select(_tagName);
    }
    _closeModal();
  }

  void _closeModal() => Navigator.pop(context);
}
