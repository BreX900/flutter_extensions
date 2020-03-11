import 'package:built_collection/built_collection.dart';
import 'package:built_value/serializer.dart';
import 'package:rxdart/rxdart.dart';

extension ListBuilderExt<T> on ListBuilder<T> {
  void removeWhereNull() => removeWhere((value) => value == null);

  void addOrRemove(bool addOrRemove, T value) {
    if (addOrRemove) {
      add(value);
    } else {
      remove(value);
    }
  }
}

extension SetBuilderExt<T> on SetBuilder<T> {
  void removeWhereNull() => removeWhere((value) => value == null);

  void addOrRemove(bool addOrRemove, T value) {
    if (addOrRemove) {
      add(value);
    } else {
      remove(value);
    }
  }
}

extension BuiltMapExt<K, V> on BuiltMap<K, V> {
  Iterable<T> generateIterable<T>(T Function(K key, V value) generator) {
    return entries.map((entry) => generator(entry.key, entry.value));
  }
}

extension MapBuilderExt<K, V> on MapBuilder<K, V> {
  void removeNullValues() => removeWhere((key, value) => value == null);
}

extension SubjectBuiltMapExt<K, V> on Subject<BuiltMap<K, V>> {
  Future<void> rebuild(void updates(MapBuilder<K, V> builder)) async {
    final oldMap = await first;
    add(oldMap.rebuild(updates));
  }
}

extension SubjectBuiltListExt<V> on Subject<BuiltList<V>> {
  Future<void> rebuild(void updates(ListBuilder<V> builder)) async {
    final oldMap = await first;
    add(oldMap.rebuild(updates));
  }

//  Future<void> putIfAbsent(K key, V creator()) async {
//    final oldMap = await first;
//    if (!oldMap.containsKey(key)) add(oldMap.rebuild((builder) => builder[key] = creator()));
//  }
}

extension StreamExtSerializer<T> on Stream<T> {
  Stream<Object> serialize(
    Serializers serializers, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return map((item) => serializers.serialize(item, specifiedType: specifiedType));
  }

  Stream<Object> serializeWith(Serializers serializers, Serializer<T> serializer) {
    return map((item) => serializers.serializeWith(serializer, item));
  }

  Stream<T> deserialize(Serializers serializers, {FullType specifiedType = FullType.unspecified}) {
    return map((item) => serializers.deserialize(item, specifiedType: specifiedType));
  }

  Stream<T> deserializeWith(Serializers serializers, Serializer<T> serializer) {
    return map((item) => serializers.deserializeWith(serializer, item));
  }
}

extension StreamExtSerializersList<T> on Stream<Iterable<T>> {
  Stream<List<T>> toList() => map((items) => items.toList());

  Stream<BuiltList<T>> toBuiltList() => map((items) => BuiltList.of(items));

  Stream<Iterable<T>> deserializeIterable(
    Serializers serializers, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return map((items) {
      return items.map((item) => serializers.deserialize(item, specifiedType: specifiedType) as T);
    });
  }

  Stream<Iterable<T>> deserializeIterableWith(Serializers serializers, Serializer<T> serializer) {
    return map((items) {
      return items.map((item) => serializers.deserializeWith(serializer, item));
    });
  }
}
