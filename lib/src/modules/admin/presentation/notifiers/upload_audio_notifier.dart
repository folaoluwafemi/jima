import 'dart:io';

import 'package:id3tag/id3tag.dart' as reader;
import 'package:jima/src/core/error_handling/try_catch.dart';
import 'package:jima/src/modules/admin/data/admin_source.dart';
import 'package:jima/src/modules/media/domain/entities/category.dart';
import 'package:jima/src/tools/tools_barrel.dart';
import 'package:vanilla_state/vanilla_state.dart';

typedef UploadAudioState = BaseState<Object?>;

class UploadAudioNotifier extends BaseNotifier<Object?> {
  final AdminSource _adminSource;

  UploadAudioNotifier(this._adminSource) : super(const InitialState());

  Future<void> uploadAudio(
    String title,
    String audioPath,
    DateTime releaseDate,
    Category category,
  ) async {
    if (state.isOutLoading) return;
    setOutLoading();
    final thumbnail = await uploadThumbnail(audioPath);
    print("uploaded thumbnail:$thumbnail");

    if (thumbnail == null) return setError('Failed to upload thumbnail');

    final audioUrl = await uploadAudioFile(audioPath);
    if (audioUrl == null) {
      _adminSource.deleteAudioThumbnail(thumbnail);
      return setError('Failed to upload audio file');
    }
    print("uploaded audio:$audioUrl");

    final result = await _adminSource
        .uploadAudio(
          title: title,
          audioUrl: audioUrl,
          releaseDate: releaseDate,
          thumbnail: thumbnail,
          category: category,
        )
        .tryCatch();

    print("uploaded thumbnail:$result");

    return switch (result) {
      Left(:final value) => setError(value.displayMessage),
      Right() => setSuccess(),
    };
  }

  Future<String?> uploadAudioFile(String filePath) async {
    final file = File(filePath);
    if (!file.existsSync()) return null;
    final url = await _adminSource.uploadAudioFile(filePath).tryCatch();
    return switch (url) {
      Left(:final value) => () {
          setError(value.displayMessage);
          notifyListeners();
          return null;
        }(),
      Right(:final value) => value,
    };
  }

  Future<String?> uploadThumbnail(String audioPath) async {
    try {
      final track = reader.ID3TagReader.path(audioPath).readTagSync();

      final image = track.pictures.firstWhereOrNull(
        (element) => element.imageData.isNotEmpty,
      );

      if (image == null) return null;

      final filename = audioPath.split('/').last;
      final thumbnailFilename = '${filename.split('.').first}thumbmail.jpg';
      final result = await _adminSource
          .uploadAudioThumbnail(image.imageData, thumbnailFilename)
          .tryCatch();

      return switch (result) {
        Left(:final value) => () {
            setError(value.displayMessage);
            notifyListeners();
            return null;
          }(),
        Right(:final value) => value,
      };
    } catch (e) {
      return null;
    }
  }
}
