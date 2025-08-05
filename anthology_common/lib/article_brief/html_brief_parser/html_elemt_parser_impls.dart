import 'package:anthology_common/article_brief/entities.dart';
import 'package:anthology_common/article_brief/html_brief_parser/html_text_element_parser.dart';

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
