import 'package:chalosaath/features/authorization/data/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../home/data/Ride.dart';

abstract class BaseFirebaseService {
  Future<void> saveUserData(String phone, UserModel userData);
  Future<UserCredential> loginWithEmail(String email, String password);
  Future<UserCredential> loginWithGoogle();
  Future<UserModel?> checkUserAndPrint(String uid);
  Future<UserModel?> updateUserAddresses(UserModel userData);
  User? getCurrentUser();
  Future<void> logout();
  Future<void> saveLocations(List<String> locations);
  Future<List<String>> searchLocationsFromFirebase(String query);
  Future<List<UserModel>>  getUserList(String role) ;
  Future<List<Ride>>  getRideList() ;
  Future<void> saveRide(Map<String, dynamic> rideData);

  // Phone Auth
  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required Function(String verificationId) codeSent,
    required Function(FirebaseAuthException error) verificationFailed,
    required Function(String verificationId, int? resendToken) codeAutoRetrievalTimeout,
    required Function(PhoneAuthCredential credential) verificationCompleted,
  });
  Future<UserCredential> signInWithPhoneCredential(PhoneAuthCredential credential);
  PhoneAuthCredential getPhoneCredential(String verificationId, String smsCode);
}
