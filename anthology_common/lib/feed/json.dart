part of 'entities.dart';

class _FeedJsonEncoder {
  final Feed feed;

  _FeedJsonEncoder(this.feed);

  Map<String, dynamic> encode() {
    return {
      'id': feed.id,
      'name': feed.name,
      'type': feed.type.name,
      if (feed.data != null) 'data': base64Encode(feed.data!),
    };
  }
}

class _FeedJsonDecoder {
  final Map<String, dynamic> json;

  _FeedJsonDecoder(this.json);

  Feed decode() {
    return Feed(
      id: json['id'] as String,
      name: json['name'] as String,
      type: FeedType.values.byName(json['type'] as String),
      data: json['data'] != null ? base64Decode(json['data'] as String) : null,
    );
  }
}

class _FeedItemJsonEncoder {
  final FeedItem item;

  _FeedItemJsonEncoder(this.item);

  Map<String, dynamic> encode() {
    return {
      'id': item.id,
      'name': item.name,
      'isSeen': item.isSeen,
      'displayImage': base64Encode(item.displayImage),
      'date': item.date.toIso8601String(),
    };
  }
}

class _FeedItemJsonDecoder {
  final Map<String, dynamic> json;

  _FeedItemJsonDecoder(this.json);

  FeedItem decode() {
    return FeedItem(
      id: json['id'] as String,
      name: json['name'] as String,
      isSeen: json['isSeen'] as bool,
      displayImage: base64Decode(json['displayImage'] as String),
      date: DateTime.parse(json['date'] as String),
    );
  }
}
