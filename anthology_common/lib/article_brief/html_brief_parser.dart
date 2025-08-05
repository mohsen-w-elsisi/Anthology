import 'package:html/dom.dart';
import 'package:html/parser.dart' as html;

import 'entities.dart';

class Htmlbriefparser {
  static const _contentElementQuerySelector = "p, h1, h2, h3, h4, h5, h6";

  static const _elementNodeTypeMap = {
    "p": TextNodeType.body,
    "h1": TextNodeType.heading1,
    "h2": TextNodeType.heading2,
    "h3": TextNodeType.heading3,
    "h4": TextNodeType.heading4,
    "h5": TextNodeType.heading5,
    "h6": TextNodeType.heading6,
  };

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
    return TextNode(
      text: element.text,
      nodeType: _elementNodeTypeMap[element.localName]!,
      bold: false,
      italic: false,
    );
  }
}
