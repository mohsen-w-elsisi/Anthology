import 'package:copy_with_extension/copy_with_extension.dart';

part 'entities.g.dart';

@CopyWith()
class Article {
  final String id;
  final Uri uri;
  final DateTime dateSaved;
  final Set<String> tags;
  final bool read;
  final double progress;
  final bool isArchived;

  const Article({
    required this.uri,
    required this.id,
    required this.tags,
    required this.dateSaved,
    required this.read,
    required this.progress,
    this.isArchived = false,
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
      "progress": _article.progress,
      "isArchived": _article.isArchived,
    };
  }
}

class ArticleJsonDecoder {
  final Json _json;

  ArticleJsonDecoder(this._json);

  Article decode() {
    return Article(
      id: _json["id"],
      uri: Uri.parse(_json["uri"]),
      tags: (_json["tags"] as Iterable).cast<String>().toSet(),
      dateSaved: DateTime.parse(_json["dateSaved"]),
      read: _json["read"],
      progress: (_json["progress"] as num?)?.toDouble() ?? 0.0,
      isArchived: _json["isArchived"] ?? false,
    );
  }
}

typedef Json = Map<String, dynamic>;
