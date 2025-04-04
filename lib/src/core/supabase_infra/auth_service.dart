import 'package:drwho_infra/drwho_infra.dart';

class SupabaseAuthService {
  final SupabaseClient _client;

  SupabaseAuthService({
    required SupabaseClient client,
  }) : _client = client;

  /// listen to auth state changes (e.g. change password, logged in, update info..etc)
  Stream<AuthState> get changes => _client.auth.onAuthStateChange;

  User? get currentState => _client.auth.currentUser;

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

  Future<void> verifyOtp(String email, String otp) async {
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
    String? phone,
  }) async {
    await _client.auth.signInWithPassword(
      password: password,
      email: email,
      phone: phone,
    );
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
}
