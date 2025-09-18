import 'package:anthology_ui/state/tag_selection_controller.dart';
import 'package:anthology_ui/shared_widgets/tag_selector_chips.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ArticleFilterChipsRow<T extends ArticleFilterNotifier>
    extends StatelessWidget {
  const ArticleFilterChipsRow({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<T>();
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _archiveChip(provider),
          const SizedBox(width: 4),
          TagSelectorChips(
            tagSelectionController: provider.tagSelectionController,
          ),
        ],
      ),
    );
  }

  Widget _archiveChip(T provider) {
    return FilterChip(
      avatar: const Icon(Icons.archive_outlined),
      label: const Text('Archived'),
      selected: provider.showArchived,
      onSelected: provider.setShowArchived,
    );
  }
}

mixin ArticleFilterNotifier on ChangeNotifier {
  final TagSelectionController tagSelectionController =
      TagSelectionController();

  bool _showArchived = false;
  bool get showArchived => _showArchived;

  void setShowArchived(bool value) {
    _showArchived = value;
    notifyListeners();
  }

  void initFilterable() {
    tagSelectionController.addListener(notifyListeners);
  }

  void disposeFilterable() {
    tagSelectionController.removeListener(notifyListeners);
    tagSelectionController.dispose();
  }
}
