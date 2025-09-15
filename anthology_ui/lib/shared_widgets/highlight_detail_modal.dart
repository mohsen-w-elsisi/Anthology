import 'dart:io';

import 'package:anthology_common/highlight/entities.dart';
import 'package:anthology_ui/app_actions.dart';
import 'package:anthology_ui/shared_widgets/utility_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HighlightDetailModal extends StatefulWidget with UtilityModal {
  final Highlight highlight;

  const HighlightDetailModal(this.highlight, {super.key});

  @override
  String get title => "Highlight";

  @override
  bool get isScrollable => true;

  @override
  State<HighlightDetailModal> createState() => _HighlightDetailModalState();
}

class _HighlightDetailModalState extends State<HighlightDetailModal> {
  late final TextEditingController _commentController;
  late final FocusNode _commentFocusNode;

  @override
  void initState() {
    super.initState();
    _commentController = TextEditingController(text: widget.highlight.comment);
    _commentFocusNode = FocusNode();
    _commentFocusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _commentFocusNode.removeListener(_onFocusChange);
    _commentFocusNode.dispose();
    _commentController.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (!_commentFocusNode.hasFocus) {
      _saveComment();
    }
  }

  void _saveComment() {
    final newComment = _commentController.text;
    if (newComment != widget.highlight.comment) {
      AppActions.updateHighlightComment(widget.highlight.id, newComment);
    }
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
          SelectionArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _highlightText(context),
                const SizedBox(height: 16.0),
                _commentTextField(context),
                // const Spacer(),
                const SizedBox(height: 16.0),
                _Actions(highlight: widget.highlight),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Text _highlightText(BuildContext context) => Text(
    '"${widget.highlight.text}"',
    style: Theme.of(context).textTheme.titleSmall,
  );

  Widget _commentTextField(BuildContext context) {
    return TextFormField(
      controller: _commentController,
      focusNode: _commentFocusNode,
      keyboardType: TextInputType.multiline,
      maxLines: 5,
      style: Theme.of(context).textTheme.bodyMedium,
      decoration: InputDecoration(
        hintText: 'no comment',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
    );
  }
}

class _Actions extends StatelessWidget {
  final Highlight highlight;

  const _Actions({required this.highlight});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 12.0,
      alignment: WrapAlignment.end,
      children: [
        _closeButton(context),
        const Spacer(),
        _deleteButton(context),
        _revealButton,
        if (Platform.isAndroid) _shareButton,
        _copyButton(context),
      ],
    );
  }

  Widget _closeButton(BuildContext context) => TextButton(
    onPressed: () => Navigator.pop(context),
    child: const Text("Close"),
  );

  Widget _deleteButton(BuildContext context) => FilledButton.tonalIcon(
    onPressed: () => _delete(context),
    label: const Text("Delete"),
    icon: const Icon(Icons.delete_outline),
  );

  Widget get _revealButton => FilledButton.tonalIcon(
    onPressed: _revealInReader,
    label: const Text("Reveal"),
    icon: const Icon(Icons.open_in_new),
  );

  Widget get _shareButton => FilledButton.tonalIcon(
    onPressed: _share,
    label: const Text("Share"),
    icon: const Icon(Icons.share_outlined),
  );

  Widget _copyButton(BuildContext context) => FilledButton.icon(
    onPressed: () => _copy(context),
    label: const Text("Copy"),
    icon: const Icon(Icons.copy),
  );

  void _delete(BuildContext context) async {
    AppActions.deleteHighlight(highlight.id);
    if (context.mounted) Navigator.pop(context);
  }

  void _revealInReader() {} // Reveal intentionally left unimplemented

  void _share() => AppActions.shareHighlight(highlight);

  void _copy(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: highlight.text));
    if (context.mounted) {
      ScaffoldMessenger.maybeOf(context)?.showSnackBar(
        const SnackBar(content: Text('Copied to clipboard.')),
      );
    }
  }
}
