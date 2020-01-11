import 'dart:convert';

import 'package:flutter/foundation.dart';

extension MapExt<K, V> on Map<K, V> {
  Iterable<T> buildIterable<T>(T generator(K key, V value)) {
    return entries.map((entry) => generator(entry.key, entry.value));
  }

  void removeNullValues() => removeWhere((key, value) => value == null);
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

extension JsonMapExt<V> on Map<String, V> {
  String serialize() => jsonEncode(this);
}
