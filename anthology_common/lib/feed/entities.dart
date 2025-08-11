import 'dart:typed_data';
import 'dart:convert';

part 'json.dart';

class Feed {
  final String id;
  final String name;
  final FeedType type;
  final Uint8List? data;

  const Feed({
    required this.id,
    required this.name,
    required this.type,
    this.data,
  });

  factory Feed.fromJson(Map<String, dynamic> json) =>
      _FeedJsonDecoder(json).decode();

  Map<String, dynamic> toJson() => _FeedJsonEncoder(this).encode();
}

enum FeedType { rss, reddit }

class FeedItem {
  final String id;
  final String name;
  final bool isSeen;
  final Uint8List displayImage;
  final DateTime date;

  const FeedItem({
    required this.id,
    required this.name,
    required this.isSeen,
    required this.displayImage,
    required this.date,
  });

  factory FeedItem.fromJson(Map<String, dynamic> json) =>
      _FeedItemJsonDecoder(json).decode();

  Map<String, dynamic> toJson() => _FeedItemJsonEncoder(this).encode();
}
