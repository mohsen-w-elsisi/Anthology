class Highlight {
  final String id;
  final String articleId;
  final String text;
  final int startIndex;
  final int endIndex;
  final String? comment;

  Highlight({
    required this.id,
    required this.articleId,
    required this.text,
    required this.startIndex,
    required this.endIndex,
    this.comment,
  });
}
