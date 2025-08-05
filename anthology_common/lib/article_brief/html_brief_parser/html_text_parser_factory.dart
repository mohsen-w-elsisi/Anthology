import 'package:anthology_common/article_brief/html_brief_parser/html_elemt_parser_impls.dart';
import 'package:anthology_common/article_brief/html_brief_parser/html_text_element_parser.dart';
import 'package:html/dom.dart';

class HtmlTextParserFactory {
  final Element _htmlElement;
  final String _htmlTag;

  HtmlTextParserFactory(this._htmlElement) : _htmlTag = _htmlElement.localName!;

  HtmlTextElementParser getParser() {
    return switch (_htmlTag) {
      "p" => HtmlParagraphParser(_htmlElement),
      "h1" => HtmlH1Parser(_htmlElement),
      "h2" => HtmlH2Parser(_htmlElement),
      "h3" => HtmlH3Parser(_htmlElement),
      "h4" => HtmlH4Parser(_htmlElement),
      "h5" => HtmlH5Parser(_htmlElement),
      "h6" => HtmlH6Parser(_htmlElement),
      "ul" => HtmlUnorderdListParser(_htmlElement),
      "ol" => HtmlOrderdListParser(_htmlElement),
      _ => throw UnimplementedError("No parser for tag $_htmlTag"),
    };
  }
}
