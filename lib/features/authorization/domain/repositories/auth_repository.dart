import 'package:firebase_auth/firebase_auth.dart';

import '../../data/user_model.dart';

abstract class AuthRepository {

  Future<UserCredential?> googleLogin() async {}

  Future<void> registerUser({required UserModel userData});

  Future<UserCredential?> loginUser({required String email, required String password});
}

