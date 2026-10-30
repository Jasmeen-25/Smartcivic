import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

Future<void> checkFirestoreConnection() async {
  try {
    final doc = FirebaseFirestore.instance
        .collection('connection_test')
        .doc('test');

    await doc.set({
      'message': 'SmartCivic Firestore Connected!',
      'createdAt': FieldValue.serverTimestamp(),
    });

    final snapshot = await doc.get();

    if (snapshot.exists) {
      debugPrint('SUCCESS: Firestore connected!');
      debugPrint('${snapshot.data()}');
    }
  } catch (e) {
    debugPrint('FIRESTORE ERROR: $e');
  }
}