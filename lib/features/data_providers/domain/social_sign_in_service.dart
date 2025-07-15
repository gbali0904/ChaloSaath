import 'package:firebase_auth/firebase_auth.dart';

abstract class SocialSignInService {
  Future<OAuthCredential> signInWithGoogle();
  Future<void> logout();
}
