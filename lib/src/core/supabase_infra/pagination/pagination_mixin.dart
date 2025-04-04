import 'package:supabase_flutter/supabase_flutter.dart';

part 'cursor.dart';

typedef PostgrestBaseQuery = PostgrestFilterBuilder<List<Map<String, dynamic>>>;

const paginationLimit = 50;

mixin SupabasePaginationMixin<Data> {
  PostgrestBaseQuery get query;

  late final Cursor cursor = Cursor.create(pageSize: size);

  int get size => paginationLimit;

  String? get orderColumn => null;

  Future<List<Data>> requestDelegate(bool fetchAFresh) async {
    if (fetchAFresh || cursor.count == 0) {
      final int count = (await query.count(CountOption.exact)).count;
      cursor.reset(count);
    }
    final List<Map<String, dynamic>> data = await cursor.buildSupabaseQuery(
      query,
      orderColumn: orderColumn,
    );

    if (data.isEmpty) return [];

    cursor.incrementPage();

    final List<Data> data_ = dataConverterDelegate(data);

    return data_;
  }

  List<Data> dataConverterDelegate(List<Map<String, Object?>> data);
}
