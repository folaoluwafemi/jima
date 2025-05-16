extension MapExtension<K, V> on Map<K, V> {
  Map<K, V> get copy => Map<K, V>.from(this);

  Map<K, V> copyUpdate(K key, V newValue) {
    return (Map.from(this)..[key] = newValue);
  }

  Map<K, V> copyRemove(K key) {
    return (Map.from(this)..remove(key));
  }
}

extension ListMapExtension<K, T> on Map<K, List<T>> {
  Map<K, List<T>> copyAddItem(K key, T newValue) {
    return (Map.from(this)
      ..[key] = (List<T>.from(this[key] ?? [])..add(newValue)));
  }

  Map<K, List<T>> copyAddItems(K key, Iterable<T> newValues) {
    return (Map.from(this)
      ..[key] = (List<T>.from(this[key] ?? [])..addAll(newValues)));
  }

  Map<K, List<T>> copyRemoveItem(K key, T newValue) {
    return (Map.from(this)
      ..[key] = (List<T>.from(this[key] ?? [])..remove(newValue)));
  }
}

extension MapMapExtension<K, SubKey, SubValue>
    on Map<K, Map<SubKey, SubValue>> {
  Map<K, Map<SubKey, SubValue>> copyAddDeepItem(
    K key,
    SubKey subKey,
    SubValue newValue,
  ) {
    return copyUpdate(key, (this[key] ?? {}).copyUpdate(subKey, newValue));
  }

  Map<K, Map<SubKey, SubValue>> copyRemoveDeepItem(
    K key,
    SubKey subKey,
  ) {
    return copyUpdate(key, this[key]!.copyRemove(subKey));
  }
}
