import 'package:equatable/equatable.dart';

class PaginationData<T> with EquatableMixin {
  final List<T> items;
  final int currentPage;
  final bool hasReachedLimit;

  const PaginationData({
    required this.items,
    required this.currentPage,
    required this.hasReachedLimit,
  });

  PaginationData.empty()
      : items = const [],
        currentPage = 0,
        hasReachedLimit = false;

  PaginationData<T> withNewData(List<T> data) {
    final newItems = {...items, ...data}.toList();

    return copyWith(
      currentPage: data.isEmpty || newItems.length <= data.length
          ? currentPage
          : currentPage + 1,
      hasReachedLimit: newItems.length <= data.length,
      items: newItems,
    );
  }

  PaginationData<T> withNewDataRaw(List<T> data) {
    final newItems = {...items, ...data}.toList();
    return copyWith(items: newItems);
  }

  @override
  List<Object> get props => [items, currentPage, hasReachedLimit];

  PaginationData<T> copyWith({
    List<T>? items,
    int? currentPage,
    bool? hasReachedLimit,
  }) {
    return PaginationData(
      items: items ?? this.items,
      currentPage: currentPage ?? this.currentPage,
      hasReachedLimit: hasReachedLimit ?? this.hasReachedLimit,
    );
  }
}
