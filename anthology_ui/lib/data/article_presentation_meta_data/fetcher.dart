import 'package:anthology_common/article/entities.dart';
import 'package:anthology_ui/data/article_presentation_meta_data/cache.dart';
import 'package:get_it/get_it.dart';
import 'package:html/dom.dart' as dom;
import 'package:http/http.dart' as http;

import 'entities.dart';

class ArticlePresentationMetaDataFetcher {
  final Article article;
  ArticlePresentationMetaData? _metaData;

  final _cache = GetIt.I<ArticlePresentationMetaDataCache>();

  ArticlePresentationMetaDataFetcher(this.article);

  ArticlePresentationMetaData get metaData {
    return _metaData ?? ArticlePresentationMetaData(title: 'Loading...');
  }

  Future<void> fetch() async {
    if (_metaData != null) return;
    if (await _cache.isCached(article.id)) {
      _metaData = await _cache.getCached(article.id);
    } else {
      await _getMetaDataFromNetwork();
    }
  }

  Future<void> _getMetaDataFromNetwork() async {
    final res = await http.get(article.uri);
    assert(res.headers['content-type']?.startsWith('text/html') ?? false);
    final document = dom.Document.html(res.body);
    _constructMetaDataFromDom(document);
    await _cache.cache(article.id, metaData);
  }

  void _constructMetaDataFromDom(dom.Document document) {
    _metaData = ArticlePresentationMetaData(
      title: document.querySelector("title")!.text,
      image: document
          .querySelector("meta[property='og:image']")
          ?.attributes['content'],
    );
  }
}
