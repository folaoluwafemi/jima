import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:jima/src/core/supabase_infra/database.dart';
import 'package:jima/src/modules/donate/domain/entities/donation_data.dart';
import 'package:jima/src/modules/media/domain/entities/audio.dart';
import 'package:jima/src/modules/media/domain/entities/audio_data.dart';
import 'package:jima/src/modules/media/domain/entities/books.dart';
import 'package:jima/src/modules/media/domain/entities/categorized_media.dart';
import 'package:jima/src/modules/media/domain/entities/category.dart';
import 'package:jima/src/modules/media/domain/entities/generic_media.dart';
import 'package:jima/src/modules/media/domain/entities/generic_media_type.dart';
import 'package:jima/src/modules/media/domain/entities/video.dart';
import 'package:jima/src/tools/constants/buckets.dart';
import 'package:jima/src/tools/constants/rpc_functions.dart';
import 'package:jima/src/tools/constants/tables.dart';
import 'package:jima/src/tools/tools_barrel.dart';
import 'package:minio_new/minio.dart';

class MediaDataSource {
  final AppDatabaseService _database;

  MediaDataSource(this._database);

  Future<List<Category>> fetchAllCategories() async {
    final result = await _database.select(
      Tables.categories,
      columns: '*',
    );

    return ParseUtils.parseMapArray(result, mapper: Category.fromMap);
  }

  Future<void> deleteCategory(String id) async {
    await _database.delete(
      Tables.categories,
      filter: (request) => request.eq('id', id),
    );
  }

  Future<void> addCategory(String name) async {
    await _database.insert(
      Tables.categories,
      values: {'name': name},
    );
  }

  Future<void> deleteMedia(
    String id,
    GenericMediaType type,
    String url,
  ) async {
    await _database.delete(
      switch (type) {
        GenericMediaType.audio => Tables.audios,
        GenericMediaType.video => Tables.videos,
        GenericMediaType.book => Tables.books,
      },
      filter: (request) => request.eq('id', id),
    );
    if (type == GenericMediaType.audio) deleteAudioFile(url);
  }

  Future<void> deleteAudioFile(String downloadUrl) async {
    final minioClient = Minio(
      endPoint: dotenv.get('B2_ENDPOINT'),
      accessKey: dotenv.get('B2KEY_ID'),
      secretKey: dotenv.get('B2_SECRET_KEY'),
    );

    if (downloadUrl.isEmpty) throw "Error: Download URL cannot be empty.";

    Uri parsedUrl = Uri.parse(downloadUrl);

    String objectName = parsedUrl.path.startsWith('/')
        ? parsedUrl.path.substring(1)
        : parsedUrl.path;

    if (objectName.isEmpty) throw "Could not extract object name from URL.";

    const String bucketName = StorageBuckets.backBlazeAudios;

    print('Attempting to delete:');
    print('  Bucket: $bucketName');
    print('  Object: $objectName');
    print('  From URL: $downloadUrl');

    await minioClient.removeObject(bucketName, objectName);
  }

  Future<List<Category>> fetchCategoriesFor({
    CategorizedMedia? filter,
  }) async {
    final result = await _database.rpc(filter.filterCategoryRpcFunction);

    return ParseUtils.parseMapArray(result, mapper: Category.fromMap);
  }

  Future<List<Video>> fetchVideos({
    bool fetchAFresh = false,
    required int page,
    int? ratingFilter,
    String? categoryId,
    int pageSize = 50,
  }) async {
    final result = await _database.select(
      Tables.videos,
      columns: Video.columns,
      filter: (request) {
        var query = request.not('url', 'is', null);
        if (categoryId != null) {
          query = query.eq('categoryId', categoryId);
        }
        return query;
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
    int? ratingFilter,
    String? categoryId,
    int pageSize = 50,
  }) async {
    final result = await _database.select(
      Tables.audios,
      columns: Audio.columns,
      filter: (request) {
        var query = request.not('url', 'is', null);
        if (categoryId != null) {
          query = query.eq('categoryId', categoryId);
        }
        return query;
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
    int? ratingFilter,
    int pageSize = 50,
  }) async {
    final result = await _database.select(
      Tables.books,
      columns: Book.columns,
      filter: (request) {
        var query = request.not('url', 'is', null);
        return query;
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

  Future<List<GenericMedia>> searchMedia({
    required String searchQuery,
    required GenericMediaType? type,
    String? categoryId,
  }) async {
    final result = await _database.rpc(
      RpcFunctions.searchAllMediaByType,
      params: {
        'search_term': searchQuery,
        'item_type': type?.name.toFirstUppercase() ?? 'all',
      },
      filter: (r) => categoryId != null ? r.eq('categoryId', categoryId) : r,
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

  Future<List<Video>> searchVideos(
    String searchQuery, {
    String? categoryId,
  }) async {
    final res = await searchMedia(
      searchQuery: searchQuery,
      type: GenericMediaType.video,
      categoryId: categoryId,
    );
    return res.map((e) => e.toVideo()).toList();
  }

  Future<List<Audio>> searchAudios(
    String searchQuery, {
    String? categoryId,
  }) async {
    final res = await searchMedia(
      searchQuery: searchQuery,
      type: GenericMediaType.audio,
      categoryId: categoryId,
    );
    return res.map((e) => e.toAudio()).toList();
  }

  Future<List<GenericMedia>> fetchHighestViewCountItem() async {
    final result = await _database.rpc(
      RpcFunctions.getHighestViewCountItem,
    );

    return ParseUtils.parseMapArray(result, mapper: GenericMedia.fromMap);
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

  Future<void> uploadDonationData(DonationData data) async {
    await _database.update(
      Tables.usageData,
      values: {'donation': data.toMap()},
      filter: (request) => request.eq('id', 1),
    );
  }

  Future<(AudioData, DonationData?)> fetchAudioData() async {
    final value = await _database.selectSingle(Tables.usageData);

    final AudioData audioData = ParseUtils.parseJson(
      value,
      mapper: AudioData.fromMap,
    );

    final donationData = ParseUtils.maybeParseJson(
      value['donation'],
      mapper: DonationData.fromMap,
    );
    return (audioData, donationData);
  }

  Future<DonationData?> fetchDonationData() async {
    final value = await _database.selectSingle(Tables.usageData);

    return ParseUtils.maybeParseJson(
      value['donation'],
      mapper: DonationData.fromMap,
    );
  }
}
