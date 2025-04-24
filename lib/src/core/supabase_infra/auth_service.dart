import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseAuthService {
  final SupabaseClient _client;

  SupabaseAuthService({
    required SupabaseClient client,
  }) : _client = client;

  /// listen to auth state changes (e.g. change password, logged in, update info..etc)
  Stream<AuthState> get changes => _client.auth.onAuthStateChange;

  User? get currentState => _client.auth.currentUser;

  Session? get currentSession => _client.auth.currentSession;

  Future<void> updateUserInfo({
    String? newPassword,
    Object? data,
  }) async {
    await _client.auth.updateUser(
      UserAttributes(password: newPassword, data: data),
    );
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  Future<void> verifyOtp({required String email, required String otp}) async {
    await _client.auth.verifyOTP(
      token: otp,
      type: OtpType.magiclink,
      email: email,
    );
  }

  Future<void> requestOtp(String email) async {
    await _client.auth.resend(type: OtpType.signup, email: email);
  }

  /// this logs a user in
  Future<void> login({
    required String email,
    required String password,
  }) async {
    await _client.auth.signInWithPassword(
      password: password,
      email: email,
    );
  }

  Future<void> loginAnonymously() async {
    await _client.auth.signInAnonymously();
  }

  /// this logs a user in
  Future<void> loginWithOtp(String email) async {
    await _client.auth.signInWithOtp(
      email: email,
      shouldCreateUser: false,
    );
  }

  /// Create an account for user.
  Future<void> signUp({
    required String email,
    required String password,
    Map<String, String>? otherData,
  }) async {
    await _client.auth.signUp(
      password: password,
      email: email,
      data: otherData,
    );
  }

  /// Create an account for user
  Future<void> continueWithFacebook() async {
    await _client.auth.signInWithOAuth(
      OAuthProvider.facebook,
      authScreenLaunchMode: LaunchMode.inAppBrowserView,
      redirectTo: 'https://lrpkqywievdyqjcyheil.supabase.co/auth/v1/callback',
    );
  }

  Future<void> continueWithGoogle({
    required String idToken,
    required String accessToken,
  }) async {
    try{
      await _client.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );
    }catch(e, s){
      print('google sign in issue $e at $s');
    }
  }

  Future<void> resetPassword(String email) async {
    await _client.auth.resetPasswordForEmail(email);
  }

  // Future<void> verifyOtp({required String otp, required String email}) async {
  //   await _client.auth.verifyOTP(
  //     type: OtpType.magiclink,
  //     email: email,
  //     token: otp,
  //   );
  // }

  Future<void> updatePassword(String password) async {
    await _client.auth.updateUser(UserAttributes(password: password));
  }
}
