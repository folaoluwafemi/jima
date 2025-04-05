import 'package:jima/src/core/error_handling/try_catch.dart';
import 'package:jima/src/modules/auth/data/auth_source.dart';
import 'package:jima/src/modules/auth/presentation/_states/login_state_data.dart';
import 'package:vanilla_state/vanilla_state.dart';

typedef LoginState = BaseState<LoginStateData>;

class LoginNotifier extends BaseNotifier<LoginStateData> {
  final AuthSource _source;

  LoginNotifier(this._source) : super(const InitialState());

  Future<void> login({
    required String email,
    required String password,
  }) async {
    setOutLoading();

    final result = await _source.login(email: email, password: password).tryCatch();

    return switch (result) {
      Left(:final value) => setError(value.message!),
      Right() => setSuccess(),
    };
  }
}
