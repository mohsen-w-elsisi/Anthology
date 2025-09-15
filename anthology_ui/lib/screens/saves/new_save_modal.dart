import 'package:anthology_common/article/entities.dart';
import 'package:anthology_ui/app_actions.dart';
import 'package:anthology_ui/shared_widgets/tag_selector_chips.dart';
import 'package:anthology_ui/shared_widgets/new_tag_button.dart';
import 'package:anthology_ui/shared_widgets/utility_modal.dart';
import 'package:anthology_ui/state/tag_aggregator.dart';
import 'package:anthology_ui/state/tag_selection_controller.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class NewSaveModal extends StatefulWidget with UtilityModal {
  final String? initialUrl;

  const NewSaveModal({super.key, this.initialUrl});

  @override
  String get title => 'Save article';

  @override
  State<NewSaveModal> createState() => _NewSaveModalState();
}

class _NewSaveModalState extends State<NewSaveModal> {
  final _tagSelectionController = TagSelectionController();
  final _controller = TextEditingController();
  bool _showInvalidUriText = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialUrl != null) _controller.text = widget.initialUrl!;
  }

  @override
  void dispose() {
    _controller.dispose();
    _tagSelectionController.dispose();
    GetIt.I<TagAggregator>().clearUnsavedTags();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: UtilityModal.modalPadding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          widget.modalTitle(context),
          _textField,
          const SizedBox(height: 16.0),
          _TageSelector(_tagSelectionController),
          const Spacer(),
          _submitButton,
        ],
      ),
    );
  }

  Widget get _textField => TextField(
    controller: _controller,
    autofocus: true,
    decoration: InputDecoration(
      labelText: 'Article URL',
      hintText: 'https://example.com/article',
      errorText: _showInvalidUriText ? 'Please enter a valid URL' : null,
    ),
    onSubmitted: (_) => _submit(),
  );

  Widget get _submitButton => FilledButton(
    onPressed: _submit,
    child: const Text('Save'),
  );

  void _submit() {
    final inputText = _controller.text.trim();
    final urlRegex = RegExp(
      r'^(https?|ftp)://[^\s/$.?#].[^\s]*$',
      caseSensitive: false,
    );
    if (urlRegex.hasMatch(inputText)) {
      final article = Article(
        uri: Uri.parse(inputText),
        id: DateTime.now().toIso8601String(),
        tags: _tagSelectionController.selectedTags,
        dateSaved: DateTime.now(),
        read: false,
        progress: 0,
        isArchived: false,
      );
      AppActions.saveArticle(article);
      Navigator.pop(context);
    } else {
      setState(() => _showInvalidUriText = true);
    }
  }
}

class _TageSelector extends StatelessWidget {
  final TagSelectionController tagSelectionController;

  const _TageSelector(this.tagSelectionController, {super.key});

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
