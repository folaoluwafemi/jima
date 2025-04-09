// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';
//
// class OauthSource {
//   Future<({String? idToken, String? accessToken})?> signInWithGoogle() async {
//     try {
//       final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
//
//       if (googleUser == null) return null;
//
//       final googleAuth = await googleUser.authentication;
//
//       final idToken = googleAuth.idToken;
//       final accessToken = googleAuth.accessToken;
//
//       print("id token: $idToken");
//       print("access token: $accessToken");
//       if (idToken == null || accessToken == null) return null;
//
//       return (idToken: idToken, accessToken: accessToken);
//     } catch (e, s) {
//       print('errror at: $e $s');
//       rethrow;
//     }
//   }
//
//   Future<String?> signInWithFacebook() async {
//     final LoginResult loginResult = await FacebookAuth.instance.login();
//     return loginResult.accessToken?.tokenString;
//   }
// }
