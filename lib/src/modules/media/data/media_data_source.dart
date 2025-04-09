import 'package:jima/src/core/supabase_infra/database.dart';
import 'package:jima/src/modules/media/domain/entities/audio.dart';
import 'package:jima/src/modules/media/domain/entities/books.dart';
import 'package:jima/src/modules/media/domain/entities/generic_media.dart';
import 'package:jima/src/modules/media/domain/entities/video.dart';
import 'package:jima/src/tools/constants/rpc_functions.dart';
import 'package:jima/src/tools/constants/tables.dart';

class MediaDataSource {
  final AppDatabaseService _database;

  MediaDataSource(this._database);

  Future<List<Video>> fetchVideos({
    bool fetchAFresh = false,
    required int page,
    String? searchQuery,
    int? ratingFilter,
    int pageSize = 50,
  }) async {
    final result = await _database.select(
      Tables.videos,
      columns: Video.columns,
      filter: (request) {
        return searchQuery != null
            ? request.ilikeAnyOf('title', ['%', searchQuery, '%'])
            : request;
      },
      transform: (request) {
        final int start = page == 0 ? 0 : (page - 1) * pageSize;
        return request
            .range(start, start + pageSize - 1)
            .order('createdAt', ascending: false);
      },
    );

    return (result as List)
        .cast<Map<String, dynamic>>()
        .map(Video.fromMap)
        .toList();
  }

  Future<List<Audio>> fetchAudios({
    bool fetchAFresh = false,
    required int page,
    String? searchQuery,
    int? ratingFilter,
    int pageSize = 50,
  }) async {
    final result = await _database.select(
      Tables.audios,
      columns: Audio.columns,
      filter: (request) {
        return searchQuery != null
            ? request.ilikeAnyOf('title', ['%', searchQuery, '%'])
            : request;
      },
      transform: (request) {
        final int start = page == 0 ? 0 : (page - 1) * pageSize;
        return request
            .range(start, start + pageSize - 1)
            .order('createdAt', ascending: false);
      },
    );

    return (result as List)
        .cast<Map<String, dynamic>>()
        .map(Audio.fromMap)
        .toList();
  }

  Future<List<Book>> fetchBooks({
    bool fetchAFresh = false,
    required int page,
    String? searchQuery,
    int? ratingFilter,
    int pageSize = 50,
  }) async {
    final result = await _database.select(
      Tables.books,
      columns: Audio.columns,
      filter: (request) {
        return searchQuery != null
            ? request.ilikeAnyOf('title', ['%', searchQuery, '%'])
            : request;
      },
      transform: (request) {
        final int start = page == 0 ? 0 : (page - 1) * pageSize;
        return request
            .range(start, start + pageSize - 1)
            .order('createdAt', ascending: false);
      },
    );

    return (result as List)
        .cast<Map<String, dynamic>>()
        .map(Book.fromMap)
        .toList();
  }

  Future<List<GenericMedia>> searchMedia(String searchQuery) async {
    final result = await _database.rpc(
      RpcFunctions.searchAllMedia,
      filter: (request) => request.ilikeAnyOf('title', ['%', searchQuery, '%']),
    );

    return (result as List)
        .cast<Map<String, dynamic>>()
        .map(GenericMedia.fromMap)
        .toList();
  }

  Future<GenericMedia> fetchHighestViewCountItem() async {
    final result = await _database.rpc(RpcFunctions.getHighestViewCountItem);

    return GenericMedia.fromMap(((result[0]) as Map).cast());
  }
}
