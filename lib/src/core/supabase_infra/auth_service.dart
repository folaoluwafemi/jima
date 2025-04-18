import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';

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
  }) async {
    await _client.auth.signInWithPassword(
      password: password,
      email: email,
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

  /// Create an account for user
  Future<void> continueWithFacebook() async {
    await _client.auth.signInWithOAuth(
      OAuthProvider.facebook,
      authScreenLaunchMode: LaunchMode.inAppBrowserView,
      redirectTo: 'https://lrpkqywievdyqjcyheil.supabase.co/auth/v1/callback',
    );
  }

  Future<void> continueWithGoogle() async {
    await _client.auth.signInWithOAuth(
      OAuthProvider.google,
      authScreenLaunchMode: Platform.isAndroid
          ? LaunchMode.externalApplication
          : LaunchMode.inAppWebView,
      redirectTo: 'https://lrpkqywievdyqjcyheil.supabase.co/auth/v1/callback',
    );
  }

  Future<void> resetPassword(String email) async {
    // await _client.auth.updateUser(UserAttributes(password: ) );
  }
}
