import 'dart:io';

import 'package:dio/dio.dart';
import 'package:jima/src/core/error_handling/failure.dart';
import 'package:equatable/equatable.dart';

typedef FutureEither<T> = Future<Either<T, Failure>>;

extension EitherFuture<T> on Future<T> {
  Future<Either<T, Failure>> tryCatch([
    Failure Function(dynamic e)? customHandler,
  ]) async {
    try {
      return Right(await this);
    } on SocketException catch (e, s) {
      return Left(
        Failure(
          message: 'Check your internet connection',
          stackTrace: s,
          exception: e,
        ),
      );
    } on DioException catch (e, s) {
      return Left(
        Failure(
          message: switch (e.response?.statusCode) {
            null => 'An error occurred',
            >= 500 => 'There was a server error',
            _ => e.message,
          },
          stackTrace: s,
          errorCode: e.response?.statusCode,
          exception: e,
        ),
      );
    } on Failure catch (e) {
      return Left(customHandler?.call(e) ?? e);
    } catch (e, s) {
      print('stack trace:$s');
      return Left(
        customHandler?.call(e) ?? Failure(message: e.toString(), stackTrace: s),
      );
    }
  }
}

sealed class Either<R, L> with EquatableMixin {
  const Either();
}

final class Right<R, L> extends Either<R, L> {
  final R value;

  const Right(this.value);

  @override
  List<Object?> get props => [value];
}

final class Left<R, L> extends Either<R, L> {
  final L value;

  const Left(this.value);

  @override
  List<Object?> get props => [value];
}
