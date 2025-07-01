import 'package:chalosaath/features/authorization/data/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/repositories/auth_repository.dart';

class FirebaseAuthRepository implements AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  FirebaseAuthRepository(this._firebaseAuth, this._firestore);

  @override
  Future<void> registerUser({required UserModel userData}) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: userData.email,
        password: userData.password.toString(),
      );

      final uid = userCredential.user!.uid;
      await _firestore
          .collection('users')
          .doc(uid)
          .set(userData.copyWith(uid: uid).toJson());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        throw Exception('Email already exists');
      } else {
        throw Exception(e.message ?? 'Registration failed');
      }
    }
  }

  @override
  Future<UserCredential> loginUser({required String email, required String password}) {
    return _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
  }
}
