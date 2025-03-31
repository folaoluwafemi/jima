import 'package:dio/dio.dart';
import 'package:jima/src/tools/tools_barrel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class NetworkClient {
  NetworkClient({
    required Dio dio,
    required FlutterSecureStorage flutterSecureStorage,
  })  : _dio = dio,
        _flutterSecureStorage = flutterSecureStorage {
    _setupInterceptors();
  }

  final Dio _dio;
  final FlutterSecureStorage _flutterSecureStorage;

  void _setupInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (
          RequestOptions requestOptions,
          RequestInterceptorHandler handler,
        ) async {
          final token = await _flutterSecureStorage.read(
            key: SecureStorageKeys.token,
          );

          if (token != null &&
              !Endpoints.nonTokenEndpoints.contains(requestOptions.path)) {
            requestOptions.headers['Authorization'] = 'Bearer $token';
          }

          return handler.next(requestOptions);
        },
        onError: (
          DioException e,
          ErrorInterceptorHandler handler,
        ) async {
          // Logout user if token is unauthorised
          if (e.response?.statusCode == 401) {
            final newAccessToken = await _refreshToken();
            if (newAccessToken == null) {
              return handler.next(e);
            }

            // Update the request header with the new access token
            e.requestOptions.headers['Authorization'] =
                'Bearer $newAccessToken';

            // Repeat the request with the updated header
            return handler.resolve(await _dio.fetch(e.requestOptions));
          }

          return handler.next(e);
        },
      ),
    );
    if (kDebugMode) {
      _dio.interceptors.add(PrettyDioLogger());
    }
  }

  Future<Response<dynamic>> get(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) {
    return _dio.get(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onReceiveProgress: onReceiveProgress,
    );
  }

  Future<Response<Map<String, dynamic>?>> post(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) {
    return _dio.post(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onReceiveProgress: onReceiveProgress,
    );
  }

  Future<Response<dynamic>> post2(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) {
    return _dio.post(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onReceiveProgress: onReceiveProgress,
    );
  }

  Future<Response<dynamic>> put(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) {
    return _dio.put(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onReceiveProgress: onReceiveProgress,
    );
  }

  Future<Response<Map<String, dynamic>?>> delete(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) {
    return _dio.delete(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  Future<Response<Map<String, dynamic>>> patch(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) {
    return _dio.patch(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  Future<String?> _refreshToken() async {
    try {
      final refresh = await _flutterSecureStorage.read(
        key: SecureStorageKeys.refresh,
      );
      final response = await post(
        Endpoints.refreshToken,
        data: {'refresh': refresh},
      );
      final access = response.data!['access'] as String;
      await _flutterSecureStorage.write(
        key: SecureStorageKeys.token,
        value: access,
      );
      return access;
    } on Exception catch (_) {
      // clear cache
      await _flutterSecureStorage.deleteAll();
      // logout user
      // TODO: go to login screen
      return null;
    }
  }
}
