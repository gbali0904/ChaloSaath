import '../../data/user_model.dart';

abstract class AuthRepository {
  Future<void> registerUser({
    required UserModel userData,
  });
}