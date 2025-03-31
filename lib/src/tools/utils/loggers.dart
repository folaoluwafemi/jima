import 'dart:developer';

import 'package:flutter/foundation.dart';

class Logger {
  static DateTime get _now => DateTime.now();

  static void info(dynamic data) {
    if (kDebugMode) {
      log(
        'MESSAGE -> $data',
        time: _now,
        name: 'JIMA::INFO::LOGGER',
      );
    }
  }

  static void error(
    Object exception, {
    StackTrace? stackTrace,
    Object? error,
    Map<String, dynamic>? hint,
  }) {
    if (kDebugMode) {
      log(
        'Exception -> $exception',
        time: _now,
        stackTrace: stackTrace,
        error: error,
        name: 'JIMA::ERROR::LOGGER',
      );
    }
  }
}
