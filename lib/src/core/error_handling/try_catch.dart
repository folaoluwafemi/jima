import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:jima/src/core/error_handling/failure.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
    } on AuthException catch (e, s) {
      return Left(
        Failure(
          message: e.message,
          stackTrace: s,
          exception: e,
          errorCode: e.code,
        ),
      );
    } on PostgrestException catch (e, s) {
      print('stack trace${e.runtimeType}$e:$s');
      return Left(
        Failure(
          message: e.message,
          stackTrace: s,
          exception: e,
          errorCode: e.code,
        ),
      );
    } on Failure catch (e) {
      return Left(customHandler?.call(e) ?? e);
    } catch (e, s) {
      print('stack trace${e.runtimeType}$e:$s');
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
