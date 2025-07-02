import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../domain/BaseFirebaseService.dart';
import '../domain/SocialSignInService.dart';

class FirebaseServiceImpl implements BaseFirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final SocialSignInService _googleSignInService;

  FirebaseServiceImpl(this._googleSignInService);

  @override
  Future<UserCredential> loginWithGoogle() async {
    final credential = await _googleSignInService.signInWithGoogle();
    return await _auth.signInWithCredential(credential);
  }

  @override
  Future<void> saveUserData(String uid, Map<String, dynamic> userData) async {
    await _firestore.collection('users').doc(uid).set(userData);
  }

  @override
  Future<UserCredential> loginWithEmail(String email, String password) {
    return _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  @override
  User? getCurrentUser() => _auth.currentUser;

  @override
  Future<void> logout() async {
    await _auth.signOut();
    await _googleSignInService.logout();
  }
}
