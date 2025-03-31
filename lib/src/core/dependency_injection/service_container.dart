import 'package:dio/dio.dart';
import 'package:jima/src/core/network_infra/network_client.dart';
import 'package:jima/src/tools/tools_barrel.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

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
    ..registerLazySingleton(
      () => NetworkClient(
        dio: container(),
        flutterSecureStorage: container(),
      ),
    );
}
