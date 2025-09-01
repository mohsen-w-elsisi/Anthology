part 'entities.json.dart';

class ArticleBrief {
  final String articleId;
  final String title;
  final String byline;
  final List<TextNode> body;
  final Uri uri;

  const ArticleBrief({
    required this.articleId,
    required this.title,
    required this.byline,
    required this.body,
    required this.uri,
  });

  String get text => body.map((node) => node.text).join();

  factory ArticleBrief.fromJson(Map<String, dynamic> json) =>
      _ArticleBriefJsonDecoder(json).decode();

  Map<String, dynamic> toJson() => _ArticleBriefJsonEncoder(this).encode();
}

class TextNode {
  final String text;
  final TextNodeType type;
  final bool bold;
  final bool italic;
  final int? _startIndex;
  final int? _endIndex;

  const TextNode({
    required this.text,
    required this.type,
    required this.bold,
    required this.italic,
    required int startIndex,
    required int endIndex,
  }) : _startIndex = startIndex,
       _endIndex = endIndex;

  const TextNode.indexless({
    required this.text,
    required this.type,
    required this.bold,
    required this.italic,
  }) : _startIndex = null,
       _endIndex = null;

  factory TextNode.fromJson(Map<String, dynamic> json) =>
      _TextNodeJsonDecoder(json).decode();

  Map<String, dynamic> toJson() => _TextNodeJsonEncoder(this).encode();

  int get startIndex {
    if (_startIndex != null) {
      return _startIndex;
    } else {
      throw StateError('startIndex not available for indexless TextNode');
    }
  }

  int get endIndex {
    if (_endIndex != null) {
      return _endIndex;
    } else {
      throw StateError('endIndex not available for indexless TextNode');
    }
  }
}

enum TextNodeType {
  heading1,
  heading2,
  heading3,
  heading4,
  heading5,
  heading6,
  body,
  orderedList,
  unorderedList,
}
