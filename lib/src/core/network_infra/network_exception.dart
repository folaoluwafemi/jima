import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class NetworkException implements Exception {
  NetworkException({required this.message});

  NetworkException.handleError(Object error) {
    if (error is DioException) {
      _handleDioError(error);
    } else {
      _handleException(error);
    }
  }

  String message = '';

  void _handleDioError(DioException dioException) {
    debugPrint('DioException: $dioException');
    switch (dioException.type) {
      case DioExceptionType.cancel:
        message = 'Request to server was cancelled';
      case DioExceptionType.connectionTimeout:
        message = 'Connection timeout with server';
      case DioExceptionType.receiveTimeout:
        message = 'Receive timeout in connection with server';
      case DioExceptionType.badResponse:
        message = _handleResponseError(dioException.response!);
      case DioExceptionType.sendTimeout:
        message = 'Send timeout in connection wth server';
      case DioExceptionType.connectionError:
        message = 'An error occurred connecting to the server';
      case DioExceptionType.badCertificate:
        message = 'Expired certificate';
      case DioExceptionType.unknown:
        message = 'Connection closed before full header was received';
    }
  }

  void _handleException(dynamic exception) {
    debugPrint('Exception: $exception');
    if (exception is SocketException) {
      message = 'No internet connection';
    } else if (exception is String) {
      message = exception;
    } else if (exception is Exception) {
      message = exception.toString();
    } else {
      message = 'An unexpected error occurred, please try again';
    }
  }

  String _handleResponseError(Response<dynamic> response) {
    log('Error: ${response.data}');
    if (response.data != null) {
      try {
        if (response.data is Map<String, dynamic>) {
          final errorResponse = response.data as Map<String, dynamic>?;

          String? responseMessage;

          errorResponse?.forEach((key, value) {
            if (value is List) {
              responseMessage = List<String>.from(value).first;
            } else if (value is String) {
              responseMessage = value;
            }
          });

          if (errorResponse?['error'] != null) {
            if (errorResponse?['error'] is String) {
              responseMessage = errorResponse?['error'] as String;
            } else if (errorResponse?['error'] is List<dynamic>) {
              responseMessage = (errorResponse?['error'] as List<String>).first;
            } else if (errorResponse?['error'] is Map<String, dynamic>) {
              (errorResponse?['error'] as Map<String, dynamic>).forEach((key, value) {
                if (value is List) {
                  responseMessage = List<String>.from(value).first;
                } else if (value is String) {
                  responseMessage = value;
                } else {
                  responseMessage = value.toString();
                }
              });
            } else {
              responseMessage = (errorResponse?['error'] as Map<String, dynamic>)['message'] as String?;
            }
          }

          return responseMessage ?? 'Unable to parse server response';
        } else {
          return response.data.toString();
        }
      } on DioException catch (_) {
        return response.data.toString();
      } on FormatException catch (_) {
        return response.data.toString();
      } on Exception catch (_) {
        return response.data.toString();
      }
    } else {
      switch (response.statusCode) {
        case 400:
          return 'Bad request';
        case 404:
          return 'The requested resource was not found';
        case 500:
          return 'Internal server error';
        default:
          return 'Something went wrong';
      }
    }
  }

  @override
  String toString() => message;
}
