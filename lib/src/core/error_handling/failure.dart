class Failure implements Exception {
  final String? message;
  final int? errorCode;
  final Exception? exception;
  final StackTrace _stackTrace;

  Failure({
    this.message,
    this.errorCode,
    this.exception,
    StackTrace? stackTrace,
  }) : _stackTrace = stackTrace ?? StackTrace.current;

  @override
  String toString() => ''' | --- Failure --- |
  message: $message
  errorCode: $errorCode
  exception: $exception
  stackTrace: $_stackTrace
  ''';

  Failure copyWith({
    final int? errorCode,
    final String? message,
    final Exception? exception,
    final StackTrace? stackTrace,
  }) {
    return Failure(
      message: message ?? this.message,
      errorCode: errorCode ?? this.errorCode,
      exception: exception ?? this.exception,
      stackTrace: stackTrace ?? _stackTrace,
    );
  }
}
