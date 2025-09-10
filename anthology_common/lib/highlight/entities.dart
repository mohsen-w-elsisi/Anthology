import 'package:anthology_common/article/entities.dart';
import 'package:copy_with_extension/copy_with_extension.dart';

part 'entities.g.dart';

@CopyWith()
class Highlight {
  final String id;
  final String articleId;
  final String text;
  final int startIndex;
  final int endIndex;
  final String? comment;

  const Highlight({
    required this.id,
    required this.articleId,
    required this.text,
    required this.startIndex,
    required this.endIndex,
    this.comment,
  });

  factory Highlight.fromJson(Json json) => _JsonDecoder(json).decode();

  Json toJson() => _JsonEncoder(this).encode();
}

class _JsonEncoder {
  final Highlight _highlight;

  _JsonEncoder(this._highlight);

  Json encode() => {
    "id": _highlight.id,
    "articleId": _highlight.articleId,
    "text": _highlight.text,
    "comment": _highlight.comment,
    "startIndex": _highlight.startIndex,
    "endIndex": _highlight.endIndex,
  };
}

class _JsonDecoder {
  final Json _json;

  _JsonDecoder(this._json);

  Highlight decode() => Highlight(
    id: _json["id"],
    articleId: _json["articleId"],
    text: _json["text"],
    comment: _json["comment"],
    startIndex: _json["startIndex"],
    endIndex: _json["endIndex"],
  );
}
