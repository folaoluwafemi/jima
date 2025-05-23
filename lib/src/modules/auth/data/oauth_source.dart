import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:jima/src/modules/profile/domain/entities/user.dart';
import 'package:jima/src/modules/profile/domain/entities/user_privilege.dart';
import 'package:jima/src/tools/extensions/extensions.dart';

class OauthSource {
  Future<
      ({
        String? idToken,
        String? accessToken,
        User user,
      })?> signInWithGoogle() async {
    try {
      if (await GoogleSignIn().isSignedIn()) {
        await GoogleSignIn().signOut();
      }

      final GoogleSignInAccount? googleUser = await GoogleSignIn(
        scopes: [
          'email',
          'https://www.googleapis.com/auth/userinfo.profile',
        ],
        serverClientId: dotenv.get('GOOGLE_WEB_CLIENT_ID'),
      ).signIn();

      if (googleUser == null) return null;

      final googleAuth = await googleUser.authentication;

      final idToken = googleAuth.idToken;
      final accessToken = googleAuth.accessToken;

      if (idToken == null || accessToken == null) return null;

      final User user = User(
        id: '',
        email: googleUser.email,
        firstname: googleUser.displayName?.words.firstOrNull,
        lastname: googleUser.displayName?.words.lastOrNull,
        profilePhoto: googleUser.photoUrl,
        createdAt: DateTime.now(),
        privilege: UserPrivilege.user,
      );

      return (idToken: idToken, accessToken: accessToken, user: user);
    } catch (e, s) {
      print('error at: $e $s');
      rethrow;
    }
  }

  // Future<String?> signInWithFacebook() async {
  //   final LoginResult loginResult = await FacebookAuth.instance.login();
  //   return loginResult.accessToken?.tokenString;
  // }
}
