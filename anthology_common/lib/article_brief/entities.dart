part 'entities.json.dart';

class ArticleBrief {
  final String title;
  final List<TextNode> body;
  final Uri uri;

  const ArticleBrief({
    required this.title,
    required this.body,
    required this.uri,
  });

  factory ArticleBrief.fromJson(Map<String, dynamic> json) =>
      _ArticleBriefJsonDecoder(json).decode();

  Map<String, dynamic> toJson() => _ArticleBriefJsonEncoder(this).encode();
}

class TextNode {
  final String text;
  final TextNodeType nodeType;
  final bool bold;
  final bool italic;

  const TextNode({
    required this.text,
    required this.nodeType,
    required this.bold,
    required this.italic,
  });

  factory TextNode.fromJson(Map<String, dynamic> json) =>
      _TextNodeJsonDecoder(json).decode();

  Map<String, dynamic> toJson() => _TextNodeJsonEncoder(this).encode();
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
