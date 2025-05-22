import 'package:jima/src/core/error_handling/try_catch.dart';
import 'package:jima/src/modules/media/data/media_data_source.dart';
import 'package:jima/src/modules/media/domain/entities/generic_media_type.dart';
import 'package:vanilla_state/vanilla_state.dart';

class DeleteMediaNotifier extends BaseNotifier {
  final MediaDataSource _source;

  DeleteMediaNotifier(this._source) : super(const InitialState());

  Future<void> deleteMedia(
    String mediaId,
    GenericMediaType type,
    String url,
  ) async {
    setOutLoading();

    final result = await _source.deleteMedia(mediaId, type, url).tryCatch();

    return switch (result) {
      Left(:final value) => setError(value.displayMessage),
      Right() => setSuccess(),
    };
  }
}
