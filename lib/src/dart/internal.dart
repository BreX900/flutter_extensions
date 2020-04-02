abstract class MapUtility {
  static Iterable<T> generateIterable<K, V, T>(
      Iterable<MapEntry<K, V>> entries, T Function(K key, V value) generator) {
    return entries.map((entry) => generator(entry.key, entry.value));
  }

  static bool every<K, V>(Iterable<MapEntry<K, V>> entries, bool test(K key, V value)) {
    for (var entry in entries) {
      if (!test(entry.key, entry.value)) return false;
    }
    return true;
  }

  static bool any<K, V>(Iterable<MapEntry<K, V>> entries, bool test(K key, V value)) {
    for (var entry in entries) {
      if (test(entry.key, entry.value)) return true;
    }
    return false;
  }
}
