import 'package:anthology_common/article_brief/entities.dart';
import 'package:anthology_common/article_brief/html_brief_parser/html_text_element_parser.dart';
import 'package:html/dom.dart';

class HtmlUnorderdListParser extends HtmlListElementParser {
  HtmlUnorderdListParser(super.htmlElement);

  @override
  String get htmlTag => "ul";

  @override
  TextNodeType get nodeType => TextNodeType.unorderedList;

  @override
  String get listLeadingChar => "-";
}

class HtmlOrderdListParser extends HtmlListElementParser {
  HtmlOrderdListParser(super.htmlElement);

  @override
  String get htmlTag => "ol";

  @override
  TextNodeType get nodeType => TextNodeType.orderedList;

  @override
  String get listLeadingChar => "-";
}

abstract class HtmlListElementParser extends HtmlTextElementParser {
  late final List<Element> _listItems;
  String _text = "";

  HtmlListElementParser(super.htmlElement);

  @override
  TextNode parse() {
    _queryListItems();
    _stackListItemsText();
    return TextNode(
      text: _text,
      nodeType: nodeType,
      bold: false,
      italic: false,
    );
  }

  void _queryListItems() {
    _listItems = htmlElement.querySelectorAll("li");
  }

  void _stackListItemsText() {
    for (final listitem in _listItems) {
      _text += "$listLeadingChar ${listitem.text}\n";
    }
  }

  String get listLeadingChar;
}

class HtmlParagraphParser extends HtmlTextElementParser {
  HtmlParagraphParser(super.htmlElement);

  @override
  String get htmlTag => "p";

  @override
  TextNodeType get nodeType => TextNodeType.body;
}

class HtmlH1Parser extends HtmlTextElementParser {
  HtmlH1Parser(super.htmlElement);

  @override
  String get htmlTag => "h1";

  @override
  TextNodeType get nodeType => TextNodeType.heading1;
}

class HtmlH2Parser extends HtmlTextElementParser {
  HtmlH2Parser(super.htmlElement);

  @override
  String get htmlTag => "h2";

  @override
  TextNodeType get nodeType => TextNodeType.heading2;
}

class HtmlH3Parser extends HtmlTextElementParser {
  HtmlH3Parser(super.htmlElement);

  @override
  String get htmlTag => "h3";

  @override
  TextNodeType get nodeType => TextNodeType.heading3;
}

class HtmlH4Parser extends HtmlTextElementParser {
  HtmlH4Parser(super.htmlElement);

  @override
  String get htmlTag => "h4";

  @override
  TextNodeType get nodeType => TextNodeType.heading4;
}

class HtmlH5Parser extends HtmlTextElementParser {
  HtmlH5Parser(super.htmlElement);

  @override
  String get htmlTag => "h5";

  @override
  TextNodeType get nodeType => TextNodeType.heading5;
}

class HtmlH6Parser extends HtmlTextElementParser {
  HtmlH6Parser(super.htmlElement);

  @override
  String get htmlTag => "h6";

  @override
  TextNodeType get nodeType => TextNodeType.heading5;
}
