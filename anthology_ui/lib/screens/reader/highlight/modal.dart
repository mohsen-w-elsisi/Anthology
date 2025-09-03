import 'package:anthology_common/highlight/entities.dart';
import 'package:anthology_ui/screens/highlights/highlight_detail_modal.dart';
import 'package:anthology_ui/screens/reader/highlight/provider.dart';
import 'package:anthology_ui/shared_widgets/utility_modal.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class HighlightsModal extends StatelessWidget with UtilityModal {
  const HighlightsModal({super.key});

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
          for (final highlight in _highlights) HighlightCard(highlight),
        ],
      ),
    );
  }

  List<Highlight> get _highlights =>
      GetIt.I<ReaderScreenHighlightProvider>().highlights;
}

class HighlightCard extends StatelessWidget {
  final Highlight highlight;

  const HighlightCard(this.highlight, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(9.0),
      child: ListTile(
        onTap: () => HighlightDetailModal(highlight).show(context),
        title: Text(highlight.text),
        subtitle: highlight.comment != null ? Text(highlight.comment!) : null,
      ),
    );
  }
}
