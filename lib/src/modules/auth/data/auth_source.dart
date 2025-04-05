import 'package:jima/src/core/supabase_infra/auth_service.dart';

class AuthSource {
  final SupabaseAuthService _authService;

  AuthSource(this._authService);

  Future<void> login({
    required String email,
    required String password,
  }) async {
    await _authService.login(
      email: email,
      password: password,
    );
  }

  Future<void> signup({
    required String firstname,
    required String lastname,
    required String email,
    required String password,
  }) async {
    await _authService.signUp(
      email: email,
      password: password,
      otherData: {'firstname': firstname, 'lastname': lastname, 'email': email},
    );
  }

  Future<void> loginWithGoogle() async {
    await _authService.continueWithGoogle();
  }

  Future<void> loginWithFacebook() async {
    await _authService.continueWithFacebook();
  }

  Future<void> sendResetInstructions(String email) async {
    await _authService.resetPassword(email);
  }
}
