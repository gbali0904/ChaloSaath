import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../domain/social_sign_in_service.dart';
class SocialSignInServiceImpl implements SocialSignInService {
  final GoogleSignIn _googleSignIn = GoogleSignIn();


  @override
  Future<OAuthCredential> signInWithGoogle() async {
    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) {
      throw Exception('Google sign-in cancelled');
    }

    final googleAuth = await googleUser.authentication;
    return GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
  }

  @override
  Future<void> logout() async {
    await _googleSignIn.signOut();
  }
}