import 'dart:async';

import 'package:anthology_ui/state/article_ui_notifier.dart';
import 'package:collection/collection.dart';
import 'package:anthology_common/article/data_gaetway.dart';
import 'package:get_it/get_it.dart';

class TagAggregator {
  final ArticleDataGateway _articleDataGateway;
  final _controller = StreamController<Set<String>>.broadcast();

  final Set<String> _transientTags = {};
  Set<String> _persistentTags = {};

  TagAggregator(this._articleDataGateway);

  Stream<Set<String>> get stream => _controller.stream;

  Set<String> get tags =>
      Set.unmodifiable(_persistentTags.union(_transientTags));

  Future<void> init() async {
    await _updateTags();
    GetIt.I<ArticleUiNotifier>().addListener(_updateTags);
  }

  void dispose() {
    _controller.close();
    GetIt.I<ArticleUiNotifier>().removeListener(_updateTags);
  }

  Future<void> refresh() async => await _updateTags();

  void addNewTag(String tag) {
    if (!_persistentTags.contains(tag)) {
      _transientTags.add(tag);
      _updateListeners();
    }
  }

  void clearUnsavedTags() {
    _transientTags.clear();
    _updateListeners();
  }

  Future<void> _updateTags() async {
    final articles = await _articleDataGateway.getAll();
    final newPersistentTags = articles
        .expand((article) => article.tags)
        .toSet();

    final oldCombinedTags = tags;

    _persistentTags = newPersistentTags;
    _transientTags.removeAll(_persistentTags);

    if (!SetEquality().equals(oldCombinedTags, tags)) {
      _updateListeners();
    }
  }

  void _updateListeners() => _controller.add(tags);
}
