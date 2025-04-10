import 'package:jima/src/core/error_handling/try_catch.dart';
import 'package:jima/src/core/supabase_infra/pagination/pagination_data.dart';
import 'package:jima/src/modules/media/data/media_data_source.dart';
import 'package:jima/src/modules/media/domain/entities/audio.dart';
import 'package:vanilla_state/vanilla_state.dart';

typedef AudiosState = BaseState<PaginationData<Audio>>;

class AudiosNotifier extends BaseNotifier<PaginationData<Audio>> {
  final MediaDataSource _source;

  AudiosNotifier(this._source)
      : super(
          InitialState(
            data: PaginationData.empty(),
          ),
        );

  Future<void> search(String query) async {
    if (state.isInLoading) return;
    setInLoading();

    final result = await _source.searchAudios(query).tryCatch();

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

  Future<void> fetchAudios({
    bool fetchAFresh = false,
  }) async {
    setInLoading();

    final result = await _source
        .fetchAudios(page: fetchAFresh ? 1 : data!.currentPage + 1)
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
