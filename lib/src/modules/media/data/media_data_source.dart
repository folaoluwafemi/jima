import 'package:jima/src/core/supabase_infra/database.dart';
import 'package:jima/src/modules/media/domain/entities/audio.dart';
import 'package:jima/src/modules/media/domain/entities/audio_data.dart';
import 'package:jima/src/modules/media/domain/entities/books.dart';
import 'package:jima/src/modules/media/domain/entities/generic_media.dart';
import 'package:jima/src/modules/media/domain/entities/generic_media_type.dart';
import 'package:jima/src/modules/media/domain/entities/video.dart';
import 'package:jima/src/tools/constants/rpc_functions.dart';
import 'package:jima/src/tools/constants/tables.dart';
import 'package:jima/src/tools/tools_barrel.dart';

class MediaDataSource {
  final AppDatabaseService _database;

  MediaDataSource(this._database);

  Future<List<Video>> fetchVideos({
    bool fetchAFresh = false,
    required int page,
    int? ratingFilter,
    int pageSize = 50,
  }) async {
    final result = await _database.select(
      Tables.videos,
      columns: Video.columns,
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
    int? ratingFilter,
    int pageSize = 50,
  }) async {
    final result = await _database.select(
      Tables.audios,
      columns: Audio.columns,
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
    int? ratingFilter,
    int pageSize = 50,
  }) async {
    final result = await _database.select(
      Tables.books,
      columns: Audio.columns,
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

  Future<List<GenericMedia>> searchMedia({
    required String searchQuery,
    required GenericMediaType? type,
  }) async {
    final result = await _database.rpc(
      RpcFunctions.searchAllMediaByType,
      params: {
        'search_term': searchQuery,
        'item_type': type?.name.toFirstUppercase() ?? 'all',
      },
    );

    return (result as List)
        .cast<Map<String, dynamic>>()
        .map(GenericMedia.fromMap)
        .toList();
  }

  Future<List<Book>> searchBooks(String searchQuery) async {
    final res = await searchMedia(
      searchQuery: searchQuery,
      type: GenericMediaType.book,
    );
    return res.map((e) => e.toBook()).toList();
  }

  Future<List<Video>> searchVideos(String searchQuery) async {
    final res = await searchMedia(
      searchQuery: searchQuery,
      type: GenericMediaType.video,
    );
    return res.map((e) => e.toVideo()).toList();
  }

  Future<List<Audio>> searchAudios(String searchQuery) async {
    final res = await searchMedia(
      searchQuery: searchQuery,
      type: GenericMediaType.audio,
    );
    return res.map((e) => e.toAudio()).toList();
  }

  Future<GenericMedia> fetchHighestViewCountItem() async {
    final result = await _database.rpc(RpcFunctions.getHighestViewCountItem);

    return GenericMedia.fromMap(((result[0]) as Map).cast());
  }

  Future<void> increaseMediaViewedCount({
    required String id,
    required GenericMediaType type,
  }) async {
    await _database.rpc(
      RpcFunctions.increaseMediaViewedCount,
      params: {'media_id': id, 'source': type.tableName},
    );
  }

  Future<AudioData> fetchAudioData() async {
    final value = await _database.select(Tables.audioData);

    return ParseUtils.parseJson(value[0], mapper: AudioData.fromMap);
  }
}
