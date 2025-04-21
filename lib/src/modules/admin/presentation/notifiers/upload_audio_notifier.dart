import 'package:jima/src/core/error_handling/try_catch.dart';
import 'package:jima/src/modules/admin/data/admin_source.dart';
import 'package:vanilla_state/vanilla_state.dart';

typedef UploadAudioState = BaseState<Object?>;

class UploadAudioNotifier extends BaseNotifier<Object?> {
  final AdminSource _adminSource;

  UploadAudioNotifier(this._adminSource) : super(const InitialState());

  Future<void> uploadAudio(
    String title,
    String audioId,
    DateTime releaseDate,
  ) async {
    setOutLoading();
    final result =
        await _adminSource.uploadAudio(title, audioId, releaseDate).tryCatch();
    return switch (result) {
      Left(:final value) => setError(value.displayMessage),
      Right() => setSuccess(),
    };
  }
}
