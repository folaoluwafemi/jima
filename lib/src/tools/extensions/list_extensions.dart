extension ListExtension<T> on List<T> {
  List<T> copyAdd(T item) {
    return (List.from(this)..add(item));
  }

  List<T> get shallowCopy => List<T>.from(this);

  List<T> copyRemove(T item) {
    return (List.from(this)..remove(item));
  }

  List<T> copyRemoveWhere(bool Function(T item) test) {
    return (List.from(this)..removeWhere(test));
  }

  bool containsWhere(bool Function(T item) test) => any(test);

  void replaceWhere(Iterable<T> replacement, bool Function(T element) test) {
    final index = indexWhere(test);

    if (index == -1) throw StateError('index not found in $this');
    replaceRange(index, index + 1, replacement);
  }

  List<T> copyReplaceWhere(
    Iterable<T> replacement,
    bool Function(T element) test,
  ) {
    final index = indexWhere(test);

    if (index == -1) throw StateError('index not found in $this');
    return (List.from(this)..replaceRange(index, index + 1, replacement));
  }

  List<T>? get nullIfEmpty => isEmpty ? null : this;
}
