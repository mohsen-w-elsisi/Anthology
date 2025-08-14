import 'package:anthology_common/article/entities.dart';
import 'package:html/dom.dart' as dom;
import 'package:http/http.dart' as http;

class ArticlePresentationMetaDataFetcher {
  final Article article;
  late final dom.Document _document;
  bool _dataIsFetched = false;

  ArticlePresentationMetaDataFetcher(this.article);

  Future<void> fetch() async {
    await _getDom();
    _dataIsFetched = true;
  }

  Future<void> _getDom() async {
    final res = await http.get(article.uri);
    assert(res.headers['content-type']?.startsWith('text/html') ?? false);
    _document = dom.Document.html(res.body);
  }

  String get title {
    if (_dataIsFetched) {
      return _document.querySelector("title")!.text;
    } else {
      return 'Loading...';
    }
  }

  String? get image {
    if (!_dataIsFetched) return null;
    final imageElement = _document.querySelector("meta[property='og:image']");
    return imageElement?.attributes['content'];
  }
}
