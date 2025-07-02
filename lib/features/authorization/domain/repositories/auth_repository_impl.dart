import 'package:firebase_auth/firebase_auth.dart';

import '../../../firebase/domain/BaseFirebaseService.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../data/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final BaseFirebaseService _firebaseService;
  AuthRepositoryImpl(this._firebaseService);

  @override
  Future<void> registerUser({required UserModel userData}) async {
    try {
      await _firebaseService.saveUserData(userData.uid, userData.toJson());
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? 'Registration failed');
    }
  }

  @override
  Future<UserCredential> loginUser({
    required String email,
    required String password,
  }) {
    return _firebaseService.loginWithEmail(email, password);
  }

  @override
  Future<UserCredential> googleLogin() {
    return _firebaseService.loginWithGoogle();
  }

  @override
  User? getCurrentUser() => _firebaseService.getCurrentUser();

  @override
  Future<void> logout() => _firebaseService.logout();
}
