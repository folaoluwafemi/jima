import 'package:jima/src/core/error_handling/try_catch.dart';
import 'package:jima/src/core/supabase_infra/pagination/pagination_data.dart';
import 'package:jima/src/modules/media/data/media_data_source.dart';
import 'package:jima/src/modules/media/domain/entities/books.dart';
import 'package:vanilla_state/vanilla_state.dart';

typedef BooksState = BaseState<PaginationData<Book>>;

class BooksNotifier extends BaseNotifier<PaginationData<Book>> {
  final MediaDataSource _source;

  BooksNotifier(this._source)
      : super(
          InitialState(
            data: PaginationData.empty(),
          ),
        );

  Future<void> search(String query) async {
    if (state.isInLoading) return;
    setInLoading();

    final result = await _source.searchBooks(query).tryCatch();

    return switch (result) {
      Left(:final value) => setError(value.displayMessage),
      Right(:final value) => setSuccess(
          PaginationData(
            items: value,
            currentPage: 1,
            hasReachedLimit: true,
          ),
        ),
    };
  }

  Future<void> fetchBooks({
    bool fetchAFresh = false,
  }) async {
    setInLoading();

    final result = await _source
        .fetchBooks(page: fetchAFresh ? 1 : data!.currentPage + 1)
        .tryCatch();

    return switch (result) {
      Left(:final value) => setError(value.displayMessage),
      Right(:final value) => setSuccess(
          fetchAFresh
              ? data!.copyWith(
                  items: value,
                  currentPage: 1,
                  hasReachedLimit: false,
                )
              : data!.withNewDataRaw(value),
        ),
    };
  }
}
