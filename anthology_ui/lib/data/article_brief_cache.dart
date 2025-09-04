import 'dart:convert';
import 'dart:io';

import 'package:anthology_common/article_brief/entities.dart';

class ArticleBriefCache {
  final String path;

  ArticleBriefCache(this.path);

  Future<void> cache(String id, ArticleBrief brief) async {
    final cache = await _readCacheFile();
    cache[id] = brief.toJson();
    await _writeCacheFile(cache);
  }

  Future<bool> isCached(String id) async {
    final cache = await _readCacheFile();
    return cache.containsKey(id);
  }

  Future<ArticleBrief> get(String id) async {
    final cache = await _readCacheFile();
    if (!cache.containsKey(id)) throw ArticleBriefCacheException(id);
    final briefJson = cache[id] as Map<String, dynamic>;
    return ArticleBrief.fromJson(briefJson);
  }

  Future<Map<String, dynamic>> _readCacheFile() async {
    final file = File(path);
    if (!await file.exists() || (await file.readAsString()).isEmpty) {
      return {};
    }
    final content = await file.readAsString();
    return jsonDecode(content) as Map<String, dynamic>;
  }

  Future<void> _writeCacheFile(Map<String, dynamic> cache) async {
    final file = File(path);
    if (!await file.parent.exists()) {
      await file.parent.create(recursive: true);
    }
    await file.writeAsString(jsonEncode(cache));
  }
}

class ArticleBriefCacheException implements Exception {
  final String id;

  ArticleBriefCacheException(this.id);

  @override
  String toString() {
    return 'article breif for article with $id is not cached';
  }
}
