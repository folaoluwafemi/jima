import 'package:jima/src/core/error_handling/try_catch.dart';
import 'package:jima/src/modules/media/data/media_data_source.dart';
import 'package:vanilla_state/vanilla_state.dart';

class DeleteCategoryNotifier extends BaseNotifier {
  final MediaDataSource _source;

  DeleteCategoryNotifier(this._source) : super(const InitialState());

  Future<void> deleteCategory(String id) async {
    setOutLoading();

    final result = await _source.deleteCategory(id).tryCatch();

    return switch (result) {
      Left(:final value) => setError(value.displayMessage),
      Right() => setSuccess(),
    };
  }
}
