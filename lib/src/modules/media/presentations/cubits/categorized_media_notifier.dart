import 'package:jima/src/core/core.dart';
import 'package:jima/src/core/error_handling/try_catch.dart';
import 'package:jima/src/modules/media/data/media_data_source.dart';
import 'package:jima/src/modules/media/domain/entities/category.dart';
import 'package:jima/src/modules/media/presentations/_states/categorized_media_state_data.dart';
import 'package:vanilla_state/vanilla_state.dart';

typedef CategorizedMediaState = BaseState<CategorizedMediaStateData>;

class CategorizedMediaNotifier extends BaseNotifier<CategorizedMediaStateData> {
  final MediaDataSource _source;

  CategorizedMediaNotifier(
    this._source, {
    required Category category,
  }) : super(
          InitialState(
            data: CategorizedMediaStateData(
              category: category,
              audios: PaginationData.empty(),
              videos: PaginationData.empty(),
            ),
          ),
        );

  Future<void> fetchCategorizedAudios(
    Category category, {
    bool fetchAFresh = false,
  }) async {
    setInLoading();

    final page = fetchAFresh ? 1 : data!.audios.currentPage + 1;
    final result = await _source
        .fetchAudios(page: page, categoryId: category.id)
        .tryCatch();

    return switch (result) {
      Left(:final value) => setError(value.displayMessage),
      Right(:final value) => setSuccess(
          data!.copyWith(
            audios: fetchAFresh
                ? data!.audios.copyWith(
                    items: value,
                    currentPage: 1,
                    hasReachedLimit: false,
                  )
                : data!.audios.withNewDataRaw(value),
          ),
        ),
    };
  }

  Future<void> fetchCategorizedVideos(
    Category category, {
    bool fetchAFresh = false,
  }) async {
    setInLoading();

    final page = fetchAFresh ? 1 : data!.videos.currentPage + 1;
    final result = await _source
        .fetchVideos(page: page, categoryId: category.id)
        .tryCatch();

    return switch (result) {
      Left(:final value) => setError(value.displayMessage),
      Right(:final value) => setSuccess(
          data!.copyWith(
            videos: fetchAFresh
                ? data!.videos.copyWith(
                    items: value,
                    currentPage: 1,
                    hasReachedLimit: false,
                  )
                : data!.videos.withNewDataRaw(value),
          ),
        ),
    };
  }
}
