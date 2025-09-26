import 'package:anthology_common/highlight/entities.dart';
import 'package:anthology_ui/shared_widgets/highlight_detail_modal.dart';
import 'package:anthology_ui/shared_widgets/utility_modal.dart';
import 'package:flutter/material.dart';

class HighlightsModal extends StatelessWidget with UtilityModal {
  final List<Highlight> highlights;

  const HighlightsModal({super.key, required this.highlights});

  @override
  String get title => "Highlights";

  @override
  bool get isScrollable => true;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          modalTitle(context),
          for (final highlight in highlights) HighlightCard(highlight),
        ],
      ),
    );
  }
}

class HighlightCard extends StatelessWidget {
  final Highlight highlight;

  const HighlightCard(this.highlight, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(9.0),
      child: ListTile(
        onTap: () => HighlightDetailModal(highlight).show(),
        title: Text(highlight.text),
        subtitle: highlight.comment != null ? Text(highlight.comment!) : null,
      ),
    );
  }
}
