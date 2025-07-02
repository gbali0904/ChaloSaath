import 'package:firebase_auth/firebase_auth.dart';

abstract class BaseFirebaseService {
  Future<void> saveUserData(String uid, Map<String, dynamic> userData);
  Future<UserCredential> loginWithEmail(String email, String password);
  Future<UserCredential> loginWithGoogle();
  User? getCurrentUser();
  Future<void> logout();
}
