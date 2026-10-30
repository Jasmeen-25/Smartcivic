
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  // Firebase Authentication instance.
  final FirebaseAuth auth = FirebaseAuth.instance;

  // Cloud Firestore instance.
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Get currently logged-in user's ID.
  String? get currentUserId => auth.currentUser?.uid;

  // Check whether a user is logged in.
  bool get isUserLoggedIn => auth.currentUser != null;

  // Get current user's email.
  String? get currentUserEmail => auth.currentUser?.email;

  // Sign out current user.
  Future<void> signOut() async {
    await auth.signOut();
  }

  // Access users collection.
  CollectionReference<Map<String, dynamic>> get usersCollection {
    return firestore.collection('users');
  }

  // Access reports collection.
  CollectionReference<Map<String, dynamic>> get reportsCollection {
    return firestore.collection('reports');
  }

  // Access redemptions collection.
  CollectionReference<Map<String, dynamic>> get redemptionsCollection {
    return firestore.collection('redemptions');
  }
}
