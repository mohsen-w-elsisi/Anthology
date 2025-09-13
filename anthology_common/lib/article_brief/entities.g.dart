// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entities.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$TextNodeCWProxy {
  TextNode text(String text);

  TextNode type(TextNodeType type);

  TextNode startIndex(int startIndex);

  TextNode endIndex(int endIndex);

  TextNode data(String? data);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `TextNode(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// TextNode(...).copyWith(id: 12, name: "My name")
  /// ````
  TextNode call({
    String text,
    TextNodeType type,
    int startIndex,
    int endIndex,
    String? data,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfTextNode.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfTextNode.copyWith.fieldName(...)`
class _$TextNodeCWProxyImpl implements _$TextNodeCWProxy {
  const _$TextNodeCWProxyImpl(this._value);

  final TextNode _value;

  @override
  TextNode text(String text) => this(text: text);

  @override
  TextNode type(TextNodeType type) => this(type: type);

  @override
  TextNode startIndex(int startIndex) => this(startIndex: startIndex);

  @override
  TextNode endIndex(int endIndex) => this(endIndex: endIndex);

  @override
  TextNode data(String? data) => this(data: data);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `TextNode(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// TextNode(...).copyWith(id: 12, name: "My name")
  /// ````
  TextNode call({
    Object? text = const $CopyWithPlaceholder(),
    Object? type = const $CopyWithPlaceholder(),
    Object? startIndex = const $CopyWithPlaceholder(),
    Object? endIndex = const $CopyWithPlaceholder(),
    Object? data = const $CopyWithPlaceholder(),
  }) {
    return TextNode(
      text: text == const $CopyWithPlaceholder()
          ? _value.text
          // ignore: cast_nullable_to_non_nullable
          : text as String,
      type: type == const $CopyWithPlaceholder()
          ? _value.type
          // ignore: cast_nullable_to_non_nullable
          : type as TextNodeType,
      startIndex: startIndex == const $CopyWithPlaceholder()
          ? _value.startIndex
          // ignore: cast_nullable_to_non_nullable
          : startIndex as int,
      endIndex: endIndex == const $CopyWithPlaceholder()
          ? _value.endIndex
          // ignore: cast_nullable_to_non_nullable
          : endIndex as int,
      data: data == const $CopyWithPlaceholder()
          ? _value.data
          // ignore: cast_nullable_to_non_nullable
          : data as String?,
    );
  }
}

extension $TextNodeCopyWith on TextNode {
  /// Returns a callable class that can be used as follows: `instanceOfTextNode.copyWith(...)` or like so:`instanceOfTextNode.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$TextNodeCWProxy get copyWith => _$TextNodeCWProxyImpl(this);
}
