import 'package:jima/src/core/error_handling/try_catch.dart';
import 'package:jima/src/modules/admin/data/admin_source.dart';
import 'package:vanilla_state/vanilla_state.dart';

typedef UploadBookState = BaseState<Object?>;

class UploadBookNotifier extends BaseNotifier<Object?> {
  final AdminSource _adminSource;

  UploadBookNotifier(this._adminSource) : super(const InitialState());

  Future<void> uploadBook({
    required String title,
    required String bookUrl,
    required String imagePath,
    required DateTime releaseDate,
  }) async {
    setOutLoading();
    final imageResult =
        await _adminSource.uploadBookCoverImage(imagePath).tryCatch();
    final String imageUrl;
    switch (imageResult) {
      case Left(:final value):
        return setError(value.displayMessage);
      case Right(:final value):
        imageUrl = value;
    }

    final result = await _adminSource
        .uploadBook(
          title: title,
          bookUrl: bookUrl,
          releaseDate: releaseDate,
          imageUrl: imageUrl,
        )
        .tryCatch();
    return switch (result) {
      Left(:final value) => setError(value.displayMessage),
      Right() => setSuccess(),
    };
  }
}
