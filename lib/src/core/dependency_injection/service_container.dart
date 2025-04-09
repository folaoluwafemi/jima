import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:jima/src/core/supabase_infra/auth_service.dart';
import 'package:jima/src/core/supabase_infra/database.dart';
import 'package:jima/src/core/supabase_infra/storage_service.dart';
import 'package:jima/src/core/supabase_infra/supabase_api.dart';
import 'package:jima/src/modules/auth/data/auth_source.dart';
import 'package:jima/src/modules/media/data/media_data_source.dart';
import 'package:jima/src/modules/media/presentations/cubits/all_view_count_notifier.dart';
import 'package:jima/src/modules/media/presentations/cubits/audios_notifier.dart';
import 'package:jima/src/modules/media/presentations/cubits/books_notifier.dart';
import 'package:jima/src/modules/media/presentations/cubits/search_all_media_notifier.dart';
import 'package:jima/src/modules/media/presentations/cubits/videos_notifier.dart';
import 'package:jima/src/tools/tools_barrel.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final container = GetIt.instance;

void injectDependencies() {
  container
    ..registerLazySingleton(
      () => Dio(
        BaseOptions(
          baseUrl: Endpoints.baseUrl,
          contentType: 'application/json',
        ),
      ),
    )
    ..registerLazySingleton(() => const FlutterSecureStorage())
    ..registerLazySingleton(() => AppDatabaseService(client: container()))
    ..registerLazySingleton(() => SupabaseApi())
    ..registerLazySingleton<SupabaseClient>(
      () => container<SupabaseApi>().client,
    )
    ..registerLazySingleton(() => SupabaseAuthService(client: container()))
    ..registerLazySingleton(() => AppStorageService(client: container()))
    ..registerLazySingleton(() => AuthSource(container()))
    ..registerLazySingleton(() => MediaDataSource(container()))
    ..registerLazySingleton(() => HighestViewedNotifier(container()))
    ..registerLazySingleton(() => SearchAllMediaNotifier(container()))
    ..registerLazySingleton(() => VideosNotifier(container()))
    ..registerLazySingleton(() => AudiosNotifier(container()))
    ..registerLazySingleton(() => BooksNotifier(container()));
}
