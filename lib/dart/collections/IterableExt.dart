import 'dart:convert';

import 'package:flutter/cupertino.dart';

extension IterableExt<T> on Iterable<T> {
  Map<int, T> judgeElements(int judges(T value)) {
    final res = Map();
    for (var element in this) {
      res[judges(element)] = element;
    }
    return res;
  }

  @deprecated
  SplittingResult<T> split(int splitter(T value)) {
    final result = SplittingResult<T>();
    for (var value in this) {
      result.add(splitter(value), value);
    }
    return result;
  }

  Iterable<T> whereNotContains(Iterable<T> badElements) {
    return where((item) => !badElements.contains(item));
  }

  Iterable<T> whereNotNull() => where((value) => value == null);

  Iterable<T> replaces(Map<T, T> replacement) {
    return this.map((item) => replacement[item] ?? item);
  }

  T get tryFirst {
    Iterator<T> it = iterator;
    return it.moveNext() ? it.current : null;
  }

  Iterable<N> doubleMap<N>(N converter(T key, T value)) {
    Iterator<T> it = iterator;
    final list = <N>[];
    while (it.moveNext()) {
      final key = it.current;
      if (!it.moveNext()) return list;
      final value = it.current;
      list.add(converter(key, value));
    }
    return list;
  }

  Iterable<T> joinBuilder(T builder(int index)) {
    if (this.length == 0) return [];

    final iterator = this.iterator;
    iterator.moveNext();
    final newList = List<T>()
      ..length = (this.length * 2) - 1
      ..[0] = iterator.current;

    int i = 1;
    while (iterator.moveNext()) {
      newList[i] = builder(i);
      i += 1;
      newList[i] = iterator.current;
      i += 1;
    }

    return newList;
  }

  Iterable<T> joinElement(T element) => joinBuilder((index) => element);

  @visibleForTesting
  Map<K, V> buildMap<K, V>(MapEntry<K, V> generator(T value)) {
    return map(generator).toMap();
  }
}

@visibleForTesting
class SplittingResult<T> {
  final List<T> less = [];
  final List<T> equals = [];
  final List<T> great = [];

  void add(int res, T value) {
    if (res == 0) {
      equals.add(value);
    } else if (res < 0) {
      less.add(value);
    } else {
      great.add(value);
    }
  }

  List<T> get lessAndEquals => [...less, ...equals];
}

extension IterableMapEntryExt<K, V> on Iterable<MapEntry<K, V>> {
  Map<K, V> toMap() => Map.fromEntries(this);
  Iterable<V> get values => map((entry) => entry.value);
  Iterable<K> get keys => map((entry) => entry.key);
}

extension ListExt<T> on List<T> {
  static List<E> nullGenerator<E>(E builder(int index), {int itemCount}) {
//    if (itemCount == 0) return <E>[];
//    E element = builder(0);
//    if (element == null) return <E>[];
//
//    List<E> newList = <E>[element];
//    for (int i = 1; element != null; i++) {
//      newList..add(element);
//      element = builder(i);
//    }
    final newList = <E>[];
    E element;
    for (int i = 0; itemCount != null ? i < itemCount : true; i++) {
      element = builder(i);
      if (element == null) break;
      newList.add(element);
    }
    return newList;
  }

  String serialize() => jsonEncode(this);
}

//extension MapBuilderExt<K, V> on MapBuilder<K, V> {
//  BuiltMap<K, V> sort(int comparator(K key, V value)) {
//    final map = build();
//
//    BuiltMap.of(map);
//    clear();
//  }
//}
