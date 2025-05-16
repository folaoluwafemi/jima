import 'dart:typed_data';

import 'package:jima/src/core/supabase_infra/database.dart';
import 'package:jima/src/core/supabase_infra/storage_service.dart';
import 'package:jima/src/modules/media/domain/entities/category.dart';
import 'package:jima/src/modules/profile/domain/entities/user.dart';
import 'package:jima/src/modules/profile/domain/entities/user_privilege.dart';
import 'package:jima/src/tools/constants/buckets.dart';
import 'package:jima/src/tools/constants/tables.dart';
import 'package:jima/src/tools/tools_barrel.dart';

class AdminSource {
  final AppDatabaseService _database;
  final AppStorageService _storageService;

  AdminSource(this._database, this._storageService);

  Future<void> uploadVideo(
    String title,
    String videoId,
    DateTime releaseDate,
    Category category,
  ) async {
    final videoUrl = 'https://youtu.be/$videoId';
    final imageUrl = 'https://img.youtube.com/vi/$videoId/maxresdefault.jpg';

    await _database.insert(
      Tables.videos,
      values: {
        'title': title,
        'url': videoUrl,
        'thumbnailUrl': imageUrl,
        'categoryId': category.id,
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

  Future<void> uploadBook(
    String title,
    String bookUrl,
    DateTime releaseDate,
    String imageUrl,
    Category category,
  ) async {
    await _database.insert(
      Tables.books,
      values: {
        'title': title,
        'url': bookUrl,
        'thumbnailUrl': imageUrl,
        'categoryId': category.id,
        'dateReleased': releaseDate.toUtc().toIso8601String(),
      },
    );
  }

  Future<void> uploadAudio({
    required String title,
    required String audioUrl,
    required DateTime releaseDate,
    required String? thumbnail,
    required Category category,
  }) async {
    await _database.insert(
      Tables.audios,
      values: {
        'thumbnailUrl': thumbnail,
        'title': title,
        'url': audioUrl,
        'categoryId': category.id,
        'dateReleased': releaseDate.toUtc().toIso8601String(),
      },
    );
  }

  Future<String> uploadAudioFile(String filePath) async {
    return await _storageService.uploadFile(
      filePath,
      bucket: StorageBuckets.audio,
    );
  }

  Future<String> uploadAudioThumbnail(
    Uint8List data,
    String filename,
  ) async {
    return await _storageService.uploadFileBinary(
      data,
      filename,
      bucket: StorageBuckets.audioThumbnails,
    );
  }

  Future<void> switchUsersToAdmin(String email) async {
    final checkExists = await _database.countSelection(
      Tables.users,
      filter: (request) => request.eq('email', email),
    );

    if (checkExists.$1 != 1) throw 'User does not exist';

    await _database.update(
      Tables.users,
      values: {'privilege': UserPrivilege.admin.enumValue},
      filter: (request) => request.eq('email', email),
    );
  }

  Future<void> removeUserAsAdmin(String id) async {
    await _database.update(
      Tables.users,
      values: {'privilege': UserPrivilege.user.enumValue},
      filter: (request) => request.eq('id', id),
    );
  }

  Future<List<User>> fetchAdmins() async {
    final values = await _database.select(
      Tables.users,
      filter: (req) => req.eq('privilege', UserPrivilege.admin.enumValue),
    );

    return ParseUtils.parseMapArray(values, mapper: User.fromMap);
  }
}
