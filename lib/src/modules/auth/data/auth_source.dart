import 'package:google_sign_in/google_sign_in.dart';
import 'package:jima/src/core/core.dart';
import 'package:jima/src/core/supabase_infra/auth_service.dart';
import 'package:jima/src/modules/auth/data/oauth_source.dart';
import 'package:jima/src/tools/tools_barrel.dart';

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
    final value = await container<OauthSource>().signInWithGoogle();

    await _authService.continueWithGoogle(
      idToken: value!.idToken!,
      accessToken: value.accessToken!,
    );
  }

  Future<void> loginWithFacebook() async {
    await _authService.continueWithFacebook();
  }

  Future<void> loginAnonymously() async {
    await _authService.loginAnonymously();
  }

  Future<void> sendResetInstructions(String email) async {
    await _authService.resetPassword(email);
  }

  Future<void> verifyOtp({
    required String otp,
    required String email,
  }) async {
    await _authService.verifyOtp(email: email, otp: otp);
  }

  Future<void> switchUsersToAdmin() async {
    await _authService.updateUserInfo(data: {'is_admin': true});
    await Future.delayed(const Duration(milliseconds: 200));
    Logger.info('metadata: ${_authService.currentState?.userMetadata}');
  }

  bool get isUserAdmin {
    return _authService.currentState?.userMetadata?['is_admin'] == 'true' ||
        _authService.currentState?.userMetadata?['is_admin'] == true;
  }

  bool get isUserAnonymous {
    return _authService.currentState?.isAnonymous == true;
  }

  Future<void> changePassword(String password) async {
    await _authService.updatePassword(password);
  }

  Future<void> signOut() async {
    await container<SupabaseAuthService>().signOut();
    if (await GoogleSignIn().isSignedIn()) {
      await GoogleSignIn().signOut();
    }
  }
}
