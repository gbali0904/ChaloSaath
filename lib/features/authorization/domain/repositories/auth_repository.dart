import 'package:firebase_auth/firebase_auth.dart';

import '../../data/user_model.dart';

abstract class AuthRepository {
  Future<void> registerUser({
    required UserModel userData,
  });

  Future<UserCredential?> googleLogin() async {}
}