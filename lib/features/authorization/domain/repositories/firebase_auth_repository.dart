import 'package:chalosaath/features/authorization/data/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../domain/repositories/auth_repository.dart';

class FirebaseAuthRepository implements AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  final GoogleSignIn _googleSignIn = GoogleSignIn();


  FirebaseAuthRepository(this._firebaseAuth, this._firestore);

  @override
  Future<void> registerUser({required UserModel userData}) async {
    try {
      await _firestore
          .collection('users')
          .doc(userData.uid)
          .set(userData.toJson());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        throw Exception('Email already exists');
      } else {
        throw Exception(e.message ?? 'Registration failed');
      }
    }
  }

  @override
  Future<UserCredential> googleLogin() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw Exception('Login cancelled');
      }

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      return await _firebaseAuth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        throw Exception('Email already exists');
      } else {
        throw Exception(e.message ?? 'Registration failed');
      }
    }
  }

  Future<UserCredential> loginUser(
      {required String email, required String password}) {
    return _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
  }
}
