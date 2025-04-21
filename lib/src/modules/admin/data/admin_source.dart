import 'package:jima/src/core/supabase_infra/database.dart';
import 'package:jima/src/core/supabase_infra/storage_service.dart';
import 'package:jima/src/tools/constants/buckets.dart';
import 'package:jima/src/tools/constants/tables.dart';

class AdminSource {
  final AppDatabaseService _database;
  final AppStorageService _storageService;

  AdminSource(this._database, this._storageService);

  Future<void> uploadVideo(
    String title,
    String videoId,
    DateTime releaseDate,
  ) async {
    final videoUrl = 'https://youtu.be/$videoId';
    final imageUrl = 'https://img.youtube.com/vi/$videoId/maxresdefault.jpg';

    await _database.insert(
      Tables.videos,
      values: {
        'title': title,
        'url': videoUrl,
        'thumbnailUrl': imageUrl,
        'dateReleased': releaseDate.toUtc().toIso8601String(),
      },
    );
  }

  Future<String> uploadBookCoverImage(String path) async {
    return await _storageService.uploadFile(
      path,
      bucket: StorageBuckets.books,
    );
  }

  Future<void> uploadBook({
    required String title,
    required String bookUrl,
    required DateTime releaseDate,
    required String imageUrl,
  }) async {
    await _database.insert(
      Tables.books,
      values: {
        'title': title,
        'url': bookUrl,
        'thumbnailUrl': imageUrl,
        'dateReleased': releaseDate.toUtc().toIso8601String(),
      },
    );
  }

  Future<void> uploadAudio(
    String title,
    String spotifyUrl,
    DateTime releaseDate,
  ) async { await _database.insert(
    Tables.audios,
    values: {
      'title': title,
      'url': spotifyUrl,
      'dateReleased': releaseDate.toUtc().toIso8601String(),
    },
  );}
}
