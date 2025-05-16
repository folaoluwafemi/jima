import 'package:jima/src/core/error_handling/try_catch.dart';
import 'package:jima/src/modules/admin/data/admin_source.dart';
import 'package:jima/src/modules/media/domain/entities/category.dart';
import 'package:vanilla_state/vanilla_state.dart';

typedef UploadVideoState = BaseState<Object?>;

class UploadVideoNotifier extends BaseNotifier<Object?> {
  final AdminSource _adminSource;

  UploadVideoNotifier(this._adminSource) : super(const InitialState());

  Future<void> uploadVideo(
    String title,
    String videoId,
    DateTime releaseDate,
    Category category,
  ) async {
    setOutLoading();
    final result = await _adminSource
        .uploadVideo(title, videoId, releaseDate, category)
        .tryCatch();
    return switch (result) {
      Left(:final value) => setError(value.displayMessage),
      Right() => setSuccess(),
    };
  }
}
