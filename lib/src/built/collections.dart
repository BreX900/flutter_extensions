import 'dart:math';

import 'package:built_collection/built_collection.dart';
import 'package:flutter_extensions/src/dart/collections/internal.dart';

extension BuiltListExt<T> on BuiltList<T> {
  T random({Random random}) {
    if (random != null) {
      return this[random.nextInt(length)];
    } else {
      return this[DateTime.now().microsecond % length];
    }
  }

  T circleGet(int index) => this[index % length];
}

extension ListBuilderExt<T> on ListBuilder<T> {
  void removeWhereNull() => removeWhere((value) => value == null);

  void addOrRemove(bool addOrRemove, T value) {
    if (addOrRemove) {
      add(value);
    } else {
      remove(value);
    }
  }

  T random(Random random) => this[random.nextInt(length)];

  T circleGet(int index) => this[index % length];
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
  Iterable<T> generateIterable<T>(T Function(K key, V value) generator) =>
      MapUtility.generateIterable(entries, generator);

  bool every(bool test(K key, V value)) => MapUtility.every(entries, test);

  bool any(bool test(K key, V value)) => MapUtility.any(entries, test);

  K getKeyAfter(K key, [int after = 1]) => MapUtility.getElementAfter(keys, key, after);

  K getKeyBefore(K key, [int before = 1]) => MapUtility.getElementBefore(keys, key, before);

  BuiltMap<K, V> where(bool Function(K, V) predicate) =>
      (toBuilder()..removeWhere(predicate)).build();

  BuiltMap<K, V> whereValueIs(V value) => (toBuilder()..removeWhere((k, v) => v == value)).build();
}

extension MapBuilderExt<K, V> on MapBuilder<K, V> {
  void removeNullValues() => removeWhere((key, value) => value == null);
}
