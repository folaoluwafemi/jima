import 'package:jima/src/core/core.dart';
import 'package:jima/src/core/error_handling/try_catch.dart';
import 'package:jima/src/modules/auth/data/auth_source.dart';
import 'package:jima/src/modules/profile/presentation/cubits/user_cubit.dart';
import 'package:vanilla_state/vanilla_state.dart';

typedef AuthActionState = BaseState<Object?>;

class AuthActionNotifier extends BaseNotifier<Object?> {
  final AuthSource _source;

  AuthActionNotifier(this._source) : super(const InitialState());

  Future<void> loginWithGoogle() async {
    setOutLoading();

    final result = await _source.loginWithGoogle().tryCatch();

    return switch (result) {
      Left(:final value) => setError(value.message!),
      Right(:final value) => () {
          setSuccess();
          container<UserNotifier>().setData(value);
        }(),
    };
  }

  Future<void> loginWithFacebook() async {
    setInLoading();

    final result = await _source.loginWithFacebook().tryCatch();

    return switch (result) {
      Left(:final value) => setError(value.message!),
      Right(:final value) => () {
          setSuccess();
          container<UserNotifier>().setData(value);
        }(),
    };
  }

  Future<void> loginAnonymously() async {
    value = const FatalErrorState(message: 'logging in anonymously');

    final result = await _source.loginAnonymously().tryCatch();

    return switch (result) {
      Left(:final value) => setError(value.message!),
      Right(:final value) => () {
          setSuccess();
          container<UserNotifier>().setData(value);
        }(),
    };
  }
}
