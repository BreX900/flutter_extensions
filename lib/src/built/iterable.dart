import 'package:built_collection/built_collection.dart';

extension IterableBuiltExtensions<T> on Iterable<T> {
  BuiltMap<K, BuiltList<V>> generateBuiltMapList<K, V>(
      MapEntry<K, V> Function(T element) generator) {
    final map = <K, ListBuilder<V>>{};
    for (var element in this) {
      final entry = generator(element);
      var list = map[entry.key];
      if (list == null) {
        map[entry.key] = list = ListBuilder<V>();
      }
      list.add(entry.value);
    }
    return map.map((k, v) => MapEntry(k, v.build())).build();
  }

  BuiltMap<int, BuiltList<T>> generateBuiltBook(
      {int valuesPerPage, int numberOfPages}) {
    if (valuesPerPage == null && numberOfPages == null)
      return BuiltMap.of({0: this});
    valuesPerPage ??= this.length ~/ numberOfPages;
    var book = MapBuilder<int, BuiltList<T>>();
    int pageCount = 0;
    var list = this;
    while (list.isNotEmpty &&
        (numberOfPages == null || pageCount < numberOfPages)) {
      book[pageCount++] = BuiltList.of(list.take(valuesPerPage));
      list = list.skip(valuesPerPage);
    }
    return book.build();
  }
}
