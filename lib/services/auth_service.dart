
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<void> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    final credential = await auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    final user = credential.user!;

    await user.updateDisplayName(name.trim());

    await db.collection('users').doc(user.uid).set({
      'name': name.trim(),
      'email': email.trim(),
      'role': 'user',
      'rewardPoints': 0,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    await auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  Future<void> logout() async {
    await auth.signOut();
  }
}
