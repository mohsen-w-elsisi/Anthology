import 'dart:convert';
import 'dart:io';

import 'package:anthology_common/errors.dart';
import 'package:anthology_common/feed/data_gateway.dart';
import 'package:anthology_common/feed/entities.dart';

class LocalJsonFeedDataGateway implements FeedDataGateway {
  static const String _filePath = './db/feed.json';

  @override
  Future<void> delete(String id) async {
    final feeds = await _readFromFile();
    await _assertFeedExists(id);
    feeds.remove(id);
    await _writeToFile(feeds);
  }

  @override
  Future<void> deleteAll() async {
    await _writeToFile({});
  }

  @override
  Future<Feed> get(String id) async {
    await _assertFeedExists(id);
    return (await _readFromFile())[id]!;
  }

  @override
  Future<List<Feed>> getAll() async {
    return (await _readFromFile()).values.toList();
  }

  @override
  Future<void> save(Feed feed) async {
    final feeds = await _readFromFile();
    feeds[feed.id] = feed;
    await _writeToFile(feeds);
  }

  Future<void> _assertFeedExists(String id) async {
    final feeds = await _readFromFile();
    if (!feeds.containsKey(id)) throw FeedNotFoundError(id);
  }

  Future<Map<String, Feed>> _readFromFile() async {
    final jsonString = await File(_filePath).readAsString();
    final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;
    return {
      for (final entry in jsonMap.entries)
        entry.key: Feed.fromJson(entry.value),
    };
  }

  Future<void> _writeToFile(Map<String, Feed> feeds) async {
    final json = {
      for (final entry in feeds.entries) entry.key: entry.value.toJson(),
    };
    final jsonString = jsonEncode(json);
    await File(_filePath).writeAsString(jsonString);
  }
}
