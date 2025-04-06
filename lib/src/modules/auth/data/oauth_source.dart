import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class OauthSource {
  Future<({String idToken, String accessToken})?> _signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final googleAuth = await googleUser?.authentication;

    final idToken = googleAuth?.idToken;
    final accessToken = googleAuth?.accessToken;

    if (idToken == null || accessToken == null) return null;

    return (idToken: idToken, accessToken: accessToken);
  }


  Future<void> _signInWithFacebook() async {
    final LoginResult loginResult = await FacebookAuth.instance.login();

    loginResult.accessToken;
  }
}
