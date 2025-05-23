import 'dart:io';

import 'package:audiotags/audiotags.dart';
import 'package:jima/src/core/error_handling/try_catch.dart';
import 'package:jima/src/modules/admin/data/admin_source.dart';
import 'package:jima/src/modules/media/domain/entities/category.dart';
import 'package:jima/src/tools/extensions/extensions.dart';
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
    print('starting url');
    final url = await _adminSource.uploadAudioFile(filePath).tryCatch();
    print("completing audio url: $url");
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
      print("audio path:$audioPath");
      final metadataRetriever = await AudioTags.read(audioPath);
      final image = metadataRetriever?.pictures.firstWhereOrNull(
        (element) =>
            element.pictureType == PictureType.coverFront ||
            element.pictureType == PictureType.coverBack ||
            element.pictureType == PictureType.illustration ||
            element.pictureType == PictureType.media ||
            element.pictureType == PictureType.leaflet,
      );
      if (image == null) return null;
      final filename = audioPath.split('/').last;
      final thumbnailFilename = '${filename.split('.').first}thumbmail.jpg';
      final result = await _adminSource
          .uploadAudioThumbnail(image.bytes, thumbnailFilename)
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
      print('Error uploading thumbnail: $e');
      return null;
    }
  }
}
