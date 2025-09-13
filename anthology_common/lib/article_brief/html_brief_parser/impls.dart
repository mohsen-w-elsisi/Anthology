import 'package:anthology_common/article_brief/entities.dart';
import 'package:anthology_common/article_brief/html_brief_parser/html_text_element_parser.dart';
import 'package:html/dom.dart';

class HtmlImageParser extends HtmlTextElementParser {
  HtmlImageParser(super.htmlElement);

  @override
  String get htmlTag => "img";

  @override
  TextNodeType get nodeType => TextNodeType.image;

  @override
  TextNode parse() {
    final src = htmlElement.attributes['src'];
    print("shoud parse image with url $src");
    return TextNode.indexless(text: "", type: nodeType, data: src);
  }
}

class HtmlUnorderdListParser extends HtmlListElementParser {
  HtmlUnorderdListParser(super.htmlElement);

  @override
  String get htmlTag => "ul";

  @override
  TextNodeType get nodeType => TextNodeType.unorderedList;

  @override
  String _bullet(int index) => "•";
}

class HtmlOrderdListParser extends HtmlListElementParser {
  HtmlOrderdListParser(super.htmlElement);

  @override
  String get htmlTag => "ol";

  @override
  TextNodeType get nodeType => TextNodeType.orderedList;

  @override
  String _bullet(int index) => "${index + 1}.";
}

abstract class HtmlListElementParser extends HtmlTextElementParser {
  late final List<Element> _listItems;
  String _text = "";

  HtmlListElementParser(super.htmlElement);

  @override
  TextNode parse() {
    _queryListItems();
    _stackListItemsText();
    return TextNode.indexless(text: _text, type: nodeType);
  }

  void _queryListItems() {
    _listItems = htmlElement.querySelectorAll("li");
  }

  void _stackListItemsText() {
    final formattedItems = <String>[];
    for (int i = 0; i < _listItems.length; i++) {
      final listItem = _listItems[i];
      final itemText = listItem.text.trim();
      if (itemText.isNotEmpty) {
        final bullet = _bullet(i);
        formattedItems.add("$bullet $itemText");
      }
    }
    _text = formattedItems.join('\n');
  }

  String _bullet(int index);
}

class HtmlParagraphParser extends HtmlTextElementParser {
  HtmlParagraphParser(super.htmlElement);

  @override
  TextNode parse() {
    final elementText = htmlElement.text.endsWith("\n")
        ? htmlElement.text
        : "${htmlElement.text}\n";
    return TextNode.indexless(text: elementText, type: nodeType);
  }

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
  TextNodeType get nodeType => TextNodeType.heading6;
}
