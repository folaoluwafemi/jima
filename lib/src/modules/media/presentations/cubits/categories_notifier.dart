import 'package:jima/src/core/error_handling/try_catch.dart';
import 'package:jima/src/modules/media/data/media_data_source.dart';
import 'package:jima/src/modules/media/domain/entities/categorized_media.dart';
import 'package:jima/src/modules/media/domain/entities/category.dart';
import 'package:jima/src/tools/tools_barrel.dart';
import 'package:vanilla_state/vanilla_state.dart';

typedef CategoriesState = BaseState<Map<CategorizedMedia?, List<Category>>>;

class CategoriesNotifier
    extends BaseNotifier<Map<CategorizedMedia?, List<Category>>> {
  final MediaDataSource _source;

  CategoriesNotifier(this._source) : super(const InitialState(data: {}));

  Future<void> fetchAudiosCategories() async {
    setInLoading();

    final result = await _source
        .fetchCategoriesFor(filter: CategorizedMedia.audio)
        .tryCatch();

    return switch (result) {
      Left(:final value) => setError(value.displayMessage),
      Right(:final value) => setSuccess(
          data!.copyUpdate(CategorizedMedia.audio, value),
        ),
    };
  }

  Future<void> fetchVideosCategories() async {
    setInLoading();

    final result = await _source
        .fetchCategoriesFor(filter: CategorizedMedia.video)
        .tryCatch();

    return switch (result) {
      Left(:final value) => setError(value.displayMessage),
      Right(:final value) => setSuccess(
          data!.copyUpdate(CategorizedMedia.video, value),
        ),
    };
  }

  Future<void> fetchCategories() async {
    setInLoading();

    final result = await _source.fetchCategoriesFor().tryCatch();

    return switch (result) {
      Left(:final value) => setError(value.displayMessage),
      Right(:final value) => setSuccess(
          data!.copyUpdate(null, value),
        ),
    };
  }
}
