// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entities.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$TextNodeCWProxy {
  TextNode text(String text);

  TextNode type(TextNodeType type);

  TextNode bold(bool bold);

  TextNode italic(bool italic);

  TextNode startIndex(int startIndex);

  TextNode endIndex(int endIndex);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `TextNode(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// TextNode(...).copyWith(id: 12, name: "My name")
  /// ````
  TextNode call({
    String text,
    TextNodeType type,
    bool bold,
    bool italic,
    int startIndex,
    int endIndex,
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
  TextNode bold(bool bold) => this(bold: bold);

  @override
  TextNode italic(bool italic) => this(italic: italic);

  @override
  TextNode startIndex(int startIndex) => this(startIndex: startIndex);

  @override
  TextNode endIndex(int endIndex) => this(endIndex: endIndex);

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
    Object? bold = const $CopyWithPlaceholder(),
    Object? italic = const $CopyWithPlaceholder(),
    Object? startIndex = const $CopyWithPlaceholder(),
    Object? endIndex = const $CopyWithPlaceholder(),
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
      bold: bold == const $CopyWithPlaceholder()
          ? _value.bold
          // ignore: cast_nullable_to_non_nullable
          : bold as bool,
      italic: italic == const $CopyWithPlaceholder()
          ? _value.italic
          // ignore: cast_nullable_to_non_nullable
          : italic as bool,
      startIndex: startIndex == const $CopyWithPlaceholder()
          ? _value.startIndex
          // ignore: cast_nullable_to_non_nullable
          : startIndex as int,
      endIndex: endIndex == const $CopyWithPlaceholder()
          ? _value.endIndex
          // ignore: cast_nullable_to_non_nullable
          : endIndex as int,
    );
  }
}

extension $TextNodeCopyWith on TextNode {
  /// Returns a callable class that can be used as follows: `instanceOfTextNode.copyWith(...)` or like so:`instanceOfTextNode.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$TextNodeCWProxy get copyWith => _$TextNodeCWProxyImpl(this);
}
