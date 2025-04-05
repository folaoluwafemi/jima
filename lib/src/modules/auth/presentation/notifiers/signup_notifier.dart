import 'package:jima/src/core/error_handling/try_catch.dart';
import 'package:jima/src/modules/auth/data/auth_source.dart';
import 'package:vanilla_state/vanilla_state.dart';

typedef SignupState = BaseState<Object?>;

class SignupNotifier extends BaseNotifier<Object?> {
  final AuthSource _source;

  SignupNotifier(this._source) : super(const InitialState());

  Future<void> signup({
    required String firstname,
    required String lastname,
    required String email,
    required String password,
  }) async {
    setOutLoading();

    final result = await _source
        .signup(
          firstname: firstname,
          lastname: lastname,
          email: email,
          password: password,
        )
        .tryCatch();

    return switch (result) {
      Left(:final value) => setError(value.message!),
      Right() => setSuccess(),
    };
  }
}
