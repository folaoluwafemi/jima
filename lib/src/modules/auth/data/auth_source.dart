import 'package:google_sign_in/google_sign_in.dart';
import 'package:jima/src/core/core.dart';
import 'package:jima/src/core/error_handling/try_catch.dart';
import 'package:jima/src/core/supabase_infra/auth_service.dart';
import 'package:jima/src/core/supabase_infra/database.dart';
import 'package:jima/src/modules/auth/data/oauth_source.dart';
import 'package:jima/src/modules/profile/domain/entities/user.dart';
import 'package:jima/src/tools/constants/tables.dart';

class AuthSource {
  final SupabaseAuthService _authService;
  final AppDatabaseService _databaseService;

  AuthSource(this._authService, this._databaseService);

  Future<void> login({
    required String email,
    required String password,
  }) async {
    await _authService.login(
      email: email,
      password: password,
    );
  }

  Future<User> signup({required User seed, required String password}) async {
    await _authService.signUp(email: seed.email!, password: password);

    // delay to allow supabase internal get the updated user
    await Future.delayed(const Duration(milliseconds: 500));
    final id = _authService.currentState!.id;

    return _fetchOrCreateUser(seed: seed, id: id);
  }

  Future<User> loginWithGoogle() async {
    final value = await container<OauthSource>().signInWithGoogle();

    await _authService.continueWithGoogle(
      idToken: value!.idToken!,
      accessToken: value.accessToken!,
    );

    // delay to allow supabase internal get the updated user
    await Future.delayed(const Duration(milliseconds: 500));
    final id = _authService.currentState!.id;

    return await _fetchOrCreateUser(seed: value.user, id: id);
  }

  Future<User> _fetchOrCreateUser({
    required User seed,
    required String id,
  }) async {
    final result = await _databaseService
        .selectSingle(Tables.users, filter: (request) => request.eq('id', id))
        .tryCatch();

    if (result case Right(:final value)) return User.fromMap(value);

    await _databaseService.insert(
      Tables.users,
      values: seed.copyWith(id: id).toMap(),
    );

    final updatedUser = await _databaseService.selectSingle(
      Tables.users,
      filter: (request) => request.eq('id', id),
    );

    return User.fromMap(updatedUser);
  }

  Future<User> loginWithFacebook() async {
    await _authService.continueWithFacebook();
    // delay to allow supabase internal get the updated user
    await Future.delayed(const Duration(milliseconds: 500));
    final id = _authService.currentState!.id;
    final email = _authService.currentState!.email;

    return await _fetchOrCreateUser(
      seed: User.create(id: id, email: email),
      id: id,
    );
  }

  Future<User> loginAnonymously() async {
    await _authService.loginAnonymously();

    await Future.delayed(const Duration(milliseconds: 500));
    final id = _authService.currentState!.id;
    final email = _authService.currentState!.email;

    return await _fetchOrCreateUser(
      seed: User.create(id: id, email: email),
      id: id,
    );
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
