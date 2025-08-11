class ArticleNotFoundError extends StateError {
  final String id;

  ArticleNotFoundError(this.id) : super("article with id $id not saved");
}

class HighlightNotFoundError extends StateError {
  final String id;

  HighlightNotFoundError(this.id) : super("highlight with id $id not saved");
}

class FeedNotFoundError extends StateError {
  final String id;

  FeedNotFoundError(this.id) : super("feed with id $id not saved");
}
