
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user_model.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final String _collection = 'users';

  // 1. Create a user profile after successful signup.
  Future<void> createUserProfile(UserModel user) async {
    await _firestore
        .collection(_collection)
        .doc(user.userId)
        .set(user.toMap());
  }

  // 2. Get a user's profile using their Firebase UID.
  Future<UserModel?> getUserProfile(String userId) async {
    final doc = await _firestore
        .collection(_collection)
        .doc(userId)
        .get();

    if (!doc.exists || doc.data() == null) {
      return null;
    }

    return UserModel.fromMap(doc.data()!);
  }

  // 3. Update a user's editable profile details.
  Future<void> updateUserProfile(
    String userId, {
    required String name,
    required String email,
  }) async {
    await _firestore
        .collection(_collection)
        .doc(userId)
        .update({
      'name': name,
      'email': email,
    });
  }

  // 4. Listen to profile changes in real time.
  Stream<UserModel?> watchUserProfile(String userId) {
    return _firestore
        .collection(_collection)
        .doc(userId)
        .snapshots()
        .map((snapshot) {
      if (!snapshot.exists || snapshot.data() == null) {
        return null;
      }

      return UserModel.fromMap(snapshot.data()!);
    });
  }
}
