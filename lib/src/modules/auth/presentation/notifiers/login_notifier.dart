import 'package:jima/src/core/error_handling/try_catch.dart';
import 'package:jima/src/modules/auth/presentation/_states/login_state_data.dart';
import 'package:vanilla_state/vanilla_state.dart';

class LoginNotifier extends BaseNotifier<LoginStateData> {
  LoginNotifier() : super(const InitialState());

  Future<void> login() async {
    setOutLoading();

    final result = await Future.delayed(
      const Duration(milliseconds: 1000),
    ).tryCatch();

    return switch (result) {
      Left(:final value) => setError(value.message!),
      Right() => setSuccess(),
    };
  }
}
