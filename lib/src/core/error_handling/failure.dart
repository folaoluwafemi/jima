class Failure implements Exception {
  final String? message;
  final String? errorCode;
  final Exception? exception;
  final StackTrace _stackTrace;

  String get displayMessage => message ?? 'An error occurred';

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
    final String? errorCode,
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
