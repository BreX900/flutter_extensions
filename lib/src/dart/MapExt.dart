import 'dart:convert';

import 'package:meta/meta.dart';

extension MapExt<K, V> on Map<K, V> {
  Iterable<T> generateIterable<T>(T Function(K key, V value) generator) {
    return entries.map((entry) => generator(entry.key, entry.value));
  }

  void removeNullValues() => removeWhere((key, value) => value == null);

  String encodeToString() => jsonEncode(this);

  Iterable<dynamic> serialize() {
    final list = <dynamic>[]..length = length * 2;
    var i = 0;
    for (var entry in entries) {
      list[i++] = entry.value;
      list[i++] = entry.key;
    }
    return list;
  }
}

extension OrderMapExt<K extends num, V> on Map<K, V> {
  @visibleForTesting
  Iterable<MapEntry<K, V>> whereKeyIs({K less, K equals, K great}) {
    final newList = <MapEntry<K, V>>[];
    for (var entry in entries) {
      if (less != null && entry.key < less) newList.add(entry);
      if (less != null && entry.key == equals) newList.add(entry);
      if (great != null && entry.key > great) newList.add(entry);
    }
    return newList;
  }
}
