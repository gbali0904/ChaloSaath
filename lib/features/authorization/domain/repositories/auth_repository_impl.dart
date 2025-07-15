import 'package:firebase_auth/firebase_auth.dart';
import '../../../data_providers/domain/base_firebase_service.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../data/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final BaseFirebaseService _firebaseService;
  AuthRepositoryImpl(this._firebaseService);

  @override
  Future<UserModel> registerUser({required UserModel userData}) async {
    try {
      await _firebaseService.saveUserData(userData.email, userData);
      return userData;  // Return the same user model after saving
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

  @override
  Future<UserModel?> checkUser({required String email}) {
    return _firebaseService.checkUserAndPrint(email);
  }
}
