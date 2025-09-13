import 'package:anthology_common/article_brief/html_brief_parser/html_text_parser_factory.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart' as html;

import '../entities.dart';

class Htmlbriefparser {
  static const _contentElementQuerySelector =
      "p, h1, h2, h3, h4, h5, h6, ul, ol, img";

  final DocumentFragment _domFragment;
  late final List<Element> _contentElements;

  Htmlbriefparser(String htmlString)
    : _domFragment = html.parseFragment(htmlString);

  List<TextNode> parse() {
    _queryContentElements();
    return _contentElements.map(_processElementToTextNode).toList();
  }

  void _queryContentElements() {
    _contentElements = _domFragment.querySelectorAll(
      _contentElementQuerySelector,
    );
  }

  TextNode _processElementToTextNode(Element element) {
    return HtmlTextParserFactory(element).getParser().parse();
  }
}
