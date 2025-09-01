part of 'entities.dart';

class _ArticleBriefJsonDecoder {
  final Map<String, dynamic> json;

  const _ArticleBriefJsonDecoder(this.json);

  ArticleBrief decode() => ArticleBrief(
    articleId: json['articleId'] as String,
    title: json['title'] as String,
    byline: json['byline'] as String,
    body: [for (final node in json['body'] as List) TextNode.fromJson(node)],
    uri: Uri.parse(json['uri'] as String),
  );
}

class _ArticleBriefJsonEncoder {
  final ArticleBrief brief;

  _ArticleBriefJsonEncoder(this.brief);

  Map<String, dynamic> encode() => {
    'articleId': brief.articleId,
    'title': brief.title,
    'byline': brief.byline,
    'body': [for (final node in brief.body) node.toJson()],
    'uri': brief.uri.toString(),
  };
}

class _TextNodeJsonDecoder {
  final Map<String, dynamic> json;

  const _TextNodeJsonDecoder(this.json);

  TextNode decode() => TextNode(
    text: json['text'] as String,
    type: TextNodeType.values.byName(json['nodeType'] as String),
    bold: json['bold'] as bool,
    italic: json['italic'] as bool,
    startIndex: json['startIndex'] as int,
    endIndex: json['endIndex'] as int,
  );
}

class _TextNodeJsonEncoder {
  final TextNode node;

  _TextNodeJsonEncoder(this.node);

  Map<String, dynamic> encode() => {
    'text': node.text,
    'nodeType': node.type.name,
    'bold': node.bold,
    'italic': node.italic,
    'startIndex': node.startIndex,
    'endIndex': node.endIndex,
  };
}
