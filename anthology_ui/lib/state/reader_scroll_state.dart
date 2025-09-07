class ReaderScrollState {
  final Map<String, double> _scrollOffsets = {};

  double getOffset(String articleId) => _scrollOffsets[articleId] ?? 0.0;

  void setOffset(String articleId, double offset) {
    _scrollOffsets[articleId] = offset;
  }
}
