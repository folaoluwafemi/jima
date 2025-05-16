import 'package:jima/src/core/error_handling/try_catch.dart';
import 'package:jima/src/modules/media/data/media_data_source.dart';
import 'package:jima/src/modules/media/domain/entities/category.dart';
import 'package:vanilla_state/vanilla_state.dart';

typedef AllCategoriesState = BaseState<List<Category>>;

class AllCategoriesNotifier extends BaseNotifier<List<Category>> {
  final MediaDataSource _source;

  AllCategoriesNotifier(this._source) : super(const InitialState());

  Future<void> fetchAllCategories() async {
    setInLoading();

    final result = await _source.fetchAllCategories().tryCatch();

    return switch (result) {
      Left(:final value) => setError(value.displayMessage),
      Right(:final value) => setSuccess(value),
    };
  }

  Future<void> deleteCategory(String id) async {
    setOutLoading();
    final result = await _source.deleteCategory(id).tryCatch();
    return switch (result) {
      Left(:final value) => setError(value.displayMessage),
      Right() => setSuccess(),
    };
  }

  Future<void> addCategory(String category) async {
    setOutLoading();

    final result = await _source.addCategory(category).tryCatch();

    return switch (result) {
      Left(:final value) => setError(value.displayMessage),
      Right() => () {
          setSuccess();
          fetchAllCategories();
        }(),
    };
  }
}
