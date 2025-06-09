import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Register with role saving
  Future<dynamic> registerWithEmail({
    required String email,
    required String password,
    required String role,
    required String branchId,
  }) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = result.user;

      if (user != null) {
        // Save role (and branchId if provided) to Firestore
        final userData = {'email': email, 'role': role, 'branchId': branchId};
        await _firestore.collection('users').doc(user.uid).set(userData);
      }

      return user;
    } catch (e) {
      print('Registration error: $e');
      return null;
    }
  }

  // Login
  Future<User?> signInWithEmail(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } catch (e) {
      print('Login error: $e');
      return null;
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Get current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // Get role from Firestore
  Future<String> getUserRole(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection('users')
          .doc(uid)
          .get();
      if (doc.exists) {
        return doc.get('role') ?? 'user'; // default fallback
      } else {
        return 'user';
      }
    } catch (e) {
      print('Error getting user role: $e');
      return 'user';
    }
  }
}
