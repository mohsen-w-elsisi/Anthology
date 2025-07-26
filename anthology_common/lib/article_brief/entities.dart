class ArticleBrief {
  final String title;
  final List<TextNode> body;
  final Uri uri;

  const ArticleBrief({
    required this.title,
    required this.body,
    required this.uri,
  });
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
}

enum TextNodeType {
  heading1,
  heading2,
  heading3,
  heading4,
  heading5,
  heading6,
  body,
}
