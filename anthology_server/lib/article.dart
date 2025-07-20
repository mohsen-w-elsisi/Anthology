class Article {
  final String name;

  const Article({required this.name});

  factory Article.fromJson(Json json) => ArticleJsonDecoder(json).decode();

  Json toJson() => ArticleJsonEncoder(this).encode();
}

class ArticleJsonEncoder {
  final Article _article;

  ArticleJsonEncoder(this._article);

  Map<String, dynamic> encode() {
    return {"name": _article.name};
  }
}

class ArticleJsonDecoder {
  final Json _json;

  ArticleJsonDecoder(this._json);

  Article decode() {
    return Article(name: _json["name"]);
  }
}

typedef Json = Map<String, dynamic>;
