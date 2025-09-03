import 'package:anthology_common/highlight/entities.dart';
import 'package:anthology_ui/shared_widgets/utility_modal.dart';
import 'package:flutter/material.dart';

class HighlightDetailModal extends StatelessWidget with UtilityModal {
  final Highlight highlight;

  const HighlightDetailModal(this.highlight, {super.key});

  @override
  String get title => "Highlight";

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: UtilityModal.modalPadding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          modalTitle(context),
          SelectionArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _highlightText(context),
                const SizedBox(height: 16.0),
                _commentText(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Text _highlightText(BuildContext context) => Text(
    '"${highlight.text}"',
    style: Theme.of(context).textTheme.titleSmall,
  );

  Text _commentText(BuildContext context) => Text(
    _commentString,
    style: Theme.of(context).textTheme.bodyMedium,
  );

  String get _commentString => (highlight.comment?.isNotEmpty ?? false)
      ? highlight.comment!
      : 'no comment';
}
