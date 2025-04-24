import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class OauthSource {
  Future<({String? idToken, String? accessToken})?> signInWithGoogle() async {
    try {
      if (await GoogleSignIn().isSignedIn()) {
        await GoogleSignIn().signOut();
      }

      final GoogleSignInAccount? googleUser = await GoogleSignIn(
        scopes: [
          'email',
          'https://www.googleapis.com/auth/userinfo.profile',
        ],
        serverClientId: dotenv.get(
          'GOOGLE_WEB_CLIENT_ID',
          fallback: '392098157619-mmttihkl8jq9vitlvf76uqourjo406md.apps.googleusercontent.com',
        ),
      ).signIn();

      if (googleUser == null) return null;

      final googleAuth = await googleUser.authentication;

      final idToken = googleAuth.idToken;
      final accessToken = googleAuth.accessToken;

      if (idToken == null || accessToken == null) return null;

      return (idToken: idToken, accessToken: accessToken);
    } catch (e, s) {
      print('error at: $e $s');
      rethrow;
    }
  }

  Future<String?> signInWithFacebook() async {
    final LoginResult loginResult = await FacebookAuth.instance.login();
    return loginResult.accessToken?.tokenString;
  }
}
