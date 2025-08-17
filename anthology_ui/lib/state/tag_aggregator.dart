import 'dart:async';

import 'package:collection/collection.dart';
import 'package:anthology_common/article/data_gaetway.dart';

class TagAggregator {
  final ArticleDataGateway _articleDataGateway;
  final _controller = StreamController<Set<String>>.broadcast();
  Set<String> _tags = {};

  TagAggregator(this._articleDataGateway);

  Stream<Set<String>> get stream => _controller.stream;

  Set<String> get tags => Set.unmodifiable(_tags);

  Future<void> init() async => await _updateTags();

  Future<void> refresh() async => await _updateTags();

  Future<void> _updateTags() async {
    final articles = await _articleDataGateway.getAll();
    final newTags = articles.expand((article) => article.tags).toSet();
    if (!SetEquality().equals(newTags, _tags)) {
      _tags = newTags;
      _controller.add(tags);
    }
  }

  void dispose() => _controller.close();
}
