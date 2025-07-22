class ArticleNotFoundError extends StateError {
  final String id;

  ArticleNotFoundError(this.id) : super("article with id $id not saved");
}
