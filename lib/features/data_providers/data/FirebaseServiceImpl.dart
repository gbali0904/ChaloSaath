import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../authorization/data/user_model.dart';
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
  Future<UserModel?> checkUserAndPrint(String email) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email.trim())
        .limit(1)
        .get();
    if (snapshot.docs.isNotEmpty) {
      final data = snapshot.docs.first.data();
      return UserModel.fromMap(data);
    } else {
      return null;
    }
  }

  @override
  Future<void> saveUserData(String email, Map<String, dynamic> userData) async {
    await _firestore.collection('users').doc(email).set(userData);
  }

  @override
  Future<UserCredential> loginWithEmail(String email, String password) {
    return _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  @override
  Future<void> saveLocations(List<String> locations) async {
    final collection = FirebaseFirestore.instance.collection('locations');
    for (final loc in locations) {
      await collection.add({
        'name': loc,
        'timestamp': FieldValue.serverTimestamp(),
      });
    }
  }

  @override
  Future<List<String>> searchLocationsFromFirebase(String query) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('locations')
        .orderBy('name')
        .get();
    var data = searchLocationsLocally(
      query,
      snapshot.docs.map((doc) => doc['name'] as String).toList(),
    );
    return data;
  }

  List<String> searchLocationsLocally(String query, List<String> collection) {
    final lowerQuery = query.toLowerCase();

    return collection.where((location) {
      return location.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  Future<UserModel?> updateUserAddresses(UserModel userData) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userData.email)
          .update({
            'homeAddress': userData.home_address,
            'officeAddress': userData.office_address,
            'isAddress': userData.isAddress,
          });
      final docRef = FirebaseFirestore.instance
          .collection('users')
          .doc(userData.email);
        await docRef.update({
          'homeAddress': userData.home_address,
          'officeAddress': userData.office_address,
          'isAddress': userData.isAddress,
        });

        final updatedDoc = await docRef.get();

        if (updatedDoc.exists && updatedDoc.data() != null) {
          return UserModel.fromMap(updatedDoc.data()!);
        } else {
          return null;
        } // success
    } catch (e) {
      print('Error updating addresses: $e');
      return null;
    }
  }

  @override
  User? getCurrentUser() => _auth.currentUser;

  @override
  Future<void> logout() async {
    await _auth.signOut();
    await _googleSignInService.logout();
  }
}
