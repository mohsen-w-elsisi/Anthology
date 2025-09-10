import 'package:anthology_common/highlight/entities.dart';
import 'package:anthology_ui/app_actions.dart';
import 'package:anthology_ui/shared_widgets/utility_modal.dart';
import 'package:flutter/material.dart';

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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _highlightText(context),
                const SizedBox(height: 16.0),
                _commentTextField(context),
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
