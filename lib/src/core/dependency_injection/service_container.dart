import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:jima/src/core/supabase_infra/auth_service.dart';
import 'package:jima/src/core/supabase_infra/database.dart';
import 'package:jima/src/core/supabase_infra/storage_service.dart';
import 'package:jima/src/core/supabase_infra/supabase_api.dart';
import 'package:jima/src/modules/auth/data/auth_source.dart';
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
    ..registerLazySingleton(() => AuthSource(container()));
}
