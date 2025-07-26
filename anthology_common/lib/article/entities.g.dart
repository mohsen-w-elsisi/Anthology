// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entities.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ArticleCWProxy {
  Article uri(Uri uri);

  Article id(String id);

  Article tags(Set<String> tags);

  Article dateSaved(DateTime dateSaved);

  Article read(bool read);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Article(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Article(...).copyWith(id: 12, name: "My name")
  /// ````
  Article call({
    Uri uri,
    String id,
    Set<String> tags,
    DateTime dateSaved,
    bool read,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfArticle.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfArticle.copyWith.fieldName(...)`
class _$ArticleCWProxyImpl implements _$ArticleCWProxy {
  const _$ArticleCWProxyImpl(this._value);

  final Article _value;

  @override
  Article uri(Uri uri) => this(uri: uri);

  @override
  Article id(String id) => this(id: id);

  @override
  Article tags(Set<String> tags) => this(tags: tags);

  @override
  Article dateSaved(DateTime dateSaved) => this(dateSaved: dateSaved);

  @override
  Article read(bool read) => this(read: read);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Article(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Article(...).copyWith(id: 12, name: "My name")
  /// ````
  Article call({
    Object? uri = const $CopyWithPlaceholder(),
    Object? id = const $CopyWithPlaceholder(),
    Object? tags = const $CopyWithPlaceholder(),
    Object? dateSaved = const $CopyWithPlaceholder(),
    Object? read = const $CopyWithPlaceholder(),
  }) {
    return Article(
      uri: uri == const $CopyWithPlaceholder()
          ? _value.uri
          // ignore: cast_nullable_to_non_nullable
          : uri as Uri,
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      tags: tags == const $CopyWithPlaceholder()
          ? _value.tags
          // ignore: cast_nullable_to_non_nullable
          : tags as Set<String>,
      dateSaved: dateSaved == const $CopyWithPlaceholder()
          ? _value.dateSaved
          // ignore: cast_nullable_to_non_nullable
          : dateSaved as DateTime,
      read: read == const $CopyWithPlaceholder()
          ? _value.read
          // ignore: cast_nullable_to_non_nullable
          : read as bool,
    );
  }
}

extension $ArticleCopyWith on Article {
  /// Returns a callable class that can be used as follows: `instanceOfArticle.copyWith(...)` or like so:`instanceOfArticle.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ArticleCWProxy get copyWith => _$ArticleCWProxyImpl(this);
}
