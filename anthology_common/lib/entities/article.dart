class Article {
  final String id;
  final Uri uri;
  final DateTime dateSaved;
  final Set<String> tags;
  final bool read;

  const Article({
    required this.uri,
    required this.id,
    required this.tags,
    required this.dateSaved,
    required this.read,
  });

  factory Article.fromJson(Json json) => ArticleJsonDecoder(json).decode();

  Json toJson() => ArticleJsonEncoder(this).encode();
}

class ArticleJsonEncoder {
  final Article _article;

  ArticleJsonEncoder(this._article);

  Map<String, dynamic> encode() {
    return {
      "id": _article.id,
      "uri": _article.uri.toString(),
      "dateSaved": _article.dateSaved.toIso8601String(),
      "tags": _article.tags.toList(),
      "read": _article.read,
    };
  }
}

class ArticleJsonDecoder {
  final Json _json;

  ArticleJsonDecoder(this._json);

  Article decode() {
    return Article(
      id: _json["id"],
      uri: Uri.dataFromString(_json["uri"]),
      tags: (_json["tags"] as Iterable).cast<String>().toSet(),
      dateSaved: DateTime.parse(_json["dateSaved"]),
      read: _json["read"],
    );
  }
}

typedef Json = Map<String, dynamic>;
