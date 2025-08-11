import '../entities.dart';

abstract class FeedHandler {
  final Feed _feed;

  FeedHandler(this._feed) {
    _validateFeedType();
  }

  Future<List<FeedItem>> getItems();
  Future<void> setAsSeen();
  Future<Uri> getItemSourceUri(FeedItem item);

  FeedType get type;

  void _validateFeedType() {
    if (_feed.type != type) throw HandlerFeedMismatchError(type, _feed.type);
  }
}

class HandlerFeedMismatchError extends TypeError {
  final FeedType _handlerType;
  final FeedType _feedType;

  HandlerFeedMismatchError(this._handlerType, this._feedType);

  @override
  String toString() =>
      "feed of type $_feedType was passed to handler of type $_handlerType";
}
