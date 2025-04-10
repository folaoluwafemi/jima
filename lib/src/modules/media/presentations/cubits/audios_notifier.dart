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

  Future<void> fetchAudios({
    String? query,
    bool fetchAFresh = false,
  }) async {
    setInLoading();

    final result = await _source
        .fetchAudios(
          page: fetchAFresh ? 1 : data!.currentPage + 1,
          searchQuery: query,
        )
        .tryCatch();

    return switch (result) {
      Left(:final value) => setError(value.displayMessage),
      Right(:final value) => setSuccess(
          query != null
              ? PaginationData(
                  items: value,
                  currentPage: 1,
                  hasReachedLimit: true,
                )
              : fetchAFresh
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
