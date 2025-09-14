import 'dart:convert';
import 'dart:io';

import 'entities.dart';

class ArticlePresentationMetaDataCache {
  final String path;

  ArticlePresentationMetaDataCache(this.path);

  Future<void> cache(String id, ArticlePresentationMetaData metaData) async {
    final cache = await _readCacheFile();
    cache[id] = metaData.toJson();
    await _writeCacheFile(cache);
  }

  Future<bool> isCached(String id) async {
    final cache = await _readCacheFile();
    return cache.containsKey(id);
  }

  Future<ArticlePresentationMetaData> getCached(String id) async {
    final cache = await _readCacheFile();
    if (!cache.containsKey(id)) throw ArticlePresentationMetaDataCacheError(id);
    final metaDataJson = cache[id] as Map<String, dynamic>;
    return ArticlePresentationMetaData.fromJson(metaDataJson);
  }

  Future<void> remove(String id) async {
    final cache = await _readCacheFile();
    cache.remove(id);
    await _writeCacheFile(cache);
  }

  Future<void> clear() async {
    await _writeCacheFile({});
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

class ArticlePresentationMetaDataCacheError extends Error {
  final String id;

  ArticlePresentationMetaDataCacheError(this.id);

  @override
  String toString() {
    return 'article meta data for artcile of id $id is not cached';
  }
}
