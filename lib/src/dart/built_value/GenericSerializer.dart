import 'package:built_value/serializer.dart';
import 'package:flutter_extensions/src/dart/IterableExt.dart';
import 'package:flutter_extensions/src/dart/MapExt.dart';

class GenericSerializer<T> extends StructuredSerializer<T> {
  final Map<String, dynamic> Function(T) toJson;
  final T Function(Map<String, dynamic>) fromJson;

  @override
  final Iterable<Type> types = [T];

  @override
  final String wireName = '$T';

  GenericSerializer(this.toJson, this.fromJson);

  @override
  Iterable serialize(Serializers serializers, T object,
      {FullType specifiedType = FullType.unspecified}) {
    return toJson(object).serialize();
  }

  @override
  T deserialize(Serializers serializers, Iterable serialized,
      {FullType specifiedType = FullType.unspecified}) {
    return fromJson(serialized.deserialize());
  }
}
