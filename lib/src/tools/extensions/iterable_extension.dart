extension IterableExtension<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;

  T? firstWhereOrNull(bool Function(T element) test) {
    try {
      return firstWhere(test);
    } catch (e) {
      return null;
    }
  }

  bool equals(Iterable<T> data) {
    return every(data.contains);
  }
}

extension NullableIterableExtension<T> on Iterable<T>? {
  Iterable<T> get orEmpty => this ?? Iterable<T>.empty();

  bool get isNullOrEmpty => orEmpty.isEmpty;

  bool get isNotNullOrEmpty => !isNullOrEmpty;
}
