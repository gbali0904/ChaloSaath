import 'package:chalosaath/features/authorization/data/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class BaseFirebaseService {
  Future<void> saveUserData(String email, Map<String, dynamic> userData);
  Future<UserCredential> loginWithEmail(String email, String password);
  Future<UserCredential> loginWithGoogle();
  Future<UserModel?> checkUserAndPrint(String uid);
  Future<UserModel?> updateUserAddresses(UserModel userData);
  User? getCurrentUser();
  Future<void> logout();
  Future<void> saveLocations(List<String> locations);
  Future<List<String>> searchLocationsFromFirebase(String query);
  Future<List<UserModel>>  getUserList(String role) ;
}
