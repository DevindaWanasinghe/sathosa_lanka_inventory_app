import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final CollectionReference users = FirebaseFirestore.instance.collection(
    'users',
  );

  Future<void> saveUserData(
    String uid,
    String email,
    String role,
    String branchId,
  ) async {
    await users.doc(uid).set({
      'email': email,
      'role': role,
      'branchId': branchId,
    });
  }

  Future<String?> getUserRole(String uid) async {
    final doc = await users.doc(uid).get();
    if (doc.exists) {
      return doc['role'];
    }
    return null;
  }

  Future<String?> getUserBranch(String uid) async {
    final doc = await users.doc(uid).get();
    if (doc.exists) {
      return doc['branchId'];
    }
    return null;
  }
}
