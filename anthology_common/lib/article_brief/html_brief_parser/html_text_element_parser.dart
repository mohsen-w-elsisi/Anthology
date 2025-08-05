import 'package:html/dom.dart';
import 'package:anthology_common/article_brief/entities.dart';

abstract class HtmlTextElementParser {
  final Element _htmlElement;

  HtmlTextElementParser(this._htmlElement) {
    assert(
      _htmlElement.localName == htmlTag,
      ElementParserMismatchError(
        parserTag: htmlTag,
        elementTag: _htmlElement.localName!,
      ),
    );
  }

  TextNode parse() {
    final elementText = _htmlElement.text;
    return TextNode(
      text: elementText,
      nodeType: nodeType,
      bold: false,
      italic: false,
    );
  }

  TextNodeType get nodeType;

  String get htmlTag;
}

class ElementParserMismatchError extends TypeError {
  final String parserTag;
  final String elementTag;

  ElementParserMismatchError({
    required this.parserTag,
    required this.elementTag,
  }) : super();

  @override
  String toString() {
    return 'parser accepts $parserTag but element is $elementTag';
  }
}
