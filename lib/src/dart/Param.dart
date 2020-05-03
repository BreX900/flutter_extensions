class Value<T> {
  final T value;

  const Value.nothing() : value = null;

  factory Value.of(T value) {
    return value == null ? null : Value.fromNullable(value);
  }

  Value(this.value) {
    assert(value != null);
  }

  const Value.fromNullable(this.value);
}
