import 'package:jima/src/core/error_handling/try_catch.dart';
import 'package:jima/src/modules/admin/data/admin_source.dart';
import 'package:jima/src/modules/media/domain/entities/category.dart';
import 'package:vanilla_state/vanilla_state.dart';

typedef UploadBookState = BaseState<Object?>;

class UploadBookNotifier extends BaseNotifier<Object?> {
  final AdminSource _source;

  UploadBookNotifier(this._source) : super(const InitialState());

  Future<void> uploadBook({
    required String title,
    required String bookUrl,
    required String imagePath,
    required DateTime releaseDate,
    required Category category,
  }) async {
    setOutLoading();
    final imgResult = await _source.uploadBookCoverImage(imagePath).tryCatch();
    final String imageUrl;
    switch (imgResult) {
      case Left(:final value):
        return setError(value.displayMessage);
      case Right(:final value):
        imageUrl = value;
    }

    final result = await _source
        .uploadBook(title, bookUrl, releaseDate, imageUrl, category)
        .tryCatch();
    return switch (result) {
      Left(:final value) => setError(value.displayMessage),
      Right() => setSuccess(),
    };
  }
}
