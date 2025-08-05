import 'package:html/dom.dart';
import 'package:anthology_common/article_brief/entities.dart';

abstract class HtmlTextElementParser {
  final Element htmlElement;

  HtmlTextElementParser(this.htmlElement) {
    assert(
      htmlElement.localName == htmlTag,
      ElementParserMismatchError(
        parserTag: htmlTag,
        elementTag: htmlElement.localName!,
      ),
    );
  }

  TextNode parse() {
    final elementText = htmlElement.text;
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
