import 'package:jima/src/core/error_handling/try_catch.dart';
import 'package:jima/src/modules/auth/data/auth_source.dart';
import 'package:vanilla_state/vanilla_state.dart';

typedef ForgotPasswordState = BaseState<Object?>;

class ForgotPasswordNotifier extends BaseNotifier<Object?> {
  final AuthSource _source;

  ForgotPasswordNotifier(this._source) : super(const InitialState());

  Future<void> sendResetInstructions(String email) async {
    setOutLoading();
    final result = await _source.sendResetInstructions(email).tryCatch();
    return switch (result) {
      Right() => setSuccess(),
      Left(:final value) => setError(value.displayMessage),
    };
  }

  Future<void> verifyOtp(String otp, String email) async {
    setOutLoading();
    final result = await _source.verifyOtp(otp: otp, email: email).tryCatch();
    return switch (result) {
      Right() => setSuccess(),
      Left(:final value) => setError(value.displayMessage),
    };
  }

  Future<void> changePassword(String password) async {
    setOutLoading();
    final result = await _source.changePassword(password).tryCatch();
    return switch (result) {
      Right() => setSuccess(),
      Left(:final value) => setError(value.displayMessage),
    };
  }
}
