// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entities.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$HighlightCWProxy {
  Highlight id(String id);

  Highlight articleId(String articleId);

  Highlight text(String text);

  Highlight startIndex(int startIndex);

  Highlight endIndex(int endIndex);

  Highlight comment(String? comment);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Highlight(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Highlight(...).copyWith(id: 12, name: "My name")
  /// ````
  Highlight call({
    String id,
    String articleId,
    String text,
    int startIndex,
    int endIndex,
    String? comment,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfHighlight.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfHighlight.copyWith.fieldName(...)`
class _$HighlightCWProxyImpl implements _$HighlightCWProxy {
  const _$HighlightCWProxyImpl(this._value);

  final Highlight _value;

  @override
  Highlight id(String id) => this(id: id);

  @override
  Highlight articleId(String articleId) => this(articleId: articleId);

  @override
  Highlight text(String text) => this(text: text);

  @override
  Highlight startIndex(int startIndex) => this(startIndex: startIndex);

  @override
  Highlight endIndex(int endIndex) => this(endIndex: endIndex);

  @override
  Highlight comment(String? comment) => this(comment: comment);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Highlight(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Highlight(...).copyWith(id: 12, name: "My name")
  /// ````
  Highlight call({
    Object? id = const $CopyWithPlaceholder(),
    Object? articleId = const $CopyWithPlaceholder(),
    Object? text = const $CopyWithPlaceholder(),
    Object? startIndex = const $CopyWithPlaceholder(),
    Object? endIndex = const $CopyWithPlaceholder(),
    Object? comment = const $CopyWithPlaceholder(),
  }) {
    return Highlight(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      articleId: articleId == const $CopyWithPlaceholder()
          ? _value.articleId
          // ignore: cast_nullable_to_non_nullable
          : articleId as String,
      text: text == const $CopyWithPlaceholder()
          ? _value.text
          // ignore: cast_nullable_to_non_nullable
          : text as String,
      startIndex: startIndex == const $CopyWithPlaceholder()
          ? _value.startIndex
          // ignore: cast_nullable_to_non_nullable
          : startIndex as int,
      endIndex: endIndex == const $CopyWithPlaceholder()
          ? _value.endIndex
          // ignore: cast_nullable_to_non_nullable
          : endIndex as int,
      comment: comment == const $CopyWithPlaceholder()
          ? _value.comment
          // ignore: cast_nullable_to_non_nullable
          : comment as String?,
    );
  }
}

extension $HighlightCopyWith on Highlight {
  /// Returns a callable class that can be used as follows: `instanceOfHighlight.copyWith(...)` or like so:`instanceOfHighlight.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$HighlightCWProxy get copyWith => _$HighlightCWProxyImpl(this);
}
