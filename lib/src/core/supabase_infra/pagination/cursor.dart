part of 'pagination_mixin.dart';

class Cursor {
  int _page;
  int _pageSize;
  int _count;

  int get page => _page;

  int get count => _count;

  int get pageSize => _pageSize;

  Cursor.create({
    int page = 0,
    int pageSize = paginationLimit,
    int count = 0,
  })  : _pageSize = pageSize,
        _count = count,
        _page = page;

  void updateCursor({
    required int page,
    int? pageSize,
  }) {
    _page = page;
    _pageSize = pageSize ?? _pageSize;
  }

  void reset([int? count]) {
    _page = 0;
    _count = count ?? _count;
  }

  void incrementPage({int incrementValue = 1}) {
    _page += incrementValue;
  }

  PostgrestTransformBuilder<List<Map<String, dynamic>>> buildSupabaseQuery(
    PostgrestBaseQuery seed, {
    String? orderColumn,
  }) {
    final int start = _page == 0 ? 0 : (_page - 1) * _pageSize;
    if (orderColumn == null) return seed.range(start, start + _pageSize - 1);
    return seed.order(orderColumn).range(start, start + _pageSize - 1);
  }

  String completeApiPath(String seed) {
    seed = seed.trim();
    final String cursorPart = 'page=$page&pageSize=$pageSize';
    return seed.contains('?')
        ? (seed.split('?').lastOrNull?.isEmpty == null ||
                seed.split('?').lastOrNull!.isEmpty)
            ? '$seed$cursorPart'
            : '$seed&$cursorPart'
        : '$seed?$cursorPart';
  }
}
